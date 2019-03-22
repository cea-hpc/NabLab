package fr.cea.nabla

import fr.cea.nabla.nabla.VarRef

class VarRefExtensions 
{
	def getTimeSuffix(VarRef it)
	{
		if (hasTimeIterator) 
		{
			if (timeIteratorDiv == 0) '_n_plus_1'
			else '_n_plus_1_' + timeIteratorDiv
		}
		else ''
	}
}