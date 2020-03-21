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
import fr.cea.nabla.ir.ir.ItemIdDefinition
import fr.cea.nabla.ir.ir.ItemIdValueIterator
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ItemDefinition
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.Iterable
import fr.cea.nabla.nabla.SingletonDefinition
import fr.cea.nabla.nabla.SpaceIterator
import java.util.ArrayList
import org.eclipse.xtext.EcoreUtil2

import static extension fr.cea.nabla.ItemRefExtensions.*

@Singleton
class IrItemIdDefinitionFactory
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrItemIdFactory
	@Inject extension IrItemIndexFactory

	/**
	 * Return the list of needed ids (and not indices) in the scope of 'it':
	 * - either the args feature of ConnectivityCall: a ConnectivityCall arg is always an id, never an index
	 * - either an index of a VarRef different from the index of the iterator: the id 
	 *   is then used to go from the iterator index to the variable index 
	 * Because two identical ids represent the same object, only one IteratorRef by id is kept.
	 */
	def getNeededIdDefinitions(SpaceIterator it)
	{
		println("[" + item.name + "] Recherche des ids")
		val neededDefinitions = new ArrayList<ItemIdDefinition>
		val iterable = EcoreUtil2::getContainerOfType(it, Iterable)
		for (referencer : iterable.eAllContents.filter(ItemRef).filter[x | x.target == item].toIterable)
		{
			val c = referencer.eContainer
			//println("[" + item.name + "] referencer : " + referencer + " - " + c)
			switch c
			{
				ConnectivityCall: addIdDefinitionIfNotExists(neededDefinitions, referencer, it)
				ArgOrVarRef:
				{
					val info = new IndexInfo(c, referencer)
					//println('  ' + info.name + " - " + toIrIndex.name + " - " + (info.name != toIrIndex.name))
					if (info.name != toIrIndex.name) addIdDefinitionIfNotExists(neededDefinitions, referencer, it)
				}
			}
		}
		println("[" + item.name + "] Needed ids: " + neededDefinitions.map[id.name].join(', '))
		return neededDefinitions
	}

	def create IrFactory::eINSTANCE.createItemIdDefinition toIrIdDefinition(SingletonDefinition d)
	{
		annotations += d.toIrAnnotation
		id = d.item.toIrId
		value = d.value.toIrIdValue
	}

	def create IrFactory::eINSTANCE.createItemIdDefinition toIrIdDefinition(ItemDefinition d)
	{
		annotations += d.toIrAnnotation
		id = d.item.toIrId
		value = d.value.toIrIdValue
	}

	private def addIdDefinitionIfNotExists(ArrayList<ItemIdDefinition> definitions, ItemRef itemRef, SpaceIterator si)
	{
		val id = itemRef.toIrId 
		if (!definitions.exists[x  | x.id === id])
			definitions += toIrIdDefinition(id, itemRef.shift, si)
	}

	private def toIrIdDefinition(ItemId id, int shift, SpaceIterator si)
	{
		val value = toIrIdValue(si, shift)
		createItemIdDefinition(id, value)
	}

	private def create IrFactory::eINSTANCE.createItemIdDefinition createItemIdDefinition(ItemId _id, ItemIdValueIterator _value)
	{
		id = _id
		value = _value
	}
}