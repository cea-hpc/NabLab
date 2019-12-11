package fr.cea.nabla.generator

import com.google.common.base.Function
import com.google.inject.Injector
import com.google.inject.Provider
import fr.cea.nabla.NablaStandaloneSetup
import fr.cea.nabla.ir.ir.IrModule
import java.util.ArrayList
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowComponent
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.IOutputConfigurationProvider
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.xtext.generator.OutputConfiguration

import static com.google.common.collect.Maps.*

abstract class NablaWorkflowComponent implements IWorkflowComponent
{
	protected val Injector injector
	protected IrModule model
	protected val nexts = new ArrayList<NablaWorkflowComponent>
	
	protected Provider<ResourceSet> resourceSetProvider
	
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