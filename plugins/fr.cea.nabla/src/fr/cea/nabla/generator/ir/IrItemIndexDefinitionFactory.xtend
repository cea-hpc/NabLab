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
import fr.cea.nabla.ir.ir.ItemIndex
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.ItemIndexValue
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.Item
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.SpaceIterator
import java.util.ArrayList
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.IScopeProvider

@Singleton
class IrItemIndexDefinitionFactory
{
	@Inject extension IrItemIdFactory
	@Inject extension IrItemIndexFactory
	@Inject IScopeProvider scopeProvider

	def getNeededIndexDefinitions(SpaceIterator si)
	{
		val indexExists = [String indexName | si.toIrIndex.name == indexName]
		createIndexDefinitions(si.item, indexExists)
	}

	def getNeededIndexDefinitions(Item item)
	{
		val indexExists = [String indexName | false]
		createIndexDefinitions(item, indexExists)
	}

	/**
	 * Return the list of needed ItemIndexDefinition instructions for 'item'.
	 *
	 * An index must be declare when an ItemRef instance references 'item',
	 * - directly, for instance rNodes in ∀r∈nodes(), X{nodes}.
	 * - by its arguments, for instance : ∀r∈nodes(), ∀j∈cellsOfNode(r), Cjr{j,r}
	 *   rNodesOfCellJ can not be created after r iterator declaration because
	 *   its value depends of j which is not yet defined. Consequently, rNodesOfCellJ
	 *   has to be defined when j is declared because the arguments needed to get
	 *   its value depends on j, i.e. rNodesOfCellJ = mesh.getNodesOfCell(jId).
	 *
	 * The indexExists lambda is used when createIndexDefinitions is called from iterator.
	 * For instance, in ∀r∈nodes(), X{nodes}, rNodes index is needed because
	 * it is referenced by X but rNodes is automatically created by r iterator.
	 * indexExists will then return true to prevent from creating the index two times.
	 */
	private def createIndexDefinitions(Item item, (String)=>boolean indexExists)
	{
		//println("[" + item.name + "] Recherche des indices")
		// Only one instance with the same index name.
		val neededDefinitions = new ArrayList<ItemIndexDefinition>

		// get all variable iterators of the context
		val module = EcoreUtil2::getContainerOfType(item, NablaModule)
		val allVarRefIterators = module.eAllContents.filter(ItemRef).filter[x | x.eContainer instanceof ArgOrVarRef].toSet

		val scope = scopeProvider.getScope(item, NablaPackage.Literals.ITEM_REF__TARGET)
		val definedItems = new ArrayList<Item>
		definedItems += item
		definedItems += scope.allElements.map[EObjectOrProxy as Item]
		//println("  [" + item.name + "] definedItems " + definedItems.map[name].join(', '))

		for (varRefIterator : allVarRefIterators)
		{
			// if iterator index and index are identical, nothing to do
			val varRef = varRefIterator.eContainer as ArgOrVarRef
			val varRefInfo = new IndexInfo(varRef, varRefIterator)
			//println("  [" + item.name + "] varRefInfo " + varRefInfo.name)

			//println("[" + item.name + "] indexExists " + indexExists.apply(varRefInfo.name))
			if (!indexExists.apply(varRefInfo.name))
			{
				//println("  [" + item.name + "] directReference " + directReference.name)
				val argReferences = varRefInfo.args.map[target]
				//println("  [" + item.name + "] indexIndirectReferences " + indexIndirectReferences.map[name].join(', '))

				// if the iterator 'it' is referenced by the index
				if (varRefIterator.target===item || argReferences.contains(item))
				{
					// if all iterators are defined
					if (definedItems.contains(varRefIterator.target) && argReferences.forall[x | definedItems.contains(x)])
						addIndexDefinitionIfNotExists(neededDefinitions, varRefInfo)
				}
			}
		}
		//println("[" + item.name + "] Needed indices: " + neededDefinitions.map[index.name].join(', '))
		return neededDefinitions
	}

	private def addIndexDefinitionIfNotExists(ArrayList<ItemIndexDefinition> definitions, IndexInfo info)
	{
		val index = info.toIrIndex
		if (!definitions.exists[x  | x.index === index])
			definitions += toIrIndexDefinition(index, info)
	}

	private def toIrIndexDefinition(ItemIndex index, IndexInfo info)
	{
		val id = info.itemRef.toIrId
		val value = toIrIndexValue(info, id)
		createItemIndexDefinition(index, value)
	}

	private def create IrFactory::eINSTANCE.createItemIndexDefinition createItemIndexDefinition(ItemIndex _index, ItemIndexValue _value)
	{
		index = _index
		value = _value
		//println("createItemIndexDefinition(" + index.name + " = indexOf " + value.id.name + " in " + value.container + ")")
	}
}