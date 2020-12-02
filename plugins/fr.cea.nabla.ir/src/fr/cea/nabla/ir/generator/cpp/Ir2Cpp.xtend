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
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.IrTransformationStep
import java.io.File
import java.net.URI
import java.util.HashMap
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Platform

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.cpp.Ir2CppUtils.*
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable

class Ir2Cpp extends CodeGenerator
{
	val Backend backend

	val extension ArgOrVarContentProvider argOrVarContentProvider
	val extension ExpressionContentProvider expressionContentProvider
	val extension JsonContentProvider jsonContentProvider
	val extension FunctionContentProvider functionContentProvider
	val extension JobCallerContentProvider jobCallerContentProvider

	new(File outputDirectory, Backend backend)
	{
		super(backend.name)
		this.backend = backend

		argOrVarContentProvider = backend.argOrVarContentProvider
		expressionContentProvider = backend.expressionContentProvider
		jsonContentProvider = backend.jsonContentProvider
		jobCallerContentProvider = backend.getJobCallerContentProvider
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

	override getFileContentsByName(IrRoot ir)
	{
		val fileContents = new HashMap<String, CharSequence>
		for (module : ir.modules)
		{
			fileContents.put(module.className + '.h', module.headerFileContent)
			fileContents.put(module.className + '.cc', module.sourceFileContent)
		}
		fileContents.put('CMakeLists.txt', backend.ir2Cmake.getContentFor(ir))
		return fileContents
	}

	override IrTransformationStep getIrTransformationStep()
	{
		backend.irTransformationStep
	}

	private def getHeaderFileContent(IrModule it)
	'''
	#ifndef «name.toUpperCase»_H_
	#define «name.toUpperCase»_H_

	«backend.includesContentProvider.getContentFor(it)»

	using namespace nablalib;
	«IF main && irRoot.modules.size > 1»
		«FOR m : irRoot.modules.filter[x | x !== it]»
			class «m.className»;
		«ENDFOR»
	«ENDIF»
	«IF !functions.empty»

	/******************** Free functions declarations ********************/

	«FOR f : functions.filter(Function).filter[body !== null]»
		«f.declarationContent»;
	«ENDFOR»
	«ENDIF»

	/******************** Module declaration ********************/

	class «className»
	{
		«IF backend instanceof KokkosTeamThreadBackend»
		typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

		«ENDIF»
	public:
		struct Options
		{
			«IF postProcessing !== null»std::string «Utils.OutputPathNameAndValue.key»;«ENDIF»
			«FOR v : options»
			«v.cppType» «v.name»;
			«ENDFOR»
			«FOR s : functionProviderClasses»
			«s» «s.toFirstLower»;
			«ENDFOR»
			«IF levelDB»std::string «Utils.NonRegressionNameAndValue.key»;«ENDIF»

			void jsonInit(const char* jsonContent);
		};

		«className»(«meshClassName»* aMesh, Options& aOptions);
		~«className»();
		«IF main»
			«IF irRoot.modules.size > 1»

				«FOR adm : irRoot.modules.filter[x | x !== it]»
				inline void set«adm.name.toFirstUpper»(«adm.className»* value) { «adm.name» = value; }
				«ENDFOR»
			«ENDIF»
		«ELSE»

		inline void setMainModule(«irRoot.mainModule.className»* value)
		{
			mainModule = value,
			mainModule->set«name.toFirstUpper»(this);
		}
		«ENDIF»

		void simulate();
		«FOR j : jobs»
		«backend.jobContentProvider.getDeclarationContent(j)»
		«ENDFOR»
		«IF levelDB»void createDB(const std::string& db_name);«ENDIF»

	private:
		«IF postProcessing !== null»
		void dumpVariables(int iteration, bool useTimer=true);

		«ENDIF»
		«IF backend instanceof KokkosTeamThreadBackend»
		/**
		 * Utility function to get work load for each team of threads
		 * In  : thread and number of element to use for computation
		 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
		 */
		const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept;

		«ENDIF»
		// Mesh and mesh variables
		«meshClassName»* mesh;
		«FOR c : irRoot.connectivities.filter[multiple] BEFORE 'size_t ' SEPARATOR ', '»«c.nbElemsVar»«ENDFOR»;

		// User options
		Options& options;
		«IF postProcessing !== null»PvdFileWriter2D writer;«ENDIF»

		«IF irRoot.modules.size > 1»
			«IF main»
				// Additional modules
				«FOR m : irRoot.modules.filter[x | x !== it]»
					«m.className»* «m.name»;
				«ENDFOR»
			«ELSE»
				// Main module
				«irRoot.mainModule.className»* mainModule;
			«ENDIF»

		«ENDIF»
		// Timers
		utils::Timer globalTimer;
		utils::Timer cpuTimer;
		utils::Timer ioTimer;

	public:
		// Global variables
		«FOR v : variables.filter[!option]»
			«v.variableDeclaration»
		«ENDFOR»
	};

	#endif
	'''

	private def getSourceFileContent(IrModule it)
	'''
	#include "«irRoot.name.toLowerCase»/«className».h"
	#include <rapidjson/document.h>
	#include <rapidjson/istreamwrapper.h>
	#include <rapidjson/stringbuffer.h>
	#include <rapidjson/writer.h>
	«IF main && irRoot.modules.size > 1»
		«FOR m : irRoot.modules.filter[x | x !== it]»
			#include "«irRoot.name.toLowerCase»/«m.className».h"
		«ENDFOR»
	«ENDIF»

	using namespace nablalib;
	«IF !functions.empty»

	/******************** Free functions definitions ********************/

	«FOR f : functions.filter(Function).filter[body !== null] SEPARATOR '\n'»
		«f.definitionContent»
	«ENDFOR»
	«ENDIF»

	/******************** Options definition ********************/

	void
	«className»::Options::jsonInit(const char* jsonContent)
	{
		rapidjson::Document document;
		assert(!document.Parse(jsonContent).HasParseError());
		assert(document.IsObject());
		const rapidjson::Value::Object& o = document.GetObject();

		«IF postProcessing !== null»
		«val opName = Utils.OutputPathNameAndValue.key»
		// «opName»
		assert(o.HasMember("«opName»"));
		const rapidjson::Value& «opName.jsonName» = o["«opName»"];
		assert(«opName.jsonName».IsString());
		«opName» = «opName.jsonName».GetString();
		«ENDIF»
		«FOR v : options»
		«v.jsonContent»
		«ENDFOR»
		«FOR v : functionProviderClasses»
		// «v.toFirstLower»
		if (o.HasMember("«v.toFirstLower»"))
		{
			rapidjson::StringBuffer strbuf;
			rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
			o["«v.toFirstLower»"].Accept(writer);
			«v.toFirstLower».jsonInit(strbuf.GetString());
		}
		«ENDFOR»
		«IF levelDB»
		// Non regression
		«val nrName = Utils.NonRegressionNameAndValue.key»
		assert(o.HasMember("«nrName»"));
		const rapidjson::Value& «nrName.jsonName» = o["«nrName»"];
		assert(«nrName.jsonName».IsString());
		«nrName» = «nrName.jsonName».GetString();
		«ENDIF»
	}

	/******************** Module definition ********************/

	«className»::«className»(«meshClassName»* aMesh, Options& aOptions)
	: mesh(aMesh)
	«FOR c : irRoot.connectivities.filter[multiple]»
	, «c.nbElemsVar»(«c.connectivityAccessor»)
	«ENDFOR»
	, options(aOptions)
	«IF postProcessing !== null», writer("«irRoot.name»", options.«Utils.OutputPathNameAndValue.key»)«ENDIF»
	«FOR v : variablesWithDefaultValue.filter[x | !x.constExpr]»
	, «v.name»(«v.defaultValue.content»)
	«ENDFOR»
	«FOR v : variables.filter(ConnectivityVariable)»
	, «v.name»(«v.cstrInit»)
	«ENDFOR»
	{
		«val dynamicArrayVariables = variables.filter[!option && !type.baseTypeStatic]»
		«IF !dynamicArrayVariables.empty»
			// Allocate dynamic arrays (RealArrays with at least a dynamic dimension)
			«FOR v : dynamicArrayVariables»
				«v.initCppTypeContent»
			«ENDFOR»

		«ENDIF»
		«IF main»
		// Copy node coordinates
		const auto& gNodes = mesh->getGeometry()->getNodes();
		«val iterator = backend.argOrVarContentProvider.formatIterators(irRoot.initNodeCoordVariable, #["rNodes"])»
		for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
		{
			«irRoot.initNodeCoordVariable.name»«iterator»[0] = gNodes[rNodes][0];
			«irRoot.initNodeCoordVariable.name»«iterator»[1] = gNodes[rNodes][1];
		}
		«ENDIF»
	}

	«className»::~«className»()
	{
	}
	«IF backend instanceof KokkosTeamThreadBackend»

	const std::pair<size_t, size_t> «className»::computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept
	{
		/*
		if (nb_elmt % thread.team_size())
		{
			std::cerr << "[ERROR] nb of elmt (" << nb_elmt << ") not multiple of nb of thread per team ("
		              << thread.team_size() << ")" << std::endl;
			std::terminate();
		}
		*/
		// Size
		size_t team_chunk(std::floor(nb_elmt / thread.league_size()));
		// Offset
		const size_t team_offset(thread.league_rank() * team_chunk);
		// Last team get remaining work
		if (thread.league_rank() == thread.league_size() - 1)
		{
			size_t left_over(nb_elmt - (team_chunk * thread.league_size()));
			team_chunk += left_over;
		}
		return std::pair<size_t, size_t>(team_offset, team_chunk);
	}
	«ENDIF»

	«FOR j : jobs SEPARATOR '\n'»
		«backend.jobContentProvider.getDefinitionContent(j)»
	«ENDFOR»
	«IF main»
	«IF postProcessing !== null»

	void «className»::dumpVariables(int iteration, bool useTimer)
	{
		if (!writer.isDisabled())
		{
			if (useTimer)
			{
				cpuTimer.stop();
				ioTimer.start();
			}
			auto quads = mesh->getGeometry()->getQuads();
			writer.startVtpFile(iteration, «irRoot.timeVariable.name», nbNodes, «irRoot.nodeCoordVariable.name».data(), nbCells, quads.data());
			«val outputVarsByConnectivities = irRoot.postProcessing.outputVariables.filter(ConnectivityVariable).groupBy(x | x.type.connectivities.head.returnType.name)»
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
			«irRoot.postProcessing.lastDumpVariable.name» = «irRoot.postProcessing.periodReference.name»;
			if (useTimer)
			{
				ioTimer.stop();
				cpuTimer.start();
			}
		}
	}
	«ENDIF»

	void «className»::«irRoot.main.codeName»()
	{
		«backend.traceContentProvider.getBeginOfSimuTrace(it)»

		«irRoot.main.callsHeader»
		«irRoot.main.callsContent»
		«backend.traceContentProvider.getEndOfSimuTrace(linearAlgebra)»
	}
	«IF levelDB»
	
	void «className»::createDB(const std::string& db_name)
	{
		// Creating data base
		leveldb::DB* db;
		leveldb::Options options;
		options.create_if_missing = true;
		leveldb::Status status = leveldb::DB::Open(options, db_name, &db);
		assert(status.ok());
		// Batch to write all data at once
		leveldb::WriteBatch batch;
		«FOR v : irRoot.variables.filter[!option]»
		batch.Put("«v.dbKey»", serialize(«getDbValue(it, v, '->')»));
		«ENDFOR»
		status = db->Write(leveldb::WriteOptions(), &batch);
		// Checking everything was ok
		assert(status.ok());
		std::cerr << "Reference database " << db_name << " created." << std::endl;
		// Freeing memory
		delete db;
	}

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
		std::cerr << "# Comparing results ..." << std::endl;
		for (it_ref->SeekToFirst(); it_ref->Valid(); it_ref->Next()) {
			auto key = it_ref->key();
			std::string value;
			auto status = db->Get(leveldb::ReadOptions(), key, &value);
			if (status.IsNotFound()) {
				std::cerr << "ERROR - Key : " << key.ToString() << " not found." << endl;
				result = false;
			}
			else {
				if (value == it_ref->value().ToString())
					std::cerr << key.ToString() << ": " << "OK" << std::endl;
				else {
					std::cerr << key.ToString() << ": " << "ERROR" << std::endl;
					result = false;
				}
			}
		}

		// looking for key in the db that are not in the ref (new variables)
		for (it->SeekToFirst(); it->Valid(); it->Next()) {
			auto key = it->key();
			std::string value;
			if (db_ref->Get(leveldb::ReadOptions(), key, &value).IsNotFound()) {
				std::cerr << "ERROR - Key : " << key.ToString() << " can not be compared (not present in the ref)." << std::endl;
				result = false;
			}
		}

		// Freeing memory
		delete db;
		delete db_ref;

		return result;
	}
	«ENDIF»

	int main(int argc, char* argv[]) 
	{
		«backend.mainContentProvider.getContentFor(it)»
		return ret;
	}
	«ENDIF»
	'''

	private def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty)
			'''mesh->getNb«c.name.toFirstUpper»()'''
		else
			'''CartesianMesh2D::MaxNb«c.name.toFirstUpper»'''
	}

	private def isLevelDB(IrModule it)
	{
		main && !backend.includesContentProvider.levelDBPath.nullOrEmpty
	}

	private def CharSequence getVariableDeclaration(Variable v)
	{
		switch (v)
		{
			 SimpleVariable case v.constExpr: '''static constexpr «v.cppType» «v.name» = «v.defaultValue.content»;'''
			 SimpleVariable case v.const: '''const «v.cppType» «v.name»;'''
			 default: '''«v.cppType» «v.name»;'''
		}
	}
}