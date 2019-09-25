package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.VarDefinition

import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*

class InstructionInterpreter 
{
	static def dispatch void interprete(VarDefinition it, Context context)
	{ 
		for (v : variables)
			context.variableValues.put(v, createValue(v, context))
	}
	
	static def dispatch void interprete(InstructionBlock it, Context context)
	{
		for (i : instructions)
			interprete(i, context)
	}
	
	static def dispatch void interprete(Affectation it, Context context)
	{
		
	}
}