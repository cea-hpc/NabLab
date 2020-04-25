/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.Cardinality
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.ReductionCall

class ExpressionExtensions
{
	def boolean respectOptionConstraints(Expression e)
	{
		e.respectOptionExpr && e.eAllContents.filter(Expression).forall[respectOptionExpr]
	}

	def boolean respectGlobalExprConstraints(Expression e)
	{
		e.respectGlobalExpr && e.eAllContents.filter(Expression).forall[respectGlobalExpr]
	}

	def boolean respectIntConstExprConstraints(Expression e)
	{
		e.respectIntConstExpr && e.eAllContents.filter(Expression).forall[respectIntConstExpr]
	}

	private def respectOptionExpr(Expression e)
	{
		switch e
		{
			ReductionCall, FunctionCall: false
			default: true
		}
	}

	private def respectGlobalExpr(Expression e)
	{
		switch e
		{
			ReductionCall: false
			default: true
		}
	}

	private def respectIntConstExpr(Expression e)
	{
		switch e
		{
			Plus, Minus, Mul, Div, Modulo, Parenthesis, IntConstant, Cardinality, ArgOrVarRef: true
			default: false
		}
	}
}