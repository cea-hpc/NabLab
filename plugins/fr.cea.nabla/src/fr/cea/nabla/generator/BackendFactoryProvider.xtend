package fr.cea.nabla.generator

import fr.cea.nabla.ir.generator.cpp.BackendFactory
import fr.cea.nabla.ir.generator.cpp.KokkosBackendFactory
import fr.cea.nabla.ir.generator.cpp.KokkosTeamThreadBackendFactory
import fr.cea.nabla.ir.generator.cpp.OpenMpBackendFactory
import fr.cea.nabla.ir.generator.cpp.SequentialBackendFactory
import fr.cea.nabla.ir.generator.cpp.StlThreadBackendFactory
import fr.cea.nabla.nablaext.TargetType

class BackendFactoryProvider
{
	def BackendFactory getCppBackend(TargetType type)
	{
		switch type
		{
			case CPP_SEQUENTIAL: new SequentialBackendFactory
			case STL_THREAD: new StlThreadBackendFactory
			case OPEN_MP: new OpenMpBackendFactory
			case KOKKOS: new KokkosBackendFactory
			case KOKKOS_TEAM_THREAD: new KokkosTeamThreadBackendFactory
			default: throw new RuntimeException("No backend for type: " + type.literal)
		}
	}
}