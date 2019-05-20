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

import fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism.HierarchicalJobContentProvider
import fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism.HierarchicalParallelismUtils
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.ScalarVariable

import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.kokkos.Ir2KokkosUtils.*
import static extension fr.cea.nabla.ir.generator.kokkos.VariableExtensions.*
import fr.cea.nabla.ir.generator.CodeGenerator

class Ir2Kokkos extends CodeGenerator
{
	extension JobContentProvider jcp

	new(JobContentProvider jcp) 
	{ 
		super('kokkos', 'cc')
		this.jcp = jcp
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
		«val globals = variables.filter(ScalarVariable).filter[!const]»
		«val globalsByType = globals.groupBy[type]»
		«FOR type : globalsByType.keySet»
		«type.kokkosType» «FOR v : globalsByType.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
		«ENDFOR»

		«val arrays = variables.filter(ArrayVariable)»
		«IF !arrays.empty»
		// Array Variables
		«FOR a : arrays»
		Kokkos::View<«a.kokkosType»> «a.name»;
		«ENDFOR»
		«ENDIF»
		
		«IF (jcp instanceof HierarchicalJobContentProvider)»
		typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;
		«ELSE»
		const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();
		«ENDIF»

	public:
		«name»(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
		: options(aOptions)
		, mesh(aNumericMesh2D)
		, writer("«name»", output)
		«FOR c : usedConnectivities»
		, «c.nbElems»(«c.connectivityAccessor»)
		«ENDFOR»
		«FOR uv : globals.filter[x|x.defaultValue!==null]»
		, «uv.name»(«uv.defaultValue.content»)
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
		«IF (jcp instanceof HierarchicalJobContentProvider)»
			«HierarchicalParallelismUtils::teamWorkRange»

		«ENDIF»
		«FOR j : jobs.sortBy[at] SEPARATOR '\n'»
			«j.content»
		«ENDFOR»			

	public:
		void simulate()
		{
			std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting «name» ..." << __RESET__ << "\n\n";

			std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options->X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options->Y_EDGE_ELEMS
				<< __RESET__ << ", length=" << __BOLD__ << options->LENGTH << __RESET__ << std::endl;


			if (Kokkos::hwloc::available()) {
				std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_numa_count()
					<< __RESET__ << ", Cores/NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_cores_per_numa()
					<< __RESET__ << ", Threads/Core=" << __BOLD__ << Kokkos::hwloc::get_available_threads_per_core() << __RESET__ << std::endl;
			} else {
				std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
			}

			// std::cout << "[" << __GREEN__ << "KOKKOS" << __RESET__ << "]    " << __BOLD__ << (is_same<MyLayout,Kokkos::LayoutLeft>::value?"Left":"Right")" << __RESET__ << " layout" << std::endl;

			if (!writer.isDisabled())
				std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
			else
				std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

			utils::Timer timer(true);

			«IF (jcp instanceof HierarchicalJobContentProvider)»
				«HierarchicalParallelismUtils::teamPolicy»

			«ENDIF»			
			«jobs.filter[x | x.at < 0].jobCallsContent»	
			«IF jobs.exists[at > 0]»
			«val variablesToPersist = persistentArrayVariables»
			«IF !variablesToPersist.empty»
			std::map<string, double*> cellVariables;
			std::map<string, double*> nodeVariables;
			«FOR v : variablesToPersist»
			«v.dimensions.head.returnType.type.name»Variables.insert(pair<string,double*>("«v.persistenceName»", «v.name».data()));
			«ENDFOR»
			
			«ENDIF»
			timer.stop();
			int iteration = 0;
			while (t < options->option_stoptime && iteration < options->option_max_iterations)
			{
				timer.start();
				utils::Timer compute_timer(true);
				iteration++;
				if (iteration!=1)
					std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << iteration << __RESET__ "] t = " << __BOLD__
						<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t << __RESET__;

				«jobs.filter[x | x.at > 0].jobCallsContent»
				compute_timer.stop();

				«IF !variablesToPersist.empty»
				if (!writer.isDisabled()) {
					utils::Timer io_timer(true);
					auto quads = mesh->getGeometricMesh()->getQuads();
					writer.writeFile(iteration, nbNodes, X.data(), nbCells, quads.data(), cellVariables, nodeVariables);
					io_timer.stop();
					std::cout << " {CPU: " << __BLUE__ << compute_timer.print(true) << __RESET__ ", IO: " << __BLUE__ << io_timer.print(true) << __RESET__ "} ";
				} else {
					std::cout << " {CPU: " << __BLUE__ << compute_timer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";
				}
				«ENDIF»
				// Progress
				std::cout << utils::progress_bar(iteration, options->option_max_iterations, t, options->option_stoptime, 30);
				timer.stop();
				std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
					utils::eta(iteration, options->option_max_iterations, t, options->option_stoptime, deltat, timer), true)
					<< __RESET__ << "\r";
				std::cout.flush();
			}
			std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << timer.print() << __RESET__ << std::endl;
			«ELSE /* no jobs with at > 0 */»
			timer.stop();
			«ENDIF»
		}
	};	

	int main(int argc, char* argv[]) 
	{
		Kokkos::initialize(argc, argv);
		auto o = new «name»::Options();
		string output;
		if (argc == 4) {
			o->X_EDGE_ELEMS = std::atoi(argv[1]);
			o->Y_EDGE_ELEMS = std::atoi(argv[2]);
			o->LENGTH = std::atof(argv[3]);
		} else if (argc == 5) {
			o->X_EDGE_ELEMS = std::atoi(argv[1]);
			o->Y_EDGE_ELEMS = std::atoi(argv[2]);
			o->LENGTH = std::atof(argv[3]);
			output = argv[4];
		} else if (argc != 1) {
			std::cerr << "[ERROR] Wrong number of arguments. Expecting 3 or 4 args: X Y length (output)." << std::endl;
			std::cerr << "(X=100, Y=10, length=0.01 output=current directory with no args)" << std::endl;
		}
		auto gm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->LENGTH, o->LENGTH);
		auto nm = new NumericMesh2D(gm);
		auto c = new «name»(o, nm, output);
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