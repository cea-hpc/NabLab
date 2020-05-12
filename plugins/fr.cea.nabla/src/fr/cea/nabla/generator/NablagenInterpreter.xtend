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
import fr.cea.nabla.ir.generator.cpp.SequentialBackend
import fr.cea.nabla.ir.generator.cpp.StlThreadBackend
import fr.cea.nabla.ir.generator.java.Ir2Java
import fr.cea.nabla.ir.generator.json.Ir2Json
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.transformers.IrTransformationStep
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

class NablagenInterpreter
{
	String projectDir
	@Accessors val traceListeners = new ArrayList<(String)=>void>
	val ir2Json = new Ir2Json
	@Inject Provider<JavaIoFileSystemAccess> fsaProvider
	@Inject Nabla2Ir nabla2Ir
	@Inject IOutputConfigurationProvider outputConfigurationProvider

	def IrModule launch(NablagenConfig it, String projectDir)
	{
		try
		{
			this.projectDir = projectDir
			trace('Starting generation of ' + nablaModule.name + '\n')
			trace('Nabla -> IR\n')
			val irModule = nabla2Ir.toIrModule(nablaModule)
			// IR -> IR with HLT
			transformIr(NablaGenerator.hltIrTransformer, irModule)

			// Tag output variables
			if (vtkOutput !== null && !vtkOutput.vars.empty)
			{
				val outVars = new HashMap<String, String>
				vtkOutput.vars.forEach[x | outVars.put(x.varRef.name, x.varName)]
				transformIr(new TagOutputVariables(outVars, vtkOutput.periodReference.name), irModule)
			}

			// Set simulation variables
			transformIr(new SetSimulationVariables(time.name, timeStep.name, nodeCoord.name), irModule)

			// IR with HLT -> IR for generation -> code generation
			val models = getModels(targets.size, irModule)
			for (i : 0..<models.size)
			{
				val target = targets.get(i)
				val model = models.get(i)

				// Code generation
				generateCode(target, model, iterationMax.name, timeMax.name)
			}

			return irModule
		}
		catch(Exception e)
		{
			trace('\n***' + e.class.name + ': ' + e.message + '\n')
			if (e.stackTrace !== null && !e.stackTrace.empty)
			{
				val stack = e.stackTrace.head
				trace('at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')\n')
			}
			throw(e)
		}
	}

	private def void generateCode(Target target, IrModule irModule, String iterationMax, String timeMax)
	{
		val baseDir =  projectDir + "/.."
		val g = getCodeGenerator(target, baseDir, iterationMax, timeMax)
		trace(g.name + " code generator\n")
		val outputFolderName = baseDir + target.outputDir
		val outputFolder = new File(outputFolderName)
		if (!outputFolder.exists || !(outputFolder.isDirectory))
			throw new RuntimeException('** Invalid outputDir: ' + target.outputDir + '\n')
		else
		{
			val fsa = getConfiguredFileSystemAccess(outputFolderName, false)
			val fileContentsByName = new LinkedHashMap<String, CharSequence>
			fileContentsByName += ir2Json.getFileContentsByName(irModule)
			fileContentsByName += g.getFileContentsByName(irModule)
			for (fileName : fileContentsByName.keySet)
			{
				val fullFileName = irModule.name.toLowerCase + '/' + fileName
				val fileContent = fileContentsByName.get(fileName)
				trace("    Generating '" + fullFileName + "\n")
				fsa.generateFile(fullFileName, fileContent)
			}
		}
	}

	private def getConfiguredFileSystemAccess(String absoluteBasePath, boolean keepSrcGen) 
	{
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

	/**
	 * Duplicate model nbTargets-1 times to avoid conflicts.
	 * Caution: clones must be done before beginning to apply
	 * non common transformations to keep model consistent.
	 */
	private def Iterable<IrModule> getModels(int nbTargets, IrModule module)
	{
		switch nbTargets
		{
			case 0: return #[]
			case 1: return #[module]
			default:
			{
				val List<IrModule> models = newArrayOfSize(nbTargets)
				models.set(0, module)
				for (i : 1..<nbTargets) models.set(i, EcoreUtil::copy(module))
				return models
			}
		}
	}

	private def void trace(String msg)
	{
		traceListeners.forEach[apply(msg)]
	}

	private def void transformIr(IrTransformationStep step, IrModule module) throws RuntimeException
	{
		step.addTraceListener([x | trace(x)])
		val ok = step.transform(module)
		if (!ok) throw new RuntimeException('Exception in IR transformation step: ' + step.description)
	}

	private def getCodeGenerator(Target it, String baseDir, String iterationMax, String timeMax)
	{
		switch it
		{
			Java: return new Ir2Java
			Cpp:
			{
				val backend = switch it
				{
					CppSequential: new SequentialBackend(iterationMax , timeMax, compiler.literal, compilerPath)
					CppStlThread: new StlThreadBackend(iterationMax , timeMax, compiler.literal, compilerPath)
					CppOpenMP: throw new RuntimeException('Not yet implemented')
					CppKokkos: new KokkosBackend(iterationMax , timeMax, compiler.literal, compilerPath, kokkosPath)
					CppKokkosTeamThread: new KokkosTeamThreadBackend(iterationMax , timeMax, compiler.literal, compilerPath, kokkosPath)
					default: throw new RuntimeException("Unsupported language " + class.name)
				}
				return new Ir2Cpp(new File(baseDir + outputDir), backend)
			}
			default : throw new RuntimeException("Unsupported language " + class.name)
		}
	}
}

