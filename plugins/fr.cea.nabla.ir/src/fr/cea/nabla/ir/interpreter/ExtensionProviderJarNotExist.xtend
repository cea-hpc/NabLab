/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ExtensionProvider

class ExtensionProviderJarNotExist extends Exception
{
	new(ExtensionProvider p, String jarFileName)
	{
		super(buildMessage(p, jarFileName))
	}

	private def static String buildMessage(ExtensionProvider p, String jarFileName)
	{
		"Jar file not found for provider " + p.providerName + ": " + jarFileName
		+ "\nIn case of C++ providers, do not forget to compile and install it: make; make install"
	}
}