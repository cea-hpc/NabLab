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
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.Item
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.SpaceIterator

import static extension fr.cea.nabla.ItemRefExtensions.*

@Singleton
class IrItemIdFactory
{
	@Inject extension IrContainerFactory
	@Inject extension IrIterationBlockFactory

	def toIrId(ItemRef itemRef)
	{
		createItemId(itemRef.name + 'Id', itemRef.target)
	}

	def toIrId(Item item)
	{
		createItemId(item.name + 'Id', item)
	}

	def toIrIdValue(ConnectivityCall call)
	{
		createItemIdValueCall(call)
	}

	def toIrIdValue(SpaceIterator iterator, int shift)
	{
		createItemIdValueIterator(iterator, shift)
	}

	private def create IrFactory::eINSTANCE.createItemId createItemId(String idName, Item item)
	{
		name = idName
		itemName = item.name
	}

	private def create IrFactory::eINSTANCE.createItemIdValueCall createItemIdValueCall(ConnectivityCall _call)
	{
		call = _call.toIrConnectivityCall
	}

	private def create IrFactory::eINSTANCE.createItemIdValueIterator createItemIdValueIterator(SpaceIterator _iterator, int _shift)
	{
		iterator = _iterator.toIrIterator
		shift = _shift
	}
}