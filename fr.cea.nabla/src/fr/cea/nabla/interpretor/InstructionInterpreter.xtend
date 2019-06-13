package fr.cea.nabla.interpretor

import com.google.inject.Inject
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.If

class InstructionInterpreter 
{
	@Inject extension ExpressionInterpreter

	def dispatch void interprete(ScalarVarDefinition it)
	{
		
	}
	
	def dispatch void interprete(If it)
	{
		val conditionValue = condition.interprete.asBool
		if (conditionValue) then.interprete
		else if (^else !== null) ^else.interprete 
	}
}