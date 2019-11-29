package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.MandatoryMeshVariables
import fr.cea.nabla.ir.MandatorySimulationVariables
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.InSituJob
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.TimeIterationCopyJob
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D
import java.util.HashMap

import static fr.cea.nabla.ir.interpreter.InstructionInterpreter.*

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class JobInterpreter
{
	val PvdFileWriter2D writer

	new (PvdFileWriter2D writer)
	{
		this.writer = writer
	}

	def dispatch interprete(InstructionJob it, Context context)
	{
		//println("Interprete InstructionJob " + name + " @ " + at)
		val innerContext = new Context(context)
		interprete(instruction, innerContext)
	}

	def dispatch interprete(InSituJob it, Context context)
	{
		//println("Interprete InSituJob " + name + " @ " + at)
		val irModule = eContainer as IrModule
		val iteration = context.getInt(ModuleInterpreter::ITERATION_VARIABLE_NAME)
		val time = context.getReal(MandatorySimulationVariables::TIME)
		var lastWriteTime = 0.0
		if (timeStep > 0)
			lastWriteTime = context.getReal(Utils::LastWriteTimeVariableName)

		if ((iterationPeriod > 0 && iteration % iterationPeriod == 0)
			|| (timeStep > 0 && time > lastWriteTime))
		{
			val cellVariables = new HashMap<String, double[]>
			val nodeVariables = new HashMap<String, double[]>

			//TODO deal with linearAlgebra
			setItemVariables(context, irModule, "cell", cellVariables)
			setItemVariables(context, irModule, "node", nodeVariables)

			val coordVariable = irModule.getVariableByName(MandatoryMeshVariables::COORD)
			val coord = (context.getVariableValue(coordVariable) as NV2Real).data
			val quads = context.meshWrapper.quads
			writer.writeFile(iteration, time, coord, quads, cellVariables, nodeVariables)
			if (timeStep > 0)
			{
				val lastWriteTimeVariable= irModule.getVariableByName(Utils::LastWriteTimeVariableName)
				context.setVariableValue(lastWriteTimeVariable, new NV0Real(lastWriteTime + timeStep))
			}
		}
	}

	def dispatch interprete(TimeIterationCopyJob it, Context context)
	{
		//println("Interprete TimeIterationCopyJob " + name + " @ " + at)
		val rightValue = context.getVariableValue(right)
		context.setVariableValue(left, rightValue)
	}

	private def setItemVariables(InSituJob it, Context context, IrModule module, String itemName, HashMap<String, double[]> map)
	{
		for (v : variables.filter(ConnectivityVariable).filter(v | v.type.connectivities.head.returnType.type.name == itemName))
		{
			val value = context.getVariableValue(module.getVariableByName(v.name))
			if (value instanceof NV1Real) map.put(v.persistenceName, (value as NV1Real).data)
		}
	}
}