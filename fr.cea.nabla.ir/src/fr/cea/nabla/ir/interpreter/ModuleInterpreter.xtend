package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.MandatoryMeshOptions
import fr.cea.nabla.ir.MandatorySimulationOptions
import fr.cea.nabla.ir.MandatorySimulationVariables
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import java.util.logging.Logger
import java.util.logging.Level
import java.util.logging.ConsoleHandler

class ModuleInterpreter 
{
	public static String ITERATION_VARIABLE_NAME = "InterpreterIteration"

	val IrModule module
	var Context context
	val PvdFileWriter2D writer
	var JobInterpreter jobInterpreter
	var Variable iterationVariable
	var Logger log

	new(IrModule module)
	{
		this.module = module
		this.context = new Context(module)
		this.writer = new PvdFileWriter2D(module.name)
		this.jobInterpreter = null
		this.iterationVariable = null

		// create a Logger and a Handler
		log = Logger.getLogger(ModuleInterpreter.name)
		log.setLevel(Level::ALL) //All Levels messages
		log.setUseParentHandlers(false) // Suppress default console
		val ch = new ConsoleHandler
		ch.setLevel(Level.INFO); // to accept only INFO messages
		log.addHandler(ch)
	}

	def interprete()
	{
		log.log(Level::WARNING," Start interpreter ");

		// Add Variable for iteration
		iterationVariable = createIterationVariable
		jobInterpreter = new JobInterpreter(writer, iterationVariable)

		// Interprete constant variables
		for (v : module.variables.filter(SimpleVariable).filter[const])
			context.setVariableValue(v, interprete(v.defaultValue, context))

		if (!module.items.empty)
		{
			// Create mesh
			val nbXQuads = context.getInt(MandatoryMeshOptions::X_EDGE_ELEMS)
			val nbYQuads = context.getInt(MandatoryMeshOptions::Y_EDGE_ELEMS)
			val xSize = context.getReal(MandatoryMeshOptions::X_EDGE_LENGTH)
			val ySize = context.getReal(MandatoryMeshOptions::Y_EDGE_LENGTH)
			context.initMesh(nbXQuads, nbYQuads, xSize, ySize)

			// Create mesh nbElems
			for (c : module.usedConnectivities)
			if (c.inTypes.empty)
				context.connectivitySizes.put(c, context.meshWrapper.getNbElems(c.name))
			else
				context.connectivitySizes.put(c, context.meshWrapper.getMaxNbElems(c.name))
		}

		// Interprete variables
		for (v : module.variables.filter[x | !(x instanceof SimpleVariable && x.const)])
			context.setVariableValue(v, createValue(v, context))

		// Copy Node Cooords
		context.setVariableValue(module.initCoordVariable, new NV2Real(context.meshWrapper.nodes))

		// Interprete init jobs
		for (j : module.jobs.filter[x | x.at < 0].sortBy[at])
			jobInterpreter.interprete(j, context)

		context.showVariables("After init jobs")
	
		// Declare time loop
		var maxIterations = context.getInt(MandatorySimulationOptions::MAX_ITERATIONS)
		var stopTime = context.getReal(MandatorySimulationOptions::STOP_TIME)

		while (iterationValue < maxIterations && context.getReal(MandatorySimulationVariables::TIME) < stopTime)
		{
			for (j : module.jobs.filter[x | x.at > 0].sortBy[at])
				jobInterpreter.interprete(j, context)
			context.showVariables("At iteration = " + iterationValue)
			incrementIterationValue
		}

		log.log(Level::WARNING," End interpreter ");

		return context
	}

	private def createIterationVariable()
	{
		val iteration = IrFactory::eINSTANCE.createSimpleVariable
		iteration.name = ModuleInterpreter.ITERATION_VARIABLE_NAME
		iteration.type = IrFactory::eINSTANCE.createBaseType => [ primitive = PrimitiveType::INT ]
		iteration.const = false
		iteration.defaultValue = IrFactory::eINSTANCE.createIntConstant =>
		[
			type = IrFactory::eINSTANCE.createBaseType => [ primitive = PrimitiveType::INT ]
			value = 0
		]
		module.variables.add(iteration)
		return iteration
	}

	private def getIterationValue()
	{
		context.getInt(iterationVariable)
	}

	private def incrementIterationValue()
	{
		val value = getIterationValue
		context.setVariableValue(iterationVariable, new NV0Int(value + 1))
	}
}