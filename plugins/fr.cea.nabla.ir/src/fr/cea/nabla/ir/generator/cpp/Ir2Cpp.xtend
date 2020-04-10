/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.PrimitiveType
import java.io.File
import java.net.URI
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Platform

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*

class Ir2Cpp extends CodeGenerator
{
	val Backend backend

	val extension ArgOrVarContentProvider argOrVarContentProvider
	val extension ExpressionContentProvider expressionContentProvider
	val extension JobContainerContentProvider jobContainerContentProvider

	new(File outputDirectory, Backend backend)
	{
		super(backend.name)
		this.backend = backend

		argOrVarContentProvider = backend.argOrVarContentProvider
		expressionContentProvider = backend.expressionContentProvider
		jobContainerContentProvider = backend.jobContainerContentProvider

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
		#{ name + '.cc' -> ccFileContent, 'CMakeLists.txt' -> backend.ir2Cmake.getContentFor(it)}
	}

	private def getCcFileContent(IrModule it)
	'''
	«backend.includesContentProvider.getContentFor(it)»

	using namespace nablalib;

	class «name»
	{
	public:
		struct Options
		{
			// Should be const but usefull to set them from main args
			«FOR v : options»
			«IF v.type.primitive == PrimitiveType.INT»size_t«ELSE»«v.cppType»«ENDIF» «v.name» = «v.defaultValue.content.toString.replaceAll('options->', '')»;
			«ENDFOR»
		};
		Options* options;

	private:
		«backend.attributesContentProvider.getContentFor(it)»

	public:
		«name»(Options* aOptions, «IF withMesh»CartesianMesh2D* aCartesianMesh2D,«ENDIF» string output)
		: options(aOptions)
		«IF withMesh»
		, mesh(aCartesianMesh2D)
		, writer("«name»", output)
		«FOR c : usedConnectivities»
		, «c.nbElemsVar»(«c.connectivityAccessor»)
		«ENDFOR»
		«ENDIF»
		«FOR uv : globalVariables.filter[x|x.defaultValue!==null]»
		, «uv.name»(«uv.defaultValue.content»)
		«ENDFOR»
		«FOR a : connectivityVariables»
		, «a.name»(«a.cstrInit»)
		«ENDFOR»
		«FOR a : linearAlgebraVariables»
		, «a.name»(«a.cstrInit»)
		«ENDFOR»
		{
			«IF withMesh»
			// Copy node coordinates
			const auto& gNodes = mesh->getGeometry()->getNodes();
			«val iterator = backend.argOrVarContentProvider.formatIterators(initNodeCoordVariable, #["rNodes"])»
			for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
				«initNodeCoordVariable.name»«iterator» = gNodes[rNodes];
			«ENDIF»
		}

	private:
		«backend.privateMethodsContentProvider.getContentFor(it)»
		«IF postProcessingInfo !== null»

		void dumpVariables(int iteration)
		{
			if (!writer.isDisabled() && «postProcessingInfo.periodVariable.name» >= «postProcessingInfo.lastDumpVariable.name» + «postProcessingInfo.periodValue»)
			{
				cpuTimer.stop();
				ioTimer.start();
				std::map<string, double*> cellVariables;
				std::map<string, double*> nodeVariables;
				«FOR v : postProcessingInfo.postProcessedVariables.filter(ConnectivityVariable)»
				«v.type.connectivities.head.returnType.name»Variables.insert(pair<string,double*>("«v.persistenceName»", «v.name».data()));
				«ENDFOR»
				auto quads = mesh->getGeometry()->getQuads();
				writer.writeFile(iteration, «irModule.timeVariable.name», nbNodes, «irModule.nodeCoordVariable.name».data(), nbCells, quads.data(), cellVariables, nodeVariables);
				«postProcessingInfo.lastDumpVariable.name» = «postProcessingInfo.periodVariable.name»;
				ioTimer.stop();
				cpuTimer.start();
			}
		}
		«ENDIF»

	public:
		void simulate()
		{
			«backend.traceContentProvider.getBeginOfSimuTrace(name, withMesh)»

			«callsHeader»
			«callsContent»
			«backend.traceContentProvider.endOfSimuTrace»
			«IF !linearAlgebraVariables.empty && mainTimeLoop !== null»«backend.traceContentProvider.getCGInfoTrace(mainTimeLoop.iterationCounter.name)»«ENDIF»
		}
	};

	int main(int argc, char* argv[]) 
	{
		«backend.mainContentProvider.getContentFor(it)»
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