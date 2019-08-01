package fr.cea.nabla

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
}