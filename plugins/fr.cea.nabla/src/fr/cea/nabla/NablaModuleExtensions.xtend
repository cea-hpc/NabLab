/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.OptionDeclaration
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import java.util.ArrayList

class NablaModuleExtensions 
{
	def getAllVars(NablaModule it)
	{
		val allVars = new ArrayList<ArgOrVar>
		for (d : declarations)
			switch d
			{
				OptionDeclaration: allVars += d.variable
				SimpleVarDeclaration: allVars += d.variable
				VarGroupDeclaration: allVars += d.variables
			}
		if (iteration !== null)
			for (v : iteration.eAllContents.filter(TimeIterator).toIterable)
				allVars += v
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

	def getVariableByName(NablaModule it, String variableName)
	{
		allVars.filter(Var).findFirst[v | v.name == variableName]
	}
}