package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRange
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.VarRef
import java.util.HashSet

class IteratorExtensions 
{
	def getRequiredConnectivities(Iterator it, Instruction context)
	{
		getExpectedConnectivities(context).filter[x|x!==range.connectivity]
	}

	def needIdFor(Iterator it, Instruction context)
	{
		!getRequiredConnectivities(context).empty || isIteratorUsedAsRangeArg(context)
	}
	
	def needNext(Iterator it, Instruction context)
	{
		context.eAllContents.filter(IteratorRef).filter[x|x.iterator===it].exists[x|x.next]
	}

	def needPrev(Iterator it, Instruction context)
	{
		context.eAllContents.filter(IteratorRef).filter[x|x.iterator===it].exists[x|x.prev]
	}	

	/**
	 * Retourne vrai si un IteratorRange utilise l'iterateur 'iterator'
	 * dans un de ses arguments pour le contexte 'context'.
	 */
	private def isIteratorUsedAsRangeArg(Iterator it, Instruction context)
	{
		for (range : context.eAllContents.filter(IteratorRange).toIterable)
			for (ref : range.args.filter(IteratorRef))
				if (ref.iterator === it) return true
		return false
	}
	
	/**
	 * Retourne, pour le contexte 'context', l'ensemble des connectivités
	 * sur lesquelles l'itérateur doit être valable, c'est à dire l'ensemble
	 * des références à l'itérateur 'iterator' au sein des VarRef du contexte.
	 */
	private def getExpectedConnectivities(Iterator it, Instruction context)
	{
		val expectedConnectivities = new HashSet<Connectivity>
		for (vRef : context.eAllContents.filter(VarRef).toIterable)
		{
			for (i : 0..<vRef.iterators.length)
			{
				val vRefIter = vRef.iterators.get(i)
				if (vRefIter instanceof IteratorRef && ((vRefIter as IteratorRef).iterator === it))
					expectedConnectivities += (vRef.variable as ArrayVariable).dimensions.get(i)
			} 
		}
		return expectedConnectivities
	}
}