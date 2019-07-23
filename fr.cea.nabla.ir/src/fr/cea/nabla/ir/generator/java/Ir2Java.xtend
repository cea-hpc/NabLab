/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable

import static extension fr.cea.nabla.ir.BaseTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.Ir2JavaUtils.*
import static extension fr.cea.nabla.ir.generator.java.JobContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.VariableExtensions.*

class Ir2Java extends CodeGenerator
{
	new() { super('java', 'java') }
	
	override getFileContent(IrModule it)
	'''
		package «name.toLowerCase»;
		
		import java.util.HashMap;
		import java.util.Arrays;
		import java.util.ArrayList;
		import java.util.stream.IntStream;

		import fr.cea.nabla.javalib.Utils;
		import fr.cea.nabla.javalib.types.*;
		import fr.cea.nabla.javalib.mesh.*;

		@SuppressWarnings("all")
		public final class «name»
		{
			public final static class Options
			{
				«FOR v : variables.filter(SimpleVariable).filter[const]»
				public final «v.javaType» «v.name» = «v.defaultValue.content.toString.replaceAll('options.', '')»;
				«ENDFOR»
			}
			
			private final Options options;

			// Mesh
			private final NumericMesh2D mesh;
			«FOR c : usedConnectivities BEFORE 'private final int ' SEPARATOR ', '»«c.nbElems»«ENDFOR»;
			private final VtkFileWriter2D writer;

			// Global Variables
			«val globals = variables.filter(SimpleVariable).filter[!const]»
			«val globalsByType = globals.groupBy[type.javaType]»
			«FOR type : globalsByType.keySet»
			private «type» «FOR v : globalsByType.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
			«ENDFOR»

			«val arrays = variables.filter(ConnectivityVariable).groupBy[type]»
			«IF !arrays.empty»
			// Array Variables
			«FOR type : arrays.keySet»
			private «type.javaType» «FOR v : arrays.get(type) SEPARATOR ', '»«v.name»«FOR i : 1..v.dimensions.length»[]«ENDFOR»«ENDFOR»;
			«ENDFOR»
			«ENDIF»
			
			public «name»(Options aOptions, NumericMesh2D aNumericMesh2D)
			{
				options = aOptions;
				mesh = aNumericMesh2D;
				writer = new VtkFileWriter2D("«name»");

				«FOR c : usedConnectivities»
				«c.nbElems» = «c.connectivityAccessor»;
				«ENDFOR»

				«FOR uv : globals.filter[x|x.defaultValue!==null]»
				«uv.name» = «uv.defaultValue.content»;
				«ENDFOR»

				// Arrays allocation
				«FOR a : variables.filter[!const]»
					«IF a instanceof ConnectivityVariable»
						«a.name» = new «a.type.root.javaType»«FOR d : a.dimensions»[«d.nbElems»]«ENDFOR»«FOR d : a.type.sizes»[«d»]«ENDFOR»;
					«ELSEIF a instanceof SimpleVariable && !a.type.scalar»
						«a.name» = new «a.type.root.javaType»«FOR d : a.type.sizes»[«d»]«ENDFOR»;
					«ENDIF»
				«ENDFOR»

				«IF nodeCoordVariable !== null»
				// Copy node coordinates
				ArrayList<double[]> gNodes = mesh.getGeometricMesh().getNodes();
				IntStream.range(0, nbNodes).parallel().forEach(rNodes -> «nodeCoordVariable.name»[rNodes] = gNodes.get(rNodes));
				«ENDIF»
			}

			«val variablesToPersist = persistentVariables»
			public void simulate()
			{
				System.out.println("Début de l'exécution du module «name»");
				«FOR j : jobs.filter[x | x.at < 0].sortBy[at]»
					«j.name.toFirstLower»(); // @«j.at»
				«ENDFOR»
				«IF jobs.exists[at > 0]»

				int iteration = 0;
				while (t < options.option_stoptime && iteration < options.option_max_iterations)
				{
					iteration++;
					System.out.println("[" + iteration + "] t = " + t);
					«IF !variablesToPersist.empty»
					dumpVariables(iteration);
					«ENDIF»
					«FOR j : jobs.filter[x | x.at > 0].sortBy[at]»
						«j.name.toFirstLower»(); // @«j.at»
					«ENDFOR»
				}
				«IF !variablesToPersist.empty»
				dumpVariables(iteration);
				«ENDIF»
				«ENDIF»
				System.out.println("Fin de l'exécution du module «name»");
			}

			public static void main(String[] args)
			{
				«name».Options o = new «name».Options();
				Mesh<double[]> gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
				NumericMesh2D nm = new NumericMesh2D(gm);
				«name» i = new «name»(o, nm);
				i.simulate();
			}
			
			«IF !variablesToPersist.empty»
			private void dumpVariables(int iteration)
			{
				HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
				HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
				«FOR v : variablesToPersist»
				«v.dimensions.head.returnType.type.name»Variables.put("«v.persistenceName»", «v.name»);
				«ENDFOR»
				writer.writeFile(iteration, X, mesh.getGeometricMesh().getQuads(), cellVariables, nodeVariables);
			}

			«ENDIF»
			«FOR j : jobs.sortBy[at] SEPARATOR '\n'»
				«j.content»
			«ENDFOR»			
		};
	'''
	
	private def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty)
			'''mesh.getNb«c.name.toFirstUpper»()'''
		else
			'''NumericMesh2D.MaxNb«c.name.toFirstUpper»'''
	}
	
	private def getPersistentVariables(IrModule it) { variables.filter(ConnectivityVariable).filter[x|x.persist && x.dimensions.size==1] }
}