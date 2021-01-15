/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.ir.Nablagen2Ir
import fr.cea.nabla.generator.providers.JniProviderGenerator
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.cpp.CppApplicationGenerator
import fr.cea.nabla.ir.generator.java.JavaApplicationGenerator
import fr.cea.nabla.ir.generator.json.JsonGenerator
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.CompositeTransformationStep
import fr.cea.nabla.ir.transformers.FillJobHLTs
import fr.cea.nabla.ir.transformers.IrTransformationStep
import fr.cea.nabla.ir.transformers.OptimizeConnectivities
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablaext.ExtensionProvider
import fr.cea.nabla.nablaext.TargetType
import fr.cea.nabla.nablagen.GenTarget
import fr.cea.nabla.nablagen.LevelDB
import fr.cea.nabla.nablagen.NablagenPackage
import fr.cea.nabla.nablagen.NablagenRoot
import fr.cea.nabla.nablagen.Target
import java.io.File
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.scoping.IScopeProvider

import static extension fr.cea.nabla.LatexLabelServices.*

class NablagenInterpreter extends StandaloneGeneratorBase
{
	@Inject Nablagen2Ir nablagen2Ir
	@Inject NablaIrWriter irWriter
	@Inject BackendFactory backendFactory
	@Inject IScopeProvider scopeProvider
	@Inject Provider<JniProviderGenerator> jniGeneratorProvider

	def IrRoot buildIr(NablagenRoot ngen, String projectDir, boolean forInterpreter)
	{
		try
		{
			// Nabla -> IR
			dispatcher.post(MessageType::Exec, 'Nabla -> IR')
			val ir = nablagen2Ir.toIrRoot(ngen)
			getCommonIrTransformation(forInterpreter).transformIr(ir, [msg | dispatcher.post(MessageType::Exec, msg)])

			if (ngen.writeIR)
			{
				val fileName = irWriter.createAndSaveResource(getConfiguredFileSystemAccess(projectDir, true), ir)
				dispatcher.post(MessageType::Exec, 'Resource saved: ' + fileName)
			}

			if (forInterpreter)
			{
				if (ngen.interpreterTarget === null)
					dispatcher.post(MessageType::Warning, 'No interpreter configuration found in nablagen file => default classpath used')
				else
				{
					val ok = setExtensionProviders(ir, projectDir + '/..', ngen.interpreterTarget, TargetType::JAVA)
					if (!ok)
						throw new RuntimeException("Can not build an IR for interpretation: missing providers")
				}
			}
			else
			{
				// LaTeX generation must be done here because it needs NabLab model
				dispatcher.post(MessageType::Exec, 'Nabla -> Latex')
				val texContents = new ArrayList<GenerationContent>
				if (ngen.mainModule !== null && ngen.mainModule.type !== null)
					texContents += new GenerationContent(ngen.mainModule.type.name + ".tex", ngen.mainModule.type.latexContent, false)
				for (adModule : ngen.additionalModules)
					if (adModule.type !== null)
						texContents += new GenerationContent(adModule.type.name + ".tex", adModule.type.latexContent, false)
				var fsa = getConfiguredFileSystemAccess(projectDir, true)
				generate(fsa, texContents, ir.name.toLowerCase)
			}

			return ir
		}
		catch(Exception e)
		{
			dispatcher.post(MessageType::Error, '\n***' + e.class.name + ': ' + e.message)
			if (e.stackTrace !== null && !e.stackTrace.empty)
			{
				val stack = e.stackTrace.head
				dispatcher.post(MessageType::Error, 'at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')')
			}
			if (e instanceof NullPointerException)
			{
				dispatcher.post(MessageType::Error, "Try to rebuild the entire project (Project menu in main menu bar) and to relaunch the generation")
			}
			throw(e)
		}
	}

	def void generateCode(IrRoot ir, List<GenTarget> targets, String iterationMaxVarName, String timeMaxVarName, String projectDir, LevelDB levelDB)
	{
		try
		{
			dispatcher.post(MessageType::Exec, "Starting Json code generator")
			val ir2Json = new JsonGenerator(levelDB!==null)
			val jsonGenerationContent = ir2Json.getGenerationContents(ir)
			var fsa = getConfiguredFileSystemAccess(projectDir, true)
			generate(fsa, jsonGenerationContent, ir.name.toLowerCase)

			val baseDir =  projectDir + "/.."
			for (target : targets)
			{
				// Set provider extension for the target
				if (setExtensionProviders(ir, baseDir, target, target.type))
				{
					// Create code generator
					val g = getCodeGenerator(target, baseDir, iterationMaxVarName, timeMaxVarName, levelDB)
					dispatcher.post(MessageType::Exec, "Starting " + g.name + " code generator")

					// Configure fsa with target output folder
					val outputFolderName = baseDir + target.outputDir
					fsa = getConfiguredFileSystemAccess(outputFolderName, false)

					// Apply IR transformations dedicated to this target (if necessary)
					if (g.irTransformationStep !== null)
					{
						val duplicatedIr = EcoreUtil::copy(ir)
						g.irTransformationStep.transformIr(duplicatedIr, [msg | dispatcher.post(MessageType::Exec, msg)])
						generate(fsa, g.getGenerationContents(duplicatedIr), ir.name.toLowerCase)
					}
					else
					{
						generate(fsa, g.getGenerationContents(ir), ir.name.toLowerCase)
					}
				}
				else
				{
					dispatcher.post(MessageType::Warning, "Generation ignored for target: " + target.type.literal)
				}
			}
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

	private def getCodeGenerator(GenTarget it, String baseDir, String iterationMax, String timeMax, LevelDB levelDB)
	{
		val levelDBPath = if (levelDB === null) null else levelDB.levelDBPath

		if (type == TargetType::JAVA)
		{
			//UnzipHelper::unzipLibJavaNabla(new File(baseDir))
			new JavaApplicationGenerator
		}
		else
		{
			val backend = backendFactory.getCppBackend(type)
			backend.traceContentProvider.maxIterationsVarName = iterationMax
			backend.traceContentProvider.stopTimeVarName = timeMax
			UnzipHelper::unzipLibCppNabla(new File(baseDir))
			// The libcppnabla is unzipped in baseDir/libCppNabla but it is transformed to a relative
			// directory for the CMakeLists.txt in order to have always the same generated file.
			var relativeBaseDir = outputDir.replaceAll("[^/]+", "..") + "/" + UnzipHelper.CppResourceName
			relativeBaseDir = (relativeBaseDir.startsWith("/") ? ".." : "../") + relativeBaseDir
			relativeBaseDir = "${CMAKE_CURRENT_SOURCE_DIR}/" + relativeBaseDir
			new CppApplicationGenerator(backend, relativeBaseDir, levelDBPath, vars)
		}
	}

	private def getVars(GenTarget it)
	{
		val result = new HashMap<String, String>
		variables.forEach[x | result.put(x.key, x.value)]
		return result
	}

	private def getCommonIrTransformation(boolean replaceAllReductions)
	{
		val description = 'IR->IR transformations shared by all generators'
		val transformations = new ArrayList<IrTransformationStep>
		transformations += new ReplaceUtf8Chars
		transformations += new OptimizeConnectivities(#['cells', 'nodes', 'faces'])
		transformations += new ReplaceReductions(replaceAllReductions)
		transformations += new FillJobHLTs
		new CompositeTransformationStep(description, transformations)
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

	private def boolean setExtensionProviders(IrRoot ir, String baseDir, Target target, TargetType type)
	{
		val jniGenerator = jniGeneratorProvider.get

		// Browse IrRoot model providers which need to be filled with Nablaext providers
		for (irProvider : ir.providers.filter[x | x.extensionName != "Math" && x.extensionName != "LinearAlgebra"])
		{
			val extensionConfig = target.extensionConfigs.findFirst[x | x.extension.name == irProvider.extensionName]
			val provider = (extensionConfig === null ? getDefaultProvider(target, type, irProvider.extensionName) : extensionConfig.provider)
			if (provider === null)
			{
				dispatcher.post(MessageType::Error, 'No provider found for extension: ' + irProvider.extensionName)
				return false
			}

			irProvider.providerName = provider.name
			irProvider.projectRoot = provider.projectRoot
			if (provider.target != type)
			{
				dispatcher.post(MessageType::Warning, 'The target of the provider differs from target: ' + provider.target.literal + " != " + type.literal)
				if (type == TargetType::JAVA)
				{
					irProvider.providerName = irProvider.providerName + 'Jni'
					irProvider.projectRoot = baseDir + "/" + irProvider.providerName
					jniGenerator.generate(baseDir, irProvider.providerName, provider)
				}
			}
		}

		// JNI providers are generated for interpreter and Java code.
		// When some JNI providers are generated, a root CMake is created
		jniGenerator.generateGlobalCMakeIfNecessary(ir, target, baseDir)
		return true
	}

	private def ExtensionProvider getDefaultProvider(EObject context, TargetType type, String extensionName)
	{
		val providerDescriptionScope = scopeProvider.getScope(context, NablagenPackage.Literals.EXTENSION_CONFIG__PROVIDER)
		for (providerDescription : providerDescriptionScope.allElements)
		{
			var o = providerDescription.EObjectOrProxy
			if (o !== null)
			{
				var ExtensionProvider provider
				if (o.eIsProxy)
					provider = context.eResource.resourceSet.getEObject(providerDescription.EObjectURI, true) as ExtensionProvider
				else
					provider = o as ExtensionProvider

				if (provider.extension.name == extensionName && provider.target == type)
				{
					dispatcher.post(MessageType::Warning, 'Default provider found for extension ' + extensionName + ': ' + provider.name)
					return provider
				}
			}
		}
		return null
	}
}

