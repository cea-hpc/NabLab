/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import com.google.inject.Inject
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.ir.IrExtensionProviderFactory
import fr.cea.nabla.generator.ir.IrRootBuilder
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.json.JsonGenerator
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.IrTransformationUtils
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.NablagenProviderList
import fr.cea.nabla.nablagen.NablagenRoot
import fr.cea.nabla.nablagen.Target
import java.util.ArrayList
import org.eclipse.emf.ecore.util.EcoreUtil

import static extension fr.cea.nabla.LatexLabelServices.*
import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*

class CodeGenerator extends StandaloneGeneratorBase
{
	@Inject NablaIrWriter irWriter
	@Inject IrCodeGeneratorFactory irCodeGeneratorFactory
	@Inject IrRootBuilder irRootBuilder
	@Inject NablagenExtensionHelper ngenExtHelper
	@Inject IrExtensionProviderFactory irExtensionProviderFactory

	def generateCode(NablagenRoot ngen, String wsPath, String projectName)
	{
		switch (ngen)
		{
			NablagenApplication: generateApplication(ngen, wsPath, projectName)
			NablagenProviderList: generateProviders(ngen, wsPath)
		}
	}

	private def generateProviders(NablagenProviderList providerList, String wsPath)
	{
		try
		{
			dispatcher.post(MessageType.Exec, "Starting code generation")
			val startTime = System.currentTimeMillis
	
			for (provider : providerList.elements)
			{
				if (provider.extension instanceof DefaultExtension)
				{
					val outputFolderName = wsPath + provider.outputPath
					val fsa = getConfiguredFileSystemAccess(outputFolderName, false)
					dispatcher.post(MessageType::Exec, "Starting " + provider.target.literal + " code generation: " + provider.outputPath)
					val irProvider = irExtensionProviderFactory.toIrDefaultExtensionProvider(provider)

					// Create code generator
					val g = irCodeGeneratorFactory.create(wsPath, provider.target)

					// Apply IR transformations dedicated to this target (if necessary)
					for (s : IrTransformationUtils.getCommonTransformation(true))
						s.transformProvider(irProvider, [msg | dispatcher.post(MessageType::Exec, msg)])

					for (s : g.irTransformationSteps)
						s.transformProvider(irProvider, [msg | dispatcher.post(MessageType::Exec, msg)])
	
					generate(fsa, g.getGenerationContents(irProvider), irProvider.dirName)
				}
				else
				{
					dispatcher.post(MessageType::Warning, "No code generator for mesh provider: " + provider.name)
				}
			}
	
			val endTime = System.currentTimeMillis
			dispatcher.post(MessageType.Exec, "Code generation ended in " + (endTime-startTime)/1000.0 + "s")
		}
		catch(Exception e)
		{
			dispatcher.post(MessageType::Error, '\n***' + e.class.name + ': ' + e.message)
			if (e.stackTrace !== null && !e.stackTrace.empty)
			{
				val stack = e.stackTrace.head
				dispatcher.post(MessageType::Error, 'at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')')
			}
			throw(e)
		}
	}

	private def void generateApplication(NablagenApplication ngenApp, String wsPath, String projectName)
	{
		try
		{
			val ir = irRootBuilder.buildGeneratorGenericIr(ngenApp)
			dispatcher.post(MessageType.Exec, "Starting code generation")
			val startTime = System.currentTimeMillis

			// LaTeX generation needs the NabLab model (not IR model)
			dispatcher.post(MessageType::Exec, 'Starting LaTeX code generator')
			val texContents = new ArrayList<GenerationContent>
			if (ngenApp.mainModule !== null && ngenApp.mainModule.type !== null)
				texContents += new GenerationContent(ngenApp.mainModule.type.name + ".tex", ngenApp.mainModule.type.latexContent, false)
			for (adModule : ngenApp.additionalModules)
				if (adModule.type !== null)
					texContents += new GenerationContent(adModule.type.name + ".tex", adModule.type.latexContent, false)
			val projectPath = wsPath + '/' + projectName
			var fsa = getConfiguredFileSystemAccess(projectPath, true)
			generate(fsa, texContents, ir.dirName)

			dispatcher.post(MessageType::Exec, "Starting Json code generator")
			val ir2Json = new JsonGenerator(ngenApp.levelDB!==null)
			val jsonGenerationContent = ir2Json.getGenerationContents(ir)
			generate(fsa, jsonGenerationContent, ir.dirName)

			for (target : ngenApp.targets)
			{
				dispatcher.post(MessageType::Exec, "Starting " + target.name + " code generator: " + target.outputPath)

				// Configure fsa with target output folder
				val outputFolderName = wsPath + target.outputPath
				fsa = getConfiguredFileSystemAccess(outputFolderName, false)

				// Set provider extension for the target
				// No need to duplicate IR. All providers are set for each target.
				if (ngenExtHelper.setExtensionProviders(ir, wsPath, target, true))
				{
					if (!target.interpreter)
					{
						// Create code generator
						val itMax = if (ngenApp.mainModule.iterationMax === null) null else ngenApp.mainModule.iterationMax.name
						val tMax = if (ngenApp.mainModule.timeMax === null) null else ngenApp.mainModule.timeMax.name
						val g = irCodeGeneratorFactory.create(wsPath, target.type, target.variables, ngenApp.levelDB, itMax, tMax)
						
						// Apply IR transformations dedicated to this target (if necessary)
						val IrRoot genIr = (g.irTransformationSteps.empty ? ir : EcoreUtil::copy(ir))
						for (s : g.irTransformationSteps)
							s.transformIrRoot(genIr, [msg | dispatcher.post(MessageType::Exec, msg)])
						if (target.writeIR)
						{
							val fileName = irWriter.createAndSaveResource(fsa, genIr)
							dispatcher.post(MessageType::Exec, '    Resource saved: ' + fileName)
						}
						generate(fsa, g.getGenerationContents(genIr), ir.dirName)
					}
				}
				else
				{
					dispatcher.post(MessageType::Warning, "    Generation ignored for: " + target.name)
				}

			}

			val endTime = System.currentTimeMillis
			dispatcher.post(MessageType.Exec, "Code generation ended in " + (endTime-startTime)/1000.0 + "s")
		}
		catch(Exception e)
		{
			dispatcher.post(MessageType::Error, '\n***' + e.class.name + ': ' + e.message)
			if (e.stackTrace !== null && !e.stackTrace.empty)
			{
				val stack = e.stackTrace.head
				dispatcher.post(MessageType::Error, 'at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')')
			}
			throw(e)
		}
	}

	private def getLatexContent(NablaModule m)
	'''
		\documentclass[11pt]{article}

		\usepackage{fontspec}
		\usepackage{geometry}
		\geometry{landscape}

		\title{Nabla Module «m.name»}
		\author{Generated by the NabLab environment}

		\begin{document}
		\maketitle

		«FOR j : m.jobs»
		«val latexContent = j.latex»
		«IF !latexContent.nullOrEmpty»

		\section{«j.name»}
		$«latexContent»$

		«ENDIF»
		«ENDFOR»
		\end{document}
	'''

	private def getName(Target it) { (interpreter ? 'interpreter' : type.literal) }
}

