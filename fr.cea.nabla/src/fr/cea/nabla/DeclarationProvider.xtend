/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.ArgType
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Dimension
import fr.cea.nabla.nabla.DimensionInt
import fr.cea.nabla.nabla.DimensionOperation
import fr.cea.nabla.nabla.DimensionVar
import fr.cea.nabla.nabla.DimensionVarReference
import fr.cea.nabla.nabla.FunctionArg
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaFactory
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.ReductionArg
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.typing.BoolType
import fr.cea.nabla.typing.ExpressionType
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.IntType
import fr.cea.nabla.typing.RealArrayType
import fr.cea.nabla.typing.RealType
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Data

@Data
class FunctionDeclaration
{
	val FunctionArg model
	val Map<DimensionVar, Integer> dimensionVarValues
	val BaseType[] inTypes
	val BaseType returnType
}

@Data
class ReductionDeclaration
{
	val ReductionArg model
	val Map<DimensionVar, Integer> dimensionVarValues
	val BaseType collectionType
	val BaseType returnType
}

class DeclarationProvider 
{
	@Inject extension ExpressionTypeProvider
	
	def FunctionDeclaration getDeclaration(FunctionCall it)
	{
		val dimensionVarValues = new HashMap<DimensionVar, Integer>

		val f = function.argGroups.findFirst[x | 
			if (x.inTypes.size != args.size) return false
			for (i : 0..<x.inTypes.size)
				if (!computeDimensionVars(dimensionVarValues, x.inTypes.get(i), args.get(i).typeFor)) return false
			return true
		]
		
		if (f === null) return null

		val inTypes = f.inTypes.map[x | computeBaseType(dimensionVarValues, x)]
		val returnType = computeBaseType(dimensionVarValues, f.returnType)
		return new FunctionDeclaration(f, dimensionVarValues, inTypes, returnType)
	}

	def ReductionDeclaration getDeclaration(ReductionCall it)
	{
		val dimensionVarValues = new HashMap<DimensionVar, Integer>

		val r = reduction.argGroups.findFirst[x | 
			val dimVarValues = new HashMap<DimensionVar, Integer>
			computeDimensionVars(dimVarValues, x.collectionType, arg.typeFor)
		]
		
		if (r === null) return null

		val collectionType = computeBaseType(dimensionVarValues, r.collectionType)
		val returnType = computeBaseType(dimensionVarValues, r.returnType)
		return new ReductionDeclaration(r, dimensionVarValues, collectionType, returnType)
	}
	
	private def dispatch boolean computeDimensionVars(Map<DimensionVar, Integer> dimVarValues, ArgType a, ExpressionType b) 
	{ 
		false
	}
	
	private def dispatch boolean computeDimensionVars(Map<DimensionVar, Integer> dimVarValues, ArgType a, BoolType b) 
	{ 
		a.root == PrimitiveType::BOOL && a.dimensions.empty
	}
	
	private def dispatch boolean computeDimensionVars(Map<DimensionVar, Integer> dimVarValues, ArgType a, IntType b) 
	{ 
		a.root == PrimitiveType::INT && a.dimensions.empty
	}
	
	private def dispatch boolean computeDimensionVars(Map<DimensionVar, Integer> dimVarValues, ArgType a, RealType b) 
	{ 
		a.root == PrimitiveType::REAL && a.dimensions.empty
	}
	
	private def dispatch boolean computeDimensionVars(Map<DimensionVar, Integer> dimVarValues, ArgType a, RealArrayType b) 
	{ 
		a.root == PrimitiveType::REAL && compute(dimVarValues, a.dimensions, b.sizes)
	}
	
	private def boolean compute(Map<DimensionVar, Integer> dimVarValues, List<Dimension> dimensions, int[] sizes)
	{
		if (dimensions.size != sizes.size) return false
		
		for (i : 0..<dimensions.size)
		{
			val actualType = sizes.get(i)
			val expectedType = dimensions.get(i)
			switch expectedType
			{
				DimensionOperation: computeValue(expectedType, dimVarValues)
				DimensionInt case (expectedType.value != actualType): return false
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
	
	private def dispatch int computeValue(DimensionOperation it, Map<DimensionVar, Integer> values)
	{
		switch op
		{
			case '+': computeValue(left, values) + computeValue(right, values)
			case '*': computeValue(left, values) * computeValue(right, values)
			default: -1
		}
	}

	private def dispatch int computeValue(DimensionInt it, Map<DimensionVar, Integer> values)
	{
		value
	}
	
	private def dispatch int computeValue(DimensionVarReference it, Map<DimensionVar, Integer> values)
	{
		values.getOrDefault(target, -1)
	}
	
	private def BaseType computeBaseType(Map<DimensionVar, Integer> values, ArgType argType)
	{
		val returnSizes = argType.dimensions.map[x | computeValue(x, values)]
		return NablaFactory::eINSTANCE.createBaseType => 
		[ 
			root = argType.root 
			sizes += returnSizes	
		]
	}
}
