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

	def toIrIndex(SpaceIterator si)
	{
		val containerName = si.container.connectivity.name + si.container.args.map[x | x.name.toFirstUpper].join('')
		val index = toIrIndex(si.name + containerName.toFirstUpper, si)
		index.container = toIrNewConnectivityCall(index, si.container.connectivity, si.container.args)
		return index
	}

	def toIrIndex(IndexInfo info)
	{
		val index = toIrIndex(info.name, info.iteratorRef.target)
		index.container = toIrNewConnectivityCall(index, info.container, info.args)
		return index
	}

	// The primary key of the index is a pair (indexName, iterator)
	private def create IrFactory::eINSTANCE.createIrIndex toIrIndex(String indexName, SpaceIterator si)
	{
		name = indexName
		iterator = si.toIrIterator
	}
}