/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.SpaceIteratorExtensions
import fr.cea.nabla.ir.ir.IrAnnotation
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.ItemId
import fr.cea.nabla.ir.ir.ItemIdDefinition
import fr.cea.nabla.ir.ir.ItemIdValue
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.Iterable
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef
import java.util.ArrayList
import org.eclipse.xtext.EcoreUtil2

import static extension fr.cea.nabla.SpaceIteratorRefExtensions.*

@Singleton
class IrItemIdDefinitionFactory
{
	@Inject extension NabLabFileAnnotationFactory
	@Inject extension SpaceIteratorExtensions
	@Inject extension IrItemIdFactory
	@Inject extension IrItemIndexFactory

	/**
	 * Return the list of needed ItemIdDefinition instructions for the SpaceIterator 'it':
	 * - either the args feature of ConnectivityCall: a ConnectivityCall arg is always an id, never an index
	 * - either an index of a VarRef different from the index of the iterator: the id 
	 *   is then used to go from the iterator index to the variable index
	 * Several ids can be necessary for a single iterator due to shifted reference (ex: X{r+1} can need rPlus1Id).
	 */
	def ArrayList<ItemIdDefinition> getNeededIdDefinitions(SpaceIterator it)
	{
		//println("[" + item.name + "] Recherche des ids")
		val neededDefinitions = new ArrayList<ItemIdDefinition>
		val iterable = EcoreUtil2::getContainerOfType(it, Iterable)
		for (referencer : iterable.eAllContents.filter(SpaceIteratorRef).filter[x | x.target == it].toIterable)
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
		//println("[" + item.name + "] Needed ids: " + neededDefinitions.map[id.name].join(', '))
		return neededDefinitions
	}

	private def addIdDefinitionIfNotExists(ArrayList<ItemIdDefinition> definitions, SpaceIteratorRef itemRef, SpaceIterator si)
	{
		val id = itemRef.toIrId 
		if (!definitions.exists[x  | x.id === id])
			definitions += toIrIdDefinition(id, itemRef.shift, si)
	}

	private def toIrIdDefinition(ItemId id, int shift, SpaceIterator si)
	{
		if (si.multiple)
			createItemIdDefinition(si.toNabLabFileAnnotation, id, toIrIdValue(si, shift))
		else
			createItemIdDefinition(si.toNabLabFileAnnotation, id, si.container.toIrIdValue)
	}

	private def create IrFactory::eINSTANCE.createItemIdDefinition createItemIdDefinition(IrAnnotation annotation, ItemId _id, ItemIdValue _value)
	{
		annotations += annotation
		id = _id
		value = _value
	}
}