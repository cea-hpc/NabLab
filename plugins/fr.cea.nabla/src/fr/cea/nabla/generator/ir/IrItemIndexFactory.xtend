/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.ItemId
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.Item
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.MultipleConnectivity
import fr.cea.nabla.nabla.SetRef
import fr.cea.nabla.nabla.SpaceIterator
import java.util.List

import static extension fr.cea.nabla.UniqueNameHelper.*

@Singleton
class IrItemIndexFactory
{
	@Inject extension IrContainerFactory

	def toIrIndex(IndexInfo info)
	{
		createItemIndex(info.name, info.itemRef.target, info.dependentItems)
	}

	def toIrIndex(SpaceIterator si)
	{
		val name = si.item.name + si.container.uniqueName.toFirstUpper
		createItemIndex(name, si.item, si.container.dependentItems)
	}

	def toIrIndexValue(IndexInfo info, ItemId id)
	{
		createItemIndexValue(id, info.container, info.args)
	}

	/**
	 * The 3 arguments of this method compose the primary key of the index.
	 * Dependant items are needed. In the following example:
	 * computeGradients: ∀c∈cells(), {
	 *    gradpi{c} = ∑{p∈nodesOfCell(c)}(Fi{p,c});
	 *    gradpe{c} = ∑{p∈nodesOfCell(c)}(Fe{p,c});
	 * }
	 * If Fi and Fe are defined {nodes, cellsOfNode}, the two reductions
	 * need an index cCellsOfNodeP on the same item c. But it is not the
	 * same index because it is not the same p node. The p node need to be 
	 * send during the creation of the index. Then Xtend creates the
	 * index.
	 */
	private def create IrFactory::eINSTANCE.createItemIndex createItemIndex(String indexName, Item item, DependentItemList dependantItems)
	{
		name = indexName
		itemName = item.name
	}

	private def create IrFactory::eINSTANCE.createItemIndexValue createItemIndexValue(ItemId _id, MultipleConnectivity _container, List<ItemRef> _args)
	{
		id = _id
		container = toIrConnectivityCall(_container, _args)
	}

	private def dispatch getDependentItems(SetRef it)
	{
		new DependentItemList(target.value.args.map[target])
	}

	private def dispatch getDependentItems(ConnectivityCall it)
	{
		new DependentItemList(args.map[target])
	}
}
