/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.Dimension
import fr.cea.nabla.nabla.DimensionInt
import fr.cea.nabla.nabla.DimensionOperation
import fr.cea.nabla.nabla.DimensionSymbol
import fr.cea.nabla.nabla.DimensionSymbolRef
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtext.EcoreUtil2

@Data
class DimensionValue 
{ 
	public static val Undefined = new DimensionValue
	
	Object value // NSTDimension or Connectivity (constant like nbCells)
	
	new() { this.value = null }
	new(NSTDimension value) { this.value = value }
	new(Connectivity value) { this.value = value }

	def isUndefined() { value === null }
	def isConnectivity() { value instanceof Connectivity }
	def isNSTDimension() { value instanceof NSTDimension }
	def isNSTDimensionInt() { value instanceof NSTDimension && NSTDimensionValue.int }

	def getConnectivityValue() { value as Connectivity }
	def getNSTDimensionValue() { value as NSTDimension }
	def getNSTDimensionIntValue() { NSTDimensionValue.intValue }
}

@Data
class FunctionDeclaration
{
	val Function model
	val Map<DimensionSymbol, DimensionValue> dimensionVarValues
	val NablaType[] inTypes
	val NablaType returnType
}

@Data
class ReductionDeclaration
{
	val Reduction model
	val Map<DimensionSymbol, DimensionValue> dimensionVarValues
	val NablaSimpleType collectionType // no reduction on ConnectivityVar => SimpleType only
	val NablaSimpleType returnType
}

class DeclarationProvider 
{
	@Inject extension ExpressionTypeProvider
	@Inject extension PrimitiveTypeTypeProvider

	def FunctionDeclaration getDeclaration(FunctionCall it)
	{
		val dimensionVarValues = new HashMap<DimensionSymbol, DimensionValue>
		val module = EcoreUtil2.getContainerOfType(function, NablaModule)
		val candidates = module.functions.filter(Function).filter[x | x.name == function.name]
		val f = candidates.findFirst[x |
			if (x.inTypes.size != args.size) return false
			for (i : 0..<x.inTypes.size)
				if (!match(x.inTypes.get(i), args.get(i), dimensionVarValues)) return false
			return true
		]
		if (f === null) return null

		val inTypes = f.inTypes.map[x | x.computeExpressionType(dimensionVarValues)]
		val returnType = f.returnType.computeExpressionType(dimensionVarValues)
		return new FunctionDeclaration(f, dimensionVarValues, inTypes, returnType)
	}

	def ReductionDeclaration getDeclaration(ReductionCall it)
	{
		val dimensionVarValues = new HashMap<DimensionSymbol, DimensionValue>
		val module = EcoreUtil2.getContainerOfType(reduction, NablaModule)
		val candidates = module.functions.filter(Reduction).filter[x | x.name == reduction.name]
		val r = candidates.findFirst[x | match(x.collectionType, arg, dimensionVarValues) ]
		if (r === null) return null

		val collectionType = r.collectionType.computeExpressionType(dimensionVarValues)
		val returnType = r.returnType.computeExpressionType(dimensionVarValues)
		return new ReductionDeclaration(r, dimensionVarValues, collectionType as NablaSimpleType, returnType as NablaSimpleType)
	}

	private def boolean match(BaseType a, Expression b, Map<DimensionSymbol, DimensionValue> dimVarValues) 
	{
		val btype = b.typeFor
		if (btype === null)
			false // undefined type
		else
			a.primitive == btype.primitive && valuesMatch(dimVarValues, a.sizes, btype.dimensionValues)
	}

