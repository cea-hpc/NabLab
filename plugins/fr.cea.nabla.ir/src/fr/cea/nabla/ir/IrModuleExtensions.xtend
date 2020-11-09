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

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

class IrModuleExtensions
{
	static def String[] getAllProviders(IrModule it)
	{
		functions.filter[x | x.provider!='Math' && x.body===null].map[provider + Utils::FunctionReductionPrefix].toSet
	}

	static def getJobByName(IrModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}

	static def getVariablesWithDefaultValue(IrModule it)
	{
		variables.filter(SimpleVariable).filter[x | x.defaultValue !== null]
	}

	static def isLinearAlgebra(IrModule it)
	{
		variables.filter(ConnectivityVariable).exists[x | x.linearAlgebra]
	}

	static def getVariableByName(IrModule it, String irVarName)
	{
		var Variable v = options.findFirst[j | j.name == irVarName]
		if (v === null) v = variables.findFirst[j | j.name == irVarName]
		return v
	}
}
