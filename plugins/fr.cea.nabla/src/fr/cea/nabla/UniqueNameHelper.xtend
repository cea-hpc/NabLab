package fr.cea.nabla

import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.SetRef
import java.util.List

import static extension fr.cea.nabla.ConnectivityCallExtensions.*
import static extension fr.cea.nabla.ItemRefExtensions.*

class UniqueNameHelper 
{
	static def dispatch getUniqueName(SetRef it)
	{
		target.name
	}

	static def dispatch getUniqueName(ConnectivityCall it)
	{
		getUniqueName(connectivity, args)
	}

	static def getUniqueName(Connectivity c, List<ItemRef> args)
	{
		c.name + args.map[x | x.name.toFirstUpper].join('')
	}
}