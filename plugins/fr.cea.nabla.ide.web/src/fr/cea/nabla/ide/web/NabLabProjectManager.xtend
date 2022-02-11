/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
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
import org.eclipse.xtext.build.BuildRequest
import org.eclipse.xtext.build.IndexState
import org.eclipse.xtext.ide.server.ProjectManager
import org.eclipse.xtext.resource.IResourceDescription
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.validation.Issue
import org.eclipse.xtext.workspace.ISourceFolder

class NabLabProjectManager extends ProjectManager
{

	static val List<URI> LIB_URIS = {
		return libURIs
	}
	static val NABLA_EXT = ".n";
	static val NABLAGEN_EXT = ".ngen";

	private static def List<URI> getLibURIs()
	{
		val uris = newArrayList
		val classPath = System.getProperty("java.class.path", ".")
		val classPathElements = classPath.split(System.getProperty("path.separator"))
		val frCeaNablaPluginPattern = Pattern.compile(".*fr\\.cea\\.nabla-.*\\.jar");
		for (element : classPathElements)
		{
			val path = Path.of(element);
			val file = path.toFile;
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
							if (jarEntryName !== null && jarEntryName.endsWith(NABLA_EXT))
							{
								val resource = NabLabProjectManager.classLoader.getResource(jarEntryName)
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
		return removeDuplicatedLibraries(uris);
	}

	/**
	 * Removes the URIs that are pointing the same libary
	 */
	private def static List<URI> removeDuplicatedLibraries(ArrayList<URI> uris)
	{
		Collections.sort(uris, Comparator.comparing[it.toString.length])

		val List<URI> filteredUris = new ArrayList;
		val Set<String> libNames = new HashSet
		for (URI u : uris)
		{
			val lastSegment = u.segment(u.segmentCount - 1);
			if (!libNames.contains(lastSegment))
			{
				filteredUris.add(u);
				libNames.add(lastSegment);
			}
		}
		filteredUris
	}

	private static def List<URI> collectNablaLibUris(Path path)
	{
		return Files.walk(path.parent) //
		.filter[fileName.toString.endsWith(NABLA_EXT) || fileName.toString.endsWith(NABLAGEN_EXT)] //
		.map[URI.createFileURI(it.toString)] //
		.collect(Collectors.toList)
	}

	private static def boolean isNablaBinFolder(Path subPath)
	{
		return Path.of("fr.cea.nabla/bin").equals(subPath)
	}

	/**
	 * Add all .n models containing in /fr.cea.nabla/ to the known resources.
	 */
	override doInitialBuild(CancelIndicator cancelIndicator)
	{

		val List<URI> allUris = new ArrayList<URI>();
		for (ISourceFolder srcFolder : projectConfig.getSourceFolders())
		{
			allUris.addAll(srcFolder.getAllResources(fileSystemScanner));
		}
		// Add library in the RessourceSet
		allUris.addAll(LIB_URIS);
		return doBuild(allUris, Collections.emptyList(), Collections.emptyList(), cancelIndicator);

	}

	/**
	 * Overriding existing behavior to prevents the validation markers to be added on the packaged libraries models
	 */
	override BuildRequest newBuildRequest(List<URI> changedFiles, List<URI> deletedFiles,
		List<IResourceDescription.Delta> externalDeltas, CancelIndicator cancelIndicator)
	{
		val BuildRequest result = new BuildRequest();
		result.setBaseDir(baseDir);
		result.setState(
			new IndexState(indexState.getResourceDescriptions().copy(), indexState.getFileMappings().copy()));
		result.setResourceSet(createFreshResourceSet(result.getState().getResourceDescriptions()));
		result.setDirtyFiles(changedFiles);
		result.setDeletedFiles(deletedFiles);
		result.setExternalDeltas(externalDeltas);
		result.setAfterValidate([ URI uri, Iterable<Issue> issues |
			// Prevents displaying error on the lib resources
			if (!LIB_URIS.contains(uri))
			{
				issueAcceptor.apply(uri, issues);
			}
			return true;
		]);
		result.setCancelIndicator(cancelIndicator);
		result.setIndexOnly(projectConfig.isIndexOnly());
		return result;
	}

}
