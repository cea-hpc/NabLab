package fr.cea.nabla

import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.InitTimeIterator
import fr.cea.nabla.nabla.NextTimeIterator

class ArgOrVarRefExtensions 
{
	def getTimeSuffix(ArgOrVarRef it)
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