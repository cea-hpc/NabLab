/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ExtensionProvider
import java.util.HashMap

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

/**
 * Native library (.so) can only be loaded once.
 * Consequently, JNI classes, containing the static loadLibrary instruction,
 * must not be load more than once to prevent IllegalAccessException.
 * This class is a singleton cache for provider classes.
 */
class ExtensionProviderCache
{
	val classByProviders = new HashMap<ExtensionProvider, ExtensionProviderHelper>
	public static val Instance = new ExtensionProviderCache

	private new()
	{
	}

	def ExtensionProviderHelper get(ExtensionProvider p, ClassLoader cl, String wsPath)
	{
		var c = classByProviders.get(p)
		if (c === null)
		{
			try
			{
				c = switch p
				{
					case p.extensionName == "Math": new StaticExtensionProviderHelper(p, cl, "java.lang")
					case p.linearAlgebra: new LinearAlgebraExtensionProviderHelper(p, cl, wsPath)
					default: new DefaultExtensionProviderHelper(p, cl, wsPath)
				}
			}
			catch (ClassNotFoundException e)
			{
				throw new ExtensionProviderNotFoundException(p)
			}
			classByProviders.put(p, c)
		}
		return c
	}

	def ExtensionProviderHelper get(ExtensionProvider p)
	{
		classByProviders.get(p)
	}
}

class ExtensionProviderNotFoundException extends Exception
{
	new(ExtensionProvider p)
	{
		super(p.buildMessage)
	}

	private def static String buildMessage(ExtensionProvider p)
	{
		'Class ' + p.packageName + '.' + p.className + ' not found for provider ' + p.providerName + ': if JNI compile and install (make; make install)'
	}
}
