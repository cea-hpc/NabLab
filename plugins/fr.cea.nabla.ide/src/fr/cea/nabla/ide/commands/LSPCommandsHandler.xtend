/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.commands

import com.google.gson.JsonPrimitive
import com.google.inject.Inject
import com.google.inject.Provider
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher
import fr.cea.nabla.generator.ir.IrRootBuilder
import fr.cea.nabla.generator.providers.NablagenFileGenerator
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.util.IrResourceImpl
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nablagen.NablagenApplication
import java.io.ByteArrayOutputStream
import java.util.Base64
import java.util.List
import java.util.Map
import java.util.concurrent.ExecutionException
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.lsp4j.ExecuteCommandParams
import org.eclipse.lsp4j.MessageParams
import org.eclipse.lsp4j.MessageType
import org.eclipse.lsp4j.services.LanguageClient
import org.eclipse.xtext.ide.server.ILanguageServerAccess
import org.eclipse.xtext.ide.server.commands.IExecutableCommandService
import org.eclipse.xtext.util.CancelIndicator

@Singleton
class LSPCommandsHandler implements IExecutableCommandService
{
	static val generateNablagenCommand = "nablabweb.generateNablagen"
	static val generateIrCommand = "nablabweb.generateIr"
	
	@Inject protected NablaGeneratorMessageDispatcher dispatcher
	@Inject protected NablagenFileGenerator generator
	@Inject IrRootBuilder irRootBuilder
	@Inject Provider<ResourceSet> resourceSetProvider
	
	protected var LanguageClient languageClient
	val traceFunction = [NablaGeneratorMessageDispatcher.MessageType type, String msg | languageClient.logMessage(new MessageParams(MessageType.Info, msg))]
	
	override List<String> initialize()
	{
		return #[generateNablagenCommand, generateIrCommand]
	}

	override Object execute(ExecuteCommandParams params, ILanguageServerAccess access, CancelIndicator cancelIndicator)
	{
		if (generateNablagenCommand.equals(params.command) && params.arguments.size === 3)
		{
			val nablaFileURI = (params.arguments.get(0) as JsonPrimitive).asString
			val genDir = (params.arguments.get(1) as JsonPrimitive).asString
			val projectName = (params.arguments.get(2) as JsonPrimitive).asString
			try
			{
				languageClient = access.languageClient
				dispatcher.traceListeners += traceFunction
				access.doRead(nablaFileURI, [
					ILanguageServerAccess.Context it | 
					val nablaRoot = it.resource.contents.filter(NablaRoot).head
					languageClient.logMessage(new MessageParams(MessageType.Info, "Starting generation process for: " + nablaFileURI))
					val startTime = System.currentTimeMillis
					generator.generate(nablaRoot, genDir, projectName)
					val endTime = System.currentTimeMillis
					languageClient.logMessage(new MessageParams(MessageType.Info, "Code generation ended in " + (endTime-startTime)/1000.0 + "s"))
					languageClient.logMessage(new MessageParams(MessageType.Info, "Generation ended successfully for: " + nablaFileURI))
					"Nablagen generated"
				]).get()
			}
			catch (InterruptedException | ExecutionException e)
			{
				languageClient.logMessage(new MessageParams(MessageType.Error, e.message))
			}
			finally
			{
				languageClient = null
				dispatcher.traceListeners -= traceFunction
			}
		}
		else if (generateIrCommand.equals(params.command) && params.arguments.size === 2)
		{
			val nablagenFileURI = (params.arguments.get(0) as JsonPrimitive).asString
			val baos = new ByteArrayOutputStream()
			
			try
			{
				languageClient = access.languageClient
				dispatcher.traceListeners += traceFunction
				
				val resourceSet = resourceSetProvider.get
				// Load nabla libraries
				access.doReadIndex([ILanguageServerAccess.IndexContext ctxt | 
					val nablaLibraries = ctxt.index.allResourceDescriptions
					for (nablaLibrary : nablaLibraries) {
						val uri = nablaLibrary.URI
						if (uri.toString().startsWith("file:/") && !uri.toString().startsWith("file:///")) {
							resourceSet.getResource(uri, true)
						}
					}
					""
				]).get()
				val ngenResource = resourceSet.createResource(URI.createURI(nablagenFileURI))
				resourceSet.createResource(URI.createURI(nablagenFileURI.replace(".ngen", ".n")))
				
				ngenResource.load(Map.of())
				EcoreUtil::resolveAll(resourceSet)
				val ngen = ngenResource.contents.filter(NablagenApplication).head
				val irRoot = buildIrFrom(ngen)
				val irResource = new IrResourceImpl(URI.createURI("inmemory"))
				irResource.contents.add(irRoot)
				irResource.save(baos, Map.of())
				return Base64.encoder.encodeToString(baos.toByteArray)
			}
			catch (Exception e)
			{
				languageClient.logMessage(new MessageParams(MessageType.Error, e.message))
			}
			finally
			{
				languageClient = null
				dispatcher.traceListeners -= traceFunction
			}
			
		}
		return "Unrecognized Command"
	}
	
	private def IrRoot buildIrFrom(NablagenApplication ngenApp)
	{
		val start = System.nanoTime()
		var IrRoot ir = null
		languageClient.logMessage(new MessageParams(MessageType.Info, "Building IR to initialize job graph editor"))

		try
		{
			ir = irRootBuilder.buildGeneratorGenericIr(ngenApp)
		}
		catch (Exception e)
		{
			languageClient.logMessage(new MessageParams(MessageType.Error, "An exception occurred during IR building"))
			// An exception can occurred during IR building if environment is not configured,
			// for example compilation not done, or during transformation step. Whatever... 
			// irModule stays null. Error message printed below.
		}

		val stop = System.nanoTime()
		languageClient.logMessage(new MessageParams(MessageType.Info, "IR converted (" + ((stop - start) / 1000000) + " ms)"))

		if (ir === null)
			languageClient.logMessage(new MessageParams(MessageType.Error, "IR module can not be built. Try to clean and rebuild all projects and start again."))

		return ir
	}
}
