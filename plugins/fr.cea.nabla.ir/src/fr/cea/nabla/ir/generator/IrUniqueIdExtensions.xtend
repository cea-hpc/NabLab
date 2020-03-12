package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.IrUniqueId

import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.IrIndexExtensions.*

class IrUniqueIdExtensions 
{
	static def getIndexValue(IrUniqueId it)
	{
		val index = defaultValueIndex.name
		val nbElems = defaultValueIndex.container.connectivity.nbElems
		switch shift
		{
			case shift < 0: '''(«index»«shift»+«nbElems»)%«nbElems»'''
			case shift > 0: '''(«index»+«shift»+«nbElems»)%«nbElems»'''
			default: '''«index»'''
		}
	}

	static def getIndexToId(IrUniqueId it)
	{
		if (defaultValueIndex === null) throw new RuntimeException("** Can not compute index value of unique id " + name + ": no index")
		if (defaultValueIndex.container.connectivity.indexEqualId) indexValue
		else defaultValueIndex.containerName + '[' + indexValue + ']'
	}
}