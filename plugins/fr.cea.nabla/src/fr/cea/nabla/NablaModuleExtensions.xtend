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

import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import java.util.ArrayList

class NablaModuleExtensions 
{
	def getAllVars(NablaModule it)
	{
		val allVars = new ArrayList<Var>
		allVars.addAll(instructions.filter(SimpleVarDefinition).map[variable]) 
		instructions.filter(VarGroupDeclaration).forEach[g | allVars.addAll(g.variables)]
		return allVars
	}

	def getFunctionByName(NablaModule it, String funcName)
	{
		return functions.findFirst[f | f.name == funcName]
	}

	def getReductionByName(NablaModule it, String reducName)
	{
		return reductions.findFirst[f | f.name == reducName]
	}

	def getJobByName(NablaModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}

	def getConnectivityByName(NablaModule it, String connectivityName)
	{
		connectivities.findFirst[c | c.name == connectivityName]
	}

	def getItemTypeByName(NablaModule it, String itemTypeName)
	{
		itemTypes.findFirst[i | i.name == itemTypeName]
	}

	def getVariableByName(NablaModule it, String variableName)
	{
		allVars.findFirst[v | v.name == variableName]
	}
}