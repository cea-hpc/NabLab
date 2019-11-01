package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.LoopIndex
import fr.cea.nabla.nabla.SimpleVar

class VarTypeProvider
{
	@Inject extension VarExtensions
	@Inject extension BaseTypeTypeProvider

	def dispatch NablaType getTypeFor(SimpleVar it)
	{
		baseType.typeFor
	}

	def dispatch NablaType getTypeFor(ConnectivityVar it)
	{
		new NablaConnectivityType(supports, baseType.typeFor)
	}

	def dispatch NablaType getTypeFor(LoopIndex it)
	{
		new NSTIntScalar
	}
}