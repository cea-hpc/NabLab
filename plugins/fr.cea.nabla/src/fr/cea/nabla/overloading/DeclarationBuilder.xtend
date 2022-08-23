/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.overloading

import com.google.inject.Inject
import fr.cea.nabla.BaseTypeSizeEvaluator
import fr.cea.nabla.LinearAlgebraUtils
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.NablaFactory
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
	@Inject extension BaseTypeSizeEvaluator
	@Inject extension LinearAlgebraUtils
	@Inject extension BaseTypeTypeProvider

	val sizeVarValues = new HashMap<SimpleVar, Expression>
	val transformers = #[new ReplaceKnownSizeValues(sizeVarValues), new ApplyPossibleBinaryOperations]

	def ReductionDeclaration tryToBuildDeclaration(Reduction r, NablaType callerInType)
	{
		var ReductionDeclaration declaration = null
		val calleeInType = r.typeDeclaration.type.typeFor
		if (typesMatch(r, calleeInType, callerInType))
		{
			val type = r.typeDeclaration.type.computeExpressionType
			if (type instanceof NablaSimpleType)
				declaration = new ReductionDeclaration(r, type)
		}
		return declaration
	}

	def FunctionDeclaration tryToBuildDeclaration(Function f, Iterable<NablaType> callerInTypes)
	{
		for (i : 0..<f.intypesDeclaration.size)
		{
			val calleeIemeType = f.intypesDeclaration.get(i).inTypes.typeFor
			val callerIemeType = callerInTypes.get(i)
			if (!typesMatch(f, calleeIemeType, callerIemeType))
				return null
		}

		val inTypes = f.intypesDeclaration.map[inTypes.computeExpressionType]
		val returnType = f.returnTypeDeclaration.returnType.computeExpressionType
		val fd = new FunctionDeclaration(f, inTypes, returnType)
		return fd
	}

	private def Iterable<Expression> getSizeExpressions(NablaType it)
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

	private def int[] getIntSizes(NablaType it)
	{
		switch it
		{
			NSTScalar: newIntArrayOfSize(0)
			NSTArray1D: #[intSize]
			NSTArray2D: #[intNbRows, intNbCols]
			NLATVector: #[intSize]
			NLATMatrix: #[intNbRows, intNbCols]
			default: throw new RuntimeException("Unmanaged type for function/reduction: " + toString)
		}
	}

	private def boolean typesMatch(FunctionOrReduction f, NablaType calleeType, NablaType callerType)
	{
		if (calleeType === null || callerType === null) return false;
		if (calleeType.class != callerType.class) return false

		val calleeSizes = calleeType.sizeExpressions
		val callerSizes = callerType.sizeExpressions
		val callerIntSizes = callerType.intSizes
		for (i : 0..<calleeSizes.size)
		{
			val callerSize = callerSizes.get(i)
			val callerIntSize = callerIntSizes.get(i)
			val calleeSize = calleeSizes.get(i)

			// CalleeType represents the type of the dimension of the declaration.
			// Validation ensures it is only IntConstant or ArgOrVarRef of a size variable
			// declared in the function/reduction header
			switch calleeSize
			{
				IntConstant:
					if (calleeSize.value != callerIntSize)
						return false
				ArgOrVarRef:
				{
					// The referenced variable must be contained by f.
					if (calleeSize.target.eContainer !== f) return false

					// Consequently, it is a SimpleVar
					val simpleVar = calleeSize.target as SimpleVar
					val dimVarValue = sizeVarValues.get(simpleVar)
					if (dimVarValue === null)
					{
						// The variable has not yet been encountered.
						// Fix the value for the rest of the loop.
						if (callerIntSize == NablaType.DYNAMIC_SIZE)
							sizeVarValues.put(simpleVar, callerSize)
						else
							sizeVarValues.put(simpleVar, NablaFactory::eINSTANCE.createIntConstant => [value = callerIntSize])
					}
					else
					{
						val simplifiedActualSize = if (callerIntSize == NablaType.DYNAMIC_SIZE) callerSize
						else NablaFactory::eINSTANCE.createIntConstant => [value = callerIntSize]

						if (!EcoreUtil.equals(dimVarValue, simplifiedActualSize)) return false
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
			case 1:
			{
				val laExtension = argType.linearAlgebraExtension
				if (laExtension === null)
				{
					val arraySize = argType.sizes.get(0).replaceValuesAndCompact
					val intArraySize = getIntSizeFor(arraySize)
					getNSTArray1DFor(argType.primitive, arraySize, intArraySize)
				}
				else
				{
					val size = argType.sizes.get(0).replaceValuesAndCompact
					new NLATVector(laExtension, size, getIntSizeFor(size))
				}
			}
			case 2:
			{
				val laExtension = argType.linearAlgebraExtension
				if (laExtension === null)
				{
					val nbRows = argType.sizes.get(0).replaceValuesAndCompact
					val nbCols = argType.sizes.get(1).replaceValuesAndCompact
					val intNbRows = getIntSizeFor(nbRows)
					val intNbCols = getIntSizeFor(nbCols)
					getNSTArray2DFor(argType.primitive, nbRows, nbCols, intNbRows, intNbCols)
				}
				else
				{
					val nbRows = argType.sizes.get(0).replaceValuesAndCompact
					val nbCols = argType.sizes.get(1).replaceValuesAndCompact
					new NLATMatrix(laExtension, nbRows, nbCols, getIntSizeFor(nbRows), getIntSizeFor(nbCols))
				}
			}
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