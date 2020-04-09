/*******************************************************************************
 * Copyright (c) 2018, 2019 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.ReductionCall

class ExpressionExtensions
{
	def boolean respectGlobalExprConstraints(Expression e)
	{
		e.respectGE && e.eAllContents.filter(Expression).forall[respectGE]
	}

	def boolean respectIntConstExprConstraints(Expression e)
	{
		val result = e.respectICE && e.eAllContents.filter(Expression).forall[respectICE]
		return result
	}

	private def respectICE(Expression e)
	{
		switch e
		{
			Plus, Minus, Mul, Div, Modulo, Parenthesis, IntConstant, ArgOrVarRef: true
			default: false
		}
	}

	private def respectGE(Expression e)
	{
		switch e
		{
			ReductionCall: false
			default: true
		}
	}
}