package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.SimpleVar

class VarTypeProvider
{
	@Inject extension ArgOrVarExtensions
	@Inject extension ArgOrVarTypeTypeProvider

	def dispatch NablaType getTypeFor(SimpleVar it)
	{
		type.typeFor
	}

	def dispatch NablaType getTypeFor(ConnectivityVar it)
	{
		new NablaConnectivityType(supports, type.typeFor)
	}

	def dispatch NablaType getTypeFor(Arg it)
	{
		type.typeFor
	}
}