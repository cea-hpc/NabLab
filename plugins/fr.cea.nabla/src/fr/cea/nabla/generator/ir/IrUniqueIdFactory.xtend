package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef

import static extension fr.cea.nabla.generator.ir.SpaceIteratorRefExtensions.*

@Singleton
class IrUniqueIdFactory
{
	@Inject extension IrIteratorFactory

	def toIrUniqueId(SpaceIteratorRef it)
	{
		val id = toIrUniqueId(name, target)
		if (dec > 0) id.shift = -dec
		else if (inc > 0) id.shift = inc
		return id
	}

	// The primary key of the unique identifier is a pair (indexName, iterator)
	private def create IrFactory::eINSTANCE.createIrUniqueId toIrUniqueId(String nameWithoutId, SpaceIterator si)
	{
		name = nameWithoutId + 'Id'
		iterator = si.toIrIterator
	}
}