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
import fr.cea.nabla.ir.generator.cpp.CppGeneratorUtils
import fr.cea.nabla.ir.generator.java.JavaApplicationGenerator
import fr.cea.nabla.ir.generator.json.JsonGenerator
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.CompositeTransformationStep
import fr.cea.nabla.ir.transformers.FillJobHLTs
import fr.cea.nabla.ir.transformers.OptimizeConnectivities
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablaext.ExtensionProvider
import fr.cea.nabla.nablaext.TargetType
import fr.cea.nabla.nablagen.LevelDB
import fr.cea.nabla.nablagen.NablagenPackage
import fr.cea.nabla.nablagen.NablagenRoot
import fr.cea.nabla.nablagen.Target
import java.io.File
import java.util.ArrayList
import java.util.HashMap
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

	/**
	 * Validation checks that there is one interpreter target max.
	 * Consequently, no need to identify the interpreter.
	 * If several interpreter are needed, the outputPath can be used as an id.
	 */
	def IrRoot buildInterpreterIr(NablagenRoot ngen, String projectDir)
	{
		try
		{
			val ir = buildIr(ngen, true)

			val target = ngen.targets.findFirst[x | x.interpreter]
			val baseDir = projectDir + '/..'
			var ok = false
			if (target === null)
				ok = setDefaultInterpreterProviders(ngen, ir, baseDir)
			else
				ok = setExtensionProviders(ir, baseDir, target, false)

			if (!ok) throw new RuntimeException("Can not build an IR for interpretation: missing providers")

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

	def void generateCode(NablagenRoot ngen, String projectDir)
	{
		try
		{
			val ir = buildIr(ngen, false)
			dispatcher.post(MessageType.Exec, "Starting code generation")
			val startTime = System.currentTimeMillis

			// LaTeX generation needs the NabLab model (not IR model)
			dispatcher.post(MessageType::Exec, 'Starting LaTeX code generator')
			val texContents = new ArrayList<GenerationContent>
			if (ngen.mainModule !== null && ngen.mainModule.type !== null)
				texContents += new GenerationContent(ngen.mainModule.type.name + ".tex", ngen.mainModule.type.latexContent, false)
			for (adModule : ngen.additionalModules)
				if (adModule.type !== null)
					texContents += new GenerationContent(adModule.type.name + ".tex", adModule.type.latexContent, false)
			var fsa = getConfiguredFileSystemAccess(projectDir, true)
			generate(fsa, texContents, ir.name.toLowerCase)

			dispatcher.post(MessageType::Exec, "Starting Json code generator")
			val ir2Json = new JsonGenerator(ngen.levelDB!==null)
			val jsonGenerationContent = ir2Json.getGenerationContents(ir)
			generate(fsa, jsonGenerationContent, ir.name.toLowerCase)

			val baseDir =  projectDir + "/.."
			for (target : ngen.targets)
			{
				dispatcher.post(MessageType::Exec, "Starting " + target.name + " code generator: " + target.outputDir)

				// Configure fsa with target output folder
				val outputFolderName = baseDir + target.outputDir
				fsa = getConfiguredFileSystemAccess(outputFolderName, false)
				if (target.writeIR)
				{
					val fileName = irWriter.createAndSaveResource(fsa, ir)
					dispatcher.post(MessageType::Exec, '    Resource saved: ' + fileName)
				}

				// Set provider extension for the target
				// No need to duplicate IR. All providers are set for each target.
				if (setExtensionProviders(ir, baseDir, target, true))
				{
					if (!target.interpreter)
					{
						// Create code generator
						val iterationMax = ngen.mainModule.iterationMax.name
						val timeMax = ngen.mainModule.timeMax.name
						val g = getCodeGenerator(target, baseDir, iterationMax, timeMax, ngen.levelDB)
	
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

	private def IrRoot buildIr(NablagenRoot ngen, boolean replaceAllReductions)
	{
		dispatcher.post(MessageType.Exec, "Starting NabLab to IR model transformation")
		val startTime = System.currentTimeMillis
		val ir = nablagen2Ir.toIrRoot(ngen)
		val commonTransformation = new CompositeTransformationStep('Common transformations', #[
			new ReplaceUtf8Chars, 
			new OptimizeConnectivities(#['cells', 'nodes', 'faces']),
			new ReplaceReductions(replaceAllReductions),
			new FillJobHLTs])
		commonTransformation.transformIr(ir, [msg | dispatcher.post(MessageType::Exec, msg)])
		val endTime = System.currentTimeMillis
		dispatcher.post(MessageType.Exec, "NabLab to IR model transformation ended in " + (endTime-startTime)/1000.0 + "s")
		return ir
	}

	private def getCodeGenerator(Target it, String baseDir, String iterationMax, String timeMax, LevelDB levelDB)
	{
		val levelDBPath = if (levelDB === null) null else levelDB.levelDBPath

		if (type == TargetType::JAVA)
		{
			// libjavanabla.jar is on the classpath of the runtime
			// no need to unzip (if the classloader is an URLClassLoader, it seems to work ?)
			// UnzipHelper::unzipLibJavaNabla(new File(baseDir))
			new JavaApplicationGenerator
		}
		else
		{
			val backend = backendFactory.getCppBackend(type)
			backend.traceContentProvider.maxIterationsVarName = iterationMax
			backend.traceContentProvider.stopTimeVarName = timeMax
			UnzipHelper::unzipLibCppNabla(new File(baseDir))
			new CppApplicationGenerator(backend, baseDir + '/' + CppGeneratorUtils.CppLibName, levelDBPath, vars)
		}
	}

	private def getVars(Target it)
	{
		val result = new HashMap<String, String>
		variables.forEach[x | result.put(x.key, x.value)]
		return result
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

	private def boolean setDefaultInterpreterProviders(EObject ngenContext, IrRoot ir, String baseDir)
	{
		// libjavanabla.jar is on the classpath of the runtime
		// no need to unzip (if the classloader is an URLClassLoader, it seems to work ?)
		// UnzipHelper::unzipLibJavaNabla(new File(baseDir))

		// Browse IrRoot model providers which need to be filled with Nablaext providers
		// TODO Traiter la lib Math comme LinearAlgebra, en vrai provider
		for (irProvider : ir.providers.filter[x | x.extensionName != "Math"])
		{
			val provider = getDefaultProvider(ngenContext, TargetType::JAVA, irProvider.extensionName)
			if (provider === null)
			{
				dispatcher.post(MessageType::Error, '    No provider found for extension: ' + irProvider.extensionName)
				return false
			}

			irProvider.providerName = provider.name
			irProvider.projectDir = baseDir + provider.projectDir
			irProvider.installDir = irProvider.projectDir + '/lib'
			irProvider.facadeClass = provider.facadeClass
			irProvider.facadeNamespace = provider.facadeNamespace
			irProvider.libName = provider.libName
		}

		return true
	}

	private def boolean setExtensionProviders(IrRoot ir, String baseDir, Target target, boolean generateJniProviders)
	{
		val jniGenerator = jniGeneratorProvider.get

		// Browse IrRoot model providers which need to be filled with Nablaext providers
		for (irProvider : ir.providers.filter[x | x.extensionName != "Math"])
		{
			val extensionConfig = target.extensionConfigs.findFirst[x | x.extension.name == irProvider.extensionName]
			val provider = (extensionConfig === null ? getDefaultProvider(target, target.type, irProvider.extensionName) : extensionConfig.provider)
			if (provider === null)
			{
				dispatcher.post(MessageType::Warning, '    No provider found for extension: ' + irProvider.extensionName)
				return false
			}

			irProvider.providerName = provider.name
			irProvider.projectDir = baseDir + provider.projectDir
			if (provider.target == TargetType::JAVA)
				irProvider.installDir = irProvider.projectDir + '/lib'
			else
				irProvider.installDir = baseDir + target.outputDir + '/' + ir.name.toLowerCase + '/lib'
			irProvider.facadeClass = provider.facadeClass
			irProvider.facadeNamespace = provider.facadeNamespace
			irProvider.libName = provider.libName
			if (provider.target != target.type && !provider.compatibleTargets.contains(target.type))
			{
				dispatcher.post(MessageType::Warning, '    The target of the provider differs from target: ' + provider.target.literal + " != " + target.type.literal)
				if (target.type == TargetType::JAVA)
				{
					if (generateJniProviders)
						jniGenerator.generateAndTransformProvider(backendFactory.getCppBackend(provider.target), provider.extension, irProvider)
					else
						jniGenerator.convertToJni(irProvider)
				}
			}
		}

		if (generateJniProviders)
			// JNI providers are generated for interpreter and Java code.
			// When some JNI providers are generated, a root CMake is created
			jniGenerator.generateGlobalCMakeIfNecessary(ir, target, baseDir)

		return true
	}

	private def ExtensionProvider getDefaultProvider(EObject ngenContext, TargetType type, String extensionName)
	{
		val providerDescriptionScope = scopeProvider.getScope(ngenContext, NablagenPackage.Literals.EXTENSION_CONFIG__PROVIDER)
		for (providerDescription : providerDescriptionScope.allElements)
		{
			var o = providerDescription.EObjectOrProxy
			if (o !== null)
			{
				var ExtensionProvider provider
				if (o.eIsProxy)
					provider = ngenContext.eResource.resourceSet.getEObject(providerDescription.EObjectURI, true) as ExtensionProvider
				else
					provider = o as ExtensionProvider

				if (provider.extension.name == extensionName && (provider.target == type || provider.compatibleTargets.contains(type)))
				{
					dispatcher.post(MessageType::Warning, '    Default provider found for extension ' + extensionName + ': ' + provider.name)
					return provider
				}
			}
		}
		return null
	}

	private def getName(Target it) { (interpreter ? 'interpreter' : type.literal) }
}

