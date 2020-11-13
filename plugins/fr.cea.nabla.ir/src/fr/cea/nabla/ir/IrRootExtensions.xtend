/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.ConnectivityVariable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

class IrRootExtensions
{
	static def getOptions(IrRoot it)
	{
		variables.filter(SimpleVariable).filter[option]
	}

	static def getMainModule(IrRoot it)
	{
		modules.findFirst[main]
	}

	static def isLinearAlgebra(IrRoot it)
	{
		variables.filter(ConnectivityVariable).exists[x | x.linearAlgebra]
	}
}
