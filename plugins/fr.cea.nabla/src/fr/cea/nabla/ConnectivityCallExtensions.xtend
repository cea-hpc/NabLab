package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.MultipleConnectivityCall
import fr.cea.nabla.nabla.SingleConnectivityCall

class ConnectivityCallExtensions
{
	@Inject SpaceIndexExtensions sie

	def dispatch Connectivity getConnectivity(MultipleConnectivityCall it) { connectivity }
	def dispatch Connectivity getConnectivity(SingleConnectivityCall it) { connectivity }

	def String getName(ConnectivityCall it)
	{
		connectivity.name + args.map[x | sie.getName(x).toFirstUpper].join('')
	}
}