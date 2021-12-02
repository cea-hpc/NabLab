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
import fr.cea.nabla.generator.providers.NablagenFileGenerator
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.nabla.NablaRoot
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.swt.widgets.Shell

@Singleton
class GenerateNablagenHandler extends AbstractGenerateHandler
{
	@Inject NablagenFileGenerator generator
	@Inject Provider<ResourceSet> resourceSetProvider

	val traceFunction = [MessageType type, String msg | consoleFactory.printConsole(type, msg)]

	override generate(IFile nablaFile, Shell shell)
	{
		new Thread
		([
			try
			{
				dispatcher.traceListeners += traceFunction
				consoleFactory.openConsole
				consoleFactory.printConsole(MessageType.Start, "Starting generation process for: " + nablaFile.name)
				consoleFactory.printConsole(MessageType.Exec, "Loading nabla resources")
				val project = nablaFile.project
				val plaftormUri = URI::createPlatformResourceURI(project.name + '/' + nablaFile.projectRelativePath, true)
				val resourceSet = resourceSetProvider.get
				val uriMap = resourceSet.URIConverter.URIMap
				uriMap.put(URI::createURI('platform:/resource/fr.cea.nabla/'), URI::createURI('platform:/plugin/fr.cea.nabla/'))
				val emfResource = resourceSet.createResource(plaftormUri)
				EcoreUtil::resolveAll(resourceSet)
				emfResource.load(null)

				val startTime = System.currentTimeMillis
				val nablaRoot = emfResource.contents.filter(NablaRoot).head
				generator.generate(nablaRoot, nablaFile.parent.location.toString, project.name)
				val endTime = System.currentTimeMillis
				consoleFactory.printConsole(MessageType.Exec, "Code generation ended in " + (endTime-startTime)/1000.0 + "s")

				project.refreshLocal(IResource::DEPTH_INFINITE, null)
				consoleFactory.printConsole(MessageType.End, "Generation ended successfully for: " + nablaFile.name)
			}
			catch (Exception e)
			{
				consoleFactory.printConsole(MessageType.Error, "Generation failed for: " + nablaFile.name)
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