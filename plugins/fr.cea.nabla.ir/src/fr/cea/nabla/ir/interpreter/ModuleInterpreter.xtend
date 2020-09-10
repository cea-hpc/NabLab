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
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D
import java.util.logging.Logger
import java.util.logging.StreamHandler
import org.eclipse.xtend.lib.annotations.Accessors

import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*
import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*

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

	/**
	 * Interpret variable with default values.
	 * This method is public to be used by default Json file generation.
	 */
	def interpreteOptionsDefaultValues()
	{
		for (v : module.options)
			context.addVariableValue(v, createValue(v, context))
	}

	def interprete(String jsonContent)
	{
		context.logInfo(" Start interpreting " + module.name + " module ")

		// Start initialising the variables with default values
		interpreteOptionsDefaultValues

		val gson = new Gson
		val jsonObject = gson.fromJson(jsonContent, JsonObject)

		// Create mesh and mesh variables
		if (!jsonObject.has("mesh")) throw new RuntimeException("Mesh block missing in Json")
		val jsonMesh = jsonObject.get("mesh").asJsonObject
		context.initMesh(gson, jsonMesh, module.connectivities)

		// Read options in Json
		if (!jsonObject.has("options")) throw new RuntimeException("Options block missing in Json")
		val jsonOptions = jsonObject.get("options").asJsonObject
		for (v : module.options)
		{
			if (jsonOptions.has(v.name))
			{
				val vValue = context.getVariableValue(v)
				val jsonElt = jsonOptions.get(v.name)
				NablaValueJsonSetter::setValue(vValue, jsonElt)
			}
			else
			{
				if (v.defaultValue === null)
				{
					// v is not present in json file and is mandatory
					throw new IllegalStateException("Mandatory option missing in Json file: " + v.name)
				}
				else
				{
					context.setVariableValue(v, interprete(v.defaultValue, context))
				}
			}
		}

		module.functions.filter[body === null].forEach[f | context.resolveFunction(f)]

		// Interprete declarations
		for (v : module.variables)
			context.addVariableValue(v, createValue(v, context))

		// Copy Node Cooords
		context.addVariableValue(module.initNodeCoordVariable, new NV2Real(context.meshWrapper.nodes))

		// Interprete Top level jobs
		for (j : module.innerJobs.sortBy[at])
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