	private def dispatch List<DimensionValue> getDimensionValues(NSTScalar it) { #[] }
	private def dispatch List<DimensionValue> getDimensionValues(NSTArray1D it) { #[new DimensionValue(size)] }
	private def dispatch List<DimensionValue> getDimensionValues(NSTArray2D it) { #[new DimensionValue(nbRows), new DimensionValue(nbCols)] }
	private def dispatch List<DimensionValue> getDimensionValues(NablaConnectivityType it) 
	{ 
		val dimensionValues = new ArrayList<DimensionValue>
		dimensionValues.addAll(simple.dimensionValues)
		supports.forEach[x | dimensionValues += new DimensionValue(x)]
		return dimensionValues
	}
		
	private def boolean valuesMatch(Map<DimensionSymbol, DimensionValue> dimVarValues, List<Dimension> dimensions, DimensionValue[] sizes)
	{
		if (dimensions.size != sizes.size) return false
		
		for (i : 0..<dimensions.size)
		{
			val actualType = sizes.get(i)
			val expectedType = dimensions.get(i)
			switch expectedType
			{
				DimensionOperation: computeValue(expectedType, dimVarValues)
				DimensionInt case (!actualType.NSTDimensionInt || expectedType.value != actualType.NSTDimensionIntValue): return false
				DimensionSymbolRef case (expectedType.target instanceof DimensionSymbol):
				{
					val dimVarValue = dimVarValues.get(expectedType.target)
					if (dimVarValue === null)
					{
						// The DimemsionVar instance has not yet been encountered.
						// Fix the value for the rest of the loop.
						dimVarValues.put(expectedType.target as DimensionSymbol, actualType)
					}
					else
					{
						if (dimVarValue != actualType) return false
					}
				} 
				default: { /* nothing to do, the loop continue */ }
			}
		}

		return true
	}
	
	private def dispatch DimensionValue computeValue(DimensionOperation it, Map<DimensionSymbol, DimensionValue> values)
	{
		switch op
		{
			case '+': computeValue(left, values) + computeValue(right, values)
			case '*': computeValue(left, values) * computeValue(right, values)
			default: DimensionValue::Undefined
		}
	}

	private def dispatch DimensionValue computeValue(DimensionInt it, Map<DimensionSymbol, DimensionValue> values)
	{
		new DimensionValue(NSTDimension.create(value))
	}
	
	private def dispatch DimensionValue computeValue(DimensionSymbolRef it, Map<DimensionSymbol, DimensionValue> values)
	{
		values.getOrDefault(target, DimensionValue::Undefined)
	}
	
	private def NablaType computeExpressionType(BaseType argType, Map<DimensionSymbol, DimensionValue> values)
	{
		var NablaType returnType = null
		if (argType.sizes.empty)
			returnType = argType.primitive.typeFor
		else
		{
			val argTypeDimensionValues = argType.sizes.map[x | computeValue(x, values)]
			val firstElement = argTypeDimensionValues.head
			val allValuesSameType = argTypeDimensionValues.tail.forall[x | x.value.class == firstElement.value.class]
			if (allValuesSameType)
			{
				returnType = switch firstElement
				{
					case firstElement.NSTDimension && argTypeDimensionValues.size == 1: 
						createArray1D(argTypeDimensionValues.get(0).NSTDimensionValue, argType.primitive)
					case firstElement.NSTDimension && argTypeDimensionValues.size == 2: 
						createArray2D(argTypeDimensionValues.get(0).NSTDimensionValue, argTypeDimensionValues.get(1).NSTDimensionValue, argType.primitive)	
					case firstElement.connectivity: 
						new NablaConnectivityType(argTypeDimensionValues.map[x|x.connectivityValue], argType.primitive.typeFor)
					// default => firstElement is undefined then returnType stays undefined
					default:
						null
				}
			}	
		}
		return returnType
	}
	
	private def NSTArray1D createArray1D(NSTDimension size, PrimitiveType primitive) 
	{
		switch primitive
		{
			case INT: new NSTIntArray1D(size)
			case REAL: new NSTRealArray1D(size)
			case BOOL: new NSTBoolArray1D(size)
		}
	}
	
	private def NSTArray2D createArray2D(NSTDimension nbRows, NSTDimension nbCols, PrimitiveType primitive) 
	{ 
		switch primitive
		{
			case INT: new NSTIntArray2D(nbRows, nbCols)
			case REAL: new NSTRealArray2D(nbRows, nbCols)
			case BOOL: new NSTBoolArray2D(nbRows, nbCols)
		}
	}
	
	private def DimensionValue operator_plus(DimensionValue a, DimensionValue b)
	{
		if (a.NSTDimensionInt && b.NSTDimensionInt)
			new DimensionValue(NSTDimension.create(a.NSTDimensionIntValue + b.NSTDimensionIntValue))
		else 
			DimensionValue::Undefined 
	}

	private def DimensionValue operator_multiply(DimensionValue a, DimensionValue b)
	{
		if (a.NSTDimensionInt && b.NSTDimensionInt)
			new DimensionValue(NSTDimension.create(a.NSTDimensionIntValue * b.NSTDimensionIntValue))
		else 
			DimensionValue::Undefined 
	}
}
