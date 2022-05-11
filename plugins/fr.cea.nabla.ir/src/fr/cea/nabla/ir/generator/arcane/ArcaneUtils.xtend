/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.CppGeneratorUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.getInstanceName
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.JobCallerExtensions.*

class ArcaneUtils
{
	static def isArcaneModule(IrModule it) { main }
	static def isArcaneService(IrModule it) { !main }

	static def getInterfaceName(IrModule it)
	{
		'I' + type
	}

	static def getClassName(IrModule it)
	{
		if (main)
			name.toFirstUpper + "Module"
		else
			name.toFirstUpper + "Service"
	}

	static def toAttributeName(String name)
	{
		"m_" + StringExtensions.separateWith(name, "_")
	}

	static def getComputeLoopEntryPointJobs(IrModule it)
	{
		jobs.filter(ExecuteTimeLoopJob).filter[x | x.caller.main]
	}

	static def isArcaneManaged(ArgOrVar it)
	{
		it instanceof Variable && global && !option && type instanceof ConnectivityType
	}

	// This function is similar to CppGeneratorutils.getCodeName except for
	// the instance name of provider for ExternFunction
	static def getCodeName(Function f)
	{
		switch f
		{
			InternFunction:
			{
				val irModule = IrUtils.getContainerOfType(f, IrModule)
				CppGeneratorUtils.getFreeFunctionNs(irModule) + '::' + f.name
			}
			ExternFunction:
			{
				if (f.provider.extensionName == "Math") 'std::' + f.name
				else toAttributeName(f.provider.instanceName) + '.' + f.name
			}
		}
	}

	static def getCodeName(ArgOrVar v)
	{
		if (v instanceof Variable)
		{
			if (v.option)
				'options()->' + StringExtensions.separateWithUpperCase(v.name) + '()'
			else if (v.global)
				'm_' + v.name
			else
				v.name
		}
		else
			v.name
	}

	static def getServices(IrModule it)
	{
		if (main && irRoot.modules.size > 1)
			irRoot.modules.filter[x | x !== it]
		else
			#[]
	}

	static def getCallName(Job it)
	{
		val jobModule = IrUtils.getContainerOfType(it, IrModule)
		val callerModule = if (caller.eContainer instanceof IrRoot)
				(caller.eContainer as IrRoot).mainModule
			else
				IrUtils.getContainerOfType(caller, IrModule)
		if (jobModule === callerModule)
			Utils.getCodeName(it)
		else
			"options()->" + jobModule.name + '()->' + Utils.getCodeName(it)
	}
}