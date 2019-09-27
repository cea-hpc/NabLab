package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.VarDefinition

import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*

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
		val rightValue = interprete(right, context)
		
		
	}

	static def dispatch void interprete(ReductionInstruction it, Context context)
	{
		
	}

	static def dispatch void interprete(Loop it, Context context)
	{
		
	}

	static def dispatch void interprete(If it, Context context)
	{
		
	}
}