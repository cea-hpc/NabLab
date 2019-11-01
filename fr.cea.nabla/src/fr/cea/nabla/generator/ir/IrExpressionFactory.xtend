/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.VarRefExtensions
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.IntMatrixConstant
import fr.cea.nabla.nabla.IntVectorConstant
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.RealMatrixConstant
import fr.cea.nabla.nabla.RealVectorConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarRef
import fr.cea.nabla.typing.DeclarationProvider
import fr.cea.nabla.typing.ExpressionTypeProvider

class IrExpressionFactory
{
	@Inject extension DeclarationProvider
	@Inject extension IrAnnotationHelper
	@Inject extension IrFunctionFactory
	@Inject extension IrVariableFactory
	@Inject extension IrIteratorFactory
	@Inject extension ExpressionTypeProvider
	@Inject extension ReductionCallExtensions
	@Inject extension VarRefExtensions
	@Inject extension NablaType2IrType

	def dispatch Expression toIrExpression(ContractedIf e)
	{
		IrFactory::eINSTANCE.createContractedIf =>
		[
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			condition = e.condition.toIrExpression
			thenExpression = e.then.toIrExpression
			elseExpression = e.^else.toIrExpression
		]
	}

	def dispatch Expression toIrExpression(Or e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(And e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Equality e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Comparison e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Plus e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Minus e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(MulOrDiv e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Modulo e) { e.toIrBinaryExpr(e.left, e.right, e.op) }

	def dispatch Expression toIrExpression(Parenthesis e)
	{
		IrFactory::eINSTANCE.createParenthesis =>
		[
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			expression = e.expression.toIrExpression
		]
	}

	def dispatch Expression toIrExpression(UnaryMinus e) { e.toIrUnaryExpr(e.expression,'-') }
	def dispatch Expression toIrExpression(Not e) { e.toIrUnaryExpr(e.expression, '!') }

	def dispatch Expression toIrExpression(IntConstant e)
	{
		IrFactory::eINSTANCE.createConstant =>
		[
			annotations += e.toIrAnnotation 
			type = e.typeFor?.toIrType
			value = e.value.toString
		]
	}

	def dispatch Expression toIrExpression(RealConstant e)
	{
		IrFactory::eINSTANCE.createConstant =>
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			value = e.value.toString
		]
	}

	def dispatch Expression toIrExpression(BoolConstant e)
	{
		IrFactory::eINSTANCE.createConstant =>
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			value = e.value.toString
		]
	}

	def dispatch Expression toIrExpression(MinConstant e)
	{
		IrFactory::eINSTANCE.createMinConstant =>
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
		]
	}

	def dispatch Expression toIrExpression(MaxConstant e)
	{
		IrFactory::eINSTANCE.createMaxConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
		]
	}

	def dispatch Expression toIrExpression(BaseTypeConstant e)
	{
		IrFactory::eINSTANCE.createBaseTypeConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			value = e.value.toIrExpression
		]
	}

	def dispatch Expression toIrExpression(IntVectorConstant e)
	{
		IrFactory::eINSTANCE.createIntVectorConstant =>
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			values += e.values
		]
	}

	def dispatch Expression toIrExpression(IntMatrixConstant e)
	{
		IrFactory::eINSTANCE.createIntMatrixConstant =>
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			for (ev : e.values)
				values += IrFactory::eINSTANCE.createIntVectorConstant =>
				[
					annotations += e.toIrAnnotation
					type = e.typeFor?.toIrType
					values += ev.values
				]
		]
	}

	def dispatch Expression toIrExpression(RealVectorConstant e)
	{
		IrFactory::eINSTANCE.createRealVectorConstant =>
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			values += e.values
		]
	}

	def dispatch Expression toIrExpression(RealMatrixConstant e)
	{
		IrFactory::eINSTANCE.createRealMatrixConstant =>
		[
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			for (ev : e.values)
				values += IrFactory::eINSTANCE.createRealVectorConstant =>
				[
					annotations += e.toIrAnnotation
					type = e.typeFor?.toIrType
					values += ev.values
				]
		]
	}

	def dispatch Expression toIrExpression(FunctionCall e)
	{
		IrFactory::eINSTANCE.createFunctionCall =>
		[
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			function = e.function.toIrFunction(e.declaration.model)
			args += e.args.map[toIrExpression]
		]
	}

	def dispatch Expression toIrExpression(ReductionCall e)
	{
		// val irVariable = if (e.global) e.toIrGlobalVariable else e.toIrLocalVariable
		val irVariable = e.toIrLocalVariable
		IrFactory::eINSTANCE.createVarRef =>
		[
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			variable = irVariable
		]
	}

	def dispatch Expression toIrExpression(VarRef e)
	{
		IrFactory::eINSTANCE.createVarRef =>
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrType
			variable = e.variable.toIrVariable(e.timeSuffix)
			for (i : e.indices)
				indices += i.toIrExpression
			for (i : 0..<e.spaceIterators.size)
				iterators += e.spaceIterators.get(i).toIrVarRefIteratorRef(i)
		]
	}

	private def create IrFactory::eINSTANCE.createBinaryExpression toIrBinaryExpr(fr.cea.nabla.nabla.Expression container, fr.cea.nabla.nabla.Expression l, fr.cea.nabla.nabla.Expression r, String op)
	{
		annotations += container.toIrAnnotation
		type = container.typeFor?.toIrType
		operator = op
		left = l.toIrExpression
		right = r.toIrExpression
	}

	private def create IrFactory::eINSTANCE.createUnaryExpression toIrUnaryExpr(fr.cea.nabla.nabla.Expression container, fr.cea.nabla.nabla.Expression e, String op)
	{
		annotations += container.toIrAnnotation
		type = container.typeFor?.toIrType
		operator = op
		expression = e.toIrExpression
	}
}