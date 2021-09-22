/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.RealConstant

class Utils
{
	static def getDaceType(PrimitiveType t)
	{
		switch t
		{
			case BOOL: "dp.bool"
			case INT: "dp.int64"
			case REAL: "dp.float64"
		}
	}

	static def getDaceType(Expression e)
	{
		switch e
		{
			ArgOrVarRef: "[" + e.target.name + "]"
			IntConstant: e.value
			RealConstant: e.value
			BoolConstant: e.value
			default: throw new RuntimeException("Not yet implemented")
		}
	}

	static def String getLabel(Expression e)
	{
		switch e
		{
			ArgOrVarRef: e.target.name
			IntConstant: e.value.toString
			RealConstant: e.value.toString
			BoolConstant: e.value.toString
			BinaryExpression: getLabel(e.left) + e.operator + getLabel(e.right)
			default: throw new RuntimeException("Not yet implemented")
		}
	}
}