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

import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.ScalarVariable
import java.util.ArrayList
import java.util.List

import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.Ir2JavaUtils.*
import static extension fr.cea.nabla.ir.generator.java.JobContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.VariableExtensions.*
import fr.cea.nabla.ir.generator.CodeGenerator

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
				«FOR v : variables.filter(ScalarVariable).filter[const]»
				public final «v.javaType» «v.name» = «v.defaultValue.content»;
				«ENDFOR»
			}
			
			private final Options options;

			// Mesh
			private final NumericMesh2D mesh;
			«FOR c : usedConnectivities BEFORE 'private final int ' SEPARATOR ', '»«c.nbElems»«ENDFOR»;
			private final VtkFileWriter2D writer;

			// Global Variables
			«val globals = variables.filter(ScalarVariable).filter[!const]»
			«val globalsByType = globals.groupBy[type]»
			«FOR type : globalsByType.keySet»
			private «type.javaType» «FOR v : globalsByType.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
			«ENDFOR»

			«val arrays = variables.filter(ArrayVariable).groupBy[type]»
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
				«FOR a : variables.filter(ArrayVariable)»
					«a.name» = new «a.type.javaType»«FOR d : a.dimensions»[«d.nbElems»]«ENDFOR»;
					«IF !a.type.javaBasicType»«allocate(a.dimensions, a.name, 'new ' + a.type.javaType + '(0.0)', new ArrayList<String>)»«ENDIF»
				«ENDFOR»

				«IF nodeCoordVariable !== null»
				// Copy node coordinates
				ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
				IntStream.range(0, nbNodes).parallel().forEach(rNodes -> «nodeCoordVariable.name»[rNodes] = gNodes.get(rNodes));
				«ENDIF»
			}
			
			«FOR j : jobs.sortBy[at] SEPARATOR '\n'»
				«j.content»
			«ENDFOR»			

			public void simulate()
			{
				System.out.println("Début de l'exécution du module «name»");
				«FOR j : jobs.filter[x | x.at < 0].sortBy[at]»
					«j.name.toFirstLower»(); // @«j.at»
				«ENDFOR»
				«IF jobs.exists[at > 0]»

				«val variablesToPersist = persistentArrayVariables»
				«IF !variablesToPersist.empty»
				HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
				HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
				«FOR v : variablesToPersist»
				«v.dimensions.head.returnType.type.name»Variables.put("«v.persistenceName»", «v.name»);
				«ENDFOR»
				«ENDIF»
				int iteration = 0;
				while (t < options.option_stoptime && iteration < options.option_max_iterations)
				{
					iteration++;
					System.out.println("[" + iteration + "] t = " + t);
					«FOR j : jobs.filter[x | x.at > 0].sortBy[at]»
						«j.name.toFirstLower»(); // @«j.at»
					«ENDFOR»
					«IF !variablesToPersist.empty»
					writer.writeFile(iteration, X, mesh.getGeometricMesh().getQuads(), cellVariables, nodeVariables);
					«ENDIF»
				}
				«ENDIF»
				System.out.println("Fin de l'exécution du module «name»");
			}

			public static void main(String[] args)
			{
				«name».Options o = new «name».Options();
				Mesh<Real2> gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.LENGTH, o.LENGTH);
				NumericMesh2D nm = new NumericMesh2D(gm);
				«name» i = new «name»(o, nm);
				i.simulate();
			}
		};
	'''
	
	private def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty)
			'''mesh.getNb«c.name.toFirstUpper»()'''
		else
			'''NumericMesh2D.MaxNb«c.name.toFirstUpper»'''
	}
	
	private def CharSequence allocate(Iterable<Connectivity> connectivities, String varName, String allocation, List<String> indexes)
	{
		if (connectivities.empty) '''«varName»«FOR i:indexes»[«i»]«ENDFOR» = «allocation»;'''
		else 
		{
			val c = connectivities.head
			indexes.add(c.indexName)
			'''
				IntStream.range(0, «c.nbElems»).parallel().forEach(«c.indexName» -> 
				{
					«connectivities.tail.allocate(varName, allocation, indexes)»
				});
			'''
		}
	}
	
	private def getIndexName(Connectivity c) { 'i' + c.name.toFirstUpper }
	private def getPersistentArrayVariables(IrModule it) { variables.filter(ArrayVariable).filter[x|x.persist && x.dimensions.size==1] }
}