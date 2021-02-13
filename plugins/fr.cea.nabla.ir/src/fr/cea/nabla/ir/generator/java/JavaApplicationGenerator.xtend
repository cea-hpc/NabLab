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
import fr.cea.nabla.ir.generator.ApplicationGenerator
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList

import static fr.cea.nabla.ir.ExtensionProviderExtensions.*

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.Utils.getInstanceName
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.FunctionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.java.JobContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.JsonContentProvider.*

class JavaApplicationGenerator implements ApplicationGenerator
{
	override getName() { 'Java' }

	override getIrTransformationStep() { null }

	override getGenerationContents(IrRoot ir)
	{
		val fileContents = new ArrayList<GenerationContent>
		for (module : ir.modules)
			fileContents += new GenerationContent(module.className + '.java', module.fileContent, false)
		return fileContents
	}

	private def getFileContent(IrModule it)
	'''
		«fileHeader»

		«val mainModule = irRoot.mainModule»
		package «irRoot.name.toLowerCase»;

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

		import fr.cea.nabla.javalib.*;
		import fr.cea.nabla.javalib.mesh.*;
		«IF linearAlgebra»
		import fr.cea.nabla.javalib.linearalgebra.Matrix;
		import fr.cea.nabla.javalib.linearalgebra.Vector;
		«ENDIF»

		@SuppressWarnings("all")
		public final class «className»
		{
			public final static class Options
			{
				«IF postProcessing !== null»
				public String «Utils.OutputPathNameAndValue.key»;
				«ENDIF»
				«FOR v : options»
				public «v.type.javaType» «v.name»;
				«ENDFOR»
				«FOR v : extensionProviders»
				public «getNsPrefix(v, '.', '.')»«v.facadeClass» «v.instanceName»;
				«ENDFOR»
				public String «Utils.NonRegressionNameAndValue.key»;

				public void jsonInit(final String jsonContent)
				{
					final JsonParser parser = new JsonParser();
					final JsonElement json = parser.parse(jsonContent);
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
					«getJsonContent(v.name, v.type as BaseType, v.defaultValue)»
					«ENDFOR»
					«FOR v : extensionProviders»
					«val vName = v.instanceName»
					// «vName»
					«vName» = new «getNsPrefix(v, '.', '.')»«v.facadeClass»();
					if (o.has("«vName»"))
						«vName».jsonInit(o.get("«vName»").toString());
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
			private final Options options;
			«IF postProcessing !== null»private final FileWriter writer;«ENDIF»

			«IF irRoot.modules.size > 1»
				«IF main»
					// Additional modules
					«FOR m : irRoot.modules.filter[x | x !== it]»
					protected «m.className» «m.name»;
					«ENDFOR»
				«ELSE»
					// Main module
					private «mainModule.className» mainModule;
				«ENDIF»

			«ENDIF»
			// Global variables
			«FOR v : variables.filter[!option]»
			protected «IF v instanceof SimpleVariable && (v as SimpleVariable).const»final «ENDIF»«v.type.javaType» «v.name»;
			«ENDFOR»

			public «className»(«javaMeshClassName» aMesh, Options aOptions)
			{
				// Mesh and mesh variables initialization
				mesh = aMesh;
				«FOR c : irRoot.connectivities.filter[multiple]»
				«c.nbElemsVar» = «c.connectivityAccessor»;
				«ENDFOR»

				// User options
				options = aOptions;
				«IF postProcessing !== null»writer = new PvdFileWriter2D("«irRoot.name»", options.«Utils.OutputPathNameAndValue.key»);«ENDIF»

				// Initialize variables with default values
				«FOR v : variablesWithDefaultValue»
					«v.name» = «v.defaultValue.content»;
				«ENDFOR»

				// Allocate arrays
				«FOR v : variables.filter[!option && defaultValue === null && !type.scalar]»
						«v.name»«v.type.javaAllocation»;
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
			«FOR f : functions.filter(InternFunction)»

				«f.content»
			«ENDFOR»

			«IF main»
			public void «irRoot.main.codeName»()
			{
				System.out.println("Start execution of «name»");
				«FOR j : irRoot.main.calls»
					«j.callName»(); // @«j.at»
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

					// Mesh instanciation
					assert(o.has("mesh"));
					«javaMeshClassName»Factory meshFactory = new «javaMeshClassName»Factory();
					meshFactory.jsonInit(o.get("mesh").toString());
					«javaMeshClassName» mesh = meshFactory.create();

					// Module instanciation(s)
					«FOR m : irRoot.modules»
						«m.instanciation»
					«ENDFOR»

					// Start simulation
					«name».simulate();

					«val dbName = irRoot.name + "DB"»
					// Non regression testing
					if («name»Options.«nrName» != null && «name»Options.«nrName».equals("«Utils.NonRegressionValues.CreateReference.toString»"))
						«name».createDB("«dbName».ref");
					if («name»Options.«nrName» != null && «name»Options.«nrName».equals("«Utils.NonRegressionValues.CompareToReference.toString»"))
					{
						«name».createDB("«dbName».current");
						if (!LevelDBUtils.compareDB("«dbName».current", "«dbName».ref"))
							ret = 1;
						LevelDBUtils.destroyDB("«dbName».current");
						System.exit(ret);
					}
				}
				else
				{
					System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
					System.err.println("        Expecting user data file name, for example «irRoot.name».json");
					System.exit(1);
				}
			}
			«IF postProcessing !== null»

			private void dumpVariables(int iteration)
			{
				if (!writer.isDisabled())
				{
					VtkFileContent content = new VtkFileContent(iteration, «irRoot.timeVariable.name», «irRoot.nodeCoordVariable.name», mesh.getGeometry().getQuads());
					«FOR v : postProcessing.outputVariables»
					content.add«v.support.name.toFirstUpper»Variable("«v.outputName»", «v.target.name»);
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
					«FOR v : irRoot.variables.filter[!option]»
					batch.put(bytes("«getDbKey(v)»"), LevelDBUtils.serialize(«getDbValue(it, v, '.')»));
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
			«ELSE /* !main */»
			public void setMainModule(«mainModule.className» aMainModule)
			{
				mainModule = aMainModule;
				mainModule.«name» = this;
			}
			«ENDIF»
		};
	'''

	private def getInstanciation(IrModule it)
	'''
		«className».Options «name»Options = new «className».Options();
		if (o.has("«name»")) «name»Options.jsonInit(o.get("«name»").toString());
		«className» «name» = new «className»(mesh, «name»Options);
		«IF !main»«name».setMainModule(«irRoot.mainModule.name»);«ENDIF»
	'''

	private def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty)
			'''mesh.getNb«c.name.toFirstUpper»()'''
		else
			'''CartesianMesh2D.MaxNb«c.name.toFirstUpper»'''
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