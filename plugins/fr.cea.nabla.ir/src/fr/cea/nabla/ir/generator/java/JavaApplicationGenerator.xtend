/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.ApplicationGenerator
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.transformers.ReplaceOperatorNames
import java.util.ArrayList

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

class JavaApplicationGenerator implements ApplicationGenerator
{
	val boolean hasLevelDB

	new(boolean hasLevelDB)
	{
		this.hasLevelDB = hasLevelDB
	}

	override getName() { 'Java' }

	override getIrTransformationSteps()
	{
		#[new ReplaceOperatorNames]
	}

	override getGenerationContents(IrRoot ir)
	{
		val fileContents = new ArrayList<GenerationContent>
		for (module : ir.modules)
			fileContents += new GenerationContent(module.className + '.java', module.fileContent, false)
		return fileContents
	}

	private def getFileContent(IrModule it)
	'''
		/* «Utils.doNotEditWarning» */

		«val mainModule = irRoot.mainModule»
		package «JavaGeneratorUtils.getPackageName(it)»;

		«IF levelDB»
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

		«IF levelDB»import fr.cea.nabla.javalib.LevelDBUtils;«ENDIF»
		import fr.cea.nabla.javalib.mesh.*;

		public final class «className»
		{
			// Mesh and mesh variables
			private final «irRoot.mesh.className» mesh;
			@SuppressWarnings("unused")
			«FOR c : irRoot.mesh.connectivities.filter[multiple] BEFORE 'private final int ' SEPARATOR ', ' AFTER ';'»«c.nbElemsVar»«ENDFOR»

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
			«IF levelDB»
				private String «IrUtils.NonRegressionNameAndValue.key»;
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
				«FOR c : irRoot.mesh.connectivities.filter[multiple]»
					«c.nbElemsVar» = «c.connectivityAccessor»;
				«ENDFOR»
			}

			public void jsonInit(final String jsonContent)
			{
				final Gson gson = new Gson();
				final JsonObject options = gson.fromJson(jsonContent, JsonObject.class);
				«IF postProcessing !== null»
					«val opName = IrUtils.OutputPathNameAndValue.key»
					assert(options.has("«opName»"));
					final JsonElement «opName.jsonName» = options.get("«opName»");
					«opName» = «opName.jsonName».getAsJsonPrimitive().getAsString();
					writer = new PvdFileWriter2D("«irRoot.name»", «opName»);
				«ENDIF»
				«FOR v : variables.filter[!constExpr]»
					«IF !v.type.scalar»
						«v.name»«getJavaAllocation(v.type, v.name)»;
					«ENDIF»
					«IF v.option»
						«getJsonContent(v.name, v.type as BaseType, v.defaultValue)»
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
				«IF levelDB»
					// Non regression
					if (options.has("«nrName»"))
					{
						final JsonElement «nrName.jsonName» = options.get("«nrName»");
						«nrName» = «nrName.jsonName».getAsJsonPrimitive().getAsString();
					}
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
			public void «Utils.getCodeName(irRoot.main)»()
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
					assert(o.has("mesh"));
					«irRoot.mesh.className» mesh = new «irRoot.mesh.className»();
					mesh.jsonInit(o.get("mesh").toString());

					// Module instanciation(s)
					«FOR m : irRoot.modules»
						«m.instanciation»
					«ENDFOR»

					// Start simulation
					«name».simulate();
					«IF levelDB»

					«val dbName = irRoot.name + "DB"»
					// Non regression testing
					if («name».«nrName» != null && «name».«nrName».equals("«IrUtils.NonRegressionValues.CreateReference.toString»"))
						«name».createDB("«dbName».ref");
					if («name».«nrName» != null && «name».«nrName».equals("«IrUtils.NonRegressionValues.CompareToReference.toString»"))
					{
						«name».createDB("«dbName».current");
						boolean ok = LevelDBUtils.compareDB("«dbName».current", "«dbName».ref");
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
			«IF levelDB»

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
					batch.put(bytes("«Utils.getDbKey(v)»"), LevelDBUtils.serialize(«Utils.getDbValue(it, v, '.')»));
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
		«className» «name» = new «className»(mesh);
		if (o.has("«name»")) «name».jsonInit(o.get("«name»").toString());
		«IF !main»«name».setMainModule(«irRoot.mainModule.name»);«ENDIF»
	'''

	private def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty)
			'''mesh.getNb«c.name.toFirstUpper»()'''
		else
			'''CartesianMesh2D.MaxNb«c.name.toFirstUpper»'''
	}

	private def isLevelDB(IrModule it)
	{
		main && hasLevelDB
	}

	private def getWriteCallContent(Variable v)
	{
		val t = v.type
		switch t
		{
			ConnectivityType: '''«v.name»«formatIteratorsAndIndices(t, #["i"])»'''
			LinearAlgebraType: '''«v.name».getValue(i)'''
			default: throw new RuntimeException("Unexpected type: " + class.name)
		}
	}
}