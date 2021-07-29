package fr.cea.nabla.ir.annotations

import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrAnnotation
import fr.cea.nabla.ir.ir.IrFactory
import org.eclipse.xtend.lib.annotations.Accessors

class NabLabFileAnnotation
{
	static val ANNOTATION_SOURCE = NabLabFileAnnotation.name
	static val ANNOTATION_URI_DETAIL = "uri"
	static val ANNOTATION_OFFSET_DETAIL = "offset"
	static val ANNOTATION_LENGTH_DETAIL = "length"

	@Accessors val IrAnnotation irAnnotation

	static def get(IrAnnotable object)
	{
		val o = object.annotations.findFirst[x | x.source == ANNOTATION_SOURCE]
		if (o === null) null
		else new NabLabFileAnnotation(o)
	}

	static def create(String uri, int offset, int length)
	{
		val o = IrFactory::eINSTANCE.createIrAnnotation => 
		[
			source = ANNOTATION_SOURCE
			details.put(ANNOTATION_URI_DETAIL, uri)
			details.put(ANNOTATION_OFFSET_DETAIL, offset.toString)
			details.put(ANNOTATION_LENGTH_DETAIL, length.toString)
		]
		return new NabLabFileAnnotation(o)
	}

	def getUri()
	{
		irAnnotation.details.get(ANNOTATION_URI_DETAIL)
	}

	def int getOffset()
	{
		Integer::parseInt(irAnnotation.details.get(ANNOTATION_OFFSET_DETAIL))
	}

	def int getLength()
	{
		Integer::parseInt(irAnnotation.details.get(ANNOTATION_LENGTH_DETAIL))
	}

	private new(IrAnnotation irAnnotation)
	{
		this.irAnnotation = irAnnotation
	}
}