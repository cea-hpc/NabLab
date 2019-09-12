/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Scalar
import fr.cea.nabla.ir.ir.SimpleVariable

import static extension fr.cea.nabla.ir.VariableExtensions.*
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

		«val linearAlgebraVars = variables.filter(ConnectivityVariable).filter[linearAlgebra]»
		«IF !linearAlgebraVars.empty»
		import org.apache.commons.math3.linear.*;
		
		«ENDIF»
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
			private int iteration;

			// Mesh
			private final NumericMesh2D mesh;
			«FOR c : usedConnectivities BEFORE 'private final int ' SEPARATOR ', '»«c.nbElems»«ENDFOR»;
			private final VtkFileWriter2D writer;

			// Global Variables
			«val globals = variables.filter(SimpleVariable).filter[!const]»
			«val globalsByType = globals.groupBy[javaType]»
			«FOR type : globalsByType.keySet»
			private «type» «FOR v : globalsByType.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
			«ENDFOR»
			«val connectivityVars = variables.filter(ConnectivityVariable).filter[!linearAlgebra].groupBy[javaType]»
			«IF !connectivityVars.empty»
			
			// Connectivity Variables
			«FOR type : connectivityVars.keySet»
			private «type» «FOR v : connectivityVars.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
			«ENDFOR»
			«ENDIF»
			«IF !linearAlgebraVars.empty»
			
			// Linear Algebra Variables
			«FOR m : linearAlgebraVars»
			private «m.javaType» «m.name»;
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
						«IF a.linearAlgebra»
							«a.name» = «a.linearAlgebraDefinition»;
						«ELSE»
							«a.name» = new «a.type.primitive.javaType»«FOR d : a.supports»[«d.nbElems»]«ENDFOR»«a.type.dimensionContent»;
						«ENDIF»
					«ELSEIF a instanceof SimpleVariable && !(a.type instanceof Scalar)»
						«a.name» = new «a.type.primitive.javaType»«a.type.dimensionContent»;
					«ENDIF»
				«ENDFOR»

				«IF nodeCoordVariable !== null»
				// Copy node coordinates
				ArrayList<double[]> gNodes = mesh.getGeometricMesh().getNodes();
				IntStream.range(0, nbNodes).parallel().forEach(rNodes -> «nodeCoordVariable.name»[rNodes] = gNodes.get(rNodes));
				«ENDIF»
			}

			public void simulate()
			{
				System.out.println("Début de l'exécution du module «name»");
				«FOR j : jobs.filter[x | x.at < 0].sortBy[at]»
					«j.name.toFirstLower»(); // @«j.at»
				«ENDFOR»
				«IF jobs.exists[at > 0]»

				iteration = 0;
				while (t < options.option_stoptime && iteration < options.option_max_iterations)
				{
					iteration++;
					System.out.println("[" + iteration + "] t = " + t);
					«FOR j : jobs.filter[x | x.at > 0].sortBy[at]»
						«j.name.toFirstLower»(); // @«j.at»
					«ENDFOR»
				}
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
	
	private def getLinearAlgebraDefinition(ConnectivityVariable v)
	{
		switch v.supports.size
		{
			case 1: 'Vector.createDenseVector(' + v.supports.get(0).nbElems + ')'
			case 2: 'Matrix.createDenseMatrix(' + v.supports.map[nbElems].join(', ') + ')'
			default: throw new RuntimeException("Not implemented exception")
		}
	}

	private def dispatch String getDimensionContent(Array1D it) { '[' + size + ']' }
	private def dispatch String getDimensionContent(Array2D it) { '[' + nbRows + ', ' + nbCols + ']' }
}