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
import fr.cea.nabla.DeclarationProvider
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
import fr.cea.nabla.typing.ArrayType
import fr.cea.nabla.typing.DefinedType
import fr.cea.nabla.typing.ExpressionType
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.UndefinedType

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
	@Inject extension Nabla2IrUtils
	@Inject extension IrConnectivityFactory
	
	def dispatch Expression toIrExpression(ContractedIf e) 
	{ 
		IrFactory::eINSTANCE.createContractedIf =>
		[
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
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
			type = e.typeFor?.toIrExpressionType
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
			type = e.typeFor?.toIrExpressionType
			value = e.value.toString
		]
	}
	
	def dispatch Expression toIrExpression(RealConstant e) 
	{ 
		IrFactory::eINSTANCE.createConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			value = e.value.toString
		]
	}
	
	def dispatch Expression toIrExpression(BoolConstant e) 
	{ 
		IrFactory::eINSTANCE.createConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			value = e.value.toString
		]
	}
	
	def dispatch Expression toIrExpression(MinConstant e) 
	{ 
		IrFactory::eINSTANCE.createMinConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
		]
	}

	def dispatch Expression toIrExpression(MaxConstant e) 
	{ 
		IrFactory::eINSTANCE.createMaxConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
		]
	}

	def dispatch Expression toIrExpression(FunctionCall e) 
	{ 
		IrFactory::eINSTANCE.createFunctionCall =>
		[
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			function = e.function.toIrFunction(e.declaration)
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
			type = e.typeFor?.toIrExpressionType
			variable = irVariable
		]
	}
	
	def dispatch Expression toIrExpression(VarRef e)
	{
		IrFactory::eINSTANCE.createVarRef => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			variable = e.variable.toIrVariable(e.timeSuffix)
			indices.addAll(e.indices)
			for (i : 0..<e.spaceIterators.size)
				iterators += e.spaceIterators.get(i).toIrVarRefIteratorRef(i)
		]
	}

	def dispatch Expression toIrExpression(RealVectorConstant e) 
	{
		IrFactory::eINSTANCE.createRealVectorConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			values += e.values
		]
	}
	
	def dispatch Expression toIrExpression(RealMatrixConstant e) 
	{
		IrFactory::eINSTANCE.createRealMatrixConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			for (ev : e.values)
				values += IrFactory::eINSTANCE.createRealVectorConstant => 
				[ 
					annotations += e.toIrAnnotation
					type = e.typeFor?.toIrExpressionType
					values += ev.values
				]
		]
	}

	def dispatch Expression toIrExpression(BaseTypeConstant e) 
	{
		IrFactory::eINSTANCE.createBaseTypeConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			value = e.value.toIrExpression
		]
	}

	// Attention, pas de fonction create mais une creation systématique
	def toIrExpressionType(ExpressionType t)
	{
		switch t
		{
			UndefinedType: null
			ArrayType: IrFactory::eINSTANCE.createExpressionType =>
			[
				root = t.root.toIrPrimitiveType
				sizes.addAll(t.sizes)
				t.connectivities.forEach[x | connectivities += x.toIrConnectivity]
			]
			DefinedType: IrFactory::eINSTANCE.createExpressionType =>
			[
				root = t.root.toIrPrimitiveType
				t.connectivities.forEach[x | connectivities += x.toIrConnectivity]
			]
		}
	}

	private def create IrFactory::eINSTANCE.createBinaryExpression toIrBinaryExpr(fr.cea.nabla.nabla.Expression container, fr.cea.nabla.nabla.Expression l, fr.cea.nabla.nabla.Expression r, String op)
	{
		annotations += container.toIrAnnotation
		type = container.typeFor?.toIrExpressionType
		operator = op
		left = l.toIrExpression
		right = r.toIrExpression
	}
	
	private def create IrFactory::eINSTANCE.createUnaryExpression toIrUnaryExpr(fr.cea.nabla.nabla.Expression container, fr.cea.nabla.nabla.Expression e, String op)
	{
		annotations += container.toIrAnnotation
		type = container.typeFor?.toIrExpressionType
		operator = op
		expression = e.toIrExpression
	}
}