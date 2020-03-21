package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.ItemId
import fr.cea.nabla.nabla.Item
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.MultipleConnectivity
import fr.cea.nabla.nabla.SpaceIterator
import java.util.List

import static extension fr.cea.nabla.ConnectivityCallExtensions.*

@Singleton
class IrItemIndexFactory
{
	@Inject extension IrConnectivityCallFactory
	@Inject extension IrIterationBlockFactory

	def toIrIndex(IndexInfo info)
	{
		createItemIndex(info.name, info.itemRef.target)
	}

	def toIrIndex(SpaceIterator si)
	{
		val name = si.item.name + si.container.uniqueName.toFirstUpper
		createItemIndex(name, si.item)
	}

	def toIrIndexValue(SpaceIterator si)
	{
		createItemIndexValueIterator(si)
	}

	def toIrIndexValue(IndexInfo info, ItemId id)
	{
		createItemIndexValueId(id, info.container, info.args)
	}

	private def create IrFactory::eINSTANCE.createItemIndex createItemIndex(String indexName, Item item)
	{
		name = indexName
		itemName = item.name
	}

	private def create IrFactory::eINSTANCE.createItemIndexValueIterator createItemIndexValueIterator(SpaceIterator si)
	{
		iterator = si.toIrIterator
	}

	private def create IrFactory::eINSTANCE.createItemIndexValueId createItemIndexValueId(ItemId _id, MultipleConnectivity _container, List<ItemRef> _args)
	{
		id = _id
		container = toIrConnectivityCall(_container, _args)
	}
}