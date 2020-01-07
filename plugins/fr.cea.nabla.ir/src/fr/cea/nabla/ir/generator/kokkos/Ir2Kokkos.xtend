/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.MandatoryOptions
import fr.cea.nabla.ir.MandatorySimulationOptions
import fr.cea.nabla.ir.MandatorySimulationVariables
import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism.HierarchicalJobContentProvider
import fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism.HierarchicalParallelismUtils
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable

import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.kokkos.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.kokkos.Ir2KokkosUtils.*

class Ir2Kokkos extends CodeGenerator
{
	val extension JobContentProvider jobContentProvider
	val extension FunctionContentProvider functionContentProvider

	new(JobContentProvider jcp) 
	{ 
		super('Kokkos')
		jobContentProvider = jcp
		functionContentProvider = new FunctionContentProvider(jcp.instructionContentProvider)
	}

	override getFileContentsByName(IrModule it)
	{
		#{ name + '.cc' -> ccFileContent, 'CMakeLists.txt' -> Ir2Cmake::getFileContent(it)}
	}

	private def getCcFileContent(IrModule it)
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
	«IF withMesh»
	#include "mesh/NumericMesh2D.h"
	#include "mesh/CartesianMesh2DGenerator.h"
	#include "mesh/PvdFileWriter2D.h"
	«ENDIF»
	#include "utils/Utils.h"
	#include "utils/Timer.h"
	#include "types/Types.h"
	#include "types/MathFunctions.h"
	#include "types/ArrayOperations.h"
	«IF functions.exists[f | f.body === null && f.provider == name]»#include "«name.toLowerCase»/«name»«Utils::FunctionReductionPrefix».h"«ENDIF»
	«val linearAlgebraVars = variables.filter(ConnectivityVariable).filter[linearAlgebra]»
	«IF !linearAlgebraVars.empty»
	#include "types/LinearAlgebraFunctions.h"
	«ENDIF»

	using namespace nablalib;

	class «name»
	{
	public:
		struct Options
		{
			// Should be const but usefull to set them from main args
			«FOR v : variables.filter(SimpleVariable).filter[const]»
				«v.cppType» «v.name» = «v.defaultValue.content.toString.replaceAll('options->', '')»;
			«ENDFOR»
		};
		Options* options;

	private:
		«IF withMesh»
		NumericMesh2D* mesh;
		FileWriter writer;
		«FOR c : usedConnectivities BEFORE 'int ' SEPARATOR ', '»«c.nbElems»«ENDFOR»;
		«ENDIF»

		// Global Variables
		«val globals = variables.filter(SimpleVariable).filter[!const]»
		«val globalsByType = globals.groupBy[type.primitive.cppType]»
		«FOR type : globalsByType.keySet»
		«type» «FOR v : globalsByType.get(type) SEPARATOR ', '»«v.name»«ENDFOR»;
		«ENDFOR»
		«val connectivityVars = variables.filter(ConnectivityVariable).filter[!linearAlgebra]»
		«IF !connectivityVars.empty»

		// Connectivity Variables
		«FOR a : connectivityVars»
		«a.cppType» «a.name»;
		«ENDFOR»
		«ENDIF»
		«IF !linearAlgebraVars.empty»
		
		// Linear Algebra Variables
		«FOR m : linearAlgebraVars»
		«m.cppType» «m.name»;
		«ENDFOR»
		«ENDIF»

		«IF (threadTeam)»
		typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;
		«ELSE»
		const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();
		«ENDIF»

	public:
		«name»(Options* aOptions, «IF withMesh»NumericMesh2D* aNumericMesh2D,«ENDIF» string output)
		: options(aOptions)
		«IF withMesh»
		, mesh(aNumericMesh2D)
		, writer("«name»")
		«ENDIF»
		«FOR c : usedConnectivities»
		, «c.nbElems»(«c.connectivityAccessor»)
		«ENDFOR»
		«FOR uv : globals.filter[x|x.defaultValue!==null]»
		, «uv.name»(«uv.defaultValue.content»)
		«ENDFOR»
		«FOR a : connectivityVars»
		, «a.name»("«a.name»", «FOR d : a.type.connectivities SEPARATOR ', '»«d.nbElems»«ENDFOR»)
		«ENDFOR»
		«FOR a : linearAlgebraVars»
		, «a.name»("«a.name»", «FOR d : a.type.connectivities SEPARATOR ', '»«d.nbElems»«ENDFOR»)
		«ENDFOR»
		{
			«IF withMesh»
			// Copy node coordinates
			const auto& gNodes = mesh->getGeometricMesh()->getNodes();
			Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
			{
				«initNodeCoordVariable.name»(rNodes) = gNodes[rNodes];
			});
			«ENDIF»
		}

	private:
		«IF (threadTeam)»
			«HierarchicalParallelismUtils::teamWorkRange»

		«ENDIF»
		«FOR j : jobs.sortJobs SEPARATOR '\n'»
			«j.content»
		«ENDFOR»			
		«FOR f : functions.filter(Function).filter[body !== null]»

			«f.content»
		«ENDFOR»

	public:
		void simulate()
		{
			std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting «name» ..." << __RESET__ << "\n\n";

			«IF withMesh»
			std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options->«MandatoryOptions::X_EDGE_ELEMS» << __RESET__ << ", Y=" << __BOLD__ << options->«MandatoryOptions::Y_EDGE_ELEMS»
				<< __RESET__ << ", X length=" << __BOLD__ << options->«MandatoryOptions::X_EDGE_LENGTH» << __RESET__ << ", Y length=" << __BOLD__ << options->«MandatoryOptions::Y_EDGE_LENGTH» << __RESET__ << std::endl;
			«ENDIF»

			if (Kokkos::hwloc::available()) {
				std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_numa_count()
					<< __RESET__ << ", Cores/NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_cores_per_numa()
					<< __RESET__ << ", Threads/Core=" << __BOLD__ << Kokkos::hwloc::get_available_threads_per_core() << __RESET__ << std::endl;
			} else {
				std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
			}

			// std::cout << "[" << __GREEN__ << "KOKKOS" << __RESET__ << "]    " << __BOLD__ << (is_same<MyLayout,Kokkos::LayoutLeft>::value?"Left":"Right")" << __RESET__ << " layout" << std::endl;

			«IF withMesh»
			if (!writer.isDisabled())
				std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
			else
				std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;
			«ENDIF»

			utils::Timer timer(true);

			«IF (threadTeam)»
				«HierarchicalParallelismUtils::teamPolicy»

			«ENDIF»			
			«jobs.filter[x | x.at < 0].jobCallsContent»	
			timer.stop();

			«IF jobs.exists[at > 0]»
			iteration = 0;
			while («MandatorySimulationVariables::TIME» < options->«MandatorySimulationOptions::STOP_TIME» && iteration < options->«MandatorySimulationOptions::MAX_ITERATIONS»)
			{
				timer.start();
				utils::Timer compute_timer(true);
				iteration++;
				if (iteration!=1)
					std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << iteration << __RESET__ "] t = " << __BOLD__
						<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << «MandatorySimulationVariables::TIME» << __RESET__;

				«jobs.filter[x | x.at > 0].jobCallsContent»
				compute_timer.stop();

				// Progress
				std::cout << utils::progress_bar(iteration, options->«MandatorySimulationOptions::MAX_ITERATIONS», «MandatorySimulationVariables::TIME», options->«MandatorySimulationOptions::STOP_TIME», 30);
				timer.stop();
				std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
					utils::eta(iteration, options->«MandatorySimulationOptions::MAX_ITERATIONS», «MandatorySimulationVariables::TIME», options->«MandatorySimulationOptions::STOP_TIME», deltat, timer), true)
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
		«IF withMesh»
		if (argc == 5) {
			o->«MandatoryOptions::X_EDGE_ELEMS» = std::atoi(argv[1]);
			o->«MandatoryOptions::Y_EDGE_ELEMS» = std::atoi(argv[2]);
			o->«MandatoryOptions::X_EDGE_LENGTH» = std::atof(argv[3]);
			o->«MandatoryOptions::Y_EDGE_LENGTH» = std::atof(argv[4]);
		} else if (argc == 6) {
			o->«MandatoryOptions::X_EDGE_ELEMS» = std::atoi(argv[1]);
			o->«MandatoryOptions::Y_EDGE_ELEMS» = std::atoi(argv[2]);
			o->«MandatoryOptions::X_EDGE_LENGTH» = std::atof(argv[3]);
			o->«MandatoryOptions::Y_EDGE_LENGTH» = std::atof(argv[4]);
			output = argv[5];
		} else if (argc != 1) {
			std::cerr << "[ERROR] Wrong number of arguments. Expecting 4 or 5 args: X Y Xlength Ylength (output)." << std::endl;
			std::cerr << "(X=100, Y=10, Xlength=0.01, Ylength=0.01 output=current directory with no args)" << std::endl;
		}
		auto gm = CartesianMesh2DGenerator::generate(o->«MandatoryOptions::X_EDGE_ELEMS», o->«MandatoryOptions::Y_EDGE_ELEMS», o->«MandatoryOptions::X_EDGE_LENGTH», o->«MandatoryOptions::Y_EDGE_LENGTH»);
		auto nm = new NumericMesh2D(gm);
		«ENDIF»
		auto c = new «name»(o, «IF withMesh»nm,«ENDIF» output);
		c->simulate();
		delete c;
		«IF withMesh»
		delete nm;
		delete gm;
		«ENDIF»
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

	private def isThreadTeam()
	{
		jobContentProvider instanceof HierarchicalJobContentProvider
	}
}