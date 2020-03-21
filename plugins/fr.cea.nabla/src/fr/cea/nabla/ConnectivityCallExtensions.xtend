package fr.cea.nabla

import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.MultipleConnectivityCall
import fr.cea.nabla.nabla.SingleConnectivityCall
import java.util.List

import static extension fr.cea.nabla.ItemRefExtensions.*

class ConnectivityCallExtensions
{
	static def dispatch Connectivity getConnectivity(MultipleConnectivityCall it) { connectivity }
	static def dispatch Connectivity getConnectivity(SingleConnectivityCall it) { connectivity }

	static def getUniqueName(ConnectivityCall it)
	{
		getUniqueName(connectivity, args)
	}

	static def getUniqueName(Connectivity c, List<ItemRef> args)
	{
		c.name + args.map[x | x.name.toFirstUpper].join('')
	}
}