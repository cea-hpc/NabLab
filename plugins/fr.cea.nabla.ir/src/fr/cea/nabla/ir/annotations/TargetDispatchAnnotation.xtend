package fr.cea.nabla.ir.annotations

import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrAnnotation
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Job
import org.eclipse.xtend.lib.annotations.Accessors

class TargetDispatchAnnotation
{
	static val ANNOTATION_SOURCE = TargetDispatchAnnotation.name
	static val ANNOTATION_TARGET_TYPE_DETAIL = "target-type"

	@Accessors val IrAnnotation irAnnotation

	static def get(Job object) { _get(object) }
	static def get(Expression object) { _get(object) }
	static def get(Instruction object) { _get(object) }
	
	static def del(IrAnnotable object)
	{
		object.annotations.removeIf[ x | x.source == ANNOTATION_SOURCE ]
	}

	static def create(TargetType targetType)
	{
		val o = IrFactory::eINSTANCE.createIrAnnotation => 
		[
			source = ANNOTATION_SOURCE
			details.put(ANNOTATION_TARGET_TYPE_DETAIL, targetType.toString)
		]
		return new TargetDispatchAnnotation(o)
	}

	def getTargetType()
	{
		TargetType.valueOf(irAnnotation.details.get(ANNOTATION_TARGET_TYPE_DETAIL))
	}

	private static def _get(IrAnnotable object)
	{
		val o = object.annotations.findFirst[x | x.source == ANNOTATION_SOURCE]
		if (o === null) null
		else new TargetDispatchAnnotation(o)
	}

	private new(IrAnnotation irAnnotation)
	{
		this.irAnnotation = irAnnotation
	}
}