package fr.cea.nabla.ir.generator

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.VarRefIteratorRef
import java.util.Comparator

import static extension fr.cea.nabla.ir.generator.Utils.*

class IteratorRefExtensions 
{
	@Inject extension IteratorExtensions
	
	private def getInternalIndexName(IteratorRef it)
	{
		switch shift
		{
			case shift < 0: target.name + 'Minus' + Math::abs(shift)
			case shift > 0: target.name + 'Plus' + shift 
			default: target.name
		}
	}
	
	def dispatch String getIndexName(IteratorRef it)
	{
		internalIndexName
	}

	def dispatch String getIndexName(VarRefIteratorRef it) 
	{ 
		internalIndexName + containerName.toFirstUpper
	}

	def getId(IteratorRef it)
	{
		internalIndexName + 'Id'
	}
	
	def dispatch getContainerName(IteratorRef it)
	{
		target.containerName
	}

	def dispatch getContainerName(VarRefIteratorRef it)
	{
		val refConnectivity = connectivity
		val args = connectivityArgs
		
		if (args.empty)
			refConnectivity.name
		else
			refConnectivity.name + args.map[internalIndexName.toFirstUpper].join()
	}
	
	def getConnectivity(VarRefIteratorRef it)
	{
		(referencedBy.variable as ArrayVariable).dimensions.get(indexInReferencerList)
	}
	
	def getConnectivityArgs(VarRefIteratorRef it)
	{
		val refConnectivity = connectivity
		val refLastArgIndex = indexInReferencerList
		val refFirstArgIndex = indexInReferencerList - refConnectivity.inTypes.size
		if (refFirstArgIndex > refLastArgIndex) throw new IndexOutOfBoundsException()
		if (refFirstArgIndex == refLastArgIndex) #[] else referencedBy.iterators.subList(refFirstArgIndex, refLastArgIndex)
	}

	def getIndirectIteratorReferences(VarRefIteratorRef it)
	{
		connectivityArgs.map[target]
	}	
	
	def getIndexValue(IteratorRef it)
	{
		switch shift
		{
			case shift < 0: '''(«target.indexName»«shift»+«nbElems»)%«nbElems»'''
			case shift > 0: '''(«target.indexName»+«shift»+«nbElems»)%«nbElems»'''
			default: '''«target.indexName»''' 
		}
	}

	def isIndexEqualId(VarRefIteratorRef it)
	{
		val refConnectivity = (referencedBy.variable as ArrayVariable).dimensions.get(indexInReferencerList)
		refConnectivity.indexEqualId
	}
	
	private def getNbElems(IteratorRef it) { target.container.connectivity.nbElems }
}

class SortById implements Comparator<IteratorRef>
{
	@Inject extension IteratorRefExtensions
	
	override compare(IteratorRef arg0, IteratorRef arg1) 
	{
		arg0.id.compareTo(arg1.id)
	}	
}

class SortByIndexName implements Comparator<VarRefIteratorRef>
{
	@Inject extension IteratorRefExtensions
	
	override compare(VarRefIteratorRef arg0, VarRefIteratorRef arg1) 
	{
		arg0.indexName.compareTo(arg1.indexName)
	}	
}
