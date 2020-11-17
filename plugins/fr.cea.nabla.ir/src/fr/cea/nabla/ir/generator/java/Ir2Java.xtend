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
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable
import java.util.HashMap

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.FunctionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.JobContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.JsonContentProvider.*

class Ir2Java extends CodeGenerator
{
	new() { super('Java') }

	override getFileContentsByName(IrRoot ir)
	{
		val fileContents = new HashMap<String, CharSequence>
		for (module : ir.modules)
			fileContents.put(module.name + '.java', module.fileContent)
		return fileContents
	}

	private def getFileContent(IrModule it)
	'''
		package «name.toLowerCase»;

		import static org.iq80.leveldb.impl.Iq80DBFactory.bytes;
		import static org.iq80.leveldb.impl.Iq80DBFactory.factory;

		import java.io.File;
		import java.io.FileReader;
		import java.io.IOException;
		import java.util.stream.IntStream;

		import org.iq80.leveldb.DB;
		import org.iq80.leveldb.WriteBatch;

		import com.google.gson.JsonElement;
		import com.google.gson.JsonObject;
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
				«FOR v : options»
				public «v.javaType» «v.name»;
				«ENDFOR»
				«FOR v : functionProviderClasses»
				public «v» «v.toFirstLower»;
				«ENDFOR»
				public String «Utils.NonRegressionNameAndValue.key»;

				public void jsonInit(JsonElement json)
				{
					assert(json.isJsonObject());
					final JsonObject o = json.getAsJsonObject();
					«IF postProcessing !== null»
					«val opName = Utils.OutputPathNameAndValue.key»
					// «opName»
					assert(o.has("«opName»"));
					final JsonElement «opName.jsonName» = o.get("«opName»");
					«opName» = «opName.jsonName».getAsJsonPrimitive().getAsString();
					«ENDIF»
					«FOR v : options»
					«v.jsonContent»
					«ENDFOR»
					«FOR v : functionProviderClasses»
					// «v.toFirstLower»
					«v.toFirstLower» = new «v»();
					if (o.has("«v.toFirstLower»"))
						«v.toFirstLower».jsonInit(o.get("«v.toFirstLower»"));
					«ENDFOR»
					// Non regression
					«val nrName = Utils.NonRegressionNameAndValue.key»
					if (o.has("«nrName»"))
					{
						final JsonElement «nrName.jsonName» = o.get("«nrName»");
						«nrName» = «nrName.jsonName».getAsJsonPrimitive().getAsString();
					}
				}
			}

			// Mesh and mesh variables
			private final «javaMeshClassName» mesh;
			«FOR c : irRoot.connectivities.filter[multiple] BEFORE 'private final int ' SEPARATOR ', '»«c.nbElemsVar»«ENDFOR»;

			// User options
			protected final Options options;
			«IF postProcessing !== null»protected final FileWriter writer;«ENDIF»

			// Global variables
			«FOR v : variables.filter[!option]»
			protected «IF v instanceof SimpleVariable && (v as SimpleVariable).const»final «ENDIF»«v.javaType» «v.name»;
			«ENDFOR»

			public «name»(«javaMeshClassName» aMesh, Options aOptions)
			{
				// Mesh and mesh variables initialization
				mesh = aMesh;
				«FOR c : irRoot.connectivities.filter[multiple]»
				«c.nbElemsVar» = «c.connectivityAccessor»;
				«ENDFOR»

				// User options
				options = aOptions;
				«IF postProcessing !== null»writer = new PvdFileWriter2D("«name»", options.«Utils.OutputPathNameAndValue.key»);«ENDIF»

				// Initialize variables with default values
				«FOR v : variablesWithDefaultValue»
					«v.name» = «v.defaultValue.content»;
				«ENDFOR»

				// Allocate arrays
				«FOR v : variables.filter[!option && defaultValue === null && !type.scalar]»
					«IF v.linearAlgebra»
						«v.name» = «(v as ConnectivityVariable).linearAlgebraDefinition»;
					«ELSE»
						«v.name»«v.javaAllocation»;
					«ENDIF»
				«ENDFOR»
				«IF main»

				// Copy node coordinates
				double[][] gNodes = mesh.getGeometry().getNodes();
				IntStream.range(0, nbNodes).parallel().forEach(rNodes ->
				{
					«irRoot.initNodeCoordVariable.name»[rNodes][0] = gNodes[rNodes][0];
					«irRoot.initNodeCoordVariable.name»[rNodes][1] = gNodes[rNodes][1];
				});
				«ENDIF»
			}
			«FOR j : jobs»

				«j.content»
			«ENDFOR»
			«FOR f : functions.filter(Function).filter[body !== null]»

				«f.content»
			«ENDFOR»
			«IF main»

			public void «irRoot.main.name.toFirstLower»()
			{
				System.out.println("Start execution of «name»");
				«FOR j : irRoot.main.calls»
					«j.codeName»(); // @«j.at»
				«ENDFOR»
				System.out.println("End of execution of «name»");
			}

			public static void main(String[] args) throws IOException
			{
				if (args.length == 1)
				{
					String dataFileName = args[0];
					JsonParser parser = new JsonParser();
					JsonObject o = parser.parse(new FileReader(dataFileName)).getAsJsonObject();
					int ret = 0;

					assert(o.has("mesh"));
					«javaMeshClassName»Factory meshFactory = new «javaMeshClassName»Factory();
					meshFactory.jsonInit(o.get("mesh"));
					«javaMeshClassName» mesh = meshFactory.create();

					«name».Options «name.toFirstLower»Options = new «name».Options();
					if (o.has("«name.toFirstLower»"))
						«name.toFirstLower»Options.jsonInit(o.get("«name.toFirstLower»"));

					«name» simulator = new «name»(mesh, «name.toFirstLower»Options);
					simulator.simulate();

					// Non regression testing
					if («name.toFirstLower»Options.«nrName» != null && «name.toFirstLower»Options.«nrName».equals("«Utils.NonRegressionValues.CreateReference.toString»"))
						simulator.createDB("«name»DB.ref");
					if («name.toFirstLower»Options.«nrName» != null && «name.toFirstLower»Options.«nrName».equals("«Utils.NonRegressionValues.CompareToReference.toString»"))
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
			«IF postProcessing !== null»

			private void dumpVariables(int iteration)
			{
				if (!writer.isDisabled())
				{
					VtkFileContent content = new VtkFileContent(iteration, «irRoot.timeVariable.name», «irRoot.nodeCoordVariable.name», mesh.getGeometry().getQuads());
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
					«FOR v : variables.filter[!option]»
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
			«ENDIF»
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