package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.IntervalIterationBlock
import fr.cea.nabla.ir.ir.SpaceIterationBlock

import static extension fr.cea.nabla.ir.generator.SizeTypeContentProvider.*
import static extension fr.cea.nabla.ir.generator.Utils.*

class IterationBlockExtensions 
{
	static def dispatch getIndexName(SpaceIterationBlock it)
	{
		range.index.name
	}

	static def dispatch getIndexName(IntervalIterationBlock it)
	{
		index.name
	}

	static def dispatch getNbElems(SpaceIterationBlock it)
	{
		val connectivity = range.index.container.connectivity
		if (connectivity.indexEqualId)
			connectivity.nbElems
		else
			'nbElems' + indexName.toFirstUpper
	}

	static def dispatch getNbElems(IntervalIterationBlock it)
	{
		nbElems.content
	}
}