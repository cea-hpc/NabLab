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

import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.PrimitiveType
import org.eclipse.emf.ecore.util.EcoreUtil

class OperatorUtils
{
	public static val OperatorPrefix = "operator"

	enum BinOpType { ArrayArray, ArrayScalar, ScalarArray }

	def create IrFactory::eINSTANCE.createLoop createLoopForUnaryOp(ArgOrVarRef result, ArgOrVarRef a, Iterable<Interval> intervals, String op)
	{
		val counter = intervals.head.index

		iterationBlock = intervals.head
		result.indices += createArgOrVarRef(counter)
		a.indices += createArgOrVarRef(counter)

		if (intervals.size > 1)
			body = createLoopForUnaryOp(result, a, intervals.tail, op)
		else
			body = IrFactory::eINSTANCE.createAffectation =>
			[
				left = result
				right = IrFactory::eINSTANCE.createUnaryExpression =>
				[
					type = createScalarBaseType((a.type as BaseType).primitive)
					constExpr = true
					expression = a
					operator = op
				]
			]

		multithreadable = true
	}

	def create IrFactory::eINSTANCE.createLoop createLoopForBinaryOp(ArgOrVarRef result, ArgOrVarRef a, ArgOrVarRef b, Iterable<Interval> intervals, BinOpType binOpType, String op)
	{
		val counter = intervals.head.index

		iterationBlock = intervals.head
		result.indices += createArgOrVarRef(counter)
		if (binOpType != BinOpType::ScalarArray) a.indices += createArgOrVarRef(counter)
		if (binOpType != BinOpType::ArrayScalar) b.indices += createArgOrVarRef(counter)

		if (intervals.size > 1)
			body = createLoopForBinaryOp(result, a, b, intervals.tail, binOpType, op)
		else
			body = IrFactory::eINSTANCE.createAffectation =>
			[
				left = result
				right = IrFactory::eINSTANCE.createBinaryExpression =>
				[
					type = createScalarBaseType((a.type as BaseType).primitive)
					constExpr = true
					left = a
					right = b
					operator = op
				]
			]

		multithreadable = true
	}

	def createArgOrVarRef(ArgOrVar v)
	{
		IrFactory::eINSTANCE.createArgOrVarRef =>
		[
			target = v
			type = EcoreUtil::copy(v.type)
			constExpr = true
		]
	}

	def createScalarBaseType(PrimitiveType t)
	{
		IrFactory::eINSTANCE.createBaseType =>
		[
			primitive = t
			isStatic = true
		]
	}

	def getBinOpType(BaseType leftType, BaseType rightType)
	{
		if (leftType.sizes.empty) BinOpType::ScalarArray
		else if (rightType.sizes.empty) BinOpType::ArrayScalar
		else BinOpType::ArrayArray
	}
}
