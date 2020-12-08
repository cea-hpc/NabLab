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

import com.google.common.base.Function
import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.generator.ir.Nablagen2Ir
import fr.cea.nabla.ir.generator.cpp.Ir2Cpp
import fr.cea.nabla.ir.generator.cpp.KokkosBackend
import fr.cea.nabla.ir.generator.cpp.KokkosTeamThreadBackend
import fr.cea.nabla.ir.generator.cpp.OpenMpBackend
import fr.cea.nabla.ir.generator.cpp.SequentialBackend
import fr.cea.nabla.ir.generator.cpp.StlThreadBackend
import fr.cea.nabla.ir.generator.java.Ir2Java
import fr.cea.nabla.ir.generator.json.Ir2Json
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.CompositeTransformationStep
import fr.cea.nabla.ir.transformers.FillJobHLTs
import fr.cea.nabla.ir.transformers.IrTransformationStep
import fr.cea.nabla.ir.transformers.OptimizeConnectivities
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablagen.Application
import fr.cea.nabla.nablagen.ExtensionConfig
import fr.cea.nabla.nablagen.LevelDB
import fr.cea.nabla.nablagen.Target
import fr.cea.nabla.nablagen.TargetType
import java.io.File
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.IOutputConfigurationProvider
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.xtext.generator.OutputConfiguration

import static com.google.common.collect.Maps.uniqueIndex

import static extension fr.cea.nabla.LatexLabelServices.*

class NablagenInterpreter
{
	@Inject Provider<JavaIoFileSystemAccess> fsaProvider
	@Inject Nablagen2Ir nablagen2Ir
	@Inject IOutputConfigurationProvider outputConfigurationProvider
	@Inject NablaIrWriter irWriter

	@Accessors val traceListeners = new ArrayList<(String)=>void>

	def IrRoot buildIr(Application ngen, String projectDir)
	{
		try
		{
			// Nabla -> IR
			trace('Nabla -> IR')
			val ir = nablagen2Ir.toIrRoot(ngen)

			// IR -> IR
			commonIrTransformation.transformIr(ir, [msg | trace(msg)])

			trace('Nabla -> Latex')
			val texContentsByName = new HashMap<String, CharSequence>
			if (ngen.mainModule !== null && ngen.mainModule.type !== null)
				texContentsByName.put(ngen.mainModule.type.name + ".tex", ngen.mainModule.type.latexContent)
			for (adModule : ngen.additionalModules)
				if (adModule.type !== null)
					texContentsByName.put(adModule.type.name + ".tex", adModule.type.latexContent)
			var fsa = getConfiguredFileSystemAccess(projectDir, true)
			generate(fsa, texContentsByName, ir)

			if (ngen.writeIR)
			{
				val fileName = irWriter.createAndSaveResource(getConfiguredFileSystemAccess(projectDir, true), ir)
				trace('Resource saved: ' + fileName)
			}

			return ir
		}
		catch(Exception e)
		{
			trace('\n***' + e.class.name + ': ' + e.message)
			if (e.stackTrace !== null && !e.stackTrace.empty)
			{
				val stack = e.stackTrace.head
				trace('at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')')
			}
			if (e instanceof NullPointerException)
			{
				trace("Try to rebuild the entire project (Project menu in main menu bar) and to relaunch the generation")
			}
			throw(e)
		}
	}

	def void generateCode(IrRoot ir, List<ExtensionConfig> extensions, List<Target> targets, String iterationMaxVarName, String timeMaxVarName, String projectDir, LevelDB levelDB)
	{
		try
		{
			trace("Starting Json code generator")
			val ir2Json = new Ir2Json(levelDB!==null)
			val jsonFileContentsByName = ir2Json.getFileContentsByName(ir)
			var fsa = getConfiguredFileSystemAccess(projectDir, true)
			generate(fsa, jsonFileContentsByName, ir)

			val baseDir =  projectDir + "/.."
			for (target : targets)
			{
				// Set provider extension for the target
				setExtensionProviders(target.type, ir, extensions)

				// Create code generator
				val g = getCodeGenerator(target, baseDir, iterationMaxVarName, timeMaxVarName, levelDB)
				trace("Starting " + g.name + " code generator")

				// Configure fsa with target output folder
				val outputFolderName = baseDir + target.outputDir
				fsa = getConfiguredFileSystemAccess(outputFolderName, false)

				// Apply IR transformations dedicated to this target (if necessary)
				if (g.needIrTransformation)
				{
					val duplicatedIr = EcoreUtil::copy(ir)
					g.irTransformationStep.transformIr(duplicatedIr, [msg | trace(msg)])
					generate(fsa, g.getFileContentsByName(duplicatedIr), ir)
				}
				else
				{
					generate(fsa, g.getFileContentsByName(ir), ir)
				}
			}
		}
		catch(Exception e)
		{
			trace('\n***' + e.class.name + ': ' + e.message)
			if (e.stackTrace !== null && !e.stackTrace.empty)
			{
				val stack = e.stackTrace.head
				trace('at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')')
			}
			throw(e)
		}
	}

