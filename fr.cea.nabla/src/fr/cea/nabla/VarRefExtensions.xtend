package fr.cea.nabla

import fr.cea.nabla.nabla.InitTimeIterator
import fr.cea.nabla.nabla.NextTimeIterator
import fr.cea.nabla.nabla.VarRef

class VarRefExtensions 
{
	def getTimeSuffix(VarRef it)
	{
		if (timeIterator === null) ''
		else timeIterator.suffix 
	}
	
	private def dispatch getSuffix(InitTimeIterator it) { '_n0' }
	private def dispatch getSuffix(NextTimeIterator it) 
	{ 
		
		if (hasDiv) '_nplus1_' + div
		else '_nplus1'
	}
}