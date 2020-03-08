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
import fr.cea.nabla.ir.ir.IrIndex
import fr.cea.nabla.ir.ir.IrUniqueId
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.Iterable
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef
import java.util.TreeSet
import org.eclipse.xtext.EcoreUtil2

class SpaceIteratorExtensions 
{
	@Inject extension IrUniqueIdFactory
	@Inject extension IrIndexFactory

	/**
	 * Return the list of needed ids (and not indices) in the scope of 'it':
	 * - either the args feature of ConnectivityCall: a ConnectivityCall arg is always an id, never an index
	 * - either an index of a VarRef different from the index of the iterator: the id 
	 *   is then used to go from the iterator index to the variable index 
	 * Because two identical ids represent the same object, only one IteratorRef by id is kept.
	 */
	def createNeededIds(SpaceIterator it)
	{
		val index = toIrIndex
		println("Recherche des ids pour l'itérateur " + name + " - " + index.name)
		val neededIds = new TreeSet<IrUniqueId>([a, b| a.name.compareTo(b.name)])
		val iterable = EcoreUtil2::getContainerOfType(it, Iterable)
		for (referencer : iterable.eAllContents.filter(SpaceIteratorRef).filter[x | x.target.name == name].toIterable)
		{
			val c = referencer.eContainer
			println("  referencer: " + referencer.target.name + " - container:" + c)
//			println("  " + toIrIndex(new IndexInfo(c, referencer)).name + " !== " + index.name + " - " + (referencer.target.toIrIndex !== index))
			switch c
			{
				ConnectivityCall: 
					neededIds += (referencer.toIrUniqueId => [defaultValueIndex = index])
				ArgOrVarRef case (toIrIndex(new IndexInfo(c, referencer)) !== index): 
					neededIds += (referencer.toIrUniqueId => [defaultValueIndex = index])
			}
		}
		println("Needed ids: " + neededIds.map[name + '(' + defaultValueIndex + ')'].join(', '))
		return neededIds
	}

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
	def createNeededIndices(SpaceIterator it)
	{
		// Only one instance with the same index name.
		val sorter = [IrIndex a, IrIndex b| a.name.compareTo(b.name)]
		val neededIndices = new TreeSet<IrIndex>(sorter)

		// get all variable iterators of the context
		val iterable = EcoreUtil2::getContainerOfType(it, Iterable)
		val allVarRefIterators = iterable.eAllContents.filter(SpaceIteratorRef).filter[x | x.eContainer instanceof ArgOrVarRef].toSet

		// get all inner iterators i.e. not yet defined iterators
		val undefinedIterators = iterable.eAllContents.filter(SpaceIterator).filter[x | x!==it].toList
//		println('  innerIterators: ' + innerIterators.map[indexName].join(', '))

		val spaceIteratorIndex = toIrIndex
		for (varRefIterator : allVarRefIterators)
		{
//			println('  - index ' + index.indexName)
			// if iterator index and index are identical, nothing to do
			val varRef = varRefIterator.eContainer as ArgOrVarRef
			val varRefIndexInfo = new IndexInfo(varRef, varRefIterator)
			val varRefIndex = toIrIndex(varRefIndexInfo)
			varRefIndex.defaultValueId = toIrUniqueId(varRefIterator)

			if (spaceIteratorIndex != varRefIndex)
			{
				val directReference = varRefIndexInfo.directIterator
//				println('    directReference: ' + directReference.name)

				val indexIndirectReferences = varRefIndexInfo.varRefArgsIterator
//				println('    indexIndirectReferences: ' + indexIndirectReferences.map[name].join(', '))

				// if the iterator 'it' is referenced by the index
				if (directReference===it || indexIndirectReferences.contains(it))
					// if all iterators are defined
					if (! (undefinedIterators.contains(directReference) || indexIndirectReferences.exists[x | undefinedIterators.contains(x)]))
						neededIndices += varRefIndex
			}
		}
		println("Needed indices: " + neededIndices.map[name + '(' + defaultValueId + ')'].join(', '))
		return neededIndices
	}
}

