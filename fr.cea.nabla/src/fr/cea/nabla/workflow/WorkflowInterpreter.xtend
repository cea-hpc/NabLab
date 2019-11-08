package fr.cea.nabla.workflow

import com.google.common.base.Function
import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.generator.ir.Nabla2Ir
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablagen.Ir2CodeComponent
import fr.cea.nabla.nablagen.Ir2IrComponent
import fr.cea.nabla.nablagen.Nabla2IrComponent
import fr.cea.nabla.nablagen.Workflow
import fr.cea.nabla.nablagen.WorkflowComponent
import java.net.URI
import java.util.ArrayList
import org.apache.log4j.Logger
import org.eclipse.core.resources.IContainer
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IResource
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
import static extension fr.cea.nabla.workflow.WorkflowExtensions.*

class WorkflowInterpreter 
{
	static val IrExtension = 'nablair'
	static val logger = Logger.getLogger(WorkflowInterpreter)
	val traceListeners = new ArrayList<IWorkflowTraceListener>
	val modelChangedListeners = new ArrayList<IWorkflowModelChangedListener>
	@Inject Provider<JavaIoFileSystemAccess> fsaProvider
	@Inject Nabla2Ir nabla2Ir
	@Inject IOutputConfigurationProvider outputConfigurationProvider
	
	def launch(Workflow workflow)
	{	
		try
		{
			val msg = 'STARTING ' + workflow.name + '\n'
			logger.info(msg)
			traceListeners.forEach[write(msg)]
			workflow.roots.forEach[c | launch(c, workflow.nablaModule)]	
		}
		catch(Exception e)
		{
			val msgheader = '\n***' + e.class.name + ': ' + e.message + '\n'
			logger.info(msgheader)
			traceListeners.forEach[write(msgheader)]
			if (e.stackTrace !== null && !e.stackTrace.empty)
			{
				val stack = e.stackTrace.head
				val msg = 'at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')\n'
				logger.info(msg)
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
	
	private def dispatch void launch(Nabla2IrComponent c, NablaModule nablaModule)
	{
		val msg = '  Nabla -> IR - ' + c.name
		logger.info(msg)
		traceListeners.forEach[write(msg)]
		val irModule = nabla2Ir.toIrModule(nablaModule)
		if (c.dumpIr)
			createAndSaveResource(irModule, c.eclipseProject, c.name)
		val msgEnd = "... ok\n"
		logger.info(msgEnd)
		traceListeners.forEach[write(msgEnd)]
		modelChangedListeners.forEach[modelChanged(irModule)]
		fireModel(c, irModule)
	}

	private def dispatch void launch(Ir2IrComponent c, IrModule irModule)
	{
		if (!c.disabled)
		{
			val step = IrTransformationStepProvider::get(c)
			val msg = '  IR -> IR - ' + c.name + ': ' + step.description
			logger.info(msg)
			traceListeners.forEach[write(msg)]
			val ok = step.transform(irModule)
			if (c.dumpIr)
				createAndSaveResource(irModule, c.eclipseProject, c.name)
			if (ok)
			{
				val msgEnd = "... ok\n"
				logger.info(msgEnd)
				traceListeners.forEach[write(msgEnd)]
				modelChangedListeners.forEach[modelChanged(irModule)]
			}
			else
			{
				val exceptionMsg = '... ko\n*** Error in IR transformation step\n'
				logger.info(exceptionMsg)
				traceListeners.forEach[write(exceptionMsg)]
				for (trace : step.outputTraces)
				{
					logger.info(trace + '\n')
					traceListeners.forEach[write(trace + '\n')]
				}
				return
			}
		}
		fireModel(c, irModule)
	}
		
	private def dispatch void launch(Ir2CodeComponent c, IrModule irModule)
	{
		if (!c.disabled)
		{
			val g = CodeGeneratorProvider::get(c)
			val fileName = irModule.name.toLowerCase + '/' + irModule.name + '.' + g.fileExtension
			val msg = "  Generating '" + fileName + "' file"
			logger.info(msg)
			traceListeners.forEach[write(msg)]
			val fileContent = g.getFileContent(irModule)
			val outputFolder = c.eclipseProject.workspace.root.findMember(c.outputDir) 
			if (outputFolder === null || !(outputFolder instanceof IContainer) || !outputFolder.exists)
			{
				val exceptionMsg = '   ** Invalid outputDir: ' + c.outputDir + '\n'
				logger.info(exceptionMsg)
				traceListeners.forEach[write(exceptionMsg)]
				//throw new RuntimeException(exceptionMsg)
				return
			}
			else
			{
				val fsa = getConfiguredFileSystemAccess(outputFolder.location.toString, false)
				fsa.generateFile(fileName, fileContent)
				outputFolder.refreshLocal(IResource::DEPTH_INFINITE, null)
				val msgEnd = "... ok\n"
				logger.info(msgEnd)
				traceListeners.forEach[write(msgEnd)]	
			}
		}
	}
		
	private def createAndSaveResource(IrModule irModule, IProject project, String fileExtensionPart)
	{
		val fileName = irModule.name.toLowerCase + '/' + irModule.name + '.' +  fileExtensionPart + '.' + IrExtension
		val fsa = getConfiguredFileSystemAccess(project.location.toString, true)
		
		val uri =  fsa.getURI(fileName)		
		val rSet = new ResourceSetImpl
		rSet.resourceFactoryRegistry.extensionToFactoryMap.put(IrExtension, new XMIResourceFactoryImpl) 
		
		val resource = rSet.createResource(uri)
		resource.contents += irModule
		resource.save(xmlSaveOptions)
		refreshResourceDir(project, uri.toString)
	}
	
	/** Refresh du répertoire s'il est contenu dans la resource (évite le F5) */
	private static def refreshResourceDir(IProject p, String fileAbsolutePath)
	{
		val uri = URI::create(fileAbsolutePath)
		val files = p.workspace.root.findFilesForLocationURI(uri)
		if (files !== null && files.size == 1) files.head.parent.refreshLocal(IResource::DEPTH_INFINITE, null)
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
	 * For n steps, the model is duplicated n-1 times to avoid conflicts
	 */
	private def fireModel(WorkflowComponent it, IrModule model)
	{
		val nextComponents = nexts
		if (!nextComponents.empty)
		{
			nextComponents.get(0).launch(model)
			for(i : 1..<nextComponents.size) 
				nextComponents.get(i).launch(EcoreUtil::copy(model))
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
