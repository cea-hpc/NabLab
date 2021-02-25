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

	def ExtensionProviderHelper get(ExtensionProvider p, ClassLoader cl)
	{
		var c = classByProviders.get(p)
		if (c === null)
		{
			c = switch p
			{
				case p.extensionName == "Math": 
				{
					p.namespace = "java.lang"
					new StaticExtensionProviderHelper(p, cl)
				}
				case p.linearAlgebra: new LinearAlgebraExtensionProviderHelper(p, cl)
				default: new DefaultExtensionProviderHelper(p, cl)
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