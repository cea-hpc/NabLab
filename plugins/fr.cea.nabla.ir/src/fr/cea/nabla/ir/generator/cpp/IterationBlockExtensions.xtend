package fr.cea.nabla.ir.generator.cpp

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
		'''
		{
			const auto «i.containerName»(«getContainerAccessor(i, IndexBuilder.MeshAccessorPrefix)»);
			const int «nbElems»(«i.containerName».size());
			«innerContent»
		}
		'''
	}

	static def dispatch defineInterval(IntervalIterationBlock it, CharSequence innerContent)
	{
		innerContent
	}
}