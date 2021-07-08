/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrModule
import java.net.URLClassLoader
import java.util.HashMap

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

/*
 * Native library (.so) can only be loaded once.
 * Consequently, JNI classes, containing the static loadLibrary instruction,
 * must not be load more than once to prevent IllegalAccessException.
 * Libraries are unloaded when associated classLoader is deleted (need 2 calls to System.gc)
 */
class DefaultExtensionProviderHelper extends CallableExtensionProviderHelper
{
	protected val providerInstances = new HashMap<IrModule, Object>
	protected URLClassLoader cl
	val Class<?> providerClass

	new(DefaultExtensionProvider provider, String wsPath)
	{
		cl = provider.getClassLoader(wsPath)
		if (cl === null)
			throw new ExtensionProviderJarNotExist(provider, provider.getJarFileName(wsPath))

		val className = provider.packageName + '.' + provider.className
		providerClass = Class.forName(className, true, cl)
	}

	override createProviderInstance(IrModule module)
	{
		providerInstances.put(module, providerClass.constructor.newInstance)
	}

	override getProviderClass(String functionName)
	{
		providerClass
	}

	override getProviderInstance(IrModule module)
	{
		providerInstances.get(module)
	}
}
