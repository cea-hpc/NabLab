/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ConstExprServices
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Cardinality
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VectorConstant
import fr.cea.nabla.overloading.DeclarationProvider
import fr.cea.nabla.typing.ExpressionTypeProvider

class IrExpressionFactory
{
	@Inject extension ReductionCallExtensions
	@Inject extension DeclarationProvider
	@Inject extension ExpressionTypeProvider
	@Inject extension NabLabFileAnnotationFactory
	@Inject extension IrFunctionFactory
	@Inject extension IrArgOrVarFactory
	@Inject extension IrItemIndexFactory
	@Inject extension IrContainerFactory
	@Inject extension NablaType2IrType
	@Inject ConstExprServices constExprServices

	def dispatch Expression toIrExpression(ContractedIf e)
	{
		IrFactory::eINSTANCE.createContractedIf =>
		[
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			condition = e.condition.toIrExpression
			thenExpression = e.then.toIrExpression
			elseExpression = e.^else.toIrExpression
			constExpr = condition.constExpr && thenExpression.constExpr && elseExpression.constExpr
		]
	}

	def dispatch Expression toIrExpression(Or e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(And e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Equality e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Comparison e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Plus e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Minus e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Mul e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Div e) { e.toIrBinaryExpr(e.left, e.right, e.op) }
	def dispatch Expression toIrExpression(Modulo e) { e.toIrBinaryExpr(e.left, e.right, e.op) }

	def dispatch Expression toIrExpression(Parenthesis e)
	{
		IrFactory::eINSTANCE.createParenthesis =>
		[
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			expression = e.expression.toIrExpression
			constExpr = expression.constExpr
		]
	}

	def dispatch Expression toIrExpression(UnaryMinus e) { e.toIrUnaryExpr(e.expression,'-') }
	def dispatch Expression toIrExpression(Not e) { e.toIrUnaryExpr(e.expression, '!') }

	def dispatch Expression toIrExpression(IntConstant e)
	{
		IrFactory::eINSTANCE.createIntConstant =>
		[
			annotations += e.toNabLabFileAnnotation 
			type = e.typeFor?.toIrType
			value = e.value
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	def dispatch Expression toIrExpression(RealConstant e)
	{
		IrFactory::eINSTANCE.createRealConstant =>
		[ 
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			value = e.value
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	def dispatch Expression toIrExpression(BoolConstant e)
	{
		IrFactory::eINSTANCE.createBoolConstant =>
		[ 
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			value = e.value
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	def dispatch Expression toIrExpression(MinConstant e)
	{
		IrFactory::eINSTANCE.createMinConstant =>
		[ 
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	def dispatch Expression toIrExpression(MaxConstant e)
	{
		IrFactory::eINSTANCE.createMaxConstant => 
		[ 
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	def dispatch Expression toIrExpression(FunctionCall e)
	{
		IrFactory::eINSTANCE.createFunctionCall =>
		[
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			function = e.declaration.model.toIrFunction
			args += e.args.map[toIrExpression]
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	def dispatch Expression toIrExpression(ReductionCall e)
	{
		val irVariable = e.toIrLocalVariable
		IrFactory::eINSTANCE.createArgOrVarRef =>
		[
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			target = irVariable
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	def dispatch Expression toIrExpression(BaseTypeConstant e)
	{
		IrFactory::eINSTANCE.createBaseTypeConstant => 
		[ 
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType // for arrays, only IntConstants in sizes
			value = e.value.toIrExpression 
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	def dispatch Expression toIrExpression(VectorConstant e)
	{
		IrFactory::eINSTANCE.createVectorConstant =>
		[ 
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			e.values.forEach[x | values += x.toIrExpression]
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	def dispatch Expression toIrExpression(Cardinality e)
	{
		IrFactory::eINSTANCE.createCardinality =>
		[ 
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			container = e.container.toIrContainer
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	def dispatch Expression toIrExpression(ArgOrVarRef e)
	{
		IrFactory::eINSTANCE.createArgOrVarRef =>
		[ 
			annotations += e.toNabLabFileAnnotation
			type = e.typeFor?.toIrType
			target = toIrArgOrVar(e.target, e.timeIterators)
			e.indices.forEach[x | indices += x.toIrExpression]
			for (i : 0..<e.spaceIterators.size)
				iterators += toIrIndex(new IndexInfo(e, e.spaceIterators.get(i)))
			constExpr = constExprServices.isConstExpr(e)
		]
	}

	private def create IrFactory::eINSTANCE.createBinaryExpression toIrBinaryExpr(fr.cea.nabla.nabla.Expression container, fr.cea.nabla.nabla.Expression l, fr.cea.nabla.nabla.Expression r, String op)
	{
		annotations += container.toNabLabFileAnnotation
		type = container.typeFor?.toIrType
		operator = op
		left = l.toIrExpression
		right = r.toIrExpression
		constExpr = left.constExpr && right.constExpr
	}

	private def create IrFactory::eINSTANCE.createUnaryExpression toIrUnaryExpr(fr.cea.nabla.nabla.Expression container, fr.cea.nabla.nabla.Expression e, String op)
	{
		annotations += container.toNabLabFileAnnotation
		type = container.typeFor?.toIrType
		operator = op
		expression = e.toIrExpression
		constExpr = expression.constExpr
	}
}