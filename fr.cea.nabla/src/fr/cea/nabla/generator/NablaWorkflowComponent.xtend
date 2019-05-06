package fr.cea.nabla.generator

import com.google.common.base.Function
import com.google.inject.Injector
import com.google.inject.Provider
import fr.cea.nabla.NablaStandaloneSetup
import fr.cea.nabla.ir.ir.IrModule
import java.util.ArrayList
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowComponent
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.IOutputConfigurationProvider
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.xtext.generator.OutputConfiguration
import org.eclipse.xtext.resource.SaveOptions

import static com.google.common.collect.Maps.*

abstract class NablaWorkflowComponent implements IWorkflowComponent
{
	static val IrExtension = 'nablair'
	
	protected val Injector injector
	protected val ResourceSet rSet
	protected IrModule model
	protected val nexts = new ArrayList<NablaWorkflowComponent>
	
	protected Provider<ResourceSet> resourceSetProvider
	
	@Accessors String outputFilePath
	@Accessors boolean active = true
	
	def setPrevious(NablaWorkflowComponent p)
	{
		p.nexts += this
	}
	
	def abstract void internalInvoke(IWorkflowContext ctx)
	override postInvoke() {}	
	override preInvoke() {}
	override invoke(IWorkflowContext ctx) 
	{ 
		if (active) 
			internalInvoke(ctx)
		fireModel
	}

	protected new()
	{
		val setup = new NablaStandaloneSetup
		injector = setup.createInjectorAndDoEMFRegistration
		rSet = new ResourceSetImpl
		rSet.resourceFactoryRegistry.extensionToFactoryMap.put(IrExtension, new XMIResourceFactoryImpl)
	}
		
	protected def getConfiguredFileSystemAccess() 
	{
		val configuredFileSystemAccess = injector.getInstance(JavaIoFileSystemAccess)
		configuredFileSystemAccess.outputConfigurations = outputConfigurations
		return configuredFileSystemAccess
	}
	
	protected def getOutputConfigurations() 
	{
		val outputConfigurationProvider = injector.getInstance(IOutputConfigurationProvider)
		val configurations = outputConfigurationProvider.outputConfigurations
		return uniqueIndex(configurations, new Function<OutputConfiguration, String>() 
		{	
			override apply(OutputConfiguration from) { return from.name }
		})
	}
	
	protected def createAndSaveResource()
	{
		if (!outputFilePath.nullOrEmpty)
		{
			//val uri = configuredFileSystemAccess.getURI(outputFileName)
			val uri = URI::createURI(outputFilePath, true)
			val resource = rSet.createResource(uri)
			resource.contents += model
			resource.save(xmlSaveOptions)
		}
	}
	
	private	def getXmlSaveOptions()
	{
		val builder = SaveOptions::newBuilder 
		builder.format
		val so = builder.options.toOptionsMap
		so.put(XMLResource::OPTION_LINE_WIDTH, 160)
		return so
	}
	
	protected def fireModel()
	{
		if (!nexts.empty)
		{
			nexts.get(0).model = model
			for(i : 1..<nexts.size) 
				nexts.get(i).model = EcoreUtil::copy(model)
		}
	}
}