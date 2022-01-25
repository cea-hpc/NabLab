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

import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.ExtensionProvider
import java.io.File
import java.net.URL
import java.net.URLClassLoader

class ExtensionProviderExtensions
{
	static def getInterfaceName(ExtensionProvider it)
	{
		'I' + extensionName
	}

	static def getClassName(ExtensionProvider it)
	{
		extensionName
	}

	static def getLibName(ExtensionProvider it)
	{
		providerName.toLowerCase
	}

	static def getPathVar(ExtensionProvider it)
	{
		new Pair(providerName.toUpperCase + '_PATH', '${N_WS_PATH}' + outputPath + '/' + dirName)
	}

	static def getDirName(ExtensionProvider it)
	{
		providerName.toLowerCase
	}

	/**
	 * Return the path to the directory containing provider "jar" for java
	 * code and interpreter and "jar + .so" for JNI. 
	 */
	static def getInstallPath(ExtensionProvider it)
	{
		outputPath + '/' + dirName + '/lib'
	}

	/** PackageName is used by Java and Jni */
	static def getPackageName(ExtensionProvider it)
	{
		if (providerName === null) ""
		else providerName.toLowerCase
	}

	static def String getInstanceName(ExtensionProvider it)
	{
		extensionName.toFirstLower
	}

	static def String getJarFileName(DefaultExtensionProvider it, String wsPath)
	{
		wsPath + installPath + "/" + libName + ".jar"
	}

	static def URLClassLoader getClassLoader(DefaultExtensionProvider it, String wsPath)
	{
		val fileName = getJarFileName(wsPath)
		val file = new File(fileName)
		if (file.exists)
		{
			val url = new URL("file://" + fileName)
			val parentClassLoader = Thread.currentThread.contextClassLoader
			new URLClassLoader(#[url], parentClassLoader)
		}
		else
			null
	}
}
