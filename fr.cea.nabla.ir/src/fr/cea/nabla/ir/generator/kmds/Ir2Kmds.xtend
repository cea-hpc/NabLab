package fr.cea.nabla.ir.generator.kmds

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ScalarVariable
import fr.cea.nabla.ir.ir.ArrayVariable

class Ir2Kmds 
{
	@Inject extension Utils
	@Inject extension Ir2KmdsUtils
	@Inject extension ExpressionContentProvider
	@Inject extension JobContentProvider
	@Inject extension VariableExtensions

	def getFileContent(IrModule it, String className)
	'''
	#include <iostream>
	// Kokkos headers
	#include <Kokkos_Core.hpp>
	// GMDS headers
	#include <KM/DS/Mesh.h>
	// GMDS math lib
	#include <GMDS/Math/VectorND.h>
	#include <GMDS/Math/Matrix.h>
	
	class «className»
	{
	public:
		// Options
		«FOR v : variables.filter(ScalarVariable).filter[const]»
			«v.kmdsType» «v.name» = «v.defaultValue.content»;
		«ENDFOR»

	private:
		// Mesh
		kmds::Mesh mesh;
		«FOR c : usedConnectivities BEFORE 'int ' SEPARATOR ', '»«c.nbElems»«ENDFOR»;
		
		// Global Variables
		«val globals = variables.filter(ScalarVariable).filter[!const].groupBy[type]»
		«FOR type : globals.keySet»
		«type.kmdsType» «FOR v : globals.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
		«ENDFOR»

		«val arrays = variables.filter(ArrayVariable).groupBy[type]»
		«IF !arrays.empty»
		// Array Variables
		«FOR type : arrays.keySet»
		private «type.kmdsType» «FOR v : arrays.get(type) SEPARATOR ', '»«v.name»«FOR i : 1..v.dimensions.length»[]«ENDFOR»«ENDFOR»;
		«ENDFOR»
		«ENDIF»

	public:
		«className»()
		{
			// Kokkos::Serial::initialize();
			// Kokkos::Threads::initialize();
			//Kokkos::InitArguments kargs;
			//kargs.num_threads = 3;
			int num_threads = 4;
			int use_numa = 1;
			int use_core = 1;
			Kokkos::OpenMP::initialize(num_threads, use_numa, use_core);
			//Kokkos::initialize(kargs);

			// Mesh allocation
			CartesianMesh2DGenerator::generate(&mesh, X_EDGE_ELEMS, Y_EDGE_ELEMS, LENGTH, LENGTH);
	
			// Create connectivity
			kmds::ConnectivityHelper ch(&mesh);
			kmds::Connectivity* N2F = mesh.createConnectivity(kmds::N2F);
			ch.buildN2F();
			//mesh.createEdges();
			//kmds::Connectivity* F2E = mesh.createConnectivity(kmds::F2E);
			//ch.buildF2E();
		}

		~«className»()
		{
			// Kokkos::Serial::finalize();
			// Kokkos::Threads::finalize();
			Kokkos::OpenMP::finalize();
			//Kokkos::finalize();
		}

	private:
		«FOR j : jobs.sortBy[at]»
			«j.content»
		«ENDFOR»			

	public:
		void simulate()
		{
			std::cout << "Début de l'exécution du module «name»" << std::endl;
			«FOR j : jobs.filter[x | x.at < 0].sortBy[at]»
				«j.name.toFirstLower»(); // @«j.at»
			«ENDFOR»
			
			int iteration = 0;
			while (t < option_stoptime && iteration < option_max_iterations)
			{
				std::cout << "t = " << t << std::endl;
				iteration++;
				«FOR j : jobs.filter[x | x.at > 0].sortBy[at]»
					«j.name.toFirstLower»(); // @«j.at»
				«ENDFOR»
			}
			std::cout << "Fin de l'exécution du module «name»" << std::endl;
		}	
	};
	
	int main() 
	{
		«className» i;
		i.simulate();
	}
	'''
}