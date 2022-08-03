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
import fr.cea.nabla.LatexImageServices
import fr.cea.nabla.LatexLabelServices
import fr.cea.nabla.generator.CodeGenerator
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher
import fr.cea.nabla.generator.NablagenFileGenerator
import fr.cea.nabla.generator.ir.IrRootBuilder
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.util.IrResourceImpl
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.NablagenRoot
import java.awt.Color
import java.io.ByteArrayOutputStream
import java.nio.file.Path
import java.nio.file.Paths
import java.util.Base64
import java.util.List
import java.util.Map
import java.util.concurrent.ExecutionException
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.lsp4j.ExecuteCommandParams
import org.eclipse.lsp4j.MessageParams
import org.eclipse.lsp4j.MessageType
import org.eclipse.lsp4j.services.LanguageClient
import org.eclipse.xtext.ide.server.ILanguageServerAccess
import org.eclipse.xtext.ide.server.commands.IExecutableCommandService
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.util.CancelIndicator

@Singleton
class LSPCommandsHandler implements IExecutableCommandService
{
	static val generateNablagenCommand = "nablabweb.generateNablagen"
	static val generateCodeCommand = "nablabweb.generateCode"
	static val generateIrCommand = "nablabweb.generateIr"
	static val updateLatexCommand = "nablabweb.updateLatex"
	
	@Inject protected NablaGeneratorMessageDispatcher dispatcher
	@Inject protected NablagenFileGenerator nablagenGenerator
	@Inject protected Provider<CodeGenerator> codeGeneratorProvider
	@Inject protected IrRootBuilder irRootBuilder
	@Inject protected Provider<ResourceSet> resourceSetProvider
	@Inject protected EObjectAtOffsetHelper eObjectAtOffsetHelper
	
	protected var LanguageClient languageClient
	val traceFunction = [NablaGeneratorMessageDispatcher.MessageType type, String msg | languageClient.logMessage(new MessageParams(MessageType.Info, msg))]
	
	override List<String> initialize()
	{
		return #[generateNablagenCommand, generateCodeCommand, generateIrCommand, updateLatexCommand]
	}

	override Object execute(ExecuteCommandParams params, ILanguageServerAccess access, CancelIndicator cancelIndicator)
	{
		if (generateNablagenCommand.equals(params.command) && params.arguments.size === 3)
		{
			val nablaFileURI = Paths.get((params.arguments.get(0) as JsonPrimitive).asString).toUri.toString
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
					nablagenGenerator.generate(nablaRoot, genDir, projectName)
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
		else if (generateCodeCommand.equals(params.command) && params.arguments.size === 3)
		{
			val nablagenFileURI = (params.arguments.get(0) as JsonPrimitive).asString
			val genDir = (params.arguments.get(1) as JsonPrimitive).asString
			val projectName = (params.arguments.get(2) as JsonPrimitive).asString
			try
			{
				languageClient = access.languageClient
				dispatcher.traceListeners += traceFunction
				
				languageClient.logMessage(new MessageParams(MessageType.Info, "Starting generation process for: " + nablagenFileURI))
				languageClient.logMessage(new MessageParams(MessageType.Info, "Loading resources (.n and .ngen)"))
				
				val resourceSet = resourceSetProvider.get
				loadNablaLibraries(access, resourceSet)
				val ngenResource = loadNgenResource(resourceSet, nablagenFileURI)
				val nablagenRoot = ngenResource.contents.filter(NablagenRoot).head
				
				codeGeneratorProvider.get.generateCode(nablagenRoot, genDir, projectName)
				
				languageClient.logMessage(new MessageParams(MessageType.Info, "Generation ended successfully for: " + nablagenFileURI))
				
				return "Code generated"
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
				loadNablaLibraries(access, resourceSet)
				val ngenResource = loadNgenResource(resourceSet, nablagenFileURI)
				val ngen = ngenResource.contents.filter(NablagenApplication).head
				
				val irRoot = buildIrFrom(ngen)
				if (irRoot !== null) {
					val irResource = new IrResourceImpl(URI.createURI("inmemory"))
					irResource.contents.add(irRoot)
					irResource.save(baos, Map.of())
					return Base64.encoder.encodeToString(baos.toByteArray)
				}
				return ""
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
		else if (updateLatexCommand.equals(params.command) && params.arguments.size === 3)
		{
			val nablaFileURI = (params.arguments.get(0) as JsonPrimitive).asString
			val offset = (params.arguments.get(1) as JsonPrimitive).asInt
			val formulaColorAsString = (params.arguments.get(2) as JsonPrimitive).asString
			
			try
			{
				languageClient = access.languageClient		
				val displayableObject = access.doRead(nablaFileURI, [
						ILanguageServerAccess.Context it | 
						getObjectAtPosition(it.resource as XtextResource, offset)
					]).get()
				if (displayableObject !== null)
				{
					val latexFormula = LatexLabelServices.getLatex(displayableObject)
					val formulaColor = Color.decode(formulaColorAsString)
					val bufferedImage = LatexImageServices.createPngImage(latexFormula, 30, formulaColor)
					return Base64.encoder.encodeToString(bufferedImage)					
				}
			}
			catch (Exception e)
			{
				languageClient.logMessage(new MessageParams(MessageType.Error, e.message))
			}
			finally
			{
				languageClient = null
			}
			return ""
		}
		return "Unrecognized Command"
	}
	
	private def Resource loadNgenResource(ResourceSet resourceSet, String nablagenFileURI)
	{
		val ngenPath = Path.of(nablagenFileURI)
		val nGenUri = URI.createURI(ngenPath.toUri.toString)

		val ngenResource = resourceSet.getResource(nGenUri, true)
		EcoreUtil::resolveAll(resourceSet)
		return ngenResource
	}

	private def void loadNablaLibraries(ILanguageServerAccess access, ResourceSet resourceSet)
	{
		access.doReadIndex([ ILanguageServerAccess.IndexContext ctxt |
			val nablaLibraries = ctxt.index.allResourceDescriptions
			for (nablaLibrary : nablaLibraries)
			{
				val uri = nablaLibrary.URI
				if (uri.toString.endsWith(".n") || uri.toString.endsWith(".ngen"))
				{
					resourceSet.getResource(uri, true)
				}
			}
		]).get()
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
		{
			languageClient.logMessage(new MessageParams(MessageType.Error, "IR module can not be built. Try to clean and rebuild all projects and start again."))
		}

		return ir
	}
	
	private def EObject getObjectAtPosition(XtextResource resource, int offset)
	{
		val selectedObject = this.eObjectAtOffsetHelper.resolveContainedElementAt(resource, offset)
		if (selectedObject !== null)
		{
			return LatexLabelServices.getClosestDisplayableNablaElt(selectedObject)
		}
		return null
	}
}
