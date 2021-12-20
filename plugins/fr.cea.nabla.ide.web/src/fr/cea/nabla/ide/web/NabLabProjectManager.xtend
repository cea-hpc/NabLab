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
import java.nio.file.Files
import java.nio.file.Path
import java.util.regex.Pattern
import java.util.stream.Collectors
import java.util.zip.ZipFile
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.ide.server.ProjectManager
import org.eclipse.xtext.util.CancelIndicator
import java.util.List
import org.eclipse.xtext.workspace.ISourceFolder

class NabLabProjectManager extends ProjectManager
{
	static val NABLA_EXT = ".n";
	val frCeaNablaPluginPattern = Pattern.compile(".*fr\\.cea\\.nabla-.*\\.jar")

	/**
	 * Add all .n models containing in /fr.cea.nabla/ to the known resources.
	 */
	override doInitialBuild(CancelIndicator cancelIndicator)
	{
		val uris = newArrayList
		val classPath = System.getProperty("java.class.path", ".")
		val classPathElements = classPath.split(System.getProperty("path.separator"))
		
		for (ISourceFolder srcFolder : projectConfig.getSourceFolders()) {
			uris.addAll(srcFolder.getAllResources(fileSystemScanner));
		}

		for (element : classPathElements)
		{
			val path = Path.of(element);
			val file = path.toFile;
			if(file.directory && path.nameCount >=2)
			{
				// Case for used for dev profile. The jar is not built instead we need to look for ".n" files inside the folder "fr.cea.nabla"
				val subPath = path.subpath(path.nameCount - 2, path.nameCount);
				if(isNablaBinFolder(subPath))
				{
					uris += path.collectNablaLibUris()
				}
			}
			else if(file.isFile)
			{
				if(element !== null && frCeaNablaPluginPattern.matcher(element).matches())
				{
					try
					{
						val jar = new ZipFile(element)
						val jarEntries = jar.entries()
						while(jarEntries.hasMoreElements())
						{
							val jarEntry = jarEntries.nextElement()
							val jarEntryName = jarEntry.name
							if(jarEntryName !== null && jarEntryName.endsWith(NABLA_EXT))
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

		}
		return doBuild(uris, emptyList, emptyList, cancelIndicator)
	}
	
	private def List<URI> collectNablaLibUris(Path path){
		 return Files.walk(path.parent) //
					.filter [fileName.toString.endsWith(NABLA_EXT)] //
					.map[URI.createFileURI(it.toString)] //
					.collect(Collectors.toList)
	}

	private def boolean isNablaBinFolder(Path subPath)
	{
		return Path.of("fr.cea.nabla/bin").equals(subPath)
	}

}
