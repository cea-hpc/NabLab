/*******************************************************************************
- * Copyright (c) 2020 CEA
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
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.typing.BaseTypeTypeProvider
import fr.cea.nabla.typing.NSTArray1D
import fr.cea.nabla.typing.NSTArray2D
import fr.cea.nabla.typing.NSTScalar
import fr.cea.nabla.typing.NablaSimpleType
import java.util.HashMap
import org.eclipse.emf.ecore.util.EcoreUtil

class SimpleTypeDeclarationFinder implements IDeclarationFinder
{
	val extension BaseTypeTypeProvider baseTypeTP

	val Iterable<NablaSimpleType> callerInTypes
	val sizeVarValues = new HashMap<SimpleVar, Expression>
	val transformers = #[new ReplaceKnownSizeValues(sizeVarValues), new ApplyPossibleBinaryOperations]

	new(BaseTypeTypeProvider baseTypeTP, Iterable<NablaSimpleType> callerInTypes)
	{
		this.baseTypeTP = baseTypeTP
		this.callerInTypes = callerInTypes
	}

	override ReductionDeclaration findReduction(Iterable<Reduction> candidates)
	{
		val r = candidates.findFirst[x | sizesMatch(x, x.typeDeclaration.type.sizes, callerInTypes.head.sizeExpressions)]
		if (r === null) return null

		val type = r.typeDeclaration.type.computeExpressionType
		return new ReductionDeclaration(r, type)
	}

	override FunctionDeclaration findFunction(Iterable<Function> candidates)
	{
		val f = candidates.findFirst[x |
			for (i : 0..<x.typeDeclaration.inTypes.size)
				if (!sizesMatch(x, x.typeDeclaration.inTypes.get(i).sizes, callerInTypes.get(i).sizeExpressions))
					return false
			return true
		]
		if (f === null) return null

		val inTypes = f.typeDeclaration.inTypes.map[computeExpressionType]
		val returnType = f.typeDeclaration.returnType.computeExpressionType
		val fd = new FunctionDeclaration(f, inTypes, returnType)
		return fd
	}

	private def  Iterable<Expression> getSizeExpressions(NablaSimpleType it)
	{
		switch it
		{
			NSTScalar: #[]
			NSTArray1D: #[size]
			NSTArray2D: #[nbRows, nbCols]
		}
	}

	private def boolean sizesMatch(FunctionOrReduction f, Iterable<Expression> expectedSizes, Iterable<Expression> actualSizes)
	{
		if (expectedSizes.size != actualSizes.size) return false

		for (i : 0..<expectedSizes.size)
		{
			val actualSize = actualSizes.get(i)
			val expectedSize = expectedSizes.get(i)

			// ExpectedType represents the type of the dimension of the declaration.
			// Validation ensures it is only IntConstant or ArgOrVarRef of a size variable
			// declared in the function/reduction header
			switch expectedSize
			{
				IntConstant: 
					if (! (actualSize instanceof IntConstant && expectedSize.value == (actualSize as IntConstant).value)) 
						return false
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
						if (!EcoreUtil.equals(dimVarValue, actualSize)) return false
					}
				} 
				default: return false
			}
		}

		return true
	}

	private def NablaSimpleType computeExpressionType(BaseType argType)
	{
		switch argType.sizes.size
		{
			case 0: argType.typeFor as NablaSimpleType
			case 1: getNSTArray1DFor(argType.primitive, argType.sizes.get(0).replaceValuesAndCompact)
			case 2: getNSTArray2DFor(argType.primitive, argType.sizes.get(0).replaceValuesAndCompact, argType.sizes.get(1).replaceValuesAndCompact)
			default: throw new RuntimeException("Unmanaged array sizes:" + argType.sizes.size)
		}
	}

	/**
	 * Replace known size values in expression it and apply possible
	 * binary operations (i.e. operations on IntConstants).
	 */
	private def Expression replaceValuesAndCompact(Expression e)
	{
		var resultExpr = EcoreUtil.copy(e)
		for (t : transformers)
			resultExpr = t.transform(resultExpr)
		return resultExpr
	}
}
