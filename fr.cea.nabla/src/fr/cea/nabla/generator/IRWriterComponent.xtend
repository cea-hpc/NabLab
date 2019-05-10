package fr.cea.nabla.generator

import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.resource.SaveOptions
import org.eclipse.emf.mwe2.runtime.Mandatory

abstract class IRWriterComponent extends NablaWorkflowComponent 
{	
	static val IrExtension = 'nablair'
	@Accessors boolean writeModel = false
	@Accessors(PUBLIC_GETTER) String id
	protected val ResourceSet rSet
	
	new()
	{
		rSet = new ResourceSetImpl
		rSet.resourceFactoryRegistry.extensionToFactoryMap.put(IrExtension, new XMIResourceFactoryImpl) 
	}
	
	@Mandatory def setId(String value) { id = value }
	
	protected def createAndSaveResource()
	{
		if (writeModel)
		{
			val fileName = model.name.toLowerCase + '/' + model.name + '.' + id + '.' + IrExtension
			val uri =  configuredFileSystemAccess.getURI(fileName)
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
}