package fr.cea.nabla.generator

import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.xtext.resource.SaveOptions

class GeneratorUtils 
{
	def getXmlSaveOptions()
	{
		val builder = SaveOptions::newBuilder 
		builder.format
		val so = builder.options.toOptionsMap
		so.put(XMLResource::OPTION_LINE_WIDTH, 160)
		return so
	}
}