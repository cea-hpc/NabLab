package fr.cea.nabla

import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import java.util.ArrayList

class JobExtensions 
{
	def getAllVars(Job it)
	{
		val allVariables = new ArrayList<Var>
		for (i : eAllContents.toIterable)
			switch i
			{
				VarGroupDeclaration : allVariables += i.variables
				SimpleVarDefinition : allVariables += i.variable
			}				
		return allVariables
	}	
	
	def getAllAffectations(Job it)
	{
		eAllContents.filter(Affectation)
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