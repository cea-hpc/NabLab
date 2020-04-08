/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.overloading

import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.MultipleConnectivity
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.typing.PrimitiveTypeTypeProvider
import java.util.HashMap

class ConnectivityTypeDeclarationFinder implements IDeclarationFinder
{
	val extension PrimitiveTypeTypeProvider primitiveTypeTP

	val Iterable<NablaConnectivityType> callerInTypes
	val sizeVarValues = new HashMap<SimpleVar, MultipleConnectivity>

	new(PrimitiveTypeTypeProvider primitiveTypeTP, Iterable<NablaConnectivityType> callerInTypes)
	{
		this.primitiveTypeTP = primitiveTypeTP
		this.callerInTypes = callerInTypes
	}

	override ReductionDeclaration findReduction(Iterable<Reduction> candidates)
	{
		// No reduction on connectivity variables
		return null
	}

	override FunctionDeclaration findFunction(Iterable<Function> candidates)
	{
		val f = candidates.findFirst[x |
			for (i : 0..<x.inTypes.size)
				if (!sizesMatch(x, x.inTypes.get(i).sizes, callerInTypes.get(i).supports)) return false
			return true
		]
		if (f === null) return null

		val inTypes = f.inTypes.map[computeExpressionType]
		val returnType = f.returnType.computeExpressionType
		return new FunctionDeclaration(f, inTypes, returnType)
	}

	private def boolean sizesMatch(FunctionOrReduction f, Iterable<Expression> expectedSizes, Iterable<MultipleConnectivity> actualSizes)
	{
		if (expectedSizes.size != actualSizes.size) return false

		for (i : 0..<expectedSizes.size)
		{
			val actualSize = actualSizes.get(i)
			val expectedSize = expectedSizes.get(i)

			// ExpectedType represents the type of the dimension of the declaration.
			// Validation ensures it is only IntConstant or ArgOrVarRef and the target
			// of ArgOrRef is a size variable declared in the function/reduction header
			switch expectedSize
			{
				ArgOrVarRef:
				{
					// The referenced variable must be contained by f.
					if (expectedSize.target.eContainer !== f) return false

					// Consequently, it is a SimpleVar
					val simpleVar = expectedSize.target as SimpleVar

					val dimVarValue = sizeVarValues.get(simpleVar)
					if (dimVarValue === null)
					{
						// The variable has not yet been encountered.
						// Fix the value for the rest of the loop.
						sizeVarValues.put(simpleVar, actualSize)
					}
					else
					{
						if (dimVarValue !== actualSize) return false
					}
				} 
				default: return false
			}
		}

		return true
	}

	private def NablaConnectivityType computeExpressionType(BaseType argType)
	{
		val supports = argType.sizes.map[value]
		if (supports.forall[x | x !== null])
			new NablaConnectivityType(supports, argType.primitive.typeFor)
	}

	private def dispatch MultipleConnectivity getValue(Expression it)
	{
		null
	}

	private def dispatch MultipleConnectivity getValue(ArgOrVarRef it)
	{
		if (timeIterators.empty && spaceIterators.empty && indices.empty && target instanceof SimpleVar)
		{
			val v = target as SimpleVar
			sizeVarValues.get(v)
		}
		else
			null
	}
}
