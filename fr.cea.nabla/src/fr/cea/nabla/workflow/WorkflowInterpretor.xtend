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
import org.apache.log4j.Logger
import org.eclipse.core.resources.IFolder
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

class WorkflowInterpretor 
{
	static val IrExtension = 'nablair'
	static val logger = Logger.getLogger(WorkflowInterpretor);
	@Inject Provider<JavaIoFileSystemAccess> fsaProvider
	@Inject Provider<Nabla2Ir> nabla2IrProvider
	@Inject IOutputConfigurationProvider outputConfigurationProvider
	
	def launch(Workflow workflow)
	{		
		workflow.roots.forEach[c | launch(c, workflow.nablaModule)]
	}
	
	private def dispatch void launch(Nabla2IrComponent c, NablaModule nablaModule)
	{
		if (!nablaModule.jobs.empty)
		{
			logger.info('Nabla -> IR - ' + c.name)	
			val nabla2ir = nabla2IrProvider.get
			val irModule = nabla2ir.toIrModule(nablaModule)
			if (c.dumpIr)
				createAndSaveResource(irModule, c.eclipseProject, c.name)
			fireModel(c, irModule)			
		}
	}
		
	private def dispatch void launch(Ir2IrComponent c, IrModule irModule)
	{
		if (!c.disabled)
		{
			logger.info('IR -> IR - ' + c.name + ': ' )
			val step = IrTransformationStepProvider::get(c)
			val ok = step.transform(irModule)
			if (c.dumpIr)
				createAndSaveResource(irModule, c.eclipseProject, c.name)
			if (!ok)
				throw new RuntimeException("Error in IR transformation step")			
		}
		fireModel(c, irModule)
	}
		
	private def dispatch void launch(Ir2CodeComponent c, IrModule irModule)
	{
		if (!c.disabled)
		{
			val g = CodeGeneratorProvider::get(c)
			val fileName = irModule.name.toLowerCase + '/' + irModule.name + '.' + g.fileExtension
			logger.info("Generating '" + fileName + "' file")
			val fileContent = g.getFileContent(irModule)
			val outputFolder = c.eclipseProject.workspace.root.findMember(c.outputDir) 
			if (outputFolder === null || !(outputFolder instanceof IFolder) || !outputFolder.exists)
				throw new RuntimeException("Invalid outputDir " + c.outputDir)
			val fsa = getConfiguredFileSystemAccess(outputFolder.rawLocation.toString, false)
			fsa.generateFile(fileName, fileContent)
			(outputFolder as IFolder).refreshLocal(IResource::DEPTH_INFINITE, null)
		}
	}
		
	private def createAndSaveResource(IrModule irModule, IProject project, String fileExtensionPart)
	{
		val fileName = irModule.name.toLowerCase + '/' + irModule.name + '.' +  fileExtensionPart + '.' + IrExtension
		val fsa = getConfiguredFileSystemAccess(project.rawLocation.toString, true)
		
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