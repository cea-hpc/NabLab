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

import com.google.inject.Inject
import fr.cea.nabla.LinearAlgebraUtils
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.typing.BaseTypeTypeProvider
import fr.cea.nabla.typing.NLATMatrix
import fr.cea.nabla.typing.NLATVector
import fr.cea.nabla.typing.NSTArray1D
import fr.cea.nabla.typing.NSTArray2D
import fr.cea.nabla.typing.NSTScalar
import fr.cea.nabla.typing.NablaSimpleType
import fr.cea.nabla.typing.NablaType
import java.util.HashMap
import org.eclipse.emf.ecore.util.EcoreUtil

class DeclarationBuilder
{
	@Inject extension LinearAlgebraUtils
	@Inject extension BaseTypeTypeProvider

	val sizeVarValues = new HashMap<SimpleVar, Expression>
	val transformers = #[new ReplaceKnownSizeValues(sizeVarValues), new ApplyPossibleBinaryOperations]

	def ReductionDeclaration tryToBuildDeclaration(Reduction r, NablaType callerInType)
	{
		var ReductionDeclaration declaration = null
		val calleeInType = r.typeDeclaration.type.typeFor
		if (calleeInType !== null && callerInType !== null && calleeInType.class == callerInType.class)
		{
			val match = sizesMatch(r, calleeInType.sizeExpressions, callerInType.sizeExpressions)
			if (match)
			{
				val type = r.typeDeclaration.type.computeExpressionType
				if (type instanceof NablaSimpleType)
					declaration = new ReductionDeclaration(r, type as NablaSimpleType)		
			}
		}
		return declaration
	}

	def FunctionDeclaration tryToBuildDeclaration(Function f, Iterable<NablaType> callerInTypes)
	{
		for (i : 0..<f.typeDeclaration.inTypes.size)
		{
			val calleeIemeType = f.typeDeclaration.inTypes.get(i).typeFor
			val callerIemeType = callerInTypes.get(i)
			if (calleeIemeType !== null && callerIemeType !== null && calleeIemeType.class != callerIemeType.class) 
				return null
			if (!sizesMatch(f, calleeIemeType.sizeExpressions, callerIemeType.sizeExpressions))
				return null
		}

		val inTypes = f.typeDeclaration.inTypes.map[computeExpressionType]
		val returnType = f.typeDeclaration.returnType.computeExpressionType
		val fd = new FunctionDeclaration(f, inTypes, returnType)
		return fd
	}

	private def  Iterable<Expression> getSizeExpressions(NablaType it)
	{
		switch it
		{
			NSTScalar: #[]
			NSTArray1D: #[size]
			NSTArray2D: #[nbRows, nbCols]
			NLATVector: #[size]
			NLATMatrix: #[nbRows, nbCols]
			default: throw new RuntimeException("Unmanaged type for function/reduction: " + toString)
		}
	}

	private def boolean sizesMatch(FunctionOrReduction f, Iterable<Expression> expectedSizes, Iterable<Expression> actualSizes)
	{
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

	private def NablaType computeExpressionType(BaseType argType)
	{
		switch argType.sizes.size
		{
			case 0: argType.typeFor as NablaSimpleType
			case 1: if (argType.linearAlgebra) new NLATVector(argType.sizes.get(0).replaceValuesAndCompact)
					else getNSTArray1DFor(argType.primitive, argType.sizes.get(0).replaceValuesAndCompact)
			case 2: if (argType.linearAlgebra) new NLATMatrix(argType.sizes.get(0).replaceValuesAndCompact, argType.sizes.get(1).replaceValuesAndCompact)
					else getNSTArray2DFor(argType.primitive, argType.sizes.get(0).replaceValuesAndCompact, argType.sizes.get(1).replaceValuesAndCompact)
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
