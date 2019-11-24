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

import fr.cea.nabla.ir.MandatoryMeshOptions
import fr.cea.nabla.ir.MandatorySimulationOptions
import fr.cea.nabla.ir.MandatorySimulationVariables
import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.FunctionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.JobContentProvider.*

class Ir2Java extends CodeGenerator
{
	new() { super('java', 'java') }

	override getFileContent(IrModule it)
	'''
		package «name.toLowerCase»;

		import java.util.HashMap;
		import java.util.ArrayList;
		import java.util.stream.IntStream;

		import fr.cea.nabla.javalib.Utils;
		import fr.cea.nabla.javalib.types.*;
		«IF withMesh»
		import fr.cea.nabla.javalib.mesh.*;
		«ENDIF»

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

			«IF withMesh»
			// Mesh
			private final NumericMesh2D mesh;
			«FOR c : usedConnectivities BEFORE 'private final int ' SEPARATOR ', '»«c.nbElems»«ENDFOR»;
			private final FileWriter writer;
			«ENDIF»

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

			public «name»(Options aOptions«IF withMesh», NumericMesh2D aNumericMesh2D«ENDIF»)
			{
				options = aOptions;
				«IF withMesh»
				mesh = aNumericMesh2D;
				writer = new PvdFileWriter2D("«name»");
				«ENDIF»
				«FOR c : usedConnectivities»
				«c.nbElems» = «c.connectivityAccessor»;
				«ENDFOR»

				«FOR uv : globals.filter[x|x.defaultValue!==null]»
				«uv.name» = «uv.defaultValue.content»;
				«ENDFOR»

				// Allocate arrays
				«FOR a : variables.filter[!(type.scalar || const)]»
					«IF a.linearAlgebra»
						«a.name» = «(a as ConnectivityVariable).linearAlgebraDefinition»;
					«ELSE»
						«a.name»«a.javaAllocation»;
					«ENDIF»
				«ENDFOR»
				«IF withMesh»

				// Copy node coordinates
				ArrayList<double[]> gNodes = mesh.getGeometricMesh().getNodes();
				IntStream.range(0, nbNodes).parallel().forEach(rNodes -> «initCoordVariable.name»[rNodes] = gNodes.get(rNodes));
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
				while («MandatorySimulationVariables::TIME» < options.«MandatorySimulationOptions::STOP_TIME» && iteration < options.«MandatorySimulationOptions::MAX_ITERATIONS»)
				{
					iteration++;
					System.out.println("[" + iteration + "] t = " + «MandatorySimulationVariables::TIME»);
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
				«IF withMesh»
				Mesh gm = CartesianMesh2DGenerator.generate(o.«MandatoryMeshOptions::X_EDGE_ELEMS», o.«MandatoryMeshOptions::Y_EDGE_ELEMS», o.«MandatoryMeshOptions::X_EDGE_LENGTH», o.«MandatoryMeshOptions::Y_EDGE_LENGTH»);
				NumericMesh2D nm = new NumericMesh2D(gm);
				«ENDIF»
				«name» i = new «name»(o«IF withMesh», nm«ENDIF»);
				i.simulate();
			}
			«FOR j : jobs.sortBy[at]»

				«j.content»
			«ENDFOR»
			«FOR f : functions.filter(Function).filter[body !== null]»

				«f.content»
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
		switch v.type.connectivities.size
		{
			case 1: 'Vector.createDenseVector(' + v.type.connectivities.get(0).nbElems + ')'
			case 2: 'Matrix.createDenseMatrix(' + v.type.connectivities.map[nbElems].join(', ') + ')'
			default: throw new RuntimeException("Not implemented exception")
		}
	}
}