package fr.cea.nabla.ir.generator.kokkos

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.ScalarVariable

class VariableExtensions 
{
	@Inject extension Ir2KokkosUtils

	def dispatch getKokkosType(ScalarVariable it) 
	{ 
		type.kokkosType
	}
	
	def dispatch getKokkosType(ArrayVariable it)
	{
		var t = getType.kokkosType
		return t
	}

	def getKokkosAllocation(ArrayVariable it)
	'''//mesh.createVariable<«kokkosType»>(kmds::KMDS_CELL, "«name»")'''
}