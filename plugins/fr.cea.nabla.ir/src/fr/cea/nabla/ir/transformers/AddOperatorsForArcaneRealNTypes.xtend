/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.UnaryExpression
import java.util.Arrays
import java.util.HashSet
import org.eclipse.emf.ecore.util.EcoreUtil

import static extension fr.cea.nabla.ir.IrTypeExtensions.*

/**
 * Operators are templated on dimension thus they are mapped to ConstArrayView in Arcane.
 * This step add operators for Real2, Real3, Real2x2 and Real3x3 when needed.
 */
class AddOperatorsForArcaneRealNTypes extends IrTransformationStep
{
	val opUtils = new OperatorUtils

	override getDescription()
	{
		"Create operators for Arcane Real2, Real2x2, Real3 and Real3x3 types"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		val functionsToDelete = new HashSet<InternFunction>

		for (m : ir.modules)
			for (fc : m.eAllContents.filter(FunctionCall).toIterable)
				if (fc.function instanceof InternFunction && fc.function.name.startsWith(OperatorUtils.OperatorPrefix) && fc.type.realN)
				{
					val oldOp = fc.function as InternFunction
					val type = fc.type as BaseType
					val newOp = duplicateOperator(oldOp, type.sizes.size, type.intSizes.get(0))
					fc.function = newOp

					// newOp already encountered (previously created) ?
					if (!m.functions.contains(newOp))
					{
						m.functions += newOp
						functionsToDelete += oldOp
					}
				}

		for (e : functionsToDelete)
			if (e.eCrossReferences.empty)
				EcoreUtil.delete(e, true)
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		// nothing to do
	}

	/* Do not replace the two integers by an array because create method will work with the reference of the array and not its content */
	private def create IrFactory::eINSTANCE.createInternFunction duplicateOperator(InternFunction f, int dimension, int dimensionValue)
	{
		val typeDimensions = newIntArrayOfSize(dimension)
		Arrays.fill(typeDimensions, dimensionValue)

		name = f.name
		returnType = createRealArray(typeDimensions)

		for (a : f.inArgs)
			inArgs += IrFactory::eINSTANCE.createArg =>
			[
				name = a.name
				type = (a.type.isScalar ? EcoreUtil.copy(a.type) : createRealArray(typeDimensions))
			]

		// create the result variable
		val result = IrFactory::eINSTANCE.createVariable
		result.name = "result"
		result.const = false
		result.constExpr = false
		result.option = false
		result.type = createRealArray(typeDimensions)

		// create body
		val block = IrFactory::eINSTANCE.createInstructionBlock
		body = block

		// variable declaration to store the result
		block.instructions += IrFactory::eINSTANCE.createVariableDeclaration => [ variable = result ]

		// loops and binary operation
		val resultRef = opUtils.createArgOrVarRef(result)
		val argRefs = inArgs.map[x | opUtils.createArgOrVarRef(x)]
		val Interval[] intervals = newArrayOfSize(typeDimensions.size)
		for (i : 0..<intervals.size) intervals.set(i, createInterval("i"+i, typeDimensions.get(i)))
		switch inArgs.size
		{
			case 1:
			{
				val op = f.body.eAllContents.findFirst[x | x instanceof UnaryExpression] as UnaryExpression
				block.instructions += opUtils.createLoopForUnaryOp(resultRef, argRefs.get(0), intervals, op.operator)
			}
			case 2:
			{
				val op = f.body.eAllContents.findFirst[x | x instanceof BinaryExpression] as BinaryExpression
				val leftType = op.left.type as BaseType
				val rightType = op.right.type as BaseType
				val binOpType = opUtils.getBinOpType(leftType, rightType)
				block.instructions += opUtils.createLoopForBinaryOp(resultRef, argRefs.get(0), argRefs.get(1), intervals, binOpType, op.operator)
			}
			default: throw new RuntimeException("")
		}

		// return instruction to return the result
		block.instructions += IrFactory::eINSTANCE.createReturn => [ expression = opUtils.createArgOrVarRef(result) ]
	}

	/**
	 * Return true if the IrType t is a Real2, Real3, Real2x2 or Real3x3 arcane type,
	 * false otherwise.
	 */
	private def boolean isRealN(IrType t)
	{
		if (t instanceof BaseType)
		{
			t.primitive == PrimitiveType.REAL
			&& (t.sizes.size == 1 || t.sizes.size == 2)
			&& (t.intSizes.forall[x | x == 2] || t.intSizes.forall[x | x == 3])
		}
		else
			false
	}

	private def createRealArray(int[] dimensions)
	{
		IrFactory::eINSTANCE.createBaseType =>
		[
			primitive = PrimitiveType.REAL
			isStatic = true
			for (d : dimensions)
			{
				sizes += IrFactory::eINSTANCE.createIntConstant =>
				[
					value = d
					constExpr = true
				]
				intSizes += d
			}
		]
	}

	private def createInterval(String counterName, int maxOccurs)
	{
		IrFactory::eINSTANCE.createInterval =>
		[
			index = IrFactory::eINSTANCE.createVariable =>
			[
				name = counterName
				type = opUtils.createScalarBaseType(PrimitiveType::INT)
				const = false
				constExpr = false
				option = false
			]
			nbElems = IrFactory::eINSTANCE.createIntConstant =>
			[
				value = maxOccurs
			]
		]
	}
}
