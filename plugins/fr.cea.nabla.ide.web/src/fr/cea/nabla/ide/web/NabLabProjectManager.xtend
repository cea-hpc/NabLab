/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.web

import java.io.IOException
import java.util.regex.Pattern
import java.util.zip.ZipFile
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.ide.server.ProjectManager
import org.eclipse.xtext.util.CancelIndicator

class NabLabProjectManager extends ProjectManager
{
	val frCeaNablaPluginPattern = Pattern.compile(".*fr\\.cea\\.nabla-.*\\.jar")
	
	/**
	 * Add all .n models containing in /fr.cea.nabla/ to the known resources.
	 */
	override doInitialBuild(CancelIndicator cancelIndicator)
	{
		val uris = newArrayList
		val classPath = System.getProperty("java.class.path", ".")
		val classPathElements = classPath.split(System.getProperty("path.separator"))
        for (element : classPathElements) {
        	if (element !== null && frCeaNablaPluginPattern.matcher(element).matches())
        	{
        		try
        		{
        			val jar = new ZipFile(element)
					val jarEntries = jar.entries()
			        while (jarEntries.hasMoreElements())
			        {
			            val jarEntry = jarEntries.nextElement()
			            val jarEntryName = jarEntry.name
			            if (jarEntryName !== null && jarEntryName.endsWith(".n"))
			            {
			            	val resource = class.classLoader.getResource(jarEntryName)
							uris += URI.createURI(resource.toString())
			            }
			        }
					jar.close();
				}
				catch(IOException e)
				{
            	}
        	}
        }
		return doBuild(uris, emptyList, emptyList, cancelIndicator)
	}
	
}