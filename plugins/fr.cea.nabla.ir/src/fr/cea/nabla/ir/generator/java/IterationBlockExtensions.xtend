package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.IntervalIterationBlock
import fr.cea.nabla.ir.ir.SpaceIterationBlock

import static extension fr.cea.nabla.ir.generator.IrIndexExtensions.*
import static extension fr.cea.nabla.ir.generator.IterationBlockExtensions.*

class IterationBlockExtensions
{
	static def dispatch defineInterval(SpaceIterationBlock it, CharSequence innerContent)
	{
		val i = range.index
		if (i.container.connectivity.indexEqualId)
			innerContent
		else
		{
			'''
			{
				final int[] «i.containerName» = «getContainerAccessor(i, IndexBuilder.MeshAccessorPrefix)»;
				final int «nbElems» = «i.containerName».length;
				«innerContent»
			}
			'''
		}
	}

	static def dispatch defineInterval(IntervalIterationBlock it, CharSequence innerContent)
	{
		innerContent
	}
}