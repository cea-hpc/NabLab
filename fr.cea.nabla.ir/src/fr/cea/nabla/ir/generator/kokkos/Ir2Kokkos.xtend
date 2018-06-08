package fr.cea.nabla.ir.generator.kokkos

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ScalarVariable
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Connectivity

class Ir2Kokkos 
{
	@Inject extension Utils
	@Inject extension Ir2KokkosUtils
	@Inject extension ExpressionContentProvider
	@Inject extension JobContentProvider
	@Inject extension VariableExtensions

	def getFileContent(IrModule it, String className)
	'''
	#include <iostream>

	// Kokkos headers
	#include <Kokkos_Core.hpp>

	// Project headers
	#include "mesh/NumericMesh2D.h"
	#include "mesh/CartesianMesh2DGenerator.h"
	#include "types/MathFunctions.h"

	using namespace nablalib;

	struct «className»Options
	{
		«FOR v : variables.filter(ScalarVariable).filter[const]»
			«v.kokkosType» «v.name» = «v.defaultValue.content»;
		«ENDFOR»
	};
	
	class «className»
	{
	private:
		«className»Options* options;
		NumericMesh2D* mesh;
		«FOR c : usedConnectivities BEFORE 'int ' SEPARATOR ', '»«c.nbElems»«ENDFOR»;

		// Global Variables
		«val globals = variables.filter(ScalarVariable).filter[!const].groupBy[type]»
		«FOR type : globals.keySet»
		«type.kokkosType» «FOR v : globals.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
		«ENDFOR»

		«val arrays = variables.filter(ArrayVariable)»
		«IF !arrays.empty»
		// Array Variables
		«FOR a : arrays»
		Kokkos::View<«a.type.kokkosType»«a.dimensions.map['*'].join»> «a.name»;
		«ENDFOR»
		«ENDIF»

	public:
		«className»(«className»Options* o, NumericMesh2D* m)
		: options(o)
		, mesh(m)
		«FOR c : usedConnectivities»
		, «c.nbElems»(«c.connectivityAccessor»)
		«ENDFOR»
		«FOR a : arrays»
		, «a.name»("«a.name»", «FOR d : a.dimensions SEPARATOR ', '»«d.nbElems»«ENDFOR»)
		«ENDFOR»
		{
			// Copy node coordinates
			auto gNodes = m->getGeometricMesh()->getNodes();
			Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
			{
				X(rNodes) = gNodes[rNodes];
			});
		}

	private:
		«FOR j : jobs.sortBy[at] SEPARATOR '\n'»
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
			while (t < options->option_stoptime && iteration < options->option_max_iterations)
			{
				std::cout << "A t = " << t << std::endl;
				iteration++;
				«FOR j : jobs.filter[x | x.at > 0].sortBy[at]»
					«j.name.toFirstLower»(); // @«j.at»
				«ENDFOR»
			}
			std::cout << "Fin de l'exécution du module «name»" << std::endl;
		}	
	};
	
	int main(int argc, char* argv[]) 
	{
		Kokkos::initialize(argc, argv);
		auto options = new «className»Options();
		auto geometricMesh = CartesianMesh2DGenerator::generate(options->X_EDGE_ELEMS, options->Y_EDGE_ELEMS, options->LENGTH, options->LENGTH);
		auto numericMesh = new NumericMesh2D(geometricMesh);
		«className» c(options, numericMesh);
		c.simulate();
		delete numericMesh;
		delete geometricMesh;
		delete options;
		Kokkos::finalize();
	}
	'''
	
	private def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty)
			'''mesh->getNb«c.name.toFirstUpper»()'''
		else
			'''NumericMesh2D::MaxNb«c.name.toFirstUpper»'''
	}
}