/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef
import fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import java.util.TreeSet

import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*

class IteratorExtensions 
{
	static val sortByIdName = new SortByIdName
	static val sortByIndexName = new SortByIndexName

	static def String getContainerName(Iterator it)
	{
		container.connectivity.name + container.args.map[x | x.name.toFirstUpper].join('')
	}

	static def getIndexName(Iterator it)
	{
		name + containerName.toFirstUpper
	}

	/**
	 * Return the list of IteratorRef that need ids (and not indices) in the scope of 'it':
	 * - either the args feature of ConnectivityCall: a ConnectivityCall arg is 
	 *   always an id, never an index
	 * - either an index of a VarRef different from the index of the iterator: the id 
	 *   is then used to go from the iterator index to the variable index 
	 * Because two identical ids represent the same object, only one IteratorRef by id is kept.
	 */
	static def getNeededIds(Iterator it)
	{
		val neededIds = new TreeSet<IteratorRef>(sortByIdName)
		for (referencer : referencers)
		{
			switch referencer
			{
				ConnectivityCallIteratorRef : neededIds += referencer
				ArgOrVarRefIteratorRef case (referencer.indexName != indexName) : neededIds += referencer
			}	
		}
//		if (neededIds.empty)
//			println('  neededIds for ' + name + ' empty')
//		else
//			println('  neededIds for ' + name + ' : ' + neededIds.map[idName].join(', '))
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
	static def getNeededIndices(Iterator it)
	{
//		println('getIndicesToDefine for: ' + name + ' - ' + indexName)

		// Only one instance with the same index name.
		val neededIndices = new TreeSet<ArgOrVarRefIteratorRef>(sortByIndexName)

		// get all variable indices of the context
		val allIndices = new TreeSet<ArgOrVarRefIteratorRef>(sortByIndexName)
		val iterableInstruction = eContainer.eContainer as IterableInstruction
		iterableInstruction.eAllContents.filter(ArgOrVarRefIteratorRef).forEach[x | allIndices += x]
//		println('  allIndices: ' + allIndices.map[indexName].join(', '))

		// get all inner iterators i.e. not yet defined iterators
		val innerIterators = iterableInstruction.eAllContents.filter(Iterator).filter[x | x!==it].toList
//		println('  innerIterators: ' + innerIterators.map[indexName].join(', '))

		for (index : allIndices)
		{
//			println('  - index ' + index.indexName)
			// if iterator index and index are identical, nothing to do
			if (index.indexName != indexName)
			{
				val directReference = index.target
//				println('    directReference: ' + directReference.name)

				val indexIndirectReferences = index.varArgs.map[target]
//				println('    indexIndirectReferences: ' + indexIndirectReferences.map[name].join(', '))

				// if the iterator 'it' is referenced by the index
				if (directReference===it || indexIndirectReferences.contains(it))
					// if all iterators are defined
					if (! (innerIterators.contains(directReference) || indexIndirectReferences.exists[x | innerIterators.contains(x)]))
						neededIndices += index
			}
		}

//		if (neededIndices.empty)
//			println('  neededIndices for ' + name + ' empty')
//		else
//			println('  neededIndices for ' + name + ' : ' + neededIndices.map[indexName].join(', '))
		return neededIndices
	}
}

