package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.ItemSet

@Singleton
class IrSetDefinitionFactory
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrContainerFactory

	def create IrFactory::eINSTANCE.createSetDefinition toIrSetDefinition(ItemSet sd)
	{
			annotations += sd.toIrAnnotation
			name = sd.name
			value = sd.value.toIrConnectivityCall
	}
}