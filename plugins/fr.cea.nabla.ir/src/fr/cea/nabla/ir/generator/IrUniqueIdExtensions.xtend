package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.IrUniqueId

import static extension fr.cea.nabla.ir.generator.Utils.*

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
}