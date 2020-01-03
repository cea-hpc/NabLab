package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.MandatoryMeshOptions
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D
import java.time.Duration
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.logging.Level
import java.util.logging.Logger
import java.util.logging.StreamHandler

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class ModuleInterpreter
{
	public static String ITERATION_VARIABLE_NAME = "InterpreterIteration"

	val IrModule module
	var Context context
	val PvdFileWriter2D writer
	var JobInterpreter jobInterpreter
	var Logger logger

	new(IrModule module, StreamHandler handler)
	{
		// create a Logger and a Handler
		logger = Logger.getLogger(ModuleInterpreter.name)
		logger.setLevel(Level::ALL) //All Levels messages
		logger.setUseParentHandlers(false) // Suppress default console
		logger.handlers.forEach(h | logger.removeHandler(h))
		logger.addHandler(handler)

		this.module = module
		this.context = new Context(module, logger)
		this.writer = new PvdFileWriter2D(module.name)
		this.jobInterpreter = null
	}

	def interprete()
	{
		val dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss")
		val startTime = LocalDateTime.now()
		logger.warning(" Start executing " + module.name + " module " + dtf.format(startTime))

		jobInterpreter = new JobInterpreter(writer)

		// Compute NeededIds and NeededIndexes for each iterator to spare time during interpretation
		module.eAllContents.filter(Iterator).forEach[i | context.setNeededIndicesAndNeededIdsInContext(i)]

		// Interprete constant variables
		for (v : module.variables.filter(SimpleVariable).filter[const])
			context.addVariableValue(v, interprete(v.defaultValue, context))

		if (module.withMesh)
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
			context.addVariableValue(v, createValue(v, context))

		// Copy Node Cooords
		context.addVariableValue(module.initNodeCoordVariable, new NV2Real(context.meshWrapper.nodes))

		// Interprete Top level jobs
		for (j : module.jobs.filter[jobContainer === null].sortBy[at])
				jobInterpreter.interprete(j, context)

		context.logVariables("At the end")
		val endTime = LocalDateTime.now()
		val duration = Duration.between(startTime, endTime);
		logger.warning(" End executing " + dtf.format(endTime) + " (" + duration.seconds + " s)")

		return context
	}

	def warn(String message)
	{
		logger.warning(message)
	}
}