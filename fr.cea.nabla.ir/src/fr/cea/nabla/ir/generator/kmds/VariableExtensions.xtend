package fr.cea.nabla.ir.generator.kmds

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.ScalarVariable

class VariableExtensions 
{
	@Inject extension Ir2KmdsUtils

	def dispatch getKmdsType(ScalarVariable it) 
	{ 
		type.kmdsType
	}
	
	def dispatch getKmdsType(ArrayVariable it)
	{
		var t = getType.kmdsType
//		if (innerSupport != ItemType::NONE) t = 'gmds::math::VectorND<'getInnerMaxAccessor(support, innerSupport) + ',' + t + '>'
		return t
	}

	def getKmdsAllocation(ArrayVariable it)
	'''//mesh.createVariable<«kmdsType»>(kmds::KMDS_CELL, "«name»")'''
}