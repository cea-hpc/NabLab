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

import com.google.gson.Gson
import com.google.gson.JsonObject
import fr.cea.nabla.ir.MandatoryVariables
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D
import java.util.logging.Logger
import java.util.logging.StreamHandler
import org.eclipse.xtend.lib.annotations.Accessors

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*

class ModuleInterpreter
{
	public static String ITERATION_VARIABLE_NAME = "InterpreterIteration"

	@Accessors val Context context
	val IrModule module
	val PvdFileWriter2D writer
	val JobInterpreter jobInterpreter
	val Logger logger

	new(IrModule module, StreamHandler handler)
	{
		this(module, handler, "")
	}

	new(IrModule module, StreamHandler handler, String outputDirName)
	{
		// create a Logger and a Handler
		logger = Logger.getLogger(ModuleInterpreter.name)
		logger.setLevel(handler.level)  //Create only logs if needed by handler
		logger.setUseParentHandlers(false) // Suppress default console
		logger.handlers.forEach(h | logger.removeHandler(h))
		logger.addHandler(handler)

		this.module = module
		this.context = new Context(module, logger)
		this.writer = new PvdFileWriter2D(module.name, outputDirName)
		this.jobInterpreter = new JobInterpreter(writer)
	}

	// interprete variable with default values
	def interpreteDefinitionsDefaultValues() { interpreteDefinitions(null) }

	// interprete variable with option file
	def interpreteDefinitions(String jsonOptionsContent)
	{
		// Variables must be created with their default values to get the right NablaValue type
		for (v : module.definitions)
			context.addVariableValue(v, interprete(v.defaultValue, context))

		// Then, the type of each option is used to read the json values
		if (!jsonOptionsContent.nullOrEmpty)
		{
			val gson = new Gson
			val jsonOptions = gson.fromJson(jsonOptionsContent, JsonObject)
			for (v : module.definitions.filter[option])
			{
				val vValue = context.getVariableValue(v)
				val jsonElt = jsonOptions.get(v.name)
				NablaValueJsonSetter::setValue(vValue, jsonElt)
			}
		}
	}

	def interpreteWithOptionDefaultValues() { interprete(null) }

	def interprete(String jsonOptionsContent)
	{
		context.logInfo(" Start interpreting " + module.name + " module ")

		// Interprete definitions
		interpreteDefinitions(jsonOptionsContent)
		module.functions.filter[body === null].forEach[f | context.resolveFunction(f)]
		if (module.withMesh)
		{
			// Create mesh
			val nbXQuads = context.getInt(MandatoryVariables::X_EDGE_ELEMS)
			val nbYQuads = context.getInt(MandatoryVariables::Y_EDGE_ELEMS)
			val xSize = context.getReal(MandatoryVariables::X_EDGE_LENGTH)
			val ySize = context.getReal(MandatoryVariables::Y_EDGE_LENGTH)
			context.initMesh(nbXQuads, nbYQuads, xSize, ySize)

			// Create mesh nbElems
			for (c : module.usedConnectivities)
			if (c.inTypes.empty)
				context.connectivitySizes.put(c, context.meshWrapper.getNbElems(c.name))
			else
				context.connectivitySizes.put(c, context.meshWrapper.getMaxNbElems(c.name))
		}

		// Interprete declarations
		for (v : module.declarations)
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