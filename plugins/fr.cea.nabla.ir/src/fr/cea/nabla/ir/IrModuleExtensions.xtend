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

import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

class IrModuleExtensions
{
	static def getJobByName(IrModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}

	static def getVariablesWithDefaultValue(IrModule it)
	{
		variables.filter(SimpleVariable).filter[x|x.defaultValue!==null]
	}

	static def isLinearAlgebra(IrModule it)
	{
		variables.filter(ConnectivityVariable).exists[x | x.linearAlgebra]
	}

//	static def getSimpleVariables(IrModule it)
//	{
//		variables.filter(SimpleVariable)
//	}
//
//	static def getConnectivityVariables(IrModule it)
//	{
//		variables.filter(ConnectivityVariable).filter[!linearAlgebra]
//	}
//
//	static def getLinearAlgebraVariables(IrModule it)
//	{
//		variables.filter(ConnectivityVariable).filter[linearAlgebra]
//	}

	/**
	 * Return the list of connectivities used by the module
	 * during variables and iterators definition.
	 */
	static def getUsedConnectivities(IrModule it)
	{
		val connectivities = variables.filter(ConnectivityVariable).map[type.connectivities].flatten.toSet
		jobs.forEach[j | connectivities += j.eAllContents.filter(ConnectivityCall).map[connectivity].toSet]
		return connectivities.filter[c | c.multiple]
	}

	static def getVariableByName(IrModule it, String varName)
	{
		var ArgOrVar variable = options.findFirst[j | j.name == varName]
		if (variable === null) variable = variables.findFirst[j | j.name == varName]
		return variable
	}

	static def withMesh(IrModule it) { !itemTypes.empty }
}
