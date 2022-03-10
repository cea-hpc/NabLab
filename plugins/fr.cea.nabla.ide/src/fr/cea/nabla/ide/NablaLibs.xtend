/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide

import java.io.IOException
import java.nio.file.Files
import java.nio.file.Path
import java.util.ArrayList
import java.util.Collections
import java.util.Comparator
import java.util.HashSet
import java.util.List
import java.util.Set
import java.util.regex.Pattern
import java.util.stream.Collectors
import java.util.zip.ZipFile
import org.eclipse.emf.common.util.URI
import java.nio.file.Paths
/**
 * Singleton holding a list of all embedded libraries
 */
class NablaLibs
{

	static val NABLA_EXT = ".n"
	static val NABLAGEN_EXT = ".ngen"

	private static class SingletonHolder
	{
		final static NablaLibs instance = new NablaLibs()
	}

	static def NablaLibs getInstance()
	{
		return SingletonHolder.instance
	}

	val List<URI> libUris

	new()
	{
		libUris = getLibURIs()
	}

	def List<URI> getUris()
	{
		return libUris
	}

	private static def boolean isNablaBinFolder(Path subPath)
	{
		return Path.of("fr.cea.nabla/bin").equals(subPath)
	}

	private static def List<URI> collectNablaLibUris(Path path)
	{
		return Files.walk(path.parent) //
		.filter[fileName.toString.endsWith(NABLA_EXT) || fileName.toString.endsWith(NABLAGEN_EXT)] //
		.map[URI.createURI(Paths.get(it.toString).toUri.toString)] //
		.collect(Collectors.toList)
	}

	private static def List<URI> getLibURIs()
	{
		val uris = newArrayList
		val classPath = System.getProperty("java.class.path", ".")
		val classPathElements = classPath.split(System.getProperty("path.separator"))
		val frCeaNablaPluginPattern = Pattern.compile(".*fr\\.cea\\.nabla-.*\\.jar")
		for (element : classPathElements)
		{
			val path = Path.of(element)
			val file = path.toFile
			if (file.directory && path.nameCount >= 2)
			{
				// Case for used for dev profile. The jar is not built instead we need to look for ".n" files inside the folder "fr.cea.nabla"
				val subPath = path.subpath(path.nameCount - 2, path.nameCount)
				if (isNablaBinFolder(subPath))
				{
					uris += path.collectNablaLibUris()
				}
			}
			else if (file.isFile)
			{
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
							if (jarEntryName !== null &&
								(jarEntryName.endsWith(NABLA_EXT) || jarEntryName.endsWith(NABLAGEN_EXT)))
							{
								val resource = NablaLibs.classLoader.getResource(jarEntryName)
								uris += URI.createURI(resource.toString())
							}
						}
						jar.close()
					}
					catch (IOException e)
					{
					}
				}
			}
		}
		/*
		 * Avoid loading twice the same library.
		 * The libraries are packaged twice since they both belong to a src folder and are referenced as bin.includes in the build.properties of the fr.cea.nabla plugin.
		 */
		return Collections.unmodifiableList(removeDuplicatedLibraries(uris))
	}

	/**
	 * Removes URIs pointing to the same library
	 */
	private def static List<URI> removeDuplicatedLibraries(ArrayList<URI> uris)
	{
		Collections.sort(uris, Comparator.comparing[it.toString.length])

		val List<URI> filteredUris = new ArrayList
		val Set<String> libNames = new HashSet
		for (URI u : uris)
		{
			val lastSegment = u.segment(u.segmentCount - 1)
			if (!libNames.contains(lastSegment))
			{
				filteredUris.add(u)
				libNames.add(lastSegment)
			}
		}
		return filteredUris
	}
}
