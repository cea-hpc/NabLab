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
import fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism.HierarchicalParallelismUtils
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import java.io.File
import java.net.URI
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Platform

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.kokkos.ExpressionContentProvider.*

class Ir2Kokkos extends CodeGenerator
{
	val IncludesManager includesManager
	val AttributesContentProvider attributesContentProvider
	val extension JobContentProvider jobContentProvider
	val extension FunctionContentProvider functionContentProvider

	new(File outputDirectory, IncludesManager im, AttributesContentProvider acp, JobContentProvider jcp)
	{
		super('Kokkos' + (if (jcp.threadTeam) ' team of threads' else ''))
		includesManager = im
		attributesContentProvider = acp
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
	«FOR include : includesManager.getSystemIncludesFor(it)»
	#include <«include»>
	«ENDFOR»
	«FOR pragma : includesManager.getPragmasFor(it)»
	#pragma «pragma»
	«ENDFOR»
	«FOR include : includesManager.getUserIncludesFor(it)»
	#include "«include»"
	«ENDFOR»

	using namespace nablalib;

	class «name»
	{
	public:
		struct Options
		{
			// Should be const but usefull to set them from main args
			«FOR v : options»
				«v.cppType» «v.name» = «v.defaultValue.content.toString.replaceAll('options->', '')»;
			«ENDFOR»
		};
		Options* options;

	private:
		«attributesContentProvider.getContentFor(it)»

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
		«FOR uv : globalVariables.filter[x|x.defaultValue!==null]»
		, «uv.name»(«uv.defaultValue.content»)
		«ENDFOR»
		«FOR a : connectivityVariables»
		, «a.name»("«a.name»", «FOR d : a.type.connectivities SEPARATOR ', '»«d.nbElems»«ENDFOR»)
		«ENDFOR»
		«FOR a : linearAlgebraVariables»
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
		«IF postProcessingInfo !== null»

		void dumpVariables(int iteration)
		{
			if (!writer.isDisabled() && «postProcessingInfo.periodVariable.name» >= «postProcessingInfo.lastDumpVariable.name» + «postProcessingInfo.periodValue»)
			{
				cpu_timer.stop();
				io_timer.start();
				std::map<string, double*> cellVariables;
				std::map<string, double*> nodeVariables;
				«FOR v : postProcessingInfo.postProcessedVariables.filter(ConnectivityVariable)»
				«v.type.connectivities.head.returnType.type.name»Variables.insert(pair<string,double*>("«v.persistenceName»", «v.name».data()));
				«ENDFOR»
				auto quads = mesh->getGeometry()->getQuads();
				writer.writeFile(iteration, «irModule.timeVariable.name», nbNodes, «irModule.nodeCoordVariable.name».data(), nbCells, quads.data(), cellVariables, nodeVariables);
				«postProcessingInfo.lastDumpVariable.name» = «postProcessingInfo.periodVariable.name»;
				io_timer.stop();
				cpu_timer.start();
			}
		}
		«ENDIF»

	public:
		void simulate()
		{
			«traceContentProvider.getBeginOfSimuTrace(name, withMesh)»

			«IF (threadTeam)»
				«HierarchicalParallelismUtils::teamPolicy»

			«ENDIF»
			«jobs.filter[topLevel].jobCallsContent»
			«traceContentProvider.endOfSimuTrace»
			«IF !linearAlgebraVariables.empty && mainTimeLoop !== null»«traceContentProvider.getCGInfoTrace(mainTimeLoop.iterationCounter.name)»«ENDIF»
		}
	};

	int main(int argc, char* argv[]) 
	{
		Kokkos::initialize(argc, argv);
		auto o = new «name»::Options();
		string output;
		«IF withMesh»
		if (argc == 5)
		{
			o->«MandatoryOptions::X_EDGE_ELEMS» = std::atoi(argv[1]);
			o->«MandatoryOptions::Y_EDGE_ELEMS» = std::atoi(argv[2]);
			o->«MandatoryOptions::X_EDGE_LENGTH» = std::atof(argv[3]);
			o->«MandatoryOptions::Y_EDGE_LENGTH» = std::atof(argv[4]);
		}
		else if (argc == 6)
		{
			o->«MandatoryOptions::X_EDGE_ELEMS» = std::atoi(argv[1]);
			o->«MandatoryOptions::Y_EDGE_ELEMS» = std::atoi(argv[2]);
			o->«MandatoryOptions::X_EDGE_LENGTH» = std::atof(argv[3]);
			o->«MandatoryOptions::Y_EDGE_LENGTH» = std::atof(argv[4]);
			output = argv[5];
		}
		else if (argc != 1)
		{
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