/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.MandatoryOptions
import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism.HierarchicalParallelismUtils
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import java.io.File
import java.net.URI
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Platform

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.kokkos.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.kokkos.Ir2KokkosUtils.*

class Ir2Kokkos extends CodeGenerator
{
	val extension JobContentProvider jobContentProvider
	val extension FunctionContentProvider functionContentProvider

	new(File outputDirectory, JobContentProvider jcp)
	{
		super('Kokkos' + (if (jcp.threadTeam) ' team of threads' else ''))
		jobContentProvider = jcp
		functionContentProvider = new FunctionContentProvider(jcp.instructionContentProvider)

		// check if c++ resources are available in the output folder
		if (outputDirectory.exists && outputDirectory.isDirectory &&
			!outputDirectory.list.contains("libcppnabla") && Platform.isRunning)
		{
			// c++ resources not available => unzip them
			// For JunitTests, launched from dev environment, copy is not possible
			val bundle = Platform.getBundle("fr.cea.nabla.ir")
			val cppResourcesUrl = bundle.getEntry("cppresources/libcppnabla.zip")
			val tmpURI = FileLocator.toFileURL(cppResourcesUrl)
			// need to use a 3-arg constructor in order to properly escape file system chars
			val zipFileUri = new URI(tmpURI.protocol, tmpURI.path, null)
			val outputFolderUri = outputDirectory.toURI
			UnzipHelper::unzip(zipFileUri, outputFolderUri)
		}
	}

	override getFileContentsByName(IrModule it)
	{
		#{ name + '.cc' -> ccFileContent, 'CMakeLists.txt' -> Ir2Cmake::getFileContent(it)}
	}

	private def getTraceContentProvider() { jobContentProvider.traceContentProvider }

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
	#include "mesh/CartesianMesh2DGenerator.h"
	#include "mesh/CartesianMesh2D.h"
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
		CartesianMesh2D* mesh;
		PvdFileWriter2D writer;
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
		// CG details
		LinearAlgebraFunctions::CGInfo cg_info;
		«ENDIF»

		utils::Timer global_timer;
		utils::Timer cpu_timer;
		utils::Timer io_timer;
		«IF (threadTeam)»
		typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;
		«ELSE»
		const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();
		«ENDIF»

	public:
		«name»(Options* aOptions, «IF withMesh»CartesianMesh2D* aCartesianMesh2D,«ENDIF» string output)
		: options(aOptions)
		«IF withMesh»
		, mesh(aCartesianMesh2D)
		, writer("«name»", output)
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
			const auto& gNodes = mesh->getGeometry()->getNodes();
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
		«FOR j : jobs.sortByAtAndName SEPARATOR '\n'»
			«j.content»
		«ENDFOR»			
		«FOR f : functions.filter(Function).filter[body !== null]»

			«f.content»
		«ENDFOR»

	public:
		void simulate()
		{
			«traceContentProvider.getBeginOfSimuTrace(name, withMesh)»

			«IF (threadTeam)»
				«HierarchicalParallelismUtils::teamPolicy»

			«ENDIF»
			«jobs.filter[topLevel].jobCallsContent»
			«traceContentProvider.endOfSimuTrace»
			«IF !linearAlgebraVars.empty && mainTimeLoop !== null»«traceContentProvider.getCGInfoTrace(mainTimeLoop.iterationCounter.name)»«ENDIF»
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
		auto nm = CartesianMesh2DGenerator::generate(o->«MandatoryOptions::X_EDGE_ELEMS», o->«MandatoryOptions::Y_EDGE_ELEMS», o->«MandatoryOptions::X_EDGE_LENGTH», o->«MandatoryOptions::Y_EDGE_LENGTH»);
		«ENDIF»
		auto c = new «name»(o, «IF withMesh»nm,«ENDIF» output);
		c->simulate();
		delete c;
		«IF withMesh»
		delete nm;
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
			'''CartesianMesh2D::MaxNb«c.name.toFirstUpper»'''
	}
}