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
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.SimpleVariable

class IrModuleExtensions
{
	static def getIrRoot(IrModule it)
	{
		eContainer as IrRoot
	}

	static def getPostProcessing(IrModule it)
	{
		if (main) irRoot.postProcessing
		else null
	}

	static def getMeshClassName(IrModule it)
	{
		irRoot.meshClassName
	}

	static def ExtensionProvider[] getExtensionProviders(IrModule it)
	{
		functions.filter[x | x.provider.extensionName!='Math' && x.body===null].map[x | x.provider].toSet
	}

	static def getJobByName(IrModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}

	static def getOptions(IrModule it)
	{
		variables.filter(SimpleVariable).filter[option]
	}

	static def getVariablesWithDefaultValue(IrModule it)
	{
		variables.filter(SimpleVariable).filter[x | !x.option && x.defaultValue !== null]
	}

	static def isLinearAlgebra(IrModule it)
	{
		variables.filter(ConnectivityVariable).exists[x | x.linearAlgebra]
	}

	static def getVariableByName(IrModule it, String irVarName)
	{
		variables.findFirst[j | j.name == irVarName]
	}
}
