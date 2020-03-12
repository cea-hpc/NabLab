package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.IrIndex
import fr.cea.nabla.ir.ir.ConnectivityCall

class IrIndexExtensions 
{
	static def String getContainerName(IrIndex it)
	{
		container.connectivity.name + container.args.map[x | x.iterator.name.toFirstUpper].join('')
	}

	static def getContainerAccessor(IrIndex it, String meshAccessorPrefix)
	'''«meshAccessorPrefix»get«container.connectivity.name.toFirstUpper»(«container.args.map[name].join(', ')»)'''

	static def getIdToIndex(IrIndex it, String indexOfPrefix, String meshAccessorPrefix)
	{
		if (defaultValueId === null) throw new RuntimeException("** Can not compute id value of index " + name + ": no id")
		if (container.connectivity.indexEqualId) defaultValueId.name
		else indexOfPrefix + 'indexOf(' + getAccessor(container, meshAccessorPrefix) + ', ' + defaultValueId.name + ')'
	}

	private static def getAccessor(ConnectivityCall it, String meshAccessorPrefix)  
	'''«meshAccessorPrefix»get«connectivity.name.toFirstUpper»(«args.map[name].join(', ')»)'''
}