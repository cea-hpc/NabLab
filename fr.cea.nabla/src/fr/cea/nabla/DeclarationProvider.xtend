/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.ArgType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.Dimension
import fr.cea.nabla.nabla.DimensionInt
import fr.cea.nabla.nabla.DimensionOperation
import fr.cea.nabla.nabla.DimensionVar
import fr.cea.nabla.nabla.DimensionVarReference
import fr.cea.nabla.nabla.FunctionArg
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.ReductionArg
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.typing.ArrayType
import fr.cea.nabla.typing.DefinedType
import fr.cea.nabla.typing.ExpressionType
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.UndefinedType
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Data

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
	val FunctionArg model
	val Map<DimensionVar, DimensionValue> dimensionVarValues
	val ExpressionType[] inTypes
	val ExpressionType returnType
}

@Data
class ReductionDeclaration
{
	val ReductionArg model
	val Map<DimensionVar, DimensionValue> dimensionVarValues
	val ExpressionType collectionType
	val ExpressionType returnType
}

class DeclarationProvider 
{
	@Inject extension ExpressionTypeProvider
	
	def FunctionDeclaration getDeclaration(FunctionCall it)
	{
		val dimensionVarValues = new HashMap<DimensionVar, DimensionValue>

		val f = function.argGroups.findFirst[x | 
			if (x.inTypes.size != args.size) return false
			for (i : 0..<x.inTypes.size)
				if (!match(x.inTypes.get(i), args.get(i).typeFor, dimensionVarValues)) return false
			return true
		]
		
		if (f === null) return null

		val inTypes = f.inTypes.map[x | x.computeExpressionType(dimensionVarValues)]
		val returnType = f.returnType.computeExpressionType(dimensionVarValues)
		return new FunctionDeclaration(f, dimensionVarValues, inTypes, returnType)
	}

	def ReductionDeclaration getDeclaration(ReductionCall it)
	{
		val dimensionVarValues = new HashMap<DimensionVar, DimensionValue>

		val r = reduction.argGroups.findFirst[x | 
			match(x.collectionType, arg.typeFor, dimensionVarValues)
		]
		
		if (r === null) return null

		val collectionType = r.collectionType.computeExpressionType(dimensionVarValues)
		val returnType = r.returnType.computeExpressionType(dimensionVarValues)
		return new ReductionDeclaration(r, dimensionVarValues, collectionType, returnType)
	}
	
	private def dispatch boolean match(ArgType a, UndefinedType b, Map<DimensionVar, DimensionValue> dimVarValues) 
	{ 
		false
	}
	
	private def dispatch boolean match(ArgType a, DefinedType b, Map<DimensionVar, DimensionValue> dimVarValues) 
	{ 
		a.root == b.root && valuesMatch(dimVarValues, a.dimensions, b.connectivities.map[x | new DimensionValue(x)])
	}
	
	private def dispatch boolean match(ArgType a, ArrayType b, Map<DimensionVar, DimensionValue> dimVarValues) 
	{ 
		val dimensionValues = new ArrayList<DimensionValue>
		b.sizes.forEach[x | dimensionValues += new DimensionValue(x)]
		b.connectivities.forEach[x | dimensionValues += new DimensionValue(x)]
		a.root == b.root && valuesMatch(dimVarValues, a.dimensions, dimensionValues)
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
	
	private def ExpressionType computeExpressionType(ArgType argType, Map<DimensionVar, DimensionValue> values)
	{
		var ExpressionType returnType = new UndefinedType
		if (argType.dimensions.empty)
			returnType = getTypeFor(argType.root, #[], #[])
		else
		{
			val argTypeDimensionValues = argType.dimensions.map[x | computeValue(x, values)]
			val firstElement = argTypeDimensionValues.head
			val allValuesSameType = argTypeDimensionValues.tail.forall[x | x.value.class == firstElement.value.class]
			if (allValuesSameType)
			{
				switch firstElement
				{
					case firstElement.int: returnType = getTypeFor(argType.root, #[], argTypeDimensionValues.map[x|x.intValue])
					case firstElement.connectivity: returnType = getTypeFor(argType.root, argTypeDimensionValues.map[x|x.connectivityValue], #[])
					// default => firstElement is undefined then returnType stays undefined
				}
			}	
		}
		return returnType
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
