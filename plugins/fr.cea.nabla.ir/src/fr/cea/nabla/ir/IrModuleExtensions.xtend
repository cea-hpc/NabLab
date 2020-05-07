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

import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

class IrModuleExtensions
{
	static def getJobByName(IrModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}

	static def getVariablesWithDefaultValue(IrModule it)
	{
		definitions.filter[x | !x.option && x.defaultValue!==null]
	}

	static def isLinearAlgebra(IrModule it)
	{
		declarations.filter(ConnectivityVariable).exists[x | x.linearAlgebra]
	}

	/**
	 * Return the list of connectivities used by the module
	 * during variables and iterators definition.
	 */
	static def getUsedConnectivities(IrModule it)
	{
		val connectivities = declarations.filter(ConnectivityVariable).map[type.connectivities].flatten.toSet
		jobs.forEach[j | connectivities += j.eAllContents.filter(ConnectivityCall).map[connectivity].toSet]
		return connectivities.filter[c | c.multiple]
	}

	static def getVariableByName(IrModule it, String varName)
	{
		var Variable variable = definitions.findFirst[j | j.name == varName]
		if (variable === null) variable = declarations.findFirst[j | j.name == varName]
		return variable
	}

	static def withMesh(IrModule it) { !itemTypes.empty }

	static def getCurrentIrVariable(IrModule m, String nablaVariableName) { getIrVariable(m, nablaVariableName, false) }
	static def getInitIrVariable(IrModule m, String nablaVariableName) { getIrVariable(m, nablaVariableName, true) }

	private static def getIrVariable(IrModule m, String nablaVariableName, boolean initTimeIterator)
	{
		var irVariable = getVariableByName(m, nablaVariableName)
		if (irVariable === null && m.mainTimeLoop !== null) 
		{
			val timeLoopVariable = m.mainTimeLoop.variables.findFirst[x | x.name == nablaVariableName]
			if (timeLoopVariable !== null) 
			{
				if (initTimeIterator && timeLoopVariable.init !== null) 
					irVariable = timeLoopVariable.init
				else
					irVariable = timeLoopVariable.current
			}
		}
		return irVariable
	}
}
