/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.ir.IrRootBuilder
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.interpreter.IrInterpreter
import fr.cea.nabla.ir.interpreter.IrInterpreterException
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.ui.console.NabLabConsoleFactory
import fr.cea.nabla.ui.console.NabLabConsoleHandler
import fr.cea.nabla.ui.console.NabLabConsoleRunnable
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.logging.Level
import java.util.stream.Collectors
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil

@Singleton
class NablagenRunner
{
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject Provider<IrRootBuilder> irRootBuilderProvider
	@Inject NabLabConsoleFactory consoleFactory
	@Inject NablaGeneratorMessageDispatcher dispatcher

	val traceFunction = [MessageType type, String msg | consoleFactory.printConsole(type, msg)]

	package def launch(IFile nablagenFile, IFile jsonFile)
	{
		val Thread interpreterThread = new Thread([
			try
			{
				dispatcher.traceListeners += traceFunction
				consoleFactory.printConsole(MessageType.Start, "Starting interpretation process for: " + nablagenFile.name)
				consoleFactory.printConsole(MessageType.Exec, "Loading resources (.n and .ngen)")

				if (nablagenFile === null || !nablagenFile.exists) throw new RuntimeException("Invalid file: " + nablagenFile.fullPath)
				val plaftormUri = URI::createPlatformResourceURI(nablagenFile.project.name + '/' + nablagenFile.projectRelativePath, true)
				val resourceSet = resourceSetProvider.get
				val uriMap = resourceSet.URIConverter.URIMap
				uriMap.put(URI::createURI('platform:/resource/fr.cea.nabla/'), URI::createURI('platform:/plugin/fr.cea.nabla/'))
				val emfResource = resourceSet.createResource(plaftormUri)
				EcoreUtil::resolveAll(resourceSet)
				emfResource.load(null)

				val ngenApp = emfResource.contents.filter(NablagenApplication).head
				if (ngenApp === null)
				{
					consoleFactory.printConsole(MessageType.Error, "Interpretation only possible on Application content")
				}
				else
				{
					val projectFolder = ResourcesPlugin.workspace.root.getFolder(jsonFile.project.location)
					val wsPath = projectFolder.parent.fullPath.toString
					val ir = irRootBuilderProvider.get.buildInterpreterIr(ngenApp, wsPath)

					consoleFactory.printConsole(MessageType.Exec, "Starting code interpretation")
					val startTime = System.currentTimeMillis
					val handler = new NabLabConsoleHandler(consoleFactory)
					handler.level = Level.FINE
					val irInterpreter = new IrInterpreter(handler)
					if (jsonFile === null || !jsonFile.exists) throw new RuntimeException("Invalid file: " + jsonFile.fullPath)
					val jsonContent = new BufferedReader(new InputStreamReader(jsonFile.contents)).lines().collect(Collectors.joining("\n"))
					irInterpreter.interprete(ir, jsonContent, wsPath)
					val endTime = System.currentTimeMillis
					consoleFactory.printConsole(MessageType.Exec, "Code interpretation ended in " + (endTime-startTime)/1000.0 + "s")

					nablagenFile.project.refreshLocal(IResource::DEPTH_INFINITE, null)
					consoleFactory.printConsole(MessageType.End, "Interpretation ended successfully for: " + nablagenFile.name)

					// 2 times. Why ? Internet forums...
					for (i : 0..<2)
					{
						System.runFinalization
						System.gc
					}
				}
			}
			catch (IrInterpreterException e)
			{
				// nothing to do
				consoleFactory.printConsole(MessageType.Error, e.message)
			}
			catch (Exception e)
			{
				consoleFactory.printConsole(MessageType.Error, "Interpretation failed for: " + nablagenFile.name)
				consoleFactory.printConsole(MessageType.Error, e.message)
				consoleFactory.printConsole(MessageType.Error, IrUtils.getStackTrace(e))
			}
			catch (NoClassDefFoundError e)
			{
				consoleFactory.printConsole(MessageType.Error, "Interpretation failed for: " + nablagenFile.name)
				consoleFactory.printConsole(MessageType.Error, e.message)
			}
			finally
			{
				dispatcher.traceListeners -= traceFunction
			}
		])

		val Runnable stopRunnable = [interpreterThread.interrupt]
		new Thread(new NabLabConsoleRunnable(consoleFactory, interpreterThread, stopRunnable)).start
	}
}
