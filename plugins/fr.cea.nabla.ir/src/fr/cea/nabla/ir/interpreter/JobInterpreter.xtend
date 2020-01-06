package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.InSituJob
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.TimeLoop
import fr.cea.nabla.ir.ir.TimeLoopCopyJob
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D
import java.util.HashMap

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.InstructionInterpreter.*

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.interpreter.NablaValueSetter.*

class JobInterpreter
{
	val PvdFileWriter2D writer

	new (PvdFileWriter2D writer)
	{
		this.writer = writer
	}

	def dispatch void interprete(InstructionJob it, Context context)
	{
		context.logFinest("Interprete InstructionJob " + name + " @ " + at)
		val innerContext = new Context(context)
		interprete(instruction, innerContext)
	}

	def dispatch void interprete(InSituJob it, Context context)
	{
		context.logFinest("Interprete InSituJob " + name + " @ " + at)
		val irModule = eContainer as IrModule
		val iteration = context.getInt(iterationVariable.name)
		val time = context.getReal(irModule.timeVariable.name)
		val period = context.getNumber(periodVariable.name)
		val lastDump = context.getNumber(lastDumpVariable.name)

		if (period >= lastDump)
		{
			val cellVariables = new HashMap<String, double[]>
			val nodeVariables = new HashMap<String, double[]>

			//TODO deal with linearAlgebra
			setItemVariables(context, irModule, "cell", cellVariables)
			setItemVariables(context, irModule, "node", nodeVariables)

			val coordVariable = irModule.getVariableByName(irModule.nodeCoordVariable.name)
			val coord = (context.getVariableValue(coordVariable) as NV2Real).data
			val quads = context.meshWrapper.quads
			writer.writeFile(iteration, time, coord, quads, cellVariables, nodeVariables)
			context.setVariableValue(lastDumpVariable, new NV0Real(period))
		}
	}

	def dispatch void interprete(TimeLoopJob it, Context context)
	{
		context.logFinest("Interprete TimeLoopJob" + name + " @ " + at)
		val irModule = eContainer as IrModule
		val iterationVariable = timeLoop.counter
		var iteration = 0
		context.logVariables("Before timeLoop " + timeLoop.name)
		context.addVariableValue(iterationVariable, new NV0Int(iteration))
		do
		{
			iteration ++
			context.setVariableValue(iterationVariable, new NV0Int(iteration))
			context.logInfo(timeLoop.indentation + "[" + iteration + "] t : " + context.getReal(irModule.timeVariable.name))
			for (j : jobs.filter[x | x.at > 0].sortBy[at])
				interprete(j, context)
			context.logVariables("After iteration = " + iteration)
			// Switch variables to prepare next iteration
			for (copy : copies)
			{
				val leftValue = context.getVariableValue(copy.destination)
				val rightValue = context.getVariableValue(copy.source)
				context.setVariableValue(copy.destination, rightValue)
				context.setVariableValue(copy.source, leftValue)
			}
		}
		while ((interprete(timeLoop.whileCondition, context) as NV0Bool).data)
		context.logVariables("After timeLoop " + iteration)
	}

	def dispatch void interprete(TimeLoopCopyJob it, Context context)
	{
		context.logFinest("Interprete TimeLoopCopyJob " + name + " @ " + at)

		for (copy : copies)
		{
			val sourceValue = context.getVariableValue(copy.source)
			val destinationValue = context.getVariableValue(copy.destination)
			destinationValue.setValue(#[], sourceValue)
		}
	}

	private def setItemVariables(InSituJob it, Context context, IrModule module, String itemName, HashMap<String, double[]> map)
	{
		for (v : dumpedVariables.filter(ConnectivityVariable).filter(v | v.type.connectivities.head.returnType.type.name == itemName))
		{
			val value = context.getVariableValue(module.getVariableByName(v.name))
			if (value instanceof NV1Real) map.put(v.persistenceName, (value as NV1Real).data)
		}
	}

	private static def String getIndentation(TimeLoop it)
	{
		if (outerTimeLoop === null) ''
		else getIndentation(outerTimeLoop) + '\t'
	}
}