/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.FunctionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.JobContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.JsonContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.TypeContentProvider.*

class IrModuleContentProvider
{
	static def getFileContent(IrModule it, boolean hasLevelDB)
	'''
		/* «Utils.doNotEditWarning» */

		«val mainModule = irRoot.mainModule»
		package «JavaGeneratorUtils.getPackageName(it)»;

		«IF main && hasLevelDB»
		import static org.iq80.leveldb.impl.Iq80DBFactory.bytes;
		import static org.iq80.leveldb.impl.Iq80DBFactory.factory;

		import org.iq80.leveldb.DB;
		import org.iq80.leveldb.WriteBatch;

		import java.io.File;
		«ENDIF»
		import java.io.FileReader;
		import java.io.IOException;
		import java.util.stream.IntStream;

		import com.google.gson.Gson;
		import com.google.gson.JsonObject;
		import com.google.gson.JsonElement;

		«IF main && hasLevelDB»import fr.cea.nabla.javalib.LevelDBUtils;«ENDIF»
		import fr.cea.nabla.javalib.mesh.*;

		public final class «className»
		{
			// Mesh and mesh variables
			private final «irRoot.mesh.className» mesh;
			«FOR a : neededConnectivityAttributes»
				private final int «a.nbElemsVar»;
			«ENDFOR»
			«FOR a : neededGroupAttributes»
				private final int «a.nbElemsVar»;
			«ENDFOR»
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
			// Options and global variables
			«IF postProcessing !== null»
				private PvdFileWriter2D writer;
				private String «IrUtils.OutputPathNameAndValue.key»;
			«ENDIF»
			«FOR v : externalProviders»
				private «v.packageName».«v.className» «v.instanceName»;
			«ENDFOR»
			«IF main && hasLevelDB»
				// Non regression
				private String «IrUtils.NonRegressionNameAndValue.key»;
				private double «IrUtils.NonRegressionToleranceNameAndValue.key»;
			«ENDIF»
			«FOR v : variables»
				«IF v.constExpr»
					static final «v.type.javaType» «v.name» = «v.defaultValue.content»;
				«ELSE»
					««« Must not be declared final even it the const attribute is true
					««« because it will be initialized in the jsonInit function (not in cstr)
					«v.type.javaType» «v.name»;
				«ENDIF»
			«ENDFOR»

			public «className»(«irRoot.mesh.className» aMesh)
			{
				// Mesh and mesh variables initialization
				mesh = aMesh;
				«FOR a : neededConnectivityAttributes»
					«a.nbElemsVar» = mesh.getNb«a.name.toFirstUpper»();
				«ENDFOR»
				«FOR a : neededGroupAttributes»
					«a.nbElemsVar» = mesh.getGroup("«a»").length;
				«ENDFOR»
			}

			public void jsonInit(final String jsonContent)
			{
				final Gson gson = new Gson();
				final JsonObject options = gson.fromJson(jsonContent, JsonObject.class);
				«IF postProcessing !== null»
					«val opName = IrUtils.OutputPathNameAndValue.key»
					assert options.has("«opName»") : "No «opName» option";
					final JsonElement «opName.jsonName» = options.get("«opName»");
					«opName» = «opName.jsonName».getAsJsonPrimitive().getAsString();
					writer = new PvdFileWriter2D("«irRoot.name»", «opName»);
				«ENDIF»
				«FOR v : variables.filter[!constExpr]»
					«IF !v.type.scalar»
						«v.name»«getJavaAllocation(v.type, v.name)»;
					«ENDIF»
					«IF v.option»
						«getJsonContent(v.name, v.type as BaseType)»
					«ELSEIF v.defaultValue !== null»
						«v.name» = «getContent(v.defaultValue)»;
					«ENDIF»
				«ENDFOR»
				«FOR v : externalProviders»
					«val vName = v.instanceName»
					// «vName»
					«vName» = new «v.packageName».«v.className»();
					if (options.has("«vName»"))
						«vName».jsonInit(options.get("«vName»").toString());
				«ENDFOR»
				«val nrName = IrUtils.NonRegressionNameAndValue.key»
				«val nrToleranceName = IrUtils.NonRegressionToleranceNameAndValue.key»
				«IF main && hasLevelDB»

					// Non regression
					if (options.has("«nrName»"))
					{
						final JsonElement «nrName.jsonName» = options.get("«nrName»");
						«nrName» = «nrName.jsonName».getAsJsonPrimitive().getAsString();
					}
					if (options.has("«nrToleranceName»"))
					{
						final JsonElement «nrToleranceName.jsonName» = options.get("«nrToleranceName»");
						«nrToleranceName» = «nrToleranceName.jsonName».getAsJsonPrimitive().getAsDouble();
					}
					else
						«nrToleranceName» = 0.0;
				«ENDIF»
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
			«FOR f : functions»

				«f.content»
			«ENDFOR»

			«IF main»
			public void simulate()
			{
				System.out.println("Start execution of «name»");
				«FOR j : irRoot.main.calls»
					«Utils.getCallName(j)»(); // @«j.at»
				«ENDFOR»
				System.out.println("End of execution of «name»");
			}

			public static void main(String[] args) throws IOException
			{
				if (args.length == 1)
				{
					final String dataFileName = args[0];
					final Gson gson = new Gson();
					final JsonObject o = gson.fromJson(new FileReader(dataFileName), JsonObject.class);

					// Mesh instanciation
					assert o.has("mesh") : "No mesh option";
					«irRoot.mesh.className» mesh = new «irRoot.mesh.className»();
					mesh.jsonInit(o.get("mesh").toString());

					// Module instanciation(s)
					«FOR m : irRoot.modules»
						«m.className» «m.name» = new «m.className»(mesh);
						assert o.has("«m.name»") : "No «m.name» option";
						«m.name».jsonInit(o.get("«m.name»").toString());
						«IF !m.main»«m.name».setMainModule(«irRoot.mainModule.name»);«ENDIF»
					«ENDFOR»

					// Start simulation
					«name».simulate();
					«IF main && hasLevelDB»

					«val dbName = irRoot.name + "DB"»
					// Non regression testing
					if («name».«nrName» != null && «name».«nrName».equals("«IrUtils.NonRegressionValues.CreateReference.toString»"))
						«name».createDB("«dbName».ref");
					if («name».«nrName» != null && «name».«nrName».equals("«IrUtils.NonRegressionValues.CompareToReference.toString»"))
					{
						«name».createDB("«dbName».current");
						boolean ok = LevelDBUtils.compareDB("«dbName».current", "«dbName».ref", «name».«nrToleranceName»);
						LevelDBUtils.destroyDB("«dbName».current");
						if (!ok) System.exit(1);
					}
					«ENDIF»
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
					try
					{
						Quad[] quads = mesh.getGeometry().getQuads();
						writer.startVtpFile(iteration, «irRoot.currentTimeVariable.name», «irRoot.nodeCoordVariable.name», quads);
						«val outputVarsByConnectivities = irRoot.postProcessing.outputVariables.groupBy(x | x.support.name)»
						writer.openNodeData();
						«val nodeVariables = outputVarsByConnectivities.get("node")»
						«IF !nodeVariables.nullOrEmpty»
							«FOR v : nodeVariables»
								writer.openNodeArray("«v.outputName»", «v.target.type.baseSizes.size»);
								for (int i=0 ; i<nbNodes ; ++i)
									writer.write(«v.target.writeCallContent»);
								writer.closeNodeArray();
							«ENDFOR»
						«ENDIF»
						writer.closeNodeData();
						writer.openCellData();
						«val cellVariables = outputVarsByConnectivities.get("cell")»
						«IF !cellVariables.nullOrEmpty»
							«FOR v : cellVariables»
								writer.openCellArray("«v.outputName»", «v.target.type.baseSizes.size»);
								for (int i=0 ; i<nbCells ; ++i)
									writer.write(«v.target.writeCallContent»);
								writer.closeCellArray();
							«ENDFOR»
						«ENDIF»
						writer.closeCellData();
						writer.closeVtpFile();
						«postProcessing.lastDumpVariable.name» = «postProcessing.periodReference.name»;
					}
					catch (java.io.FileNotFoundException e)
					{
						System.out.println("* WARNING: no dump of variables. FileNotFoundException: " + e.getMessage());
					}
				}
			}
			«ENDIF»
			«IF main && hasLevelDB»

			private void createDB(String dbName) throws IOException
			{
				org.iq80.leveldb.Options levelDBOptions = new org.iq80.leveldb.Options();

				// Destroy if exists
				factory.destroy(new File(dbName), levelDBOptions);

				// Create data base
				levelDBOptions.createIfMissing(true);
				DB db = factory.open(new File(dbName), levelDBOptions);

				WriteBatch batch = db.createWriteBatch();
				try
				{
					«FOR v : irRoot.variables.filter[!option]»
					batch.put(bytes("«Utils.getDbDescriptor(v)»"), LevelDBUtils.toByteArrayDescriptor(«JavaGeneratorUtils.getDbBytes(v.type)», new int[] {«JavaGeneratorUtils.getDbSizes(v.type, Utils.getDbValue(it, v, '.'))»}));
					batch.put(bytes("«Utils.getDbKey(v)»"), LevelDBUtils.toByteArray(«Utils.getDbValue(it, v, '.')»));
					«ENDFOR»

					db.write(batch);
				}
				finally
				{
					// Make sure you close the batch to avoid resource leaks.
					batch.close();
				}
				db.close();
				System.out.println("Reference database " + dbName + " created.");
			}
			«ENDIF»
			«ELSE /* !main */»
			public void setMainModule(«mainModule.className» aMainModule)
			{
				mainModule = aMainModule;
				mainModule.«name» = this;
			}
			«ENDIF»
		};
	'''

	private static def getWriteCallContent(Variable v)
	{
		val t = v.type
		switch t
		{
			ConnectivityType: '''«v.name»[i]'''
			LinearAlgebraType: '''«v.name».getValue(i)'''
			default: throw new RuntimeException("Unexpected type: " + t.class.name)
		}
	}
}