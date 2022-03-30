/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.Variable

class ArgOrVarExtensions
{
	static def isIteratorCounter(ArgOrVar it)
	{
		eContainer instanceof Iterator
	}

	static def isOption(ArgOrVar it)
	{
		(it instanceof Variable && (it as Variable).option)
	}

	static def isGlobal(ArgOrVar it)
	{
		(it instanceof Variable && eContainer instanceof IrModule)
	}

	static def isLinearAlgebra(ArgOrVar it)
	{
		it.type instanceof LinearAlgebraType
	}

	static def isFunctionDimVar(ArgOrVar it)
	{
		eContainer instanceof Function && eContainingFeature === IrPackage.eINSTANCE.function_Variables
	}
}
