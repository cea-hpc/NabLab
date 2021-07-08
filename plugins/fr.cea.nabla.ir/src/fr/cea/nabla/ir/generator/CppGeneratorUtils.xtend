/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrModule

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.getInstanceName
import static extension fr.cea.nabla.ir.IrModuleExtensions.getClassName

class CppGeneratorUtils
{
	static def getFreeFunctionNs(IrModule it)
	{
		className.toLowerCase + "freefuncs"
	}

	static def dispatch getCodeName(InternFunction it)
	{
		val irModule = IrUtils.getContainerOfType(it, IrModule)
		irModule.freeFunctionNs + '::' + name
	}

	static def dispatch getCodeName(ExternFunction it)
	{
		if (provider.extensionName == "Math") 'std::' + name
		else 'options.' + provider.instanceName + '.' + name
	}

	static def getHDefineName(String name)
	{
		'__' + name.toUpperCase + '_H_'
	}
}
