package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.InSituJob
import fr.cea.nabla.ir.ir.EndOfTimeLoopJob
import fr.cea.nabla.ir.ir.EndOfInitJob

import static fr.cea.nabla.ir.interpreter.InstructionInterpreter.*
import static fr.cea.nabla.ir.interpreter.NablaValueSetter.*

class JobInterpreter 
{
	static def dispatch interprete(InstructionJob it, Context context)
	{
		println("Dans interprete de InstructionJob " + name + " @ " + at)
		val innerContext = new Context(context)
		interprete(instruction, innerContext)
		//context.showVariables("Apres interprete " + name)
	}

	static def dispatch interprete(InSituJob it, Context context)
	{
		println("Dans interprete de InSituJob " + name)
		//TODO
	}

	static def dispatch interprete(EndOfTimeLoopJob it, Context context)
	{
		println("Dans interprete de EndOfTimeLoopJob" + name + " @ " + at)
		// Switch Vn and Vn+1
		val leftValue = context.getVariableValue(left)
		val rightValue = context.getVariableValue(right)
		context.setVariableValue(left, rightValue)
		context.setVariableValue(right, leftValue)
	}

	static def dispatch interprete(EndOfInitJob it, Context context)
	{
		println("Dans interprete de EndOfInitJob " + name + " @ " + at)
		// Set Vn = V0
		setValue(context.getVariableValue(left), #[], context.getVariableValue(right))
	}
}