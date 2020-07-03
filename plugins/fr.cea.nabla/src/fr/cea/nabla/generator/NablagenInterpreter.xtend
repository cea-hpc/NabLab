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
import fr.cea.nabla.generator.ir.Nabla2Ir
import fr.cea.nabla.ir.generator.cpp.Ir2Cpp
import fr.cea.nabla.ir.generator.cpp.KokkosBackend
import fr.cea.nabla.ir.generator.cpp.KokkosTeamThreadBackend
import fr.cea.nabla.ir.generator.cpp.OpenMpBackend
import fr.cea.nabla.ir.generator.cpp.SequentialBackend
import fr.cea.nabla.ir.generator.cpp.StlThreadBackend
import fr.cea.nabla.ir.generator.java.Ir2Java
import fr.cea.nabla.ir.generator.json.Ir2Json
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.transformers.CompositeTransformationStep
import fr.cea.nabla.ir.transformers.FillJobHLTs
import fr.cea.nabla.ir.transformers.IrTransformationStep
import fr.cea.nabla.ir.transformers.OptimizeConnectivities
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.ir.transformers.SetSimulationVariables
import fr.cea.nabla.ir.transformers.TagOutputVariables
import fr.cea.nabla.nablagen.Cpp
import fr.cea.nabla.nablagen.CppKokkos
import fr.cea.nabla.nablagen.CppKokkosTeamThread
import fr.cea.nabla.nablagen.CppOpenMP
import fr.cea.nabla.nablagen.CppSequential
import fr.cea.nabla.nablagen.CppStlThread
import fr.cea.nabla.nablagen.Java
import fr.cea.nabla.nablagen.NablagenConfig
import fr.cea.nabla.nablagen.Target
import java.io.File
import java.util.ArrayList
import java.util.HashMap
import java.util.LinkedHashMap
import java.util.List
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.IOutputConfigurationProvider
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.xtext.generator.OutputConfiguration

import static com.google.common.collect.Maps.uniqueIndex
import fr.cea.nabla.nablagen.LevelDB

class NablagenInterpreter
{
	@Inject Provider<JavaIoFileSystemAccess> fsaProvider
	@Inject Nabla2Ir nabla2Ir
	@Inject IOutputConfigurationProvider outputConfigurationProvider
	@Inject IrModuleTransformer transformer
	@Inject NablaIrWriter irWriter

	@Accessors val traceListeners = new ArrayList<(String)=>void>
	val ir2Json = new Ir2Json

	def IrModule buildIrModule(NablagenConfig it, String projectDir)
	{
		try
		{
			// Nabla -> IR
			trace('Nabla -> IR')
			val irModule = nabla2Ir.toIrModule(nablaModule)

			// IR -> IR
			transformer.transformIr(commonIrTransformation, irModule, [msg | trace(msg)])

			if (writeIR)
			{
				val fileName = irWriter.createAndSaveResource(getConfiguredFileSystemAccess(projectDir, true), irModule)
				trace('Resource saved: ' + fileName)
			}

			return irModule
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

	def void generateCode(IrModule irModule, List<Target> targets, String iterationMaxVarName, String timeMaxVarName, String projectDir, LevelDB levelDB)
	{
		try
		{
			val jsonFileContentsByName = ir2Json.getFileContentsByName(irModule)
			val baseDir =  projectDir + "/.."
			for (target : targets)
			{
				// Code generation
				val g = getCodeGenerator(target, baseDir, iterationMaxVarName, timeMaxVarName, levelDB)
				trace("Starting " + g.name + " code generator")
				val outputFolderName = baseDir + target.outputDir
				val fsa = getConfiguredFileSystemAccess(outputFolderName, false)
				val fileContentsByName = new LinkedHashMap<String, CharSequence>
				fileContentsByName += jsonFileContentsByName

				if (g.needIrTransformation)
				{
					val duplicatedIrModule = EcoreUtil::copy(irModule)
					transformer.transformIr(g.irTransformationStep, duplicatedIrModule, [msg | trace(msg)])
					fileContentsByName += g.getFileContentsByName(duplicatedIrModule)
				}
				else
				{
					fileContentsByName += g.getFileContentsByName(irModule)
				}

				for (fileName : fileContentsByName.keySet)
				{
					val fullFileName = irModule.name.toLowerCase + '/' + fileName
					val fileContent = fileContentsByName.get(fileName)
					trace("    Generating: " + fullFileName)
					fsa.generateFile(fullFileName, fileContent)
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
		
		switch it
		{
			Java: return new Ir2Java
			Cpp:
			{
				val backend = switch it
				{
					CppSequential: new SequentialBackend(iterationMax, timeMax, compiler.literal, compilerPath, levelDBPath)
					CppStlThread: new StlThreadBackend(iterationMax , timeMax, compiler.literal, compilerPath, levelDBPath)
					CppOpenMP:new OpenMpBackend(iterationMax , timeMax, compiler.literal, compilerPath, levelDBPath)
					CppKokkos: new KokkosBackend(iterationMax , timeMax, compiler.literal, compilerPath, kokkosPath, levelDBPath)
					CppKokkosTeamThread: new KokkosTeamThreadBackend(iterationMax , timeMax, compiler.literal, compilerPath, kokkosPath, levelDBPath)
					default: throw new RuntimeException("Unsupported language " + class.name)
				}
				return new Ir2Cpp(new File(baseDir + outputDir), backend)
			}
			default : throw new RuntimeException("Unsupported language " + class.name)
		}
	}

	private def getCommonIrTransformation(NablagenConfig it)
	{
		val description = 'IR->IR transformations shared by all generators'
		val transformations = new ArrayList<IrTransformationStep>
		transformations += new ReplaceUtf8Chars
		transformations += new OptimizeConnectivities(#['cells', 'nodes', 'faces'])
		transformations += new ReplaceReductions(false)
		transformations += new FillJobHLTs
		transformations += new SetSimulationVariables(simulation.time.name, simulation.timeStep.name, simulation.nodeCoord.name)

		if (vtkOutput !== null && !vtkOutput.vars.empty)
		{
			val outVars = new HashMap<String, String>
			vtkOutput.vars.forEach[x | outVars.put(x.varRef.name, x.varName)]
			transformations += new TagOutputVariables(outVars, vtkOutput.periodReference.name)
		}

		new CompositeTransformationStep(description, transformations)
	}
}

