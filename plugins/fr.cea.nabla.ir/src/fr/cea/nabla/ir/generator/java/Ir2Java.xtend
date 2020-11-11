/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.FunctionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.JobContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.JsonContentProvider.*

class Ir2Java extends CodeGenerator
{
	new() { super('Java') }

	override getFileContentsByName(IrModule it)
	{
		#{ name + '.java' -> javaFileContent }
	}

	private def getJavaFileContent(IrModule it)
	'''
		package «name.toLowerCase»;

		import static org.iq80.leveldb.impl.Iq80DBFactory.bytes;
		import static org.iq80.leveldb.impl.Iq80DBFactory.factory;

		import java.io.File;
		import java.io.FileReader;
		import java.io.IOException;
		import java.lang.reflect.Type;
		import java.util.stream.IntStream;

		import org.iq80.leveldb.DB;
		import org.iq80.leveldb.WriteBatch;

		import com.google.gson.Gson;
		import com.google.gson.GsonBuilder;
		import com.google.gson.JsonDeserializationContext;
		import com.google.gson.JsonDeserializer;
		import com.google.gson.JsonElement;
		import com.google.gson.JsonObject;
		import com.google.gson.JsonParseException;
		import com.google.gson.JsonParser;

		import fr.cea.nabla.javalib.types.*;
		import fr.cea.nabla.javalib.mesh.*;
		import fr.cea.nabla.javalib.utils.*;

		«IF linearAlgebra»
		import org.apache.commons.math3.linear.*;

		«ENDIF»
		@SuppressWarnings("all")
		public final class «name»
		{
			public final static class Options
			{
				«IF postProcessing !== null»
				public String «Utils.OutputPathNameAndValue.key»;
				«ENDIF»
				public String «Utils.NonRegressionNameAndValue.key»;
				«FOR v : options»
				public «v.javaType» «v.name»;
				«ENDFOR»
			}

			public final static class OptionsDeserializer implements JsonDeserializer<Options>
			{
				@Override
				public Options deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException
				{
					final JsonObject d = json.getAsJsonObject();
					Options options = new Options();
					«IF postProcessing !== null»
					«val opName = Utils.OutputPathNameAndValue.key»
					// «opName»
					assert(d.has("«opName»"));
					final JsonElement «opName.jsonName» = d.get("«opName»");
					options.«opName» = «opName.jsonName».getAsJsonPrimitive().getAsString();
					«ENDIF»
					// Non regression
					«val nrName = Utils.NonRegressionNameAndValue.key»
					if(d.has("«nrName»"))
					{
						final JsonElement «nrName.jsonName» = d.get("«nrName»");
						options.«nrName» = «nrName.jsonName».getAsJsonPrimitive().getAsString();
					}
					«FOR v : options»
					«v.jsonContent»
					«ENDFOR»
					return options;
				}
			}

			// Mesh and mesh variables
			private final «javaMeshClassName» mesh;
			«FOR c : connectivities.filter[multiple] BEFORE 'private final int ' SEPARATOR ', '»«c.nbElemsVar»«ENDFOR»;

			// User options and external classes
			private final Options options;
			«FOR s : allProviders»
			private «s» «s.toFirstLower»;
			«ENDFOR»
			«IF postProcessing !== null»private final FileWriter writer;«ENDIF»

			// Global variables
			«FOR v : variables»
			private «IF v instanceof SimpleVariable && (v as SimpleVariable).const»final «ENDIF»«v.javaType» «v.name»;
			«ENDFOR»

			public «name»(«javaMeshClassName» aMesh, Options aOptions«FOR s : allProviders BEFORE ', ' SEPARATOR ', '»«s» a«s»«ENDFOR»)
			{
				// Mesh and mesh variables initialization
				mesh = aMesh;
				«FOR c : connectivities.filter[multiple]»
				«c.nbElemsVar» = «c.connectivityAccessor»;
				«ENDFOR»

				// User options and external classes initialization
				options = aOptions;
				«FOR s : allProviders»
					«s.toFirstLower» = a«s»;
				«ENDFOR»
				«IF postProcessing !== null»writer = new PvdFileWriter2D("«name»", options.«Utils.OutputPathNameAndValue.key»);«ENDIF»

				// Initialize variables with default values
				«FOR v : variablesWithDefaultValue»
					«v.name» = «v.defaultValue.content»;
				«ENDFOR»

				// Allocate arrays
				«FOR v : variables.filter[defaultValue === null && !type.scalar]»
					«IF v.linearAlgebra»
						«v.name» = «(v as ConnectivityVariable).linearAlgebraDefinition»;
					«ELSE»
						«v.name»«v.javaAllocation»;
					«ENDIF»
				«ENDFOR»

				// Copy node coordinates
				double[][] gNodes = mesh.getGeometry().getNodes();
				IntStream.range(0, nbNodes).parallel().forEach(rNodes ->
				{
					«initNodeCoordVariable.name»[rNodes][0] = gNodes[rNodes][0];
					«initNodeCoordVariable.name»[rNodes][1] = gNodes[rNodes][1];
				});
			}

			public void «main.name»()
			{
				System.out.println("Start execution of module «name»");
				«FOR j : main.calls»
					«j.codeName»(); // @«j.at»
				«ENDFOR»
				System.out.println("End of execution of module «name»");
			}

			public static void main(String[] args) throws IOException
			{
				if (args.length == 1)
				{
					String dataFileName = args[0];
					JsonParser parser = new JsonParser();
					JsonObject o = parser.parse(new FileReader(dataFileName)).getAsJsonObject();
					GsonBuilder gsonBuilder = new GsonBuilder();
					gsonBuilder.registerTypeAdapter(Options.class, new «name».OptionsDeserializer());
					Gson gson = gsonBuilder.create();
					int ret = 0;

					assert(o.has("mesh"));
					«javaMeshClassName»Factory meshFactory = gson.fromJson(o.get("mesh"), «javaMeshClassName»Factory.class);
					«javaMeshClassName» mesh = meshFactory.create();
					assert(o.has("options"));
					«name».Options options = gson.fromJson(o.get("options"), «name».Options.class);
					«FOR s : allProviders»
					«s» «s.toFirstLower» = (o.has("«s.toFirstLower»") ? gson.fromJson(o.get("«s.toFirstLower»"), «s».class) : new «s»());
					«ENDFOR»

					«name» simulator = new «name»(mesh, options«FOR s : allProviders BEFORE ', ' SEPARATOR ', '»«s.toFirstLower»«ENDFOR»);
					simulator.simulate();

					// Non regression testing
					if (options.«nrName»!=null &&  options.«nrName».equals("«Utils.NonRegressionValues.CreateReference.toString»"))
						simulator.createDB("«name»DB.ref");
					if (options.«nrName»!=null &&  options.«nrName».equals("«Utils.NonRegressionValues.CompareToReference.toString»"))
					{
						simulator.createDB("«name»DB.current");
						if (!LevelDBUtils.compareDB("«name»DB.current", "«name»DB.ref"))
							ret = 1;
						LevelDBUtils.destroyDB("«name»DB.current");
						System.exit(ret);
					}
				}
				else
				{
					System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
					System.err.println("        Expecting user data file name, for example «name»Default.json");
					System.exit(1);
				}
			}
			«FOR j : jobs»

				«j.content»
			«ENDFOR»
			«FOR f : functions.filter(Function).filter[body !== null]»

				«f.content»
			«ENDFOR»
			«IF postProcessing !== null»

			private void dumpVariables(int iteration)
			{
				if (!writer.isDisabled())
				{
					VtkFileContent content = new VtkFileContent(iteration, «irModule.timeVariable.name», «irModule.nodeCoordVariable.name», mesh.getGeometry().getQuads());
					«FOR v : postProcessing.outputVariables.filter(ConnectivityVariable)»
					content.add«v.type.connectivities.head.returnType.name.toFirstUpper»Variable("«v.outputName»", «v.name»«IF v.linearAlgebra».toArray()«ENDIF»);
					«ENDFOR»
					writer.writeFile(content);
					«postProcessing.lastDumpVariable.name» = «postProcessing.periodReference.name»;
				}
			}
			«ENDIF»

			private void createDB(String db_name) throws IOException
			{
				org.iq80.leveldb.Options levelDBOptions = new org.iq80.leveldb.Options();

				// Destroy if exists
				factory.destroy(new File(db_name), levelDBOptions);

				// Create data base
				levelDBOptions.createIfMissing(true);
				DB db = factory.open(new File(db_name), levelDBOptions);

				WriteBatch batch = db.createWriteBatch();
				try
				{
					«FOR v : variables»
					batch.put(bytes("«v.name»"), LevelDBUtils.serialize(«v.name»));
					«ENDFOR»

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
		};
	'''

	private def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty)
			'''mesh.getNb«c.name.toFirstUpper»()'''
		else
			'''CartesianMesh2D.MaxNb«c.name.toFirstUpper»'''
	}

	private def getLinearAlgebraDefinition(ConnectivityVariable v)
	{
		switch v.type.connectivities.size
		{
			case 1: 'Vector.createDenseVector(' + v.type.connectivities.get(0).nbElemsVar + ')'
			case 2: 'Matrix.createDenseMatrix(' + v.type.connectivities.map[nbElemsVar].join(', ') + ')'
			default: throw new RuntimeException("Not implemented exception")
		}
	}

	private def String getJavaMeshClassName(IrModule it)
	{
		meshClassName.replace('::', '.')
	}

	private def getDefaultValue(Variable v)
	{
		switch v
		{
			SimpleVariable : v.defaultValue
			default : null
		}
	}
}