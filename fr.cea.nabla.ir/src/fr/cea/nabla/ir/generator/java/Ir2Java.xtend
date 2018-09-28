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

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.IrGenerator
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.ScalarVariable
import fr.cea.nabla.ir.transformers.FillJobHLTs
import fr.cea.nabla.ir.transformers.OptimizeConnectivities
import fr.cea.nabla.ir.transformers.ReplaceInternalReductions
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import java.util.ArrayList
import java.util.List

class Ir2Java implements IrGenerator
{
	static val FileExtension = 'java'
	static val TransformationSteps = #[new ReplaceUtf8Chars, new ReplaceInternalReductions, new OptimizeConnectivities, new FillJobHLTs]

	@Inject extension Utils
	@Inject extension Ir2JavaUtils
	@Inject extension ExpressionContentProvider
	@Inject extension JobContentProvider
	@Inject extension VariableExtensions

	override getFileExtension() { FileExtension }
	override getTransformationSteps() { TransformationSteps }
	
	/**
	 * TODO améliorer le scope des itérateurs de reduction
	 * TODO reporter les annotations en infos de debug. Comment ?
	 * TODO : filtrer les propositions de complétion pour l'itérateur en fonction du type
	 * TODO bug : operator multiply (1 / 4) -> appel multiply (int avec v=0) au lieu de multiply(double)
	 * TODO : parallélisme de taches du graphe en Kokkos et Java.
	 */
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
			«val initializedGlobals = globals.filter[x|x.defaultValue!==null]»
			«FOR uv : initializedGlobals»
			private «uv.type.javaType» «uv.name» = «uv.defaultValue.content»;
			«ENDFOR»
			«val uninitializedGlobals = globals.filter[x|x.defaultValue===null].groupBy[type]»
			«FOR type : uninitializedGlobals.keySet»
			private «type.javaType» «FOR v : uninitializedGlobals.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
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
				«FOR c : usedConnectivities»
				«c.nbElems» = «c.connectivityAccessor»;
				«ENDFOR»
				writer = new VtkFileWriter2D("«name»");

				// Arrays allocation
				«FOR a : variables.filter(ArrayVariable)»
					«a.name» = new «a.type.javaType»«FOR d : a.dimensions»[«d.nbElems»]«ENDFOR»;
					«IF !a.type.javaBasicType»«allocate(a.dimensions, a.name, 'new ' + a.type.javaType + '(0.0)', new ArrayList<String>)»«ENDIF»
				«ENDFOR»

				«IF variables.exists[x | x.name == 'coord']»
				// Copy node coordinates
				ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
				IntStream.range(0, nbNodes).parallel().forEach(rNodes -> coord[rNodes] = gNodes.get(rNodes));
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
				
				HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
				cellVariables.put("Density", rho);
				int iteration = 0;
				while (t < options.option_stoptime && iteration < options.option_max_iterations)
				{
					System.out.println("t = " + t);
					iteration++;
					«FOR j : jobs.filter[x | x.at > 0].sortBy[at]»
						«j.name.toFirstLower»(); // @«j.at»
					«ENDFOR»
					writer.writeFile(iteration, X, mesh.getGeometricMesh().getQuads(), cellVariables, null);
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
}