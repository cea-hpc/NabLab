package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrIndex
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef
import java.util.List

import static extension fr.cea.nabla.generator.ir.SpaceIteratorRefExtensions.*

@Singleton
class IrIndexFactory 
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrConnectivityFactory
	@Inject extension IrUniqueIdFactory

	def toIrIndex(SpaceIterator si)
	{
		val containerName = si.container.connectivity.name + si.container.args.map[x | x.name.toFirstUpper].join('')
		val index = toIrIndex(si.name + containerName.toFirstUpper, si)
		index.container = toIrConnectivityCall(index, si.container.connectivity, si.container.args)
		return index
	}

	def toIrIndex(IndexInfo info)
	{
		val index = toIrIndex(info.name, info.iteratorRef.target)
		index.container = toIrConnectivityCall(index, info.container, info.args)
		return index
	}

	// The primary key of the index is a pair (indexName, iterator)
	private def create IrFactory::eINSTANCE.createIrIndex toIrIndex(String indexName, SpaceIterator si)
	{
		println("Creation de l'index " + indexName +" : " + it)
		name = indexName
	}

	// index as arg because it is part of the primary key
	private def create IrFactory::eINSTANCE.createConnectivityCall toIrConnectivityCall(IrIndex index, Connectivity c, List<SpaceIteratorRef> las)
	{
		annotations += c.toIrAnnotation
		connectivity = c.toIrConnectivity
		las.forEach[x | args += x.toIrUniqueId]
	}
}