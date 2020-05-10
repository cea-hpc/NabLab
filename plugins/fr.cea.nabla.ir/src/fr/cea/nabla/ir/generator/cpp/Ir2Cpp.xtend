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
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.transformers.TagOutputVariables
import java.io.File
import java.net.URI
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Platform

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.cpp.Ir2CppUtils.*

class Ir2Cpp extends CodeGenerator
{
	val Backend backend

	val extension ArgOrVarContentProvider argOrVarContentProvider
	val extension ExpressionContentProvider expressionContentProvider
	val extension JsonContentProvider jsonContentProvider
	val extension FunctionContentProvider functionContentProvider
	val extension JobContainerContentProvider jobContainerContentProvider

	new(File outputDirectory, Backend backend)
	{
		super(backend.name)
		this.backend = backend

		argOrVarContentProvider = backend.argOrVarContentProvider
		expressionContentProvider = backend.expressionContentProvider
		jsonContentProvider = backend.jsonContentProvider
		jobContainerContentProvider = backend.jobContainerContentProvider
		functionContentProvider = backend.functionContentProvider

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
		#{ name + '.h' -> headerFileContent, name + '.cc' -> sourceFileContent, 'CMakeLists.txt' -> backend.ir2Cmake.getContentFor(it)}
	}

	private def getHeaderFileContent(IrModule it)
	'''
	«backend.includesContentProvider.getContentFor(it)»

	using namespace nablalib;

	«IF !functions.empty»
	/******************** Free functions declarations ********************/

	«FOR f : functions.filter(Function).filter[body !== null]»
		«f.declarationContent»;
	«ENDFOR»
	«ENDIF»


	/******************** Module declaration ********************/

	class «name»
	{
	public:
		struct Options
		{
			«IF postProcessingInfo !== null»std::string «TagOutputVariables.OutputPathNameAndValue.key»;«ENDIF»
			«FOR v : definitions.filter[option]»
			«v.cppType» «v.name»;
			«ENDFOR»

			Options(const std::string& fileName);
		};

		Options* options;

		«name»(Options* aOptions«IF withMesh», CartesianMesh2D* aCartesianMesh2D«ENDIF»);

	private:
		«backend.attributesContentProvider.getContentFor(it)»

		«backend.privateMethodsContentProvider.getDeclarationContentFor(it)»
		«IF postProcessingInfo !== null»

		void dumpVariables(int iteration);
		«ENDIF»

	public:
		void simulate();
	};
	'''
	
	private def getSourceFileContent(IrModule it)
	'''
	#include "«name».h"

	using namespace nablalib;

	«IF !functions.empty»
	/******************** Free functions definitions ********************/

	«FOR f : functions.filter(Function).filter[body !== null]»
		«f.definitionContent»

	«ENDFOR»
	«ENDIF»

	/******************** Options definition ********************/

	«name»::Options::Options(const std::string& fileName)
	{
		ifstream ifs(fileName);
		rapidjson::IStreamWrapper isw(ifs);
		rapidjson::Document d;
		d.ParseStream(isw);
		assert(d.IsObject());
		«IF postProcessingInfo !== null»
		// outputPath
		«val opName = TagOutputVariables.OutputPathNameAndValue.key»
		assert(d.HasMember("«opName»"));
		const rapidjson::Value& valueof_«opName» = d["«opName»"];
		assert(valueof_«opName».IsString());
		«opName» = valueof_«opName».GetString();
		«ENDIF»
		«FOR v : definitions.filter[option]»
		«v.jsonContent»
		«ENDFOR»
	}

	/******************** Module definition ********************/

	«name»::«name»(Options* aOptions«IF withMesh», CartesianMesh2D* aCartesianMesh2D«ENDIF»)
	: options(aOptions)
	«IF withMesh»
	, mesh(aCartesianMesh2D)
	, writer("«name»", options->«TagOutputVariables.OutputPathNameAndValue.key»)
	«FOR c : usedConnectivities»
	, «c.nbElemsVar»(«c.connectivityAccessor»)
	«ENDFOR»
	«ENDIF»
	«FOR v : definitions.filter[x | !(x.option || x.constExpr)]»
	, «v.name»(«v.defaultValue.content»)
	«ENDFOR»
	«FOR v : declarations.filter(ConnectivityVariable)»
	, «v.name»(«v.cstrInit»)
	«ENDFOR»
	{
		«val dynamicArrayVariables = declarations.filter[!type.baseTypeStatic]»
		«IF !dynamicArrayVariables.empty»
			// Allocate dynamic arrays (RealArrays with at least a dynamic dimension)
			«FOR v : dynamicArrayVariables»
				«v.initCppTypeContent»
			«ENDFOR»
		«ENDIF»
		«IF withMesh»

		// Copy node coordinates
		const auto& gNodes = mesh->getGeometry()->getNodes();
		«val iterator = backend.argOrVarContentProvider.formatIterators(initNodeCoordVariable, #["rNodes"])»
		for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
		{
			«initNodeCoordVariable.name»«iterator»[0] = gNodes[rNodes][0];
			«initNodeCoordVariable.name»«iterator»[1] = gNodes[rNodes][1];
		}
		«ENDIF»
	}

	«backend.privateMethodsContentProvider.getDefinitionContentFor(it)»
	«IF postProcessingInfo !== null»

	void «name»::dumpVariables(int iteration)
	{
		if (!writer.isDisabled() && «postProcessingInfo.periodReference.getCodeName('->')» >= «postProcessingInfo.lastDumpVariable.getCodeName('->')» + «postProcessingInfo.periodValue.getCodeName('->')»)
		{
			cpuTimer.stop();
			ioTimer.start();
			auto quads = mesh->getGeometry()->getQuads();
			writer.startVtpFile(iteration, «irModule.timeVariable.name», nbNodes, «irModule.nodeCoordVariable.name».data(), nbCells, quads.data());
			«val outputVarsByConnectivities = postProcessingInfo.outputVariables.filter(ConnectivityVariable).groupBy(x | x.type.connectivities.head.returnType.name)»
			«val nodeVariables = outputVarsByConnectivities.get("node")»
			«IF !nodeVariables.nullOrEmpty»
				writer.openNodeData();
				«FOR v : nodeVariables»
					writer.write«FOR s : v.type.base.sizes BEFORE '<' SEPARATOR ',' AFTER '>'»«s.content»«ENDFOR»("«v.outputName»", «v.name»);
				«ENDFOR»
				writer.closeNodeData();
			«ENDIF»
			«val cellVariables = outputVarsByConnectivities.get("cell")»
			«IF !cellVariables.nullOrEmpty»
				writer.openCellData();
				«FOR v : cellVariables»
					writer.write«FOR s : v.type.base.sizes BEFORE '<' SEPARATOR ',' AFTER '>'»«s.content»«ENDFOR»("«v.outputName»", «v.name»);
				«ENDFOR»
				writer.closeCellData();
			«ENDIF»
			writer.closeVtpFile();
			«postProcessingInfo.lastDumpVariable.name» = «postProcessingInfo.periodReference.name»;
			ioTimer.stop();
			cpuTimer.start();
		}
	}
	«ENDIF»

	void «name»::simulate()
	{
		«backend.traceContentProvider.getBeginOfSimuTrace(name, withMesh)»

		«callsHeader»
		«callsContent»
		«backend.traceContentProvider.endOfSimuTrace»
		«IF linearAlgebra && mainTimeLoop !== null»«backend.traceContentProvider.getCGInfoTrace(mainTimeLoop.iterationCounter.name)»«ENDIF»
	}


	/******************** Module definition ********************/

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