package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.ItemIndex
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.ItemIndexValueId
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

	/** 
	 * Return the list of indices to declare in the scope of 'it' iterator.
	 * 
	 * An index must be declare when :
	 * - it references the 'it' iterator directly or indirectly (see below)
	 * - all iterator referenced by the index are defined (because they
	 *   are necessary to obtain the value of the index)
	 * 
	 * What means directly/indirectly: an iterator can be referenced :
	 * - directly via the 'target' feature reference 
	 * - indirectly via the return of indirectIteratorReferences operation.
	 */
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

	private def createIndexDefinitions(Item item, (String)=>boolean indexExists)
	{
		//println("[" + item.name + "] Recherche des indices")
		// Only one instance with the same index name.
		val neededDefinitions = new ArrayList<ItemIndexDefinition>

		// get all variable iterators of the context
		val module = EcoreUtil2::getContainerOfType(item, NablaModule)
		val allVarRefIterators = module.eAllContents.filter(ItemRef).filter[x | x.eContainer instanceof ArgOrVarRef].toSet

		// get all inner items i.e. not yet defined items
		//val undefinedItems = module.eAllContents.filter(Item).filter[x | x !== item].toList

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
				val directReference = varRefInfo.itemRef.target
				//println("  [" + item.name + "] directReference " + directReference.name)
				val indexIndirectReferences = varRefInfo.args.map[target]
				//println("  [" + item.name + "] indexIndirectReferences " + indexIndirectReferences.map[name].join(', '))

				// if the iterator 'it' is referenced by the index
				if (directReference===item || indexIndirectReferences.contains(item))
				{
					// if all iterators are defined
					if (definedItems.contains(directReference) && indexIndirectReferences.forall[x | definedItems.contains(x)])
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

	private def create IrFactory::eINSTANCE.createItemIndexDefinition createItemIndexDefinition(ItemIndex _index, ItemIndexValueId _value)
	{
		index = _index
		value = _value
		//println("createItemIndexDefinition(" + index.name + " = indexOf " + value.id.name + " in " + value.container + ")")
	}
}