	private def generate(JavaIoFileSystemAccess fsa, Map<String, CharSequence> fileContentsByName, IrRoot ir)
	{
		for (fileName : fileContentsByName.keySet)
		{
			val fullFileName = ir.name.toLowerCase + '/' + fileName
			val fileContent = fileContentsByName.get(fileName)
			trace("    Generating: " + fullFileName)
			fsa.generateFile(fullFileName, fileContent)
		}
	}

	private def getConfiguredFileSystemAccess(String absoluteBasePath, boolean keepSrcGen)
	{
		val baseFolder = new File(absoluteBasePath)
		if (!baseFolder.exists || !(baseFolder.isDirectory))
			throw new RuntimeException('** Invalid outputDir: ' + absoluteBasePath)

		val fsa = fsaProvider.get
		fsa.outputConfigurations = outputConfigurations
		fsa.outputConfigurations.values.forEach
		[
			if (keepSrcGen)
				outputDirectory = absoluteBasePath + '/' + outputDirectory
			else
				outputDirectory = absoluteBasePath
		]
		return fsa
	}

	private def getOutputConfigurations() 
	{
		val configurations = outputConfigurationProvider.outputConfigurations
		return uniqueIndex(configurations, new Function<OutputConfiguration, String>() 
		{	
			override apply(OutputConfiguration from) { return from.name }
		})
	}

	private def void trace(String msg)
	{
		traceListeners.forEach[apply(msg)]
	}

	private def getCodeGenerator(Target it, String baseDir, String iterationMax, String timeMax, LevelDB levelDB)
	{
		val levelDBPath = if (levelDB === null) null else levelDB.levelDBPath

		switch type
		{
			case JAVA: return new Ir2Java
			case CPP_SEQUENTIAL: new Ir2Cpp(new File(baseDir + outputDir), new SequentialBackend(iterationMax, timeMax, levelDBPath, vars))
			case STL_THREAD: new Ir2Cpp(new File(baseDir + outputDir), new StlThreadBackend(iterationMax , timeMax, levelDBPath, vars))
			case OPEN_MP: new Ir2Cpp(new File(baseDir + outputDir), new OpenMpBackend(iterationMax , timeMax, levelDBPath, vars))
			case KOKKOS: new Ir2Cpp(new File(baseDir + outputDir), new KokkosBackend(iterationMax , timeMax, levelDBPath, vars))
			case KOKKOS_TEAM_THREAD: new Ir2Cpp(new File(baseDir + outputDir), new KokkosTeamThreadBackend(iterationMax , timeMax, levelDBPath, vars))
			default: throw new RuntimeException("Unsupported language " + class.name)
		}
	}

	private def getVars(Target it)
	{
		val result = new HashMap<String, String>
		variables.forEach[x | result.put(x.key, x.value)]
		return result
	}

	private def getCommonIrTransformation()
	{
		val description = 'IR->IR transformations shared by all generators'
		val transformations = new ArrayList<IrTransformationStep>
		transformations += new ReplaceUtf8Chars
		transformations += new OptimizeConnectivities(#['cells', 'nodes', 'faces'])
		transformations += new ReplaceReductions(false)
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

	private def void setExtensionProviders(TargetType target, IrRoot ir, List<ExtensionConfig> extensionConfigs)
	{
		for (irProvider : ir.providers)
		{
			val extensionConfig = extensionConfigs.findFirst[x | x.extension.name == irProvider.extensionName]
			if (extensionConfig === null)
				throw new RuntimeException("Missing nablagen configuration for extension: " + irProvider.extensionName)

			val provider = extensionConfig.providers.findFirst[x | x.targets.contains(target)]
			if (provider === null)
				throw new RuntimeException("Missing " + target.literal + " provider for extension: " + irProvider.extensionName)

			irProvider.facadeClass = provider.facadeClass
			irProvider.libHome = provider.libHome
			irProvider.libName = provider.libName
		}
	}
}

