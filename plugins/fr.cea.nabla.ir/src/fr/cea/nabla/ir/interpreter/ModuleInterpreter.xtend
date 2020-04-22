/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.MandatoryOptions
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D
import java.util.logging.Logger
import java.util.logging.StreamHandler

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*

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
		logger.setLevel(handler.level)  //Create only logs if needed by handler
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
		context.logInfo(" Start interpreting " + module.name + " module ")

		jobInterpreter = new JobInterpreter(writer)
		module.functions.filter[body === null].forEach[f | context.resolveFunction(f)]

		// Interprete options
		for (v : module.options)
			context.addVariableValue(v, interprete(v.defaultValue, context))

		if (module.withMesh)
		{
			// Create mesh
			val nbXQuads = context.getInt(MandatoryOptions::X_EDGE_ELEMS)
			val nbYQuads = context.getInt(MandatoryOptions::Y_EDGE_ELEMS)
			val xSize = context.getReal(MandatoryOptions::X_EDGE_LENGTH)
			val ySize = context.getReal(MandatoryOptions::Y_EDGE_LENGTH)
			context.initMesh(nbXQuads, nbYQuads, xSize, ySize)

			// Create mesh nbElems
			for (c : module.usedConnectivities)
			if (c.inTypes.empty)
				context.connectivitySizes.put(c, context.meshWrapper.getNbElems(c.name))
			else
				context.connectivitySizes.put(c, context.meshWrapper.getMaxNbElems(c.name))
		}

		// Interprete variables
		for (v : module.variables)
			context.addVariableValue(v, createValue(v, context))

		// Copy Node Cooords
		context.addVariableValue(module.initNodeCoordVariable, new NV2Real(context.meshWrapper.nodes))

		// Interprete Top level jobs
		for (j : module.jobs.filter[topLevel].sortBy[at])
			jobInterpreter.interprete(j, context)

		context.logVariables("At the end")
		context.logInfo(" End interpreting")

		return context
	}

	def info(String message)
	{
		logger.info(message)
	}
}