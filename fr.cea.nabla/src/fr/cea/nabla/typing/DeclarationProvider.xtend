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
import fr.cea.nabla.nabla.ArgType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.Dimension
import fr.cea.nabla.nabla.DimensionInt
import fr.cea.nabla.nabla.DimensionOperation
import fr.cea.nabla.nabla.DimensionVar
import fr.cea.nabla.nabla.DimensionVarReference
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
	public static val Undefined = new DimensionValue(null)
	
	Object value // Integer or Connectivity (constant like nbCells)
	
	new(int value) { this.value = value }
	new(Connectivity value) { this.value = value }

	def isUndefined() { value === null }
	def isConnectivity() { value instanceof Connectivity }
	def isInt() { value instanceof Integer }

	def getConnectivityValue() { value as Connectivity }
	def getIntValue() { value as Integer }
}

@Data
class FunctionDeclaration
{
	val Function model
	val Map<DimensionVar, DimensionValue> dimensionVarValues
	val NablaType[] inTypes
	val NablaType returnType
}

@Data
class ReductionDeclaration
{
	val Reduction model
	val Map<DimensionVar, DimensionValue> dimensionVarValues
	val NablaSimpleType collectionType // no reduction on ConnectivityVar => SimpleType only
	val NablaSimpleType returnType
}

class DeclarationProvider 
{
	@Inject extension ExpressionTypeProvider
	@Inject extension PrimitiveTypeTypeProvider
	
	def FunctionDeclaration getDeclaration(FunctionCall it)
	{
		val dimensionVarValues = new HashMap<DimensionVar, DimensionValue>
		val module = EcoreUtil2.getContainerOfType(it, NablaModule)
		val candidates = module.functions.filter(Function).filter[x | x.name == function.name]
		val f = candidates.findFirst[x |
			if (x.inArgs.size != args.size) return false
			for (i : 0..<x.inArgs.size)
				if (!match(x.inArgs.get(i).type, args.get(i), dimensionVarValues)) return false
			return true
		]
		if (f === null) return null

		val inTypes = f.inArgs.map[x | x.type.computeExpressionType(dimensionVarValues)]
		val returnType = f.returnType.computeExpressionType(dimensionVarValues)
		return new FunctionDeclaration(f, dimensionVarValues, inTypes, returnType)
	}

	def ReductionDeclaration getDeclaration(ReductionCall it)
	{
		val dimensionVarValues = new HashMap<DimensionVar, DimensionValue>
		val module = EcoreUtil2.getContainerOfType(it, NablaModule)
		val candidates = module.functions.filter(Reduction).filter[x | x.name == reduction.name]
		val r = candidates.findFirst[x | match(x.collectionType, arg, dimensionVarValues) ]
		if (r === null) return null

		val collectionType = r.collectionType.computeExpressionType(dimensionVarValues)
		val returnType = r.returnType.computeExpressionType(dimensionVarValues)
		return new ReductionDeclaration(r, dimensionVarValues, collectionType as NablaSimpleType, returnType as NablaSimpleType)
	}
	
	private def boolean match(ArgType a, Expression b, Map<DimensionVar, DimensionValue> dimVarValues) 
	{ 
		val btype = b.typeFor
		if (btype === null)
			false // undefined type
		else
			a.primitive == btype.primitive && valuesMatch(dimVarValues, a.indices, btype.dimensionValues)
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
		
	private def boolean valuesMatch(Map<DimensionVar, DimensionValue> dimVarValues, List<Dimension> dimensions, DimensionValue[] sizes)
	{
		if (dimensions.size != sizes.size) return false
		
		for (i : 0..<dimensions.size)
		{
			val actualType = sizes.get(i)
			val expectedType = dimensions.get(i)
			switch expectedType
			{
				DimensionOperation: computeValue(expectedType, dimVarValues)
				DimensionInt case (!actualType.int || expectedType.value != actualType.intValue): return false
				DimensionVarReference :
				{
					val dimVarValue = dimVarValues.get(expectedType.target)
					if (dimVarValue === null)
					{
						// The DimemsionVar instance has not yet been encountered.
						// Fix the value for the rest of the loop.
						dimVarValues.put(expectedType.target, actualType)
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
	
	private def dispatch DimensionValue computeValue(DimensionOperation it, Map<DimensionVar, DimensionValue> values)
	{
		switch op
		{
			case '+': computeValue(left, values) + computeValue(right, values)
			case '*': computeValue(left, values) * computeValue(right, values)
			default: DimensionValue::Undefined
		}
	}

	private def dispatch DimensionValue computeValue(DimensionInt it, Map<DimensionVar, DimensionValue> values)
	{
		new DimensionValue(value)
	}
	
	private def dispatch DimensionValue computeValue(DimensionVarReference it, Map<DimensionVar, DimensionValue> values)
	{
		values.getOrDefault(target, DimensionValue::Undefined)
	}
	
	private def NablaType computeExpressionType(ArgType argType, Map<DimensionVar, DimensionValue> values)
	{
		var NablaType returnType = null
		if (argType.indices.empty)
			returnType = argType.primitive.typeFor
		else
		{
			val argTypeDimensionValues = argType.indices.map[x | computeValue(x, values)]
			val firstElement = argTypeDimensionValues.head
			val allValuesSameType = argTypeDimensionValues.tail.forall[x | x.value.class == firstElement.value.class]
			if (allValuesSameType)
			{
				returnType = switch firstElement
				{
					case firstElement.int && argTypeDimensionValues.size == 1: 
						createArray1D(argTypeDimensionValues.get(0).intValue, argType.primitive)
					case firstElement.int && argTypeDimensionValues.size == 2: 
						createArray2D(argTypeDimensionValues.get(0).intValue, argTypeDimensionValues.get(1).intValue, argType.primitive)	
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
	
	private def NSTArray1D createArray1D(int size, PrimitiveType primitive) 
	{ 
		switch primitive
		{
			case INT: new NSTIntArray1D(size)
			case REAL: new NSTRealArray1D(size)
			case BOOL: new NSTBoolArray1D(size)
		}
	}
	
	private def NSTArray2D createArray2D(int nbRows, int nbCols, PrimitiveType primitive) 
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
		if (a.int && b.int)
			new DimensionValue(a.intValue + b.intValue)
		else 
			DimensionValue::Undefined // no operation on connectivities
	}

	private def DimensionValue operator_multiply(DimensionValue a, DimensionValue b)
	{
		if (a.int && b.int)
			new DimensionValue(a.intValue * b.intValue)
		else 
			DimensionValue::Undefined // no operation on connectivities
	}
}
