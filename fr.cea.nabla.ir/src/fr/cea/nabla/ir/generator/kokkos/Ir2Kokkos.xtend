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
package fr.cea.nabla.ir.generator.kokkos

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

class Ir2Kokkos extends IrGenerator
{
	static val TransformationSteps = #[new ReplaceUtf8Chars, new ReplaceInternalReductions, new OptimizeConnectivities, new FillJobHLTs]

	@Inject extension Utils
	@Inject extension Ir2KokkosUtils
	@Inject extension ExpressionContentProvider
	@Inject extension JobContentProvider
	@Inject extension VariableExtensions

	new() 
	{ 
		super('kokkos', 'cc', TransformationSteps)
	}

	override getFileContent(IrModule it)
	'''
	#include <iostream>
	#include <iomanip>
	#include <type_traits>
	#include <limits>
	#include <utility>
	#include <cmath>
	#include <cfenv>
	#pragma STDC FENV_ACCESS ON

	// Kokkos headers
	#include <Kokkos_Core.hpp>
	#include <Kokkos_hwloc.hpp>

	// Project headers
	#include "mesh/NumericMesh2D.h"
	#include "mesh/CartesianMesh2DGenerator.h"
	#include "mesh/VtkFileWriter2D.h"
	#include "utils/Utils.h"
	#include "utils/Timer.h"
	#include "types/Types.h"
	#include "types/MathFunctions.h"
	«IF functions.exists[f | f.provider == name]»#include "«name.toLowerCase»/«name»Functions.h"«ENDIF»

	using namespace nablalib;

	class «name»
	{
	public:
		struct Options
		{
			«FOR v : variables.filter(ScalarVariable).filter[const]»
				«v.kokkosType» «v.name» = «v.defaultValue.content»;
			«ENDFOR»
		};
		Options* options;
	
	private:
		NumericMesh2D* mesh;
		VtkFileWriter2D writer;
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
		Kokkos::View<«a.kokkosType»> «a.name»;
		«ENDFOR»
		«ENDIF»
		
		typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;
		const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();

	public:
		«name»(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
		: options(aOptions)
		, mesh(aNumericMesh2D)
		, writer("«name»", output)
		«FOR c : usedConnectivities»
		, «c.nbElems»(«c.connectivityAccessor»)
		«ENDFOR»
		«FOR a : arrays»
		, «a.name»("«a.name»", «FOR d : a.dimensions SEPARATOR ', '»«d.nbElems»«ENDFOR»)
		«ENDFOR»
		{
			«IF nodeCoordVariable !== null»
			// Copy node coordinates
			const auto& gNodes = mesh->getGeometricMesh()->getNodes();
			Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
			{
				«nodeCoordVariable.name»(rNodes) = gNodes[rNodes];
			});
			«ENDIF»
		}

	private:
		/**
		 * Utility function to get work load for each team of threads
		 * In : thread and number of element to use for computation
		 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
		 */
		const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const int& nb_elmt) noexcept {
	//	  if (nb_elmt % thread.team_size()) {
	//	    std::cerr << "[ERROR] nb of elmt (" << nb_elmt << ") not multiple of nb of thread per team ("
	//	              << thread.team_size() << ")" << std::endl;
	//	    std::terminate();
	//	  }
		  // Size
	    size_t team_chunk(std::floor(nb_elmt / thread.league_size()));
	    // Offset
	    const size_t team_offset(thread.league_rank() * team_chunk);
	    // Last team get remaining work
	    if (thread.league_rank() == thread.league_size() - 1) {
	      size_t left_over(nb_elmt - (team_chunk * thread.league_size()));
	      team_chunk += left_over;
	    }
	    return std::pair<size_t, size_t>(team_offset, team_chunk);
		}

		«FOR j : jobs.sortBy[at] SEPARATOR '\n'»
			«j.content»
		«ENDFOR»			

	public:
		void simulate()
		{
			auto team_policy(Kokkos::TeamPolicy<>(
				Kokkos::hwloc::get_available_numa_count(),
				Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));
			
			std::cout << "Début de l'exécution du module «name»" << std::endl;
			«jobs.filter[x | x.at < 0].jobCallsContent»
	
			«val variablesToPersist = persistentArrayVariables»
			«IF !variablesToPersist.empty»
			map<string, Kokkos::View<double*>> cellVariables;
			map<string, Kokkos::View<double*>> nodeVariables;
			«FOR v : variablesToPersist»
			«v.dimensions.head.returnType.type.name»Variables.insert(pair<string,Kokkos::View<double*>>("«v.persistenceName»", «v.name»));
			«ENDFOR»
			«ENDIF»
			int iteration = 0;
			while (t < options->option_stoptime && iteration < options->option_max_iterations)
			{
				iteration++;
				std::cout << "[" << iteration << "] t = " << t << std::endl;
				«jobs.filter[x | x.at > 0].jobCallsContent»
				«IF !variablesToPersist.empty»
				auto quads = mesh->getGeometricMesh()->getQuads();
				writer.writeFile(iteration, X, quads, cellVariables, nodeVariables);
				«ENDIF»
			}
			std::cout << "Fin de l'exécution du module «name»" << std::endl;
		}	
	};	

	int main(int argc, char* argv[]) 
	{
		Kokkos::initialize(argc, argv);
		auto o = new «name»::Options();
		auto gm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->LENGTH, o->LENGTH);
		auto nm = new NumericMesh2D(gm);
		auto c = new «name»(o, nm);
		c->simulate();
		delete c;
		delete nm;
		delete gm;
		delete o;
		Kokkos::finalize();
		return 0;
	}
	'''
	
	private def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty)
			'''mesh->getNb«c.name.toFirstUpper»()'''
		else
			'''NumericMesh2D::MaxNb«c.name.toFirstUpper»'''
	}

	private def getPersistentArrayVariables(IrModule it) { variables.filter(ArrayVariable).filter[x|x.persist && x.dimensions.size==1] }
}