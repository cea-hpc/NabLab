/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrRoot

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

class IrRootExtensions
{
	static def getOptions(IrRoot it)
	{
		variables.filter[option]
	}

	static def getMainModule(IrRoot it)
	{
		modules.findFirst[main]
	}

	static def isLinearAlgebra(IrRoot it)
	{
		variables.exists[v | v.linearAlgebra]
	}

	static def getDirName(IrRoot it)
	{
		name.toLowerCase
	}

	static def getExecName(IrRoot it)
	{
		name.toLowerCase
	}
}
