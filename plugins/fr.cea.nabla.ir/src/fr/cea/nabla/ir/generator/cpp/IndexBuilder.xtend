package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.SpaceIterationBlock

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*

class IndexBuilder 
{
	/** Define all needed ids and indexes at the beginning of an iteration, ie Loop or ReductionInstruction  */
	static def defineIndices(SpaceIterationBlock it)
	'''
		«range.defineIndices»
		«FOR s : singletons»
			int «s.indexName»(«s.accessor»);
			«s.defineIndices»
		«ENDFOR»
	'''

	static def defineIndices(Iterator it)
	'''
		«FOR neededId : neededIds»
			int «neededId.idName»(«neededId.indexToId»);
		«ENDFOR»
		«FOR neededIndex : neededIndices»
			int «neededIndex.indexName»(«neededIndex.idToIndex»);
		«ENDFOR»
	'''

	private static def getIndexToId(IteratorRef it)
	{
		if (target.container.connectivity.indexEqualId || target.singleton) indexValue
		else target.containerName + '[' + indexValue + ']'		
	}

	private static def getIdToIndex(ArgOrVarRefIteratorRef it)
	{
		if (varContainer.indexEqualId) idName
		else 'utils::indexOf(' + accessor + ',' + idName + ')'
	}

	static def getAccessor(ArgOrVarRefIteratorRef it) { getAccessor(varContainer, varArgs) }
	static def getAccessor(Iterator it)  { getAccessor(container.connectivity, container.args) }

	private static def getAccessor(Connectivity c, Iterable<? extends IteratorRef> args)  
	'''mesh->get«c.name.toFirstUpper»(«args.map[idName].join(', ')»)'''
}