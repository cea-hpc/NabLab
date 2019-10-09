package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.VarRefIteratorRef
import java.util.Comparator

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

class IteratorRefExtensions 
{
	static def getIndexName(VarRefIteratorRef it) { name + containerName.toFirstUpper }
	static def getIdName(IteratorRef it) { name + 'Id' }
	static def getContainerName(VarRefIteratorRef it) { varContainer.name + varArgs.map[name.toFirstUpper].join }

	static def getName(IteratorRef it)
	{
		switch shift
		{
			case shift < 0: target.name + 'Minus' + Math::abs(shift)
			case shift > 0: target.name + 'Plus' + shift 
			default: target.name
		}
	}
	
	static def getVarContainer(VarRefIteratorRef it)
	{
		(referencedBy.variable as ConnectivityVariable).type.connectivities.get(indexInReferencerList)
	}
	
	static def getVarArgs(VarRefIteratorRef it)
	{
		val refConnectivity = varContainer
		val refLastArgIndex = indexInReferencerList
		val refFirstArgIndex = indexInReferencerList - refConnectivity.inTypes.size
		if (refFirstArgIndex > refLastArgIndex) throw new IndexOutOfBoundsException()
		if (refFirstArgIndex == refLastArgIndex) #[] else referencedBy.iterators.subList(refFirstArgIndex, refLastArgIndex)
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
	
	private static def getNbElems(IteratorRef it) { target.container.connectivity.nbElems }
}

class SortByIdName implements Comparator<IteratorRef>
{
	override compare(IteratorRef arg0, IteratorRef arg1) 
	{
		val arg0Id = IteratorRefExtensions::getIdName(arg0)
		val arg1Id = IteratorRefExtensions::getIdName(arg1)
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
