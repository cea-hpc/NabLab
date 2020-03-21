package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.ItemIdValueCall
import fr.cea.nabla.ir.ir.ItemIdValueIterator
import fr.cea.nabla.ir.ir.ItemIndexValueId

import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ConnectivityCallExtensions.*

class ItemIndexAndIdValueContentProvider 
{
	static def dispatch getContent(ItemIndexValueId it)
	{
		if (container.connectivity.indexEqualId) 
			'''«id.name»'''
		else 
			'''utils::indexOf(mesh.«container.accessor», «id.name»)'''
	}

	static def dispatch getContent(ItemIdValueIterator it)
	{
		if (iterator.container.connectivity.indexEqualId) indexValue
		else iterator.container.name + '[' + indexValue + ']'
	}

	static def dispatch getContent(ItemIdValueCall it)
	'''mesh->«call.accessor»'''

	private static def getIndexValue(ItemIdValueIterator it)
	{
		val index = iterator.index.name
		val nbElems = iterator.container.connectivity.nbElems
		switch shift
		{
			case shift < 0: '''(«index»«shift»+«nbElems»)%«nbElems»'''
			case shift > 0: '''(«index»+«shift»+«nbElems»)%«nbElems»'''
			default: '''«index»'''
		}
	}
}