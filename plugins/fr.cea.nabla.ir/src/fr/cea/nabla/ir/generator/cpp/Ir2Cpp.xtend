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

import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.transformers.IrTransformationStep
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

	override IrTransformationStep getIrTransformationStep()
	{
		backend.irTransformationStep
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
			«FOR v : options»
			«v.cppType» «v.name»;
			«ENDFOR»
			«IF levelDB»std::string «Utils.NonRegressionNameAndValue.key»;«ENDIF»

			void jsonInit(const rapidjson::Value::ConstObject& d);
		};

		«name»(«meshClassName»* aMesh, const Options& aOptions«FOR s : allProviders BEFORE ', ' SEPARATOR ', '»«s»& a«s»«ENDFOR»);
		~«name»();

	private:
		«backend.attributesContentProvider.getContentFor(it)»

		«backend.privateMethodsContentProvider.getDeclarationContentFor(it)»
		«IF postProcessingInfo !== null»

		void dumpVariables(int iteration, bool useTimer=true);
		«ENDIF»
		«IF levelDB»

	public:
		void createDB(const std::string& db_name);
		«ENDIF»

	public:
		void simulate();
	};
	'''

	private def getSourceFileContent(IrModule it)
	'''
	#include "«name.toLowerCase»/«name».h"

	using namespace nablalib;

	«IF !functions.empty»
	/******************** Free functions definitions ********************/

	«FOR f : functions.filter(Function).filter[body !== null]»
		«f.definitionContent»

	«ENDFOR»
	«ENDIF»

	/******************** Options definition ********************/

	void
	«name»::Options::jsonInit(const rapidjson::Value::ConstObject& d)
	{
		«IF postProcessingInfo !== null»
		«val opName = TagOutputVariables.OutputPathNameAndValue.key»
		// «opName»
		assert(d.HasMember("«opName»"));
		const rapidjson::Value& «opName.jsonName» = d["«opName»"];
		assert(«opName.jsonName».IsString());
		«opName» = «opName.jsonName».GetString();
		«ENDIF»
		«IF levelDB»
		// Non regression
		«val nrName = Utils.NonRegressionNameAndValue.key»
		assert(d.HasMember("«nrName»"));
		const rapidjson::Value& «nrName.jsonName» = d["«nrName»"];
		assert(«nrName.jsonName».IsString());
		«nrName» = «nrName.jsonName».GetString();
		«ENDIF»
		«FOR v : options»
		«v.jsonContent»
		«ENDFOR»
	}

	/******************** Module definition ********************/

	«name»::«name»(«meshClassName»* aMesh, const Options& aOptions«FOR s : allProviders BEFORE ', ' SEPARATOR ', '»«s»& a«s»«ENDFOR»)
	: mesh(aMesh)
	«FOR c : connectivities.filter[multiple]»
	, «c.nbElemsVar»(«c.connectivityAccessor»)
	«ENDFOR»
	, options(aOptions)
	«FOR s : allProviders»
	, «s.toFirstLower»(a«s»)
	«ENDFOR»
	«IF postProcessingInfo !== null», writer("«name»", options.«TagOutputVariables.OutputPathNameAndValue.key»)«ENDIF»
	«FOR v : variablesWithDefaultValue.filter[x | !x.constExpr]»
	, «v.name»(«v.defaultValue.content»)
	«ENDFOR»
	«FOR v : variables.filter(ConnectivityVariable)»
	, «v.name»(«v.cstrInit»)
	«ENDFOR»
	{
		«val dynamicArrayVariables = variables.filter[!type.baseTypeStatic]»
		«IF !dynamicArrayVariables.empty»
			// Allocate dynamic arrays (RealArrays with at least a dynamic dimension)
			«FOR v : dynamicArrayVariables»
				«v.initCppTypeContent»
			«ENDFOR»

		«ENDIF»
		// Copy node coordinates
		const auto& gNodes = mesh->getGeometry()->getNodes();
		«val iterator = backend.argOrVarContentProvider.formatIterators(initNodeCoordVariable, #["rNodes"])»
		for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
		{
			«initNodeCoordVariable.name»«iterator»[0] = gNodes[rNodes][0];
			«initNodeCoordVariable.name»«iterator»[1] = gNodes[rNodes][1];
		}
	}

	«name»::~«name»()
	{
	}

	«backend.privateMethodsContentProvider.getDefinitionContentFor(it)»
	«IF postProcessingInfo !== null»

	void «name»::dumpVariables(int iteration, bool useTimer)
	{
		if (!writer.isDisabled())
		{
			if (useTimer)
			{
				cpuTimer.stop();
				ioTimer.start();
			}
			auto quads = mesh->getGeometry()->getQuads();
			writer.startVtpFile(iteration, «irModule.timeVariable.name», nbNodes, «irModule.nodeCoordVariable.name».data(), nbCells, quads.data());
			«val outputVarsByConnectivities = postProcessingInfo.outputVariables.filter(ConnectivityVariable).groupBy(x | x.type.connectivities.head.returnType.name)»
			writer.openNodeData();
			«val nodeVariables = outputVarsByConnectivities.get("node")»
			«IF !nodeVariables.nullOrEmpty»
				«FOR v : nodeVariables»
					writer.write«FOR s : v.type.base.sizes BEFORE '<' SEPARATOR ',' AFTER '>'»«s.content»«ENDFOR»("«v.outputName»", «v.name»);
				«ENDFOR»
			«ENDIF»
			writer.closeNodeData();
			writer.openCellData();
			«val cellVariables = outputVarsByConnectivities.get("cell")»
			«IF !cellVariables.nullOrEmpty»
				«FOR v : cellVariables»
					writer.write«FOR s : v.type.base.sizes BEFORE '<' SEPARATOR ',' AFTER '>'»«s.content»«ENDFOR»("«v.outputName»", «v.name»);
				«ENDFOR»
			«ENDIF»
			writer.closeCellData();
			writer.closeVtpFile();
			«postProcessingInfo.lastDumpVariable.name» = «postProcessingInfo.periodReference.name»;
			if (useTimer)
			{
				ioTimer.stop();
				cpuTimer.start();
			}
		}
	}
	«ENDIF»
	«IF levelDB»
	
	void «name»::createDB(const std::string& db_name)
	{
		// Creating data base
		leveldb::DB* db;
		leveldb::Options options;
		options.create_if_missing = true;
		leveldb::Status status = leveldb::DB::Open(options, db_name, &db);
		assert(status.ok());
		// Batch to write all data at once
		leveldb::WriteBatch batch;
		«FOR v : variables»
		batch.Put("«v.name»", serialize(«v.name»));
		«ENDFOR»
		status = db->Write(leveldb::WriteOptions(), &batch);
		// Checking everything was ok
		assert(status.ok());
		std::cerr << "Reference database " << db_name << " created." << std::endl;
		// Freeing memory
		delete db;
	}
	«ENDIF»

	void «name»::simulate()
	{
		«backend.traceContentProvider.getBeginOfSimuTrace(it, name)»

		«callsHeader»
		«callsContent»
		«backend.traceContentProvider.getEndOfSimuTrace(linearAlgebra)»
	}
	«IF levelDB»

	/******************** Non regression testing ********************/

	bool compareDB(const std::string& current, const std::string& ref)
	{
		// Final result
		bool result = true;

		// Loading ref DB
		leveldb::DB* db_ref;
		leveldb::Options options_ref;
		options_ref.create_if_missing = false;
		leveldb::Status status = leveldb::DB::Open(options_ref, ref, &db_ref);
		if (!status.ok())
		{
			std::cerr << "No ref database to compare with ! Looking for " << ref << std::endl;
			return false;
		}
		leveldb::Iterator* it_ref = db_ref->NewIterator(leveldb::ReadOptions());


		// Loading current DB
		leveldb::DB* db;
		leveldb::Options options;
		options.create_if_missing = false;
		status = leveldb::DB::Open(options, current, &db);
		assert(status.ok());
		leveldb::Iterator* it = db->NewIterator(leveldb::ReadOptions());

		// Results comparison
		std::cerr << "# Compairing results ..." << std::endl;
		for (it_ref->SeekToFirst(), it->SeekToFirst(); it_ref->Valid() && it->Valid(); it_ref->Next(), it->Next()) {
			assert(it_ref->key().ToString() == it->key().ToString());
			if (it_ref->value().ToString() == it->value().ToString())
				std::cerr << it->key().ToString() << ": " << "OK" << std::endl;
			else
			{
				std::cerr << it->key().ToString() << ": " << "ERROR" << std::endl;
				result = false;
			}
		}

		// Freeing memory
		delete db;
		delete db_ref;

		return result;
	}
	«ENDIF»

	/******************** Module definition ********************/

	int main(int argc, char* argv[]) 
	{
		«backend.mainContentProvider.getContentFor(it)»
		return ret;
	}
	'''

	private def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty)
			'''mesh->getNb«c.name.toFirstUpper»()'''
		else
			'''CartesianMesh2D::MaxNb«c.name.toFirstUpper»'''
	}

	private def isLevelDB()
	{
		!backend.includesContentProvider.levelDBPath.nullOrEmpty
	}
}