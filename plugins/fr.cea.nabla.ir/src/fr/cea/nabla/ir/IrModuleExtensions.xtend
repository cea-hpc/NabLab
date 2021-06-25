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

import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import fr.cea.nabla.ir.ir.MeshExtensionProvider

class IrModuleExtensions
{
	static def getIrRoot(IrModule it)
	{
		eContainer as IrRoot
	}

	static def getClassName(IrModule it)
	{
		name.toFirstUpper
	}

	static def getPostProcessing(IrModule it)
	{
		if (main) getIrRoot.postProcessing
		else null
	}

	static def getMeshClassName(IrModule it)
	{
		val meshProviders = providers.filter(MeshExtensionProvider)
		if (meshProviders.size == 1)
			meshProviders.head.extensionName
		else
			throw new Exception("Not yet implemented")
	}

	static def DefaultExtensionProvider[] getDefaultExtensionProviders(IrModule it)
	{
		providers.filter(DefaultExtensionProvider).filter[x | x.extensionName != "Math"]
	}

	static def getJobByName(IrModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}

	static def getOptions(IrModule it)
	{
		variables.filter[option]
	}

	static def getVariablesWithDefaultValue(IrModule it)
	{
		variables.filter[x | !x.option && x.defaultValue !== null]
	}

	static def isLinearAlgebra(IrModule it)
	{
		variables.exists[v | v.linearAlgebra]
	}

	static def getVariableByName(IrModule it, String irVarName)
	{
		variables.findFirst[j | j.name == irVarName]
	}
}
