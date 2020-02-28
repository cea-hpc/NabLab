package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.IntervalIterationBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.SpaceIterationBlock

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.SizeTypeContentProvider.*
import static extension fr.cea.nabla.ir.generator.Utils.*

class IterationBlockExtensions
{
	static def dispatch getIndexName(SpaceIterationBlock it)
	{
		range.indexName
	}

	static def dispatch getIndexName(IntervalIterationBlock it)
	{
		index.name
	}

	static def dispatch defineInterval(SpaceIterationBlock it, CharSequence innerContent)
	{
		if (range.container.connectivity.indexEqualId)
			innerContent
		else
		'''
		{
			final int[] «range.containerName» = «range.accessor»;
			final int «nbElems» = «range.containerName».length;
			«innerContent»
		}
		'''
	}

	static def dispatch defineInterval(IntervalIterationBlock it, CharSequence innerContent)
	{
		innerContent
	}

	static def dispatch getNbElems(SpaceIterationBlock it)
	{
		if (range.container.connectivity.indexEqualId)
			range.container.connectivity.nbElems
		else
			'nbElems' + indexName.toFirstUpper
	}

	static def dispatch getNbElems(IntervalIterationBlock it)
	{
		nbElems.content
	}

	static def getAccessor(Iterator it)  { getAccessor(container.connectivity, container.args) }
	static def getAccessor(Connectivity c, Iterable<? extends IteratorRef> args)  
	'''mesh.get«c.name.toFirstUpper»(«args.map[idName].join(', ')»)'''
}