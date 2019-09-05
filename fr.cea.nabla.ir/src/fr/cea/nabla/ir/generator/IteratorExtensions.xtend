package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.ConnectivityCallIteratorRef
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.VarRefIteratorRef
import java.util.TreeSet

import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*

class IteratorExtensions 
{
	static val sortById = new SortById
	static val sortByIndexName = new SortByIndexName
	
	static def String getContainerName(Iterator it)
	{
		if (container.args.empty)
			container.connectivity.name
		else
			container.connectivity.name + container.args.map[indexName.toString.toFirstUpper].join('')
	}
	
	static def getIndexName(Iterator it)
	{
		name + containerName.toFirstUpper
	}
	
	static def getId(Iterator it)
	{
		name + 'Id'
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
		val neededIds = new TreeSet<IteratorRef>(sortById)
		for (referencer : referencers)
		{
			switch referencer
			{
				ConnectivityCallIteratorRef : neededIds += referencer
				VarRefIteratorRef case (referencer.indexName != indexName) : neededIds += referencer
			}	
		}
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
	static def getIndicesToDefine(Iterator it)
	{
		//println('getIndicesToDefined for: ' + name + ' - ' + indexName)
		
		// Only one instance with the same index name.
		val indexToDefined = new TreeSet<VarRefIteratorRef>(sortByIndexName)
		
		// get all variable indices of the context
		val allIndices = new TreeSet<VarRefIteratorRef>(sortByIndexName)
		eContainer.eAllContents.filter(VarRefIteratorRef).forEach[x | allIndices += x]
		//println('  allIndices: ' + allIndices.map[indexName].join(', '))

		// get all inner iterators i.e. not yet defined iterators
		val innerIterators = eContainer.eAllContents.filter(Iterator).filter[x | x!==it].toList
		//println('  innerIterators: ' + innerIterators.map[indexName].join(', '))
		
		for (index : allIndices)
		{
			//println('  - index ' + index.indexName)
			// if iterator index and index are identical, nothing to do
			if (index.indexName != indexName)
			{
				val directReference = index.target
				//println('    directReference: ' + directReference.name)

				val indexIndirectReferences = index.indirectIteratorReferences
				//println('    indexIndirectReferences: ' + indexIndirectReferences.map[name].join(', '))
				
				// if the iterator 'it' is referenced by the index
				if (directReference===it || indexIndirectReferences.contains(it))
					// if all iterators are defined
					if (! (innerIterators.contains(directReference) || indexIndirectReferences.exists[x | innerIterators.contains(x)]))
						indexToDefined += index
			}
		}
		
		//println('  indexToDefined: ' + indexToDefined.map[indexName].join(', '))
		return indexToDefined
	}
}

