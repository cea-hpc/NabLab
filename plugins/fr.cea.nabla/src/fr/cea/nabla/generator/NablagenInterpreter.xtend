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
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
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
import fr.cea.nabla.nablaext.TargetType
import fr.cea.nabla.nablagen.ExtensionConfig
import fr.cea.nabla.nablagen.LevelDB
import fr.cea.nabla.nablagen.NablagenRoot
import fr.cea.nabla.nablagen.Target
import java.io.File
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

import static extension fr.cea.nabla.LatexLabelServices.*

class NablagenInterpreter extends StandaloneGeneratorBase
{
	@Inject Nablagen2Ir nablagen2Ir
	@Inject NablaIrWriter irWriter

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
				if (ngen.interpreterConfig === null)
					dispatcher.post(MessageType::Warning, 'No interpreter configuration found in nablagen file => default classpath used')
				else
					setExtensionProviders(TargetType::JAVA, ngen.interpreterConfig.extensionConfigs, ir)
			}
			else
			{
				// LaTeX generation must be done here because it needs NabLab model
				dispatcher.post(MessageType::Exec, 'Nabla -> Latex')
				val texContentsByName = new HashMap<String, CharSequence>
				if (ngen.mainModule !== null && ngen.mainModule.type !== null)
					texContentsByName.put(ngen.mainModule.type.name + ".tex", ngen.mainModule.type.latexContent)
				for (adModule : ngen.additionalModules)
					if (adModule.type !== null)
						texContentsByName.put(adModule.type.name + ".tex", adModule.type.latexContent)
				var fsa = getConfiguredFileSystemAccess(projectDir, true)
				generate(fsa, texContentsByName, ir)
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

	def void generateCode(IrRoot ir, List<Target> targets, String iterationMaxVarName, String timeMaxVarName, String projectDir, LevelDB levelDB)
	{
		try
		{
			dispatcher.post(MessageType::Exec, "Starting Json code generator")
			val ir2Json = new Ir2Json(levelDB!==null)
			val jsonFileContentsByName = ir2Json.getFileContentsByName(ir)
			var fsa = getConfiguredFileSystemAccess(projectDir, true)
			generate(fsa, jsonFileContentsByName, ir)

			val baseDir =  projectDir + "/.."
			for (target : targets)
			{
				// Set provider extension for the target
				setExtensionProviders(target.type, target.extensionConfigs, ir)

				// Create code generator
				val g = getCodeGenerator(target, baseDir, iterationMaxVarName, timeMaxVarName, levelDB)
				dispatcher.post(MessageType::Exec, "Starting " + g.name + " code generator")

				// Configure fsa with target output folder
				val outputFolderName = baseDir + target.outputDir
				fsa = getConfiguredFileSystemAccess(outputFolderName, false)

				// Apply IR transformations dedicated to this target (if necessary)
				if (g.needIrTransformation)
				{
					val duplicatedIr = EcoreUtil::copy(ir)
					g.irTransformationStep.transformIr(duplicatedIr, [msg | dispatcher.post(MessageType::Exec, msg)])
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
			dispatcher.post(MessageType::Error, '\n***' + e.class.name + ': ' + e.message)
			if (e.stackTrace !== null && !e.stackTrace.empty)
			{
				val stack = e.stackTrace.head
				dispatcher.post(MessageType::Error, 'at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')')
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
			dispatcher.post(MessageType::Exec, "    Generating: " + fullFileName)
			fsa.generateFile(fullFileName, fileContent)
		}
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

	private def void setExtensionProviders(TargetType targetType, Iterable<ExtensionConfig> configs, IrRoot ir)
	{
		for (irProvider : ir.providers.filter[x | x.extensionName != "Math" && x.extensionName != "LinearAlgebra"])
		{
			val extensionConfig = configs.findFirst[x | x.extension.name == irProvider.extensionName]
			if (extensionConfig === null)
				throw new RuntimeException("Missing nablagen configuration for extension: " + irProvider.extensionName)

			if (extensionConfig.provider === null)
				throw new RuntimeException("Missing " + targetType.literal + " provider for extension: " + irProvider.extensionName)

			irProvider.facadeClass = extensionConfig.provider.facadeClass
			irProvider.libHome = extensionConfig.provider.libHome
			irProvider.libName = extensionConfig.provider.libName
		}
	}
}

