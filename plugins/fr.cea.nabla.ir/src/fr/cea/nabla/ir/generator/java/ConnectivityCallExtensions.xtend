package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.ConnectivityCall

class ConnectivityCallExtensions 
{
	static def getName(ConnectivityCall it)
	{
		connectivity.name + args.map[x | x.itemName.toFirstUpper].join('')
	}

	static def getAccessor(ConnectivityCall it)
	'''get«connectivity.name.toFirstUpper»(«args.map[name].join(', ')»)'''
}