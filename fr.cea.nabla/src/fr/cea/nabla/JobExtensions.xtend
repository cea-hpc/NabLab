package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.Job

class JobExtensions 
{
	@Inject extension InstructionExtensions
		
	def getAllVars(Job it)
	{
		instruction.allVars
	}	
	
	def getAllAffectations(Job it)
	{
		instruction.allAffectations
	}
}