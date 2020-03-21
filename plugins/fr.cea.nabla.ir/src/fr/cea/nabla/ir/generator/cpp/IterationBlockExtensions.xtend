package fr.cea.nabla.ir.generator.cpp

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
		'''
		{
			const auto «container.name»(«container.accessor»);
			const int «nbElems»(«container.name».size());
			«innerContent»
		}
		'''
	}

	static def dispatch defineInterval(Interval it, CharSequence innerContent)
	{
		innerContent
	}
}