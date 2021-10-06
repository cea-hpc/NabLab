/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.Cardinality
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.OptionDeclaration
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.VarDeclaration
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.SpaceIterator

/**
 * This class evaluates the value of a BaseType.sizes expression.
 * If the expression is not allowed in a BaseType size expression, an exception is thrown.
 * Otherwise its integer value is evaluated.
 * If the type is dynamic, DYNAMIC_SIZE constant is returned.
 */
class BaseTypeSizeEvaluator
{
	public static val int DYNAMIC_SIZE = IrTypeExtensions::DYNAMIC_SIZE

	def int getIntSizeFor(Expression e)
	{
		switch e
		{
			Plus: getIntSizeForBinaryOp(e.left, e.right, e.op)
			Minus: getIntSizeForBinaryOp(e.left, e.right, e.op)
			Mul: getIntSizeForBinaryOp(e.left, e.right, e.op)
			Div: getIntSizeForBinaryOp(e.left, e.right, e.op)
			Modulo: getIntSizeForBinaryOp(e.left, e.right, e.op)
			Parenthesis: getIntSizeFor(e.expression)
			IntConstant: e.value
			MinConstant: Integer.MIN_VALUE
			MaxConstant: Integer.MAX_VALUE
			ArgOrVarRef case (e.spaceIterators.empty && e.indices.empty): getIntSizeForVar(e)
			Cardinality: DYNAMIC_SIZE
			default: throw new InvalidBaseTypeSize(e)
		}
	}

	package def int getIntSizeForBinaryOp(Expression left, Expression right, String op)
	{
		val iLeft = left.intSizeFor
		if (iLeft == DYNAMIC_SIZE) return iLeft
		val iRight = right.intSizeFor
		if (iRight == DYNAMIC_SIZE) return iRight
		switch op
		{
			case "+": return iLeft + iRight
			case "-": return iLeft - iRight
			case "*": return iLeft * iRight
			case "/": return iLeft / iRight
			case "%": return iLeft % iRight
		}
		throw new InvalidBaseTypeSize(left)
	}

	private def int getIntSizeForVar(ArgOrVarRef vref)
	{
		val v = vref.target
		val c = v.eContainer
		if (c !== null)
		{
			switch c
			{
				// option always dynamic, even if it has a default value,
				// the value can be overwritten with the json file value
				OptionDeclaration case (c.type.primitive == PrimitiveType::INT):
						return DYNAMIC_SIZE
				SimpleVarDeclaration case (c.type.primitive == PrimitiveType::INT):
					if (c.value === null)
						return DYNAMIC_SIZE
					else
						return getIntSizeFor(c.value)
				VarDeclaration case (c.type.primitive == PrimitiveType::INT):
					return DYNAMIC_SIZE
				FunctionOrReduction, SpaceIterator, Interval:
					return DYNAMIC_SIZE
			}
		}
		throw new InvalidBaseTypeSize(vref)
	}
}

class InvalidBaseTypeSize extends Exception
{
	new(Expression e)
	{
		super("Expression type not allowed for BaseType size: " + e.class.name)
	}
}