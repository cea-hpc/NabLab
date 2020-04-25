/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.workflow

import com.google.common.base.Function
import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.generator.ir.Nabla2Ir
import fr.cea.nabla.ir.generator.json.Ir2Json
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablagen.Ir2CodeComponent
import fr.cea.nabla.nablagen.Ir2IrComponent
import fr.cea.nabla.nablagen.Nabla2IrComponent
import fr.cea.nabla.nablagen.Workflow
import fr.cea.nabla.nablagen.WorkflowComponent
import java.io.File
import java.util.ArrayList
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.xtext.generator.IOutputConfigurationProvider
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.xtext.generator.OutputConfiguration
import org.eclipse.xtext.resource.SaveOptions

import static com.google.common.collect.Maps.uniqueIndex

import static extension fr.cea.nabla.workflow.WorkflowComponentExtensions.*
import java.util.LinkedHashMap

class WorkflowInterpreter 
{
	static val IrExtension = 'nablair'
	String projectDir
	val traceListeners = new ArrayList<IWorkflowTraceListener>
	val modelChangedListeners = new ArrayList<IWorkflowModelChangedListener>
	val ir2Json = new Ir2Json
	@Inject Provider<JavaIoFileSystemAccess> fsaProvider
	@Inject Nabla2Ir nabla2Ir
	@Inject IOutputConfigurationProvider outputConfigurationProvider

	def launch(Workflow workflow, String projectDir)
	{
		try
		{
			this.projectDir = projectDir
			val msg = 'STARTING ' + workflow.name + '\n'
			traceListeners.forEach[write(msg)]
			workflow.components.filter(Nabla2IrComponent).forEach[c | launchComponent(c, workflow.nablaModule)]
		}
		catch(Exception e)
		{
			val msgheader = '\n***' + e.class.name + ': ' + e.message + '\n'
			traceListeners.forEach[write(msgheader)]
			if (e.stackTrace !== null && !e.stackTrace.empty)
			{
				val stack = e.stackTrace.head
				val msg = 'at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')\n'
				traceListeners.forEach[write(msg)]
			}
			throw(e)
		}
	}

	def addWorkflowTraceListener(IWorkflowTraceListener listener)
	{
		traceListeners += listener
	}

	def addWorkflowModelChangedListener(IWorkflowModelChangedListener listener)
	{
		modelChangedListeners += listener
	}

	private def dispatch void launchComponent(Nabla2IrComponent c, NablaModule nablaModule)
	{
		val msg = '  Nabla -> IR - ' + c.name
		traceListeners.forEach[write(msg)]
		val irModule = nabla2Ir.toIrModule(nablaModule, c.timeVar, c.deltatVar, c.nodeCoordVar)
		if (c.dumpIr)
			createAndSaveResource(irModule, projectDir, c.name)
		val msgEnd = "... ok\n"
		traceListeners.forEach[write(msgEnd)]
		modelChangedListeners.forEach[modelChanged(irModule)]
		fireModel(c, irModule)
	}

	private def dispatch void launchComponent(Ir2IrComponent c, IrModule irModule)
	{
		if (!c.disabled)
		{
			val step = IrTransformationStepProvider::get(c)
			val msg = '  IR -> IR - ' + c.name + ': ' + step.description
			traceListeners.forEach[write(msg)]
			val ok = step.transform(irModule)
			if (c.dumpIr)
				createAndSaveResource(irModule, projectDir, c.name)
			if (ok)
			{
				val msgEnd = "... ok\n"
				traceListeners.forEach[write(msgEnd)]
				modelChangedListeners.forEach[modelChanged(irModule)]
			}
			else
			{
				val exceptionMsg = '... ko\n*** Error in IR transformation step\n'
				traceListeners.forEach[write(exceptionMsg)]
				for (trace : step.outputTraces)
				{
					traceListeners.forEach[write(trace + '\n')]
				}
				return
			}
		}
		fireModel(c, irModule)
	}
		
	private def dispatch void launchComponent(Ir2CodeComponent c, IrModule irModule)
	{
		if (!c.disabled)
		{
			val baseDir =  projectDir + "/.."
			val g = CodeGeneratorProvider::get(c, baseDir)
			val msg = "  " + g.name + " code generator\n"
			traceListeners.forEach[write(msg)]
			val outputFolderName = baseDir + c.outputDir
			val outputFolder = new File(outputFolderName)
			if (!outputFolder.exists || !(outputFolder.isDirectory))
			{
				val exceptionMsg = '   ** Invalid outputDir: ' + c.outputDir + '\n'
				traceListeners.forEach[write(exceptionMsg)]
				//throw new RuntimeException(exceptionMsg)
				return
			}
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
					val msg2 = "    Generating '" + fullFileName
					traceListeners.forEach[write(msg2)]	
					fsa.generateFile(fullFileName, fileContent)
					val msgEnd = "... ok\n"
					traceListeners.forEach[write(msgEnd)]	
				}
			}
		}
	}

	private def createAndSaveResource(IrModule irModule, String projectAbsolutePath, String fileExtensionPart)
	{
		val fileName = irModule.name.toLowerCase + '/' + irModule.name + '.' +  fileExtensionPart + '.' + IrExtension
		val fsa = getConfiguredFileSystemAccess(projectAbsolutePath, true)

		val uri =  fsa.getURI(fileName)
		val rSet = new ResourceSetImpl
		rSet.resourceFactoryRegistry.extensionToFactoryMap.put(IrExtension, new XMIResourceFactoryImpl) 

		val resource = rSet.createResource(uri)
		resource.contents += irModule
		resource.save(xmlSaveOptions)
	}

	private	def getXmlSaveOptions()
	{
		val builder = SaveOptions::newBuilder
		builder.format
		val so = builder.options.toOptionsMap
		so.put(XMLResource::OPTION_LINE_WIDTH, 160)
		return so
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
	 * Execute next workflow step(s)
	 * For n steps, the model is cloned n-1 times to avoid conflicts.
	 * Caution: clones must be done before continuing the workflow
	 * to keep consistent for the following steps.
	 */
	private def fireModel(WorkflowComponent it, IrModule model)
	{
		val nextComponents = nexts
		switch (nextComponents.size)
		{
			case 0: return
			case 1: nextComponents.head.launchComponent(model)
			default: nextComponents.forEach[c | c.launchComponent(EcoreUtil::copy(model))]
		}
	}
}

interface IWorkflowTraceListener 
{
	def void write(String message)
}

interface IWorkflowModelChangedListener
{
	def void modelChanged(IrModule module)
}
