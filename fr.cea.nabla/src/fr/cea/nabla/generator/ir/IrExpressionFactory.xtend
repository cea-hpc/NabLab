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
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.FunctionCallExtensions
import fr.cea.nabla.VarRefExtensions
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Real2Constant
import fr.cea.nabla.ir.ir.Real3Constant
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BasicType
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
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
import fr.cea.nabla.nabla.Real2x2Constant
import fr.cea.nabla.nabla.Real3x3Constant
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.RealXCompactConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarRef
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NablaType

class IrExpressionFactory 
{
	@Inject extension FunctionCallExtensions
	@Inject extension IrAnnotationHelper
	@Inject extension Nabla2IrUtils
	@Inject extension IrFunctionFactory
	@Inject extension IrVariableFactory
	@Inject extension IrIteratorFactory
	@Inject extension ExpressionTypeProvider
	@Inject extension ReductionCallExtensions
	@Inject extension VarRefExtensions
	
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
		IrFactory::eINSTANCE.createIntConstant => 
		[
			annotations += e.toIrAnnotation 
			type = e.typeFor?.toIrExpressionType
			value = e.value 
		]
	}
	
	def dispatch Expression toIrExpression(RealConstant e) 
	{ 
		IrFactory::eINSTANCE.createRealConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			value = e.value 
		]
	}
	
	def dispatch Expression toIrExpression(fr.cea.nabla.nabla.Real2Constant e) 
	{ 
		IrFactory::eINSTANCE.createReal2Constant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			x = e.x
			y = e.y
		]
	}
	
	def dispatch Expression toIrExpression(fr.cea.nabla.nabla.Real3Constant e) 
	{ 
		IrFactory::eINSTANCE.createReal3Constant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			x = e.x 
			y = e.y
			z = e.z
		]
	}
	
	def dispatch Expression toIrExpression(Real2x2Constant e) 
	{ 
		IrFactory::eINSTANCE.createReal2x2Constant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			x = e.x.toIrExpression as Real2Constant
			y = e.y.toIrExpression as Real2Constant
		]
	}
	
	def dispatch Expression toIrExpression(Real3x3Constant e) 
	{ 
		IrFactory::eINSTANCE.createReal3x3Constant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			x = e.x.toIrExpression as Real3Constant
			y = e.y.toIrExpression as Real3Constant
			z = e.z.toIrExpression as Real3Constant
		]
	}
	
	def dispatch Expression toIrExpression(BoolConstant e) 
	{ 
		IrFactory::eINSTANCE.createBoolConstant => 
		[ 
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
			value = e.value
		]
	}
	
	def dispatch Expression toIrExpression(RealXCompactConstant e) 
	{
		toIrRealExpression(e.type, e.value) =>
		[
			annotations += e.toIrAnnotation
			type = e.typeFor?.toIrExpressionType
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
			e.spaceIterators.forEach[x | iterators += x.toIrIteratorRangeOrRef]
			e.fields.forEach[x | fields += x]
		]
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
	
	// Attention, pas de fonction create mais une creation systématique
	private def toIrExpressionType(NablaType t)
	{
		IrFactory::eINSTANCE.createExpressionType => 
		[
			basicType = t.base.toIrBasicType
			dimension = t.dimension
		]
	}
	
	private def toIrRealExpression(BasicType type, double v)
	{
		switch type
		{
			case REAL: IrFactory::eINSTANCE.createRealConstant => [ value=v ]
			case REAL2: IrFactory::eINSTANCE.createReal2Constant => [ x=v y=v ]
			case REAL3: IrFactory::eINSTANCE.createReal3Constant => [ x=v y=v z=v ]
			case REAL2X2: IrFactory::eINSTANCE.createReal2x2Constant => 
			[ 
				x=IrFactory::eINSTANCE.createReal2Constant => [ x=v y=v ]
				y=IrFactory::eINSTANCE.createReal2Constant => [ x=v y=v ]
			]
			case REAL3X3: IrFactory::eINSTANCE.createReal3x3Constant => 
			[ 
				x=IrFactory::eINSTANCE.createReal3Constant => [ x=v y=v z=v ]
				y=IrFactory::eINSTANCE.createReal3Constant => [ x=v y=v z=v ]
				z=IrFactory::eINSTANCE.createReal3Constant => [ x=v y=v z=v ]
			]
			default: throw new RuntimeException("Type inattendu dans une constante : " + type.literal)
		}
	}
}