package fr.cea.nabla

import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration

class VarExtensions 
{
	def getBasicType(Var it) 
	{ 
		val decl = eContainer
		switch decl
		{
			ScalarVarDefinition : decl.type
			VarGroupDeclaration : decl.type
		}
	}

	def boolean isConst(Var it) 
	{ 
		val decl = eContainer
		switch decl
		{
			ScalarVarDefinition : decl.const
			default : false
		}
	}

	def isGlobal(Var it) 
	{ 
		eContainer.eContainer instanceof NablaModule
	}
	
	def getDefaultValue(Var it)
	{
		val decl = eContainer
		switch decl
		{
			ScalarVarDefinition : decl.defaultValue
			VarGroupDeclaration : null
		}
	}
}