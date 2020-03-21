package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.Iterator

import static extension fr.cea.nabla.ir.generator.IterationBlockExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ConnectivityCallExtensions.*

class IterationBlockExtensions
{
	static def dispatch defineInterval(Iterator it, CharSequence innerContent)
	{
		if (container.connectivity.indexEqualId)
			innerContent
		else
		{
			'''
			{
				final int[] «container.name» = mesh.«container.accessor»;
				final int «nbElems» = «container.name».length;
				«innerContent»
			}
			'''
		}
	}

	static def dispatch defineInterval(Interval it, CharSequence innerContent)
	{
		innerContent
	}
}
