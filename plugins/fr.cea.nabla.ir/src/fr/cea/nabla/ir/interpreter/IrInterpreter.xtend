/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import com.google.gson.Gson
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.javalib.LevelDBUtils
import java.io.File
import java.util.logging.Logger
import java.util.logging.StreamHandler
import org.iq80.leveldb.Options

import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*
import static org.iq80.leveldb.impl.Iq80DBFactory.bytes
import static org.iq80.leveldb.impl.Iq80DBFactory.factory

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.interpreter.NablaValueExtensions.*

class IrInterpreter
{
	public static val ITERATION_VARIABLE_NAME = "InterpreterIteration"

	val Logger logger

	new(StreamHandler handler)
	{
		// create a Logger and a Handler
		logger = Logger.getLogger(IrInterpreter.name)
		logger.setLevel(handler.level)  //Create only logs if needed by handler
		logger.setUseParentHandlers(false) // Suppress default console
		logger.handlers.forEach(h | logger.removeHandler(h))
		logger.addHandler(handler)
	}

	def interprete(IrRoot ir, String jsonContent, String wsPath)
	{
		val context = new Context(logger, ir, wsPath)
		context.logInfo("  Start interpreting " + context.ir.name + " module")

		val gson = new Gson
		val jsonObject = gson.fromJson(jsonContent, JsonObject)

		// Create mesh and mesh variables
		if (!jsonObject.has("mesh")) throw new RuntimeException("Mesh block is missing in Json data file")
		val mesh = context.mesh
		mesh.createProviderInstance(null)
		mesh.jsonInit(null, jsonObject.get("mesh").toString)

		// Interprete variables and options
		for (m : context.ir.modules)
			jsonInit(context, m, jsonObject.get(m.name), wsPath)

		// Copy Node Cooords
		context.addVariableValue(context.ir.initNodeCoordVariable, new NV2Real(context.mesh.nodes))

		// Interprete Top level jobs
		for (j : context.ir.main.calls)
			JobInterpreter.interprete(j, context)

		// Non regression testing
		val mainModuleName = context.ir.mainModule.name
		if (jsonObject.has(mainModuleName))
		{
			val jsonMainModuleOptions = jsonObject.get(mainModuleName).asJsonObject
			val nrName = IrUtils.NonRegressionNameAndValue.key
			val nrToleranceName = IrUtils.NonRegressionToleranceNameAndValue.key
			if (jsonMainModuleOptions.has(nrName))
			{
				val dbBaseName = "results/interpreter/" + context.ir.name.toLowerCase + "/" + context.ir.name + "DB."
				val refDBName = dbBaseName + "ref"
				val jsonNrName = jsonMainModuleOptions.get(nrName).asString

				if (jsonNrName.equals(IrUtils.NonRegressionValues.CreateReference.toString))
					createDB(context, refDBName)
				if (jsonNrName.equals(IrUtils.NonRegressionValues.CompareToReference.toString))
				{
					val jsonNrTolerance = jsonMainModuleOptions.has(nrToleranceName) ? jsonMainModuleOptions.get(nrToleranceName).asDouble : 0.0
					val curDBName = dbBaseName + "current"
					createDB(context, curDBName)
					context.levelDBCompareResult = LevelDBUtils.compareDB(curDBName, refDBName, jsonNrTolerance)
					LevelDBUtils.destroyDB(curDBName)
				}
			}
		}

		context.logVariables("At the end")
		context.logInfo("  End interpreting")

		return context
	}

	private def jsonInit(Context context, IrModule m, JsonElement jsonElt, String wsPath)
	{
		if (jsonElt === null) throw new RuntimeException("No Json element for module: " + m.name)
		val jsonOptions = jsonElt.asJsonObject
		if (jsonOptions === null) throw new RuntimeException("No Json element for module: " + m.name)

		for (v : m.variables)
		{
			context.addVariableValue(v, createValue(v.type, v.name, v.defaultValue, context))

			if (v.option)
			{
				if (jsonOptions.has(v.name))
				{
					val vValue = context.getVariableValue(v)
					val jsonOpt = jsonOptions.get(v.name)
					NablaValueJsonSetter::setValue(vValue, jsonOpt)
				}
				else
					throw new IllegalStateException("Missing option in Json file: " + v.name)
			}
		}

		if (m.postProcessing !== null)
		{
			val outputPathName = "outputPath"
			if (jsonOptions.has(outputPathName))
			{
				val outputPath = jsonOptions.get(outputPathName)
				context.initWriter(wsPath + File.separator + outputPath.asString)
			}
			else
				throw new IllegalStateException("Missing option in Json file: outputPath")
		}

		for (provider : m.providers)
		{
			val providerHelper = context.providers.get(provider)
			providerHelper.createProviderInstance(m)
			if (jsonOptions.has(provider.instanceName))
				providerHelper.jsonInit(m, jsonOptions.get(provider.instanceName).toString)
		}
	}

	private def createDB(Context context, String db_name)
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
			for (v : context.ir.variables.filter[!option])
				batch.put(bytes(v.name), context.getVariableValue(v).serialize);
			db.write(batch);
		}
		finally
		{
			// Make sure you close the batch to avoid resource leaks.
			batch.close();
		}
		db.close();
		context.logInfo("Database " + db_name + " created.")
	}
}
