package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.SpaceIterationBlock

import static fr.cea.nabla.ir.generator.IrUniqueIdExtensions.*

import static extension fr.cea.nabla.ir.generator.IrIndexExtensions.*

class IndexBuilder
{
	public static val MeshAccessorPrefix = "mesh."

	/** Define all needed ids and indexes at the beginning of an iteration, ie Loop or ReductionInstruction  */
	static def defineIndices(SpaceIterationBlock it)
	'''
		«range.defineIndices»
		«FOR s : singletons»
			final int «s.index.name» = «getContainerAccessor(s.index, MeshAccessorPrefix)»;
			«s.defineIndices»
		«ENDFOR»
	'''

	static def defineIndices(Iterator it)
	'''
		«FOR neededId : neededIds»
			final int «neededId.name» = «getIndexToId(neededId)»;
		«ENDFOR»
		«FOR neededIndex : neededIndices»
			final int «neededIndex.name» = «getIdToIndex(neededIndex, "Utils.", MeshAccessorPrefix)»;
		«ENDFOR»
	'''
}