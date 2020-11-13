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
import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D
import fr.cea.nabla.javalib.utils.LevelDBUtils
import java.io.File
import java.util.logging.Logger
import java.util.logging.StreamHandler
import org.eclipse.xtend.lib.annotations.Accessors
import org.iq80.leveldb.Options

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*
import static org.iq80.leveldb.impl.Iq80DBFactory.bytes
import static org.iq80.leveldb.impl.Iq80DBFactory.factory

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.interpreter.NablaValueExtensions.*

class IrInterpreter
{
	public static String ITERATION_VARIABLE_NAME = "InterpreterIteration"

	@Accessors val Context context
	val IrRoot ir
	val PvdFileWriter2D writer
	val JobInterpreter jobInterpreter
	val Logger logger
	val String levelDatabasePath
	var Boolean levelDBcompareResult

	new(IrRoot ir, StreamHandler handler)
	{
		this(ir, handler, "")
	}

	new(IrRoot ir, StreamHandler handler, String outputDirName)
	{
		// create a Logger and a Handler
		logger = Logger.getLogger(IrInterpreter.name)
		logger.setLevel(handler.level)  //Create only logs if needed by handler
		logger.setUseParentHandlers(false) // Suppress default console
		logger.handlers.forEach(h | logger.removeHandler(h))
		logger.addHandler(handler)

		this.ir = ir
		this.context = new Context(ir, logger)
		this.writer = new PvdFileWriter2D(ir.name, outputDirName)
		this.jobInterpreter = new JobInterpreter(writer)
		this.levelDatabasePath = "results/interpreter/" + ir.name.toLowerCase + "/"
		this.levelDBcompareResult = true
	}

	/**
	 * Interpret variable with default values.
	 * This method is public to be used by default Json file generation.
	 */
	def interpreteOptionsDefaultValues()
	{
		for (v : ir.options)
			context.addVariableValue(v, createValue(v, context))
	}

	def interprete(String jsonContent)
	{
		context.logInfo(" Start interpreting " + ir.name + " module ")

		// Start initialising the variables with default values
		interpreteOptionsDefaultValues

		val gson = new Gson
		val jsonObject = gson.fromJson(jsonContent, JsonObject)

		// Create mesh and mesh variables
		if (!jsonObject.has("mesh")) throw new RuntimeException("Mesh block missing in Json")
		val jsonMesh = jsonObject.get("mesh").asJsonObject
		context.initMesh(gson, jsonMesh, ir.connectivities)

		// Read options in Json
		if (!jsonObject.has("options")) throw new RuntimeException("Options block missing in Json")
		val jsonOptions = jsonObject.get("options").asJsonObject
		for (v : ir.options)
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

		ir.functions.filter[body === null].forEach[f | context.resolveFunction(f)]

		// Interprete variables that are not options
		for (v : ir.variables.filter[!option])
			context.addVariableValue(v, createValue(v, context))

		// Copy Node Cooords
		context.addVariableValue(ir.initNodeCoordVariable, new NV2Real(context.meshWrapper.nodes))

		// Interprete Top level jobs
		for (j : ir.main.calls)
			jobInterpreter.interprete(j, context)

		// Non regression testing
		val nrName = Utils.NonRegressionNameAndValue.key
		if (jsonOptions.has(nrName) && (jsonOptions.get(nrName).asString).equals(Utils.NonRegressionValues.CreateReference.toString))
			createDB(refDBName)
		if (jsonOptions.has(nrName) && (jsonOptions.get(nrName).asString).equals(Utils.NonRegressionValues.CompareToReference.toString))
		{
			createDB(curDBName)
			levelDBcompareResult = LevelDBUtils.compareDB(curDBName, refDBName)
			LevelDBUtils.destroyDB(curDBName)
		}

		context.logVariables("At the end")
		context.logInfo(" End interpreting")

		return context
	}

	def info(String message)
	{
		logger.info(message)
	}

	def getLevelDBCompareResult()
	{
		levelDBcompareResult
	}

	private def createDB(String db_name)
	{
		val levelDBOptions = new Options()

		// Destroy if exists
		factory.destroy(new File(db_name), levelDBOptions)

		// Create data base
		levelDBOptions.createIfMissing(true)
		val db = factory.open(new File(db_name), levelDBOptions);

		val batch = db.createWriteBatch();
		try
		{
			for (v : ir.variables.filter[!option])
				batch.put(bytes(v.name), context.getVariableValue(v).serialize);

			db.write(batch);
		}
		finally
		{
			// Make sure you close the batch to avoid resource leaks.
			batch.close();
		}
		db.close();
		System.out.println("Reference database " + db_name + " created.");
	}

	private def getRefDBName() { levelDatabasePath + ir.name + "DB.ref" }
	private def getCurDBName() { levelDatabasePath + ir.name + "DB.current" }
}