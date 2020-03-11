package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.IrConnectivityCall
import fr.cea.nabla.ir.ir.IrIndex
import fr.cea.nabla.ir.ir.IrUniqueId
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.SpaceIterationBlock

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.IrUniqueIdExtensions.*

class IndexBuilder
{
	/** Define all needed ids and indexes at the beginning of an iteration, ie Loop or ReductionInstruction  */
	static def defineIndices(SpaceIterationBlock it)
	'''
		«range.defineIndices»
		«FOR s : singletons»
			final int «s.indexName» = «s.accessor»;
			«s.defineIndices»
		«ENDFOR»
	'''

	static def defineIndices(Iterator it)
	'''
		«FOR neededId : neededIds»
			// final int «neededId.name» = «neededId.indexToId»;
		«ENDFOR»
		«FOR neededIndex : neededIndices»
			// final int «neededIndex.name» = «neededIndex.idToIndex»;
		«ENDFOR»
		«FOR neededId : oldNeededIds»
			final int «neededId.idName» = «neededId.indexToId»;
		«ENDFOR»
		«FOR neededIndex : oldNeededIndices»
			final int «neededIndex.indexName» = «neededIndex.idToIndex»;
		«ENDFOR»
	'''

	static def getIndexToId(IteratorRef it)
	{
		if (target.container.connectivity.indexEqualId || target.singleton) indexValue
		else target.containerName + '[' + indexValue + ']'
	}

	static def getIdToIndex(ArgOrVarRefIteratorRef it)
	{
		if (varContainer.indexEqualId) idName
		else 'Utils.indexOf(' + accessor + ', ' + idName + ')'
	}

	static def getIndexToId(IrUniqueId it)
	{
		if (defaultValueIndex === null) throw new RuntimeException("** Can not compute index value of unique id " + name + ": no index")
		if (defaultValueIndex.container.connectivity.indexEqualId) indexValue
		else containerName + '[' + indexValue + ']'
	}

	static def getIdToIndex(IrIndex it)
	{
		if (defaultValueId === null) throw new RuntimeException("** Can not compute id value of index " + name + ": no id")
		if (container.connectivity.indexEqualId) defaultValueId.name
		else 'Utils.indexOf(' + container.accessor + ', ' + defaultValueId.name + ')'
	}

	static def getAccessor(ArgOrVarRefIteratorRef it) { getAccessor(varContainer, varArgs) }
	static def getAccessor(Iterator it)  { getAccessor(container.connectivity, container.args) }
	static def getAccessor(Connectivity c, Iterable<? extends IteratorRef> args)  
	'''mesh.get«c.name.toFirstUpper»(«args.map[idName].join(', ')»)'''

	static def getAccessor(IrConnectivityCall it)  
	'''mesh.get«connectivity.name.toFirstUpper»(«args.map[name].join(', ')»)'''
}