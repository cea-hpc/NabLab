/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.ir.VectorConstant
import java.util.ArrayList
import org.eclipse.emf.ecore.util.EcoreUtil

/**
 * Unary/binary operators on non scalar types are replaced by functions within loops.
 * Operators are renamed to have a valid function name in any language.
 * Note that specializations can be done by languages supporting operator overload.
 */
class CreateArrayOperators extends IrTransformationStep
{
	val opUtils = new OperatorUtils
	val expressionsToDelete = new ArrayList<Expression>

	static val UnaryOperatorNames = #{
		'-' -> 'Minus',
		'!' -> 'Not'
	}

	static val BinaryOperatorNames = #{
		'||' -> 'Or',
		'&&' -> 'And',
		'==' -> 'Equal',
		'!=' -> 'NotEqual',
		'>=' -> 'Gte',
		'<=' -> 'Lte',
		'>' -> 'Gt',
		'<' -> 'Lt',
		'+' -> 'Add',
		'-' -> 'Sub',
		'*' -> 'Mult',
		'/' -> 'Div',
		'%' -> 'Mod'
	}

	new()
	{
		super('Replace unary/binary operators with array arguments by functions')
	}

	override transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)

		var boolean ret = false
		try
		{
			for (o : ir.eAllContents.filter[x | x instanceof Instruction || x instanceof Variable].toIterable)
				for (r : o.eClass.EAllReferences.filter[x | x.EType == IrPackage.Literals.EXPRESSION])
				{
					// No list of expressions in IR for the moment
					if (r.many) throw new RuntimeException("Not yet implemented")
	
					val refValue = o.eGet(r)
					if (refValue !== null)
					{
						// Do not filter on scalar expressions :
						// a function can return a scalar type and have array arguments
						// f(R[3] x) : R
						val expr = refValue as Expression
						o.eSet(r, createArrayOperations(expr))
					}
				}
	
			for (e : expressionsToDelete)
				EcoreUtil.delete(e)

			ret = true
		}
		catch (Exception e)
		{
			trace(e.class.name + ": " + e.message)
			trace(IrUtils.getStackTrace(e))
			ret = false
		}

		return ret
	}

	private def Expression createArrayOperations(Expression e)
	{
		switch e
		{
			UnaryExpression:
			{
				// Only non scalar expressions needs array operations
				if (e.type instanceof BaseType && (e.type as BaseType).sizes.size > 0)
				{
					val type = (e.type as BaseType)
					val dimension = type.sizes.size
					val module = IrUtils.getContainerOfType(e, IrModule)
					val unaryOp = toIrUnaryOperation(type.primitive, dimension, e.operator)
					module.functions += unaryOp
					expressionsToDelete += e
					return IrFactory::eINSTANCE.createFunctionCall =>
					[
						function = unaryOp
						type = EcoreUtil.copy(e.type)
						args += createArrayOperations(e.expression)
					]
				}
				else
				{
					e.expression = createArrayOperations(e.expression)
					return e
				}
			}
			BinaryExpression:
			{
				// Only non scalar expressions needs array operations
				if (e.type instanceof BaseType && (e.type as BaseType).sizes.size > 0)
				{
					val type = (e.type as BaseType)
					val dimension = type.sizes.size
					val module = IrUtils.getContainerOfType(e, IrModule)
					val leftType = e.left.type as BaseType
					val rightType = e.right.type as BaseType
					val binOpType = opUtils.getBinOpType(leftType, rightType)
					val binaryOp = toIrBinaryOperation(leftType.primitive, rightType.primitive, dimension, binOpType, e.operator)
					module.functions += binaryOp
					expressionsToDelete += e
					return IrFactory::eINSTANCE.createFunctionCall =>
					[
						function = binaryOp
						type = EcoreUtil.copy(e.type)
						args += createArrayOperations(e.left)
						args += createArrayOperations(e.right)
					]
				}
				else
				{
					e.left = createArrayOperations(e.left)
					e.right = createArrayOperations(e.right)
					return e
				}
			}
			BaseTypeConstant:
			{
				e.value = createArrayOperations(e.value)
				return e
			}
			ContractedIf:
			{
				e.condition = createArrayOperations(e.condition)
				e.thenExpression = createArrayOperations(e.thenExpression)
				if (e.elseExpression !== null)
					e.elseExpression = createArrayOperations(e.elseExpression)
				return e
			}
			FunctionCall:
			{
				for (i : 0..<e.args.size)
					e.args.set(i, createArrayOperations(e.args.get(i)))
				return e
			}
			Parenthesis:
			{
				e.expression = createArrayOperations(e.expression)
				return e
			}
			VectorConstant:
			{
				for (i : 0..<e.values.size)
					e.values.set(i, createArrayOperations(e.values.get(i)))
				return e
			}
			default: return e
		}
	}

	private def create IrFactory::eINSTANCE.createInternFunction toIrUnaryOperation(PrimitiveType primitiveType, int dimension, String op)
	{
		val suffix = UnaryOperatorNames.get(op)
		if (suffix === null) throw new RuntimeException("Operator not supported: " + op)
		name = OperatorUtils.OperatorPrefix + suffix

		// create size variables
		for (i : 0..<dimension)
		{
			val v = IrFactory::eINSTANCE.createVariable
			v.name = "x" + i
			v.type = opUtils.createScalarBaseType(PrimitiveType.INT)
			v.option = false
			v.const = true
			v.constExpr = true
			variables += v
		}

		// return type
		returnType = createArrayBaseType(primitiveType, variables)

		// create argument
		val a = IrFactory::eINSTANCE.createArg
		a.name = "a"
		a.type = createArrayBaseType(primitiveType, variables)
		inArgs += a

		// create the result variable
		val result = IrFactory::eINSTANCE.createVariable
		result.name = "result"
		result.const = false
		result.constExpr = false
		result.option = false
		result.type = createArrayBaseType(primitiveType, variables)

		// create body
		val block = IrFactory::eINSTANCE.createInstructionBlock
		body = block

		// variable declaration to store the result
		block.instructions += IrFactory::eINSTANCE.createVariableDeclaration => [ variable = result ]

		// loops and binary operation
		val resultRef = opUtils.createArgOrVarRef(result)
		val aRef = opUtils.createArgOrVarRef(a)
		val Interval[] intervals = newArrayOfSize(variables.size)
		for (i : 0..<intervals.size) intervals.set(i, createInterval(variables.get(i)))
		block.instructions += opUtils.createLoopForUnaryOp(resultRef, aRef, intervals, op)

		// return instruction to return the result
		block.instructions += IrFactory::eINSTANCE.createReturn => [ expression = opUtils.createArgOrVarRef(result) ]
	}

	private def create IrFactory::eINSTANCE.createInternFunction toIrBinaryOperation(PrimitiveType aPrimitive, PrimitiveType bPrimitive, int dimension, OperatorUtils.BinOpType binOpType, String op)
	{
		val suffix = BinaryOperatorNames.get(op)
		if (suffix === null) throw new RuntimeException("Operator not supported: " + op)
		name = OperatorUtils.OperatorPrefix + suffix

		// create size variables
		for (i : 0..<dimension)
		{
			val v = IrFactory::eINSTANCE.createVariable
			v.name = "x" + i
			v.type = opUtils.createScalarBaseType(PrimitiveType.INT)
			v.option = false
			v.const = true
			v.constExpr = true
			variables += v
		}

		// return type
		val returnPrimitiveType = (binOpType == OperatorUtils.BinOpType::ScalarArray ? bPrimitive : aPrimitive)
		returnType = createArrayBaseType(returnPrimitiveType, variables)

		// create first argument
		val a = IrFactory::eINSTANCE.createArg
		a.name = "a"
		if (binOpType == OperatorUtils.BinOpType::ScalarArray)
			a.type = opUtils.createScalarBaseType(aPrimitive)
		else
			a.type = createArrayBaseType(aPrimitive, variables)
		inArgs += a

		// create second argument
		val b = IrFactory::eINSTANCE.createArg
		b.name = "b"
		if (binOpType == OperatorUtils.BinOpType::ArrayScalar)
			b.type = opUtils.createScalarBaseType(bPrimitive)
		else
			b.type = createArrayBaseType(bPrimitive, variables)
		inArgs += b

		// create the result variable
		val result = IrFactory::eINSTANCE.createVariable
		result.name = "result"
		result.const = false
		result.constExpr = false
		result.option = false
		result.type = createArrayBaseType(returnPrimitiveType, variables)

		// create body
		val block = IrFactory::eINSTANCE.createInstructionBlock
		body = block

		// variable declaration to store the result
		block.instructions += IrFactory::eINSTANCE.createVariableDeclaration => [ variable = result ]

		// loops and binary operation
		val resultRef = opUtils.createArgOrVarRef(result)
		val aRef = opUtils.createArgOrVarRef(a)
		val bRef = opUtils.createArgOrVarRef(b)
		val Interval[] intervals = newArrayOfSize(variables.size)
		for (i : 0..<intervals.size) intervals.set(i, createInterval(variables.get(i)))
		block.instructions += opUtils.createLoopForBinaryOp(resultRef, aRef, bRef, intervals, binOpType, op)

		// return instruction to return the result
		block.instructions += IrFactory::eINSTANCE.createReturn => [ expression = opUtils.createArgOrVarRef(result) ]
	}

	private def createInterval(Variable sizeVariable)
	{
		IrFactory::eINSTANCE.createInterval =>
		[
			index = IrFactory::eINSTANCE.createVariable =>
			[
				name = "i" + sizeVariable.name
				type = opUtils.createScalarBaseType(PrimitiveType::INT)
				const = false
				constExpr = false
				option = false
			]
			nbElems = opUtils.createArgOrVarRef(sizeVariable)
		]
	}

	private def createArrayBaseType(PrimitiveType t, Iterable<Variable> sizeVariables)
	{
		IrFactory::eINSTANCE.createBaseType =>
		[
			primitive = t
			isStatic = false
			for (x : sizeVariables)
			{
				sizes += opUtils.createArgOrVarRef(x)
				intSizes += -1
			}
		]
	}
}
