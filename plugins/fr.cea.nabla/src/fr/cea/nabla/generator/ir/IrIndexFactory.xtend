package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.SpaceIterator

import static extension fr.cea.nabla.generator.ir.SpaceIteratorRefExtensions.*

@Singleton
class IrIndexFactory 
{
	@Inject extension IrIteratorFactory

	def toIrIndex(SpaceIterator it)
	{
		val containerName = container.connectivity.name + container.args.map[x | x.name.toFirstUpper].join('')
		val indexName = name + containerName.toFirstUpper
		createIrIndex(indexName, it)
	}

	def toIrIndex(IndexInfo info)
	{
		createIrIndex(info.name, info.iteratorRef.target)
	}

	// The primary key of the index is a pair (indexName, iterator)
	private def create IrFactory::eINSTANCE.createIrIndex createIrIndex(String indexName, SpaceIterator iterator)
	{
		name = indexName
		container = toIrNewConnectivityCall(iterator.container)
	}
}