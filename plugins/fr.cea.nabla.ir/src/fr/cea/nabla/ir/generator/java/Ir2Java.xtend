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

import fr.cea.nabla.ir.MandatoryOptions
import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.FunctionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.JobContentProvider.*

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

		import java.io.FileNotFoundException;
		import java.io.FileReader;
		import java.util.HashMap;
		import java.util.stream.IntStream;

		import com.google.gson.Gson;
		import com.google.gson.GsonBuilder;
		import com.google.gson.stream.JsonReader;

		import fr.cea.nabla.javalib.types.*;
		«IF withMesh»
		import fr.cea.nabla.javalib.mesh.*;
		«ENDIF»

		«IF linearAlgebra»
		import org.apache.commons.math3.linear.*;

		«ENDIF»
		@SuppressWarnings("all")
		public final class «name»
		{
			public final static class Options
			{
				«FOR v : options»
				public «v.javaType» «v.name»;
				«ENDFOR»
		
				public static Options createOptions(String jsonFileName) throws FileNotFoundException
				{
					Gson gson = new Gson();
					JsonReader reader = new JsonReader(new FileReader(jsonFileName));
					return gson.fromJson(reader, Options.class);
				}
			}

			private final Options options;

			«IF withMesh»
			// Mesh
			private final CartesianMesh2D mesh;
			private final FileWriter writer;
			«FOR c : usedConnectivities BEFORE 'private final int ' SEPARATOR ', '»«c.nbElemsVar»«ENDFOR»;
			«ENDIF»

			// Global Variables
			«FOR v : variables»
			private «IF v.const»final «ENDIF»«v.javaType» «v.name»;
			«ENDFOR»

			public «name»(Options aOptions«IF withMesh», CartesianMesh2D aCartesianMesh2D«ENDIF»)
			{
				options = aOptions;
				«IF withMesh»
				mesh = aCartesianMesh2D;
				writer = new PvdFileWriter2D("«name»");
				«FOR c : usedConnectivities»
				«c.nbElemsVar» = «c.connectivityAccessor»;
				«ENDFOR»
				«ENDIF»

				// Initialize variables
				«FOR v : variables»
					«IF v instanceof SimpleVariable && (v as SimpleVariable).defaultValue !== null»
						«v.name» = «(v as SimpleVariable).defaultValue.content»;
					«ELSEIF !v.type.scalar»
						«IF v.linearAlgebra»
							«v.name» = «(v as ConnectivityVariable).linearAlgebraDefinition»;
						«ELSE»
							«v.name»«v.javaAllocation»;
						«ENDIF»
					«ENDIF»
				«ENDFOR»
				«IF withMesh»

				// Copy node coordinates
				double[][] gNodes = mesh.getGeometry().getNodes();
				IntStream.range(0, nbNodes).parallel().forEach(rNodes -> {
					«initNodeCoordVariable.name»[rNodes][0] = gNodes[rNodes][0];
					«initNodeCoordVariable.name»[rNodes][1] = gNodes[rNodes][1];
				});
				«ENDIF»
			}

			public void simulate()
			{
				System.out.println("Start execution of module «name»");
				«FOR j : jobs.filter[topLevel].sortByAtAndName»
					«j.codeName»(); // @«j.at»
				«ENDFOR»
				System.out.println("End of execution of module «name»");
			}

			public static void main(String[] args) throws FileNotFoundException
			{
				if (args.length == 1)
				{
					String dataFileName = args[0];
					«name».Options o = «name».Options.createOptions(dataFileName);
					«IF withMesh»
					CartesianMesh2D mesh = CartesianMesh2DGenerator.generate(o.«MandatoryOptions::X_EDGE_ELEMS», o.«MandatoryOptions::Y_EDGE_ELEMS», o.«MandatoryOptions::X_EDGE_LENGTH», o.«MandatoryOptions::Y_EDGE_LENGTH»);
					«ENDIF»
					«name» i = new «name»(o«IF withMesh», mesh«ENDIF»);
					i.simulate();
				}
				else
				{
					System.out.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
					System.out.println("        Expecting user data file name, for example «name»DefaultOptions.json");
				}
			}
			«FOR j : jobs.sortByAtAndName»

				«j.content»
			«ENDFOR»
			«FOR f : functions.filter(Function).filter[body !== null]»

				«f.content»
			«ENDFOR»
			«IF postProcessingInfo !== null»

			private void dumpVariables(int iteration)
			{
				if («postProcessingInfo.lastDumpVariable.name» < 0 || «postProcessingInfo.periodVariable.name» >= «postProcessingInfo.lastDumpVariable.name» + «postProcessingInfo.periodValue»)
				{
					HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
					HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
					«FOR v : postProcessingInfo.postProcessedVariables.filter(ConnectivityVariable)»
					«v.type.connectivities.head.returnType.name»Variables.put("«v.persistenceName»", «v.name»«IF v.linearAlgebra».toArray()«ENDIF»);
					«ENDFOR»
					writer.writeFile(iteration, «irModule.timeVariable.name», «irModule.nodeCoordVariable.name», mesh.getGeometry().getQuads(), cellVariables, nodeVariables);
					«postProcessingInfo.lastDumpVariable.name» = «postProcessingInfo.periodVariable.name»;
				}
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
}