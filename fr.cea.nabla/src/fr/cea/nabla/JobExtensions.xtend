package fr.cea.nabla

import com.google.inject.Inject
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
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
	
	def getVariableByName(Job it, String variableName)
	{
		allVars.findFirst[v | v.name == variableName]
	}
	
	def getVarAffectationByName(Job it, String variableName)
	{
		allAffectations.findFirst[a | a.varRef.variable.name == variableName]
	}
	
	def getConnectivityCallFor(Job it, Connectivity connectivity)
	{
		eAllContents.filter(ConnectivityCall).findFirst[ cc | cc.connectivity == connectivity]
	}	
}