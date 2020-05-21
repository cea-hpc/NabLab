/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.overloading

import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.NablaFactory
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.SimpleVar
import java.util.HashMap
import org.eclipse.emf.ecore.util.EcoreUtil

interface ExpressionTransformer
{
	def Expression transform(Expression it)
}

/**
 * Replace size variables by their value in argument expr.
 */
class ReplaceKnownSizeValues implements ExpressionTransformer
{
	val HashMap<SimpleVar, Expression> sizeVarValues

	new(HashMap<SimpleVar, Expression> sizeVarValues)
	{
		this.sizeVarValues = sizeVarValues
	}

	override transform(Expression it) { dispatchTransform }

	private def dispatch Expression dispatchTransform(Expression it)
	{
		it
	}

	private def dispatch Expression dispatchTransform(Plus it) 
	{
		left = left.dispatchTransform
		right = right.dispatchTransform
		return it
	}

	private def dispatch Expression dispatchTransform(Minus it)
	{
		left = left.dispatchTransform
		right = right.dispatchTransform
		return it
	}

	private def dispatch Expression dispatchTransform(Mul it)
	{
		left = left.dispatchTransform
		right = right.dispatchTransform
		return it
	}

	private def dispatch Expression dispatchTransform(Div it)
	{
		left = left.dispatchTransform
		right = right.dispatchTransform
		return it
	}

	private def dispatch Expression dispatchTransform(Modulo it)
	{
		left = left.dispatchTransform
		right = right.dispatchTransform
		return it
	}

	private def dispatch Expression dispatchTransform(Parenthesis it)
	{
		expression = expression.dispatchTransform
		return it
	}

	private def dispatch Expression dispatchTransform(ArgOrVarRef it)
	{
		if (timeIterators.empty && spaceIterators.empty && indices.empty && target instanceof SimpleVar)
		{
			val v = target as SimpleVar
			val vValue = sizeVarValues.get(v)
			if (vValue === null) null
			else EcoreUtil::copy(vValue)
		}
	}
}

/**
 * Apply binary operators on IntConstant value if possible.
 */
class ApplyPossibleBinaryOperations implements ExpressionTransformer
{
	override transform(Expression it) { dispatchTransform }

	private def dispatch Expression dispatchTransform(Expression it)
	{
		it
	}

	private def dispatch Expression dispatchTransform(Plus it)
	{
		val lv = left.dispatchTransform
		val rv = right.dispatchTransform
		if (lv instanceof IntConstant && rv instanceof IntConstant)
			return createIntConstant((lv as IntConstant).value + (rv as IntConstant).value)
		else
		{
			left = lv
			right = rv
			return it
		}
	}

	private def dispatch Expression dispatchTransform(Minus it)
	{
		val lv = left.dispatchTransform
		val rv = right.dispatchTransform
		if (lv instanceof IntConstant && rv instanceof IntConstant)
			return createIntConstant((lv as IntConstant).value - (rv as IntConstant).value)
		else
		{
			left = lv
			right = rv
			return it
		}
	}

	private def dispatch Expression dispatchTransform(Mul it)
	{
		val lv = left.dispatchTransform
		val rv = right.dispatchTransform
		if (lv instanceof IntConstant && rv instanceof IntConstant)
			return createIntConstant((lv as IntConstant).value * (rv as IntConstant).value)
		else
		{
			left = lv
			right = rv
			return it
		}
	}

	private def dispatch Expression dispatchTransform(Div it) 
	{
		val lv = left.dispatchTransform
		val rv = right.dispatchTransform
		if (lv instanceof IntConstant && rv instanceof IntConstant)
			return createIntConstant((lv as IntConstant).value / (rv as IntConstant).value)
		else
		{
			left = lv
			right = rv
			return it
		}
	}

	private def dispatch Expression dispatchTransform(Modulo it) 
	{ 
		val lv = left.dispatchTransform
		val rv = right.dispatchTransform
		if (lv instanceof IntConstant && rv instanceof IntConstant)
			return createIntConstant((lv as IntConstant).value % (rv as IntConstant).value)
		else
		{
			left = lv
			right = rv
			return it
		}
	}

	private def dispatch Expression dispatchTransform(Parenthesis it)
	{
		expression = expression.dispatchTransform
		return it
	}

	private def createIntConstant(int v)
	{
		NablaFactory::eINSTANCE.createIntConstant => [value = v]
	}
}