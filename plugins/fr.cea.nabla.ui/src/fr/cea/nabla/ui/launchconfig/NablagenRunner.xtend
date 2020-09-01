/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.launchconfig

import com.google.inject.Inject
import com.google.inject.Provider
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.NablagenInterpreter
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.ui.NabLabConsoleFactory
import java.io.PrintWriter
import java.io.StringWriter
import org.eclipse.core.resources.IResource
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil

@Singleton
class NablagenRunner
{
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject Provider<NablagenInterpreter> interpreterProvider
	@Inject NabLabConsoleFactory consoleFactory

	package def launch(IResource eclipseResource)
	{
		val interpreter = interpreterProvider.get

		consoleFactory.openConsole
		interpreter.traceListeners += [String msg | consoleFactory.printConsole(MessageType.Exec, msg)]

		new Thread
		([
			try
			{
				consoleFactory.clearAndActivateConsole
				consoleFactory.printConsole(MessageType.Start, "Starting generation process for: " + eclipseResource.name)
				consoleFactory.printConsole(MessageType.Exec, "Loading nablagen and nabla resources")
				val plaftormUri = URI::createPlatformResourceURI(eclipseResource.project.name + '/' + eclipseResource.projectRelativePath, true)
				val resourceSet = resourceSetProvider.get
				val uriMap = resourceSet.URIConverter.URIMap
				uriMap.put(URI::createURI('platform:/resource/fr.cea.nabla/'), URI::createURI('platform:/plugin/fr.cea.nabla/'))
				val emfResource = resourceSet.createResource(plaftormUri)
				EcoreUtil::resolveAll(resourceSet)
				emfResource.load(null)
				for (module : emfResource.contents.filter(NablagenModule))
					if (module.config !== null)
					{
						val c = module.config
						val baseDir = eclipseResource.project.location.toString
						consoleFactory.printConsole(MessageType.Exec, "Starting NabLab to IR model transformation")
						val startTime = System.currentTimeMillis
						val irModule = interpreter.buildIrModule(c, baseDir)
						val afterConvertionTime = System.currentTimeMillis
						consoleFactory.printConsole(MessageType.Exec, "NabLab to IR model transformation ended in " + (afterConvertionTime-startTime)/1000.0 + "s")

						consoleFactory.printConsole(MessageType.Exec, "Starting code generation")
						interpreter.generateCode(irModule, c.targets, c.simulation.iterationMax.name, c.simulation.timeMax.name, baseDir, c.levelDB)
						val afterGenerationTime = System.currentTimeMillis
						consoleFactory.printConsole(MessageType.Exec, "Code generation ended in " + (afterGenerationTime-afterConvertionTime)/1000.0 + "s")

						consoleFactory.printConsole(MessageType.Exec, "Total time: " + (afterGenerationTime-startTime)/1000.0 + "s");
					}
				eclipseResource.project.refreshLocal(IResource::DEPTH_INFINITE, null)
				consoleFactory.printConsole(MessageType.End, "Generation ended successfully for: " + eclipseResource.name)
			}
			catch (Exception e)
			{
				consoleFactory.printConsole(MessageType.End, "Generation failed for: " + eclipseResource.name)
				consoleFactory.printConsole(MessageType.End, e.message)
				consoleFactory.printConsole(MessageType.End, getStackTrace(e))
			}
		]).start
	}

	static private def String getStackTrace(Exception e)
	{
		val result = new StringWriter()
		val printWriter = new PrintWriter(result)
		e.printStackTrace(printWriter)
		return result.toString()
	}
}