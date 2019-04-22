/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.VarRef
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
			val arg = if (i.call.args.empty) '' else i.call.args.head.target.name
			new Index(i, i.call.connectivity, arg)
		}
		
		static def createIndex(int index, List<Connectivity> connectivities, List<IteratorRef> iterators)
		{
			val i = iterators.get(index).target
			val c = connectivities.get(index)
			val arg = if (c.inTypes.empty || index==0) '' else iterators.get(index-1).target.name
			new Index(i, c, arg)
		}
	}
	
	def getRequiredIndexes(Iterator iterator, EObject context)
	{
		val needed = context.neededIndexes
		//println('\nneeded ' + context.iterator.name)
		//needed.forEach[x|println('   ' + x.label)]
		val available = context.getAvailableIndexes(iterator)
		//println('available ' + context.iterator.name)
		//available.forEach[x|println('   ' + x.label)]
		val required = needed.reject[x | available.exists[y | y == x]]
		//println('required for ' + context.iterator.name)
		//required.forEach[x|println('   ' + x.label)]
		return required
	}

	def needIdFor(Iterator it, EObject context)
	{
		!getRequiredIndexes(context).empty || isIteratorIsReferenced(context)
	}
	
	def needNext(Iterator it, EObject context)
	{
		context.eAllContents.filter(IteratorRef).filter[x|x.target===it].exists[x|x.next]
	}

	def needPrev(Iterator it, EObject context)
	{
		context.eAllContents.filter(IteratorRef).filter[x|x.target===it].exists[x|x.prev]
	}	
		
	def indexToId(Index it) { indexToId('') }
	def indexToId(Index it, String prefix)
	{
		val realLabel = if (prefix.nullOrEmpty) label else prefix + label.toFirstUpper
		if (connectivity.indexEqualId) realLabel
		else containerName + '[' + realLabel + ']'
	}
	
	def idToIndex(Index it, String idName, String separator)
	{
		if (connectivity.indexEqualId) idName
		else 'Utils' + separator + 'indexOf(' + containerName + ',' + idName + ')'
	}

	/**
	 * Retourne vrai si un itérateur est utilisé en argument d'un appel de fonction de connectivité.
	 */
	private def isIteratorIsReferenced(Iterator it, EObject context)
	{
		for (call : context.eAllContents.filter(ConnectivityCall).toIterable)
			if (call.args.exists[x | x.target === it]) return true
		return false
	}
	
	private def getAvailableIndexes(EObject context, Iterator iterator)
	{		
		val indexes = context.eContainer.outerScopeIndexes
		indexes += IndexFactory::createIndex(iterator)
		return indexes
	}
	
	/**
	 * Retourne, pour le contexte 'context', l'ensemble des itérateurs 
	 * nécessaires sous forme d'une liste de paires <Iterator, Connectivity>,
	 * correspondant à la liste des déréférecement effectués par les variables. 
	 */
	private def getNeededIndexes(EObject context)
	{
		val indexes = new HashSet<Index>
		for (vRef : context.eAllContents.filter(VarRef).filter[x|x.variable instanceof ArrayVariable && x.nearestLoopOrReduction===context].toIterable)
		{
			for (i : 0..<vRef.iterators.length)
			{
				val vrConnectivities = (vRef.variable as ArrayVariable).dimensions
				indexes += IndexFactory::createIndex(i, vrConnectivities, vRef.iterators)
			} 
		}
		return indexes
	}
	
	private def EObject getNearestLoopOrReduction(EObject o)
	{
		if (o instanceof Loop || o instanceof ReductionInstruction) o
		else if (o.eContainer === null) null
		else o.eContainer.nearestLoopOrReduction
	}
	
	/** Find all available indexes in the outer scope of the context */
	private def HashSet<Index> getOuterScopeIndexes(EObject context)
	{
		switch context
		{
			Loop: 
			{
				val indexes = context.eContainer.outerScopeIndexes
				indexes += IndexFactory::createIndex(context.iterator);
				indexes += context.neededIndexes
				return indexes
			}
			ReductionInstruction: 
			{
				val indexes = context.eContainer.outerScopeIndexes
				indexes += IndexFactory::createIndex(context.iterator);
				indexes += context.neededIndexes
				return indexes
			}
			case (context.eContainer === null): new HashSet<Index>
			default: context.eContainer.outerScopeIndexes
		}
	} 
}