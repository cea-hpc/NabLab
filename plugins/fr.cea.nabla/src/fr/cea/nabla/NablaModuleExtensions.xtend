/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.MeshExtension
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import java.util.ArrayList
import java.util.LinkedHashSet

class NablaModuleExtensions 
{
	def Iterable<MeshExtension> getMeshExtensions(NablaModule it)
	{
		val meshes = new LinkedHashSet<MeshExtension>
		meshes += eAllContents.filter(ConnectivityCall).map[connectivity.eContainer as MeshExtension].toIterable
		for (v : eAllContents.filter(ConnectivityVar).toIterable)
			for (s : v.supports)
				meshes += s.eContainer as MeshExtension
		return meshes
	}

	def getAllVars(NablaModule it)
	{
		val allVars = new ArrayList<ArgOrVar>
		for (d : declarations)
			switch d
			{
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

	def getVarByName(NablaModule it, String variableName)
	{
		allVars.filter(Var).findFirst[v | v.name == variableName]
	}
}