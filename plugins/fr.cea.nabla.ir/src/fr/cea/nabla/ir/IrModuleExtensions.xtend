/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import java.util.LinkedHashSet

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

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

	static def getJobByName(IrModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}

	static def isLinearAlgebra(IrModule it)
	{
		variables.exists[v | v.linearAlgebra]
	}

	static def getVariableByName(IrModule it, String irVarName)
	{
		variables.findFirst[j | j.name == irVarName]
	}

	static def getExternalProviders(IrModule it)
	{
		providers.filter[x | x.extensionName != "Math"]
	}

	static def getNeededConnectivityAttributes(IrModule it)
	{
		val neededConnectivities = new LinkedHashSet<Connectivity>
		// All variables' connectivities for allocation
		for (t : variables.map[type].filter(ConnectivityType))
			neededConnectivities += t.connectivities.filter[x | x.multiple && x.inTypes.empty]
		for (cc : eAllContents.filter(ConnectivityCall).filter[x | x.connectivity.multiple && x.args.empty && x.group===null].toIterable)
			neededConnectivities += cc.connectivity
		return neededConnectivities
	}

	static def getNeededGroupAttributes(IrModule it)
	{
		eAllContents.filter(ConnectivityCall).filter[x | x.group!==null].map[group].toSet
	}
}
