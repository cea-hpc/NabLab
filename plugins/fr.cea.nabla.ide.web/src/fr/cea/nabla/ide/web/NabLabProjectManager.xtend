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

import fr.cea.nabla.ide.NablaLibs
import java.util.ArrayList
import java.util.Collections
import java.util.List
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

	/**
	 * Add all .n models containing in /fr.cea.nabla/ to the known resources.
	 */
	override doInitialBuild(CancelIndicator cancelIndicator)
	{

		val List<URI> allUris = new ArrayList<URI>()
		for (ISourceFolder srcFolder : projectConfig.getSourceFolders())
		{
			allUris.addAll(srcFolder.getAllResources(fileSystemScanner))
		}
		// Add library in the RessourceSet
		allUris.addAll(NablaLibs.instance.uris)
		return doBuild(allUris, Collections.emptyList(), Collections.emptyList(), cancelIndicator)

	}

	/**
	 * Overriding existing behavior to prevents the validation markers to be added on the packaged libraries models
	 */
	override BuildRequest newBuildRequest(List<URI> changedFiles, List<URI> deletedFiles,
		List<IResourceDescription.Delta> externalDeltas, CancelIndicator cancelIndicator)
	{
		val BuildRequest result = new BuildRequest()
		result.setBaseDir(baseDir)
		result.setState(
			new IndexState(indexState.getResourceDescriptions().copy(), indexState.getFileMappings().copy()))
		result.setResourceSet(createFreshResourceSet(result.getState().getResourceDescriptions()))
		result.setDirtyFiles(changedFiles)
		result.setDeletedFiles(deletedFiles)
		result.setExternalDeltas(externalDeltas)
		result.setAfterValidate([ URI uri, Iterable<Issue> issues |
			// Prevents displaying error on the lib resources
			if (!NablaLibs.instance.uris.contains(uri))
			{
				issueAcceptor.apply(uri, issues)
			}
			return true
		])
		result.setCancelIndicator(cancelIndicator)
		result.setIndexOnly(projectConfig.isIndexOnly())
		return result
	}

}
