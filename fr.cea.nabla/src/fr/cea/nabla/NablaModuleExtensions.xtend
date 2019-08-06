package fr.cea.nabla

import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import java.util.ArrayList

class NablaModuleExtensions 
{
	def getAllVars(NablaModule it)
	{
		val allVars = new ArrayList<Var>
		allVars.addAll(variables.filter(ScalarVarDefinition).map[variable]) 
		variables.filter(VarGroupDeclaration).forEach[g | allVars.addAll(g.variables)]
		return allVars
	}	
	
	def getFunctionByName(NablaModule it, String funcName)
	{
		return functions.filter(Function).findFirst[f | f.name == funcName]
	}
	
	def getJobByName(NablaModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}
	
	def getConnectivityByName(NablaModule it, String connectivityName)
	{
		connectivities.findFirst[c | c.name == connectivityName]
	}
	
	def getItemTypeByName(NablaModule it, String itemTypeName)
	{
		items.findFirst[i | i.name == itemTypeName]
	}
}