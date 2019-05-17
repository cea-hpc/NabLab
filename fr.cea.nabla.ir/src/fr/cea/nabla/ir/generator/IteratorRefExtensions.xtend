package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.VarRefIteratorRef
import java.util.Comparator

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

class IteratorRefExtensions 
{
	private static def getInternalIndexName(IteratorRef it)
	{
		switch shift
		{
			case shift < 0: target.name + 'Minus' + Math::abs(shift)
			case shift > 0: target.name + 'Plus' + shift 
			default: target.name
		}
	}
	
	static def dispatch String getIndexName(IteratorRef it)
	{
		internalIndexName
	}

	static def dispatch String getIndexName(VarRefIteratorRef it) 
	{ 
		internalIndexName + containerName.toFirstUpper
	}

	static def getId(IteratorRef it)
	{
		internalIndexName + 'Id'
	}
	
	static def dispatch getContainerName(IteratorRef it)
	{
		target.containerName
	}

	static def dispatch getContainerName(VarRefIteratorRef it)
	{
		val refConnectivity = connectivity
		val args = connectivityArgs
		
		if (args.empty)
			refConnectivity.name
		else
			refConnectivity.name + args.map[internalIndexName.toFirstUpper].join()
	}
	
	static def getConnectivity(VarRefIteratorRef it)
	{
		(referencedBy.variable as ArrayVariable).dimensions.get(indexInReferencerList)
	}
	
	static def getConnectivityArgs(VarRefIteratorRef it)
	{
		val refConnectivity = connectivity
		val refLastArgIndex = indexInReferencerList
		val refFirstArgIndex = indexInReferencerList - refConnectivity.inTypes.size
		if (refFirstArgIndex > refLastArgIndex) throw new IndexOutOfBoundsException()
		if (refFirstArgIndex == refLastArgIndex) #[] else referencedBy.iterators.subList(refFirstArgIndex, refLastArgIndex)
	}

	static def getIndirectIteratorReferences(VarRefIteratorRef it)
	{
		connectivityArgs.map[target]
	}	
	
	static def getIndexValue(IteratorRef it)
	{
		switch shift
		{
			case shift < 0: '''(«target.indexName»«shift»+«nbElems»)%«nbElems»'''
			case shift > 0: '''(«target.indexName»+«shift»+«nbElems»)%«nbElems»'''
			default: '''«target.indexName»''' 
		}
	}

	static def isIndexEqualId(VarRefIteratorRef it)
	{
		val refConnectivity = (referencedBy.variable as ArrayVariable).dimensions.get(indexInReferencerList)
		refConnectivity.indexEqualId
	}
	
	static private def getNbElems(IteratorRef it) { target.container.connectivity.nbElems }
}

class SortById implements Comparator<IteratorRef>
{
	override compare(IteratorRef arg0, IteratorRef arg1) 
	{
		val arg0Id = IteratorRefExtensions::getId(arg0)
		val arg1Id = IteratorRefExtensions::getId(arg1)
		arg0Id.compareTo(arg1Id)
	}	
}

class SortByIndexName implements Comparator<VarRefIteratorRef>
{
	override compare(VarRefIteratorRef arg0, VarRefIteratorRef arg1) 
	{
		val arg0IndexName = IteratorRefExtensions::getIndexName(arg0)
		val arg1IndexName = IteratorRefExtensions::getIndexName(arg1)
		arg0IndexName.compareTo(arg1IndexName)
	}	
}
