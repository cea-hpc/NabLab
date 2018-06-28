package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRange
import fr.cea.nabla.ir.ir.IteratorRangeOrRef
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.VarRef
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Data

class IndexHelper 
{
	@Data
	static class Index
	{
		Iterator iterator
		Connectivity connectivity
		String connectivityArgIterator

		def getContainerName()
		{
			if (connectivityArgIterator.nullOrEmpty)
				connectivity.name
			else
				connectivity.name + connectivityArgIterator.toFirstUpper
		}
		
		def getLabel() 
		{ 
			iterator.name + containerName.toFirstUpper
		}
		
		override equals(Object o)
		{
			if (o instanceof Index)
			{
				val i = o as Index
				return (i.iterator === iterator 
						&& i.connectivity === connectivity
						&& i.connectivityArgIterator == connectivityArgIterator)
			}
			return false
		}
	}
	
	static class IndexFactory
	{
		static def createIndex(Iterator i)
		{
			val arg = if (i.range.args.empty) '' else i.range.args.head.argName
			new Index(i, i.range.connectivity, arg)
		}
		
		static def createIndex(Iterator i, int iIndex, List<Connectivity> connectivities, List<IteratorRangeOrRef> args)
		{
			val c = connectivities.get(iIndex)
			val arg = if (c.inTypes.empty || iIndex==0) '' else args.get(iIndex-1).argName
			new Index(i, c, arg)
		}
		
		private static def dispatch getArgName(IteratorRef it) { iterator.name }
		private static def dispatch getArgName(IteratorRange it) { 'range' + it.hashCode.toString }
	}
	
	def getRequiredIndexes(Loop context)
	{
		val needed = context.neededIndexes
		//println('\nneeded ' + context.iterator.name)
		//needed.forEach[x|println('   ' + x.label)]
		val available = context.availableIndexes
		//println('available ' + context.iterator.name)
		//available.forEach[x|println('   ' + x.label)]
		val required = needed.reject[x | available.exists[y | y == x]]
		//println('required for ' + context.iterator.name)
		//required.forEach[x|println('   ' + x.label)]
		return required
	}

	def needIdFor(Iterator it, Loop context)
	{
		!getRequiredIndexes(context).empty || isIteratorUsedAsRangeArg(context)
	}
	
	def needNext(Iterator it, Loop context)
	{
		context.eAllContents.filter(IteratorRef).filter[x|x.iterator===it].exists[x|x.next]
	}

	def needPrev(Iterator it, Loop context)
	{
		context.eAllContents.filter(IteratorRef).filter[x|x.iterator===it].exists[x|x.prev]
	}	
		
	def indexToId(Index it) { indexToId('') }
	def indexToId(Index it, String prefix)
	{
		val realLabel = if (prefix.nullOrEmpty) label else prefix + label.toFirstUpper
		if (connectivity.indexEqualId) realLabel
		else containerName + '[' + realLabel + ']'
	}
	
	def idToIndex(Index it, String idName)
	{
		if (connectivity.indexEqualId) idName
		else 'Utils.indexOf(' + containerName + ',' + idName + ')'
	}

	def idToIndexArray(Index it)
	'''int[] «containerName» = mesh.get«connectivity.name.toFirstUpper()»(«connectivityArgIterator»Id);'''
	
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
	
	private def getAvailableIndexes(Loop context)
	{		
		val indexes = new HashSet<Index>
		// l'iterateur definit pour la boucle context est disponible
		indexes += IndexFactory::createIndex(context.iterator)
		for (outerLoop : context.eContainer.outerLoops)
		{
			// l'iterateur de toutes les outer boucles sont disponibles
			indexes += IndexFactory::createIndex(outerLoop.iterator)
			// les index nécessaires dans les outer loops sont disponibles egalement
			indexes += outerLoop.neededIndexes
		}
		return indexes
	}
	
	/**
	 * Retourne, pour le contexte 'context', l'ensemble des itérateurs 
	 * nécessaires sous forme d'une liste de paires <Iterator, Connectivity>,
	 * correspondant à la liste des déréférecement effectués par les variables. 
	 */
	private def getNeededIndexes(Loop context)
	{
		val indexes = new HashSet<Index>
		for (vRef : context.eAllContents.filter(VarRef).filter[x|x.nearestLoop===context].toIterable)
		{
			for (i : 0..<vRef.iterators.length)
			{
				val vRefIter = vRef.iterators.get(i)
				if (vRefIter instanceof IteratorRef)
				{
					val vrIterator = (vRefIter as IteratorRef).iterator
					val vrConnectivities = (vRef.variable as ArrayVariable).dimensions
					indexes += IndexFactory::createIndex(vrIterator, i, vrConnectivities, vRef.iterators)
				}
			} 
		}
		return indexes
	}
	
	private def Loop getNearestLoop(EObject o)
	{
		if (o instanceof Loop) o as Loop
		else if (o.eContainer === null) null
		else o.eContainer.nearestLoop
	}
	
	private def List<Loop> getOuterLoops(EObject o)
	{
		if (o instanceof Loop) 
		{
			val l = o.eContainer.outerLoops
			l += o as Loop
			return l
		}
		else if (o.eContainer === null) new ArrayList<Loop>
		else o.eContainer.outerLoops
	}
}