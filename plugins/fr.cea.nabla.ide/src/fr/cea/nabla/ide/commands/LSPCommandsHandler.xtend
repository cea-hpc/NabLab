/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.commands

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher
import fr.cea.nabla.generator.providers.NablagenFileGenerator
import fr.cea.nabla.nabla.NablaRoot
import java.util.List
import java.util.concurrent.ExecutionException
import org.eclipse.lsp4j.ExecuteCommandParams
import org.eclipse.lsp4j.MessageParams
import org.eclipse.lsp4j.services.LanguageClient
import org.eclipse.xtext.ide.server.ILanguageServerAccess
import org.eclipse.xtext.ide.server.commands.IExecutableCommandService
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.lsp4j.MessageType
import com.google.gson.JsonPrimitive

@Singleton
class LSPCommandsHandler implements IExecutableCommandService
{
	static val generateNablagenCommand = "nablabweb.generateNablagen"
	
	@Inject protected NablaGeneratorMessageDispatcher dispatcher
	@Inject protected NablagenFileGenerator generator
	
	protected var LanguageClient languageClient
	val traceFunction = [fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType type, String msg | languageClient.logMessage(new MessageParams(MessageType.Info, msg))]
	
	override List<String> initialize()
	{
		return #[generateNablagenCommand]
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
		return "Unrecognized Command"
	}
}
