package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.ItemType
import fr.cea.nabla.nabla.SingleConnectivityCall
import fr.cea.nabla.nabla.SpaceIteratorRef

class SpaceIndexExtensions 
{
	@Inject extension ConnectivityCallExtensions cce

	def dispatch ItemType getType(SingleConnectivityCall it) { connectivity.returnType }
	def dispatch ItemType getType(SpaceIteratorRef it) { target.container.connectivity.returnType }

	def dispatch String getName(SpaceIteratorRef it)
	{
		var name = target.name
		if (dec > 0) name += 'Minus' + dec.toString
		else if (inc > 0) name += 'Plus' + inc.toString
		return name
	}

	def dispatch String getName(SingleConnectivityCall it)
	{
		cce.getName(it)
	}
}