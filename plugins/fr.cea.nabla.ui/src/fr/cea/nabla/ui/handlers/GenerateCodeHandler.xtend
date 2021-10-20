/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.handlers

import com.google.inject.Inject
import com.google.inject.Provider
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.application.NablagenApplicationGenerator
import fr.cea.nabla.generator.providers.NablagenProviderGenerator
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.NablagenProviderList
import fr.cea.nabla.nablagen.NablagenRoot
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.swt.widgets.Shell

@Singleton
class GenerateCodeHandler extends AbstractGenerateHandler
{
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject Provider<NablagenApplicationGenerator> applicationGeneratorProvider
	@Inject Provider<NablagenProviderGenerator> providerGeneratorProvider

	val traceFunction = [MessageType type, String msg | consoleFactory.printConsole(type, msg)]

	override generate(IFile nablagenFile, Shell shell)
	{
		new Thread
		([
			try
			{
				dispatcher.traceListeners += traceFunction
				consoleFactory.openConsole
				consoleFactory.printConsole(MessageType.Start, "Starting generation process for: " + nablagenFile.name)
				consoleFactory.printConsole(MessageType.Exec, "Loading resources (.n and .ngen)")
				val project = nablagenFile.project
				val plaftormUri = URI::createPlatformResourceURI(project.name + '/' + nablagenFile.projectRelativePath, true)
				val resourceSet = resourceSetProvider.get
				val uriMap = resourceSet.URIConverter.URIMap
				uriMap.put(URI::createURI('platform:/resource/fr.cea.nabla/'), URI::createURI('platform:/plugin/fr.cea.nabla/'))
				val emfResource = resourceSet.createResource(plaftormUri)
				EcoreUtil::resolveAll(resourceSet)
				emfResource.load(null)

				val ngen = emfResource.contents.filter(NablagenRoot).head
				val projectFolder = ResourcesPlugin.workspace.root.getFolder(project.location)
				val wsPath = projectFolder.parent.fullPath.toString
				switch (ngen)
				{
					NablagenApplication: applicationGeneratorProvider.get.generateApplication(ngen, wsPath, project.name)
					NablagenProviderList: providerGeneratorProvider.get.generateProviders(ngen, wsPath)
				}

				project.refreshLocal(IResource::DEPTH_INFINITE, null)
				consoleFactory.printConsole(MessageType.End, "Generation ended successfully for: " + nablagenFile.name)
			}
			catch (Exception e)
			{
				consoleFactory.printConsole(MessageType.Error, "Generation failed for: " + nablagenFile.name)
				consoleFactory.printConsole(MessageType.Error, e.message)
				consoleFactory.printConsole(MessageType.Error, IrUtils.getStackTrace(e))
			}
			finally
			{
				dispatcher.traceListeners -= traceFunction
			}
		]).start
	}
}