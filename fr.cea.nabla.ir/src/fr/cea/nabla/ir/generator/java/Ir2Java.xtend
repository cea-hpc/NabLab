package fr.cea.nabla.ir.generator.java

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.ScalarVariable
import java.util.ArrayList
import java.util.List

class Ir2Java 
{
	@Inject extension Utils
	@Inject extension Ir2JavaUtils
	@Inject extension ExpressionContentProvider
	@Inject extension JobContentProvider
	@Inject extension VariableExtensions
	
	/**
	 * TODO reporter les annotations en infos de debug. Comment ?
	 * TODO : faire un mailleur 3D
	 * TODO : filtrer les propositions de complétion pour l'itérateur en fonction du type
	 * TODO bug : operator multiply (1 / 4) -> appel multiply (int avec v=0) au lieu de multiply(double)
	 * TODO : option de la bibliothèque de maillage pour savoir si les index sont consécutifs
	 * TODO : parallélisme de taches du graphe en Kokkos et Java.
	 */
	def getFileContent(IrModule it, String className)
	'''
		package «name»;
		
		import java.util.ArrayList;
		import java.util.stream.IntStream;

		import fr.cea.nabla.javalib.types.*;
		import fr.cea.nabla.javalib.mesh.*;

		@SuppressWarnings("all")
		public final class «className»
		{
			// Options
			«FOR v : variables.filter(ScalarVariable).filter[const]»
				public final «v.javaType» «v.name» = «v.defaultValue.content»;
			«ENDFOR»
		
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
			
			public «className»()
			{
				// Mesh allocation
				Mesh<Real2> geometricMesh = CartesianMesh2DGenerator.generate(X_EDGE_ELEMS, Y_EDGE_ELEMS, LENGTH, LENGTH);
				mesh = new NumericMesh2D(geometricMesh);
				«FOR c : usedConnectivities»
				«c.nbElems» = «c.connectivityAccessor»;
				«ENDFOR»
				writer = new VtkFileWriter2D("ParallelWhiteHeat", geometricMesh);

				// Arrays allocation
				«FOR a : variables.filter(ArrayVariable)»
					«a.name» = new «a.type.javaType»«FOR d : a.dimensions»[«d.nbElems»]«ENDFOR»;
					«IF !a.type.javaBasicType»«allocate(a.dimensions, a.name, 'new ' + a.type.javaType + '(0.0)', new ArrayList<String>)»«ENDIF»
				«ENDFOR»

				// Copy node coordinates
				ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
				IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X[rNodes] = gNodes.get(rNodes));
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
				
				int iteration = 0;
				while (t < option_stoptime && iteration < option_max_iterations)
				{
					System.out.println("t = " + t);
					iteration++;
					«FOR j : jobs.filter[x | x.at > 0].sortBy[at]»
						«j.name.toFirstLower»(); // @«j.at»
					«ENDFOR»
					writer.writeFile(iteration);
				}
				System.out.println("Fin de l'exécution du module «name»");
			}

			public static void main(String[] args)
			{
				«className» i = new «className»();
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