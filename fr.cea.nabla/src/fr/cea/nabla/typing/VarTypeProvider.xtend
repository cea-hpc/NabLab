package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.ArrayVar
import fr.cea.nabla.nabla.ScalarVar

class VarTypeProvider 
{
	@Inject extension VarExtensions
	
	def dispatch NablaType getTypeFor(ScalarVar it) 
	{ 
		new NablaType(basicType, 0)
	}
	
	def dispatch NablaType getTypeFor(ArrayVar it) 
	{ 
		new NablaType(basicType, dimensions.length)
	}
}
