/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.UnzipHelper
import fr.cea.nabla.ir.generator.ApplicationGenerator
import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList
import java.util.LinkedHashSet

import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.CppGeneratorUtils.*

class CppApplicationGenerator extends CppGenerator implements ApplicationGenerator
{
	val boolean hasLevelDB
	val cMakeVars = new LinkedHashSet<Pair<String, String>>

	new(Backend backend, String wsPath, boolean hasLevelDB, Iterable<Pair<String, String>> cmakeVars)
	{
		super(backend)
		this.hasLevelDB = hasLevelDB
		cmakeVars.forEach[x | this.cMakeVars += x]

		// Set WS_PATH variables in CMake and unzip NRepository if necessary
		this.cMakeVars += new Pair(CMakeUtils.WS_PATH, wsPath)
		UnzipHelper::unzipNRepository(wsPath)
	}

	override getGenerationContents(IrRoot ir)
	{
		val fileContents = new ArrayList<GenerationContent>
		for (module : ir.modules)
		{
			fileContents += new GenerationContent(module.className + '.h', module.headerFileContent, false)
			fileContents += new GenerationContent(module.className + '.cc', module.sourceFileContent, false)
		}
		fileContents += new GenerationContent('CMakeLists.txt', backend.cmakeContentProvider.getContentFor(ir, hasLevelDB, cMakeVars), false)
		return fileContents
	}

	private def getHeaderFileContent(IrModule it)
	'''
	/* «Utils::doNotEditWarning» */

	#ifndef «name.HDefineName»
	#define «name.HDefineName»

	«backend.includesContentProvider.getIncludes(hasLevelDB, (irRoot.postProcessing !== null))»
	#include "«irRoot.mesh.className».h"
	«IF irRoot.postProcessing !== null»#include "PvdFileWriter2D.h"«ENDIF»
	«FOR provider : externalProviders»
	#include "«provider.className».h"
	«ENDFOR»
	«IF !main»
	#include "«irRoot.mainModule.className».h"
	«ENDIF»

	«backend.includesContentProvider.getUsings(hasLevelDB)»
	«IF main && irRoot.modules.size > 1»

		«FOR m : irRoot.modules.filter[x | x !== it]»
			class «m.className»;
		«ENDFOR»
	«ENDIF»
	«IF !functions.empty»

	/******************** Free functions declarations ********************/

	namespace «freeFunctionNs»
	{
	«FOR f : functions»
		«functionContentProvider.getDeclarationContent(f)»;
	«ENDFOR»
	}
	«ENDIF»

	/******************** Module declaration ********************/

	class «className»
	{
		«FOR adm : irRoot.modules.filter[x | x !== it]»
		friend class «adm.className»;
		«ENDFOR»
		«IF kokkosTeamThread»
		typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

		«ENDIF»
	public:
		«className»(«irRoot.mesh.className»& aMesh);
		~«className»();

		void jsonInit(const char* jsonContent);
		«IF !main»

		inline void setMainModule(«irRoot.mainModule.className»* value)
		{
			mainModule = value,
			mainModule->«name» = this;
		}
		«ENDIF»

		void simulate();
		«FOR j : jobs»
		«backend.jobContentProvider.getDeclarationContent(j)»
		«ENDFOR»
		«IF levelDB»
			const std::string& get«IrUtils.NonRegressionNameAndValue.key.toFirstUpper»()
			{
				return «IrUtils.NonRegressionNameAndValue.key»;
			}

			void createDB(const std::string& db_name);
		«ENDIF»

	private:
		«IF postProcessing !== null»
		void dumpVariables(int iteration, bool useTimer=true);

		«ENDIF»
		«IF kokkosTeamThread»
		/**
		 * Utility function to get work load for each team of threads
		 * In  : thread and number of element to use for computation
		 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
		 */
		const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept;

		«ENDIF»
		// Mesh and mesh variables
		«irRoot.mesh.className»& mesh;
		«FOR c : irRoot.mesh.connectivities.filter[multiple] BEFORE 'size_t ' SEPARATOR ', ' AFTER ';'»«c.nbElemsVar»«ENDFOR»

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
		// Option and global variables
		«IF postProcessing !== null»
			PvdFileWriter2D* writer;
			std::string «IrUtils.OutputPathNameAndValue.key»;
		«ENDIF»
		«FOR v : externalProviders»
			«v.className» «v.instanceName»;
		«ENDFOR»
		«IF levelDB»
			std::string «IrUtils.NonRegressionNameAndValue.key»;
		«ENDIF»
		«FOR v : variables»
			«v.variableDeclaration»
		«ENDFOR»

		// Timers
		Timer globalTimer;
		Timer cpuTimer;
		Timer ioTimer;
	};

	#endif
	'''

	private def getSourceFileContent(IrModule it)
	'''
	/* «Utils::doNotEditWarning» */

	#include "«className».h"
	#include <rapidjson/document.h>
	#include <rapidjson/istreamwrapper.h>
	#include <rapidjson/stringbuffer.h>
	#include <rapidjson/writer.h>
	«IF main && irRoot.modules.size > 1»
		«FOR m : irRoot.modules.filter[x | x !== it]»
			#include "«m.className».h"
		«ENDFOR»
	«ENDIF»

	«IF !functions.empty»

	/******************** Free functions definitions ********************/

	namespace «freeFunctionNs»
	{
	«FOR f : functions SEPARATOR '\n'»
		«functionContentProvider.getDefinitionContent(f)»
	«ENDFOR»
	}
	«ENDIF»

	/******************** Module definition ********************/

	«className»::«className»(«irRoot.mesh.className»& aMesh)
	: mesh(aMesh)
	«FOR c : irRoot.mesh.connectivities.filter[multiple]»
	, «c.nbElemsVar»(«c.connectivityAccessor»)
	«ENDFOR»
	«FOR v : variables»
		«IF !v.option && v.defaultValue !== null && !v.constExpr»
			, «v.name»(«expressionContentProvider.getContent(v.defaultValue)»)
		«ELSEIF !(v.type instanceof BaseType)»
			, «v.name»(«typeContentProvider.getCstrInit(v.type, v.name)»)
		«ENDIF»
	«ENDFOR»
	{
		«val dynamicArrayVariables = variables.filter[x | x.type instanceof BaseType && !(x.type as BaseType).isStatic]»
		«IF !dynamicArrayVariables.empty»
			// Allocate dynamic arrays (RealArrays with at least a dynamic dimension)
			«FOR v : dynamicArrayVariables»
				«typeContentProvider.initCppTypeContent(v.name, v.type)»
			«ENDFOR»

		«ENDIF»
		«IF main»
		// Copy node coordinates
		const auto& gNodes = mesh.getGeometry()->getNodes();
		«val iterator = backend.typeContentProvider.formatIterators(irRoot.initNodeCoordVariable.type as ConnectivityType, #["rNodes"])»
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

	void
	«className»::jsonInit(const char* jsonContent)
	{
		rapidjson::Document document;
		assert(!document.Parse(jsonContent).HasParseError());
		assert(document.IsObject());
		const rapidjson::Value::Object& o = document.GetObject();

		«IF postProcessing !== null»
		«val opName = IrUtils.OutputPathNameAndValue.key»
		// «opName»
		assert(o.HasMember("«opName»"));
		const rapidjson::Value& «jsonContentProvider.getJsonName(opName)» = o["«opName»"];
		assert(«jsonContentProvider.getJsonName(opName)».IsString());
		«opName» = «jsonContentProvider.getJsonName(opName)».GetString();
		writer = new PvdFileWriter2D("«irRoot.name»", «opName»);
		«ENDIF»
		«FOR v : options»
		«jsonContentProvider.getJsonContent(v.name, v.type as BaseType, v.defaultValue)»
		«ENDFOR»
		«FOR v : externalProviders»
		«val vName = v.instanceName»
		// «vName»
		if (o.HasMember("«vName»"))
		{
			rapidjson::StringBuffer strbuf;
			rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
			o["«vName»"].Accept(writer);
			«vName».jsonInit(strbuf.GetString());
		}
		«ENDFOR»
		«IF levelDB»
		// Non regression
		«val nrName = IrUtils.NonRegressionNameAndValue.key»
		assert(o.HasMember("«nrName»"));
		const rapidjson::Value& «jsonContentProvider.getJsonName(nrName)» = o["«nrName»"];
		assert(«jsonContentProvider.getJsonName(nrName)».IsString());
		«nrName» = «jsonContentProvider.getJsonName(nrName)».GetString();
		«ENDIF»
	}

	«IF kokkosTeamThread»

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
		if (writer != NULL && !writer->isDisabled())
		{
			if (useTimer)
			{
				cpuTimer.stop();
				ioTimer.start();
			}
			auto quads = mesh.getGeometry()->getQuads();
			writer->startVtpFile(iteration, «irRoot.currentTimeVariable.name», nbNodes, «irRoot.nodeCoordVariable.name».data(), nbCells, quads.data());
			«val outputVarsByConnectivities = irRoot.postProcessing.outputVariables.groupBy(x | x.support.name)»
			writer->openNodeData();
			«val nodeVariables = outputVarsByConnectivities.get("node")»
			«IF !nodeVariables.nullOrEmpty»
				«FOR v : nodeVariables»
					writer->openNodeArray("«v.outputName»", «v.target.type.baseSizes.size»);
					for (size_t i=0 ; i<nbNodes ; ++i)
						writer->write(«v.target.writeCallContent»);
					writer->closeNodeArray();
				«ENDFOR»
			«ENDIF»
			writer->closeNodeData();
			writer->openCellData();
			«val cellVariables = outputVarsByConnectivities.get("cell")»
			«IF !cellVariables.nullOrEmpty»
				«FOR v : cellVariables»
					writer->openCellArray("«v.outputName»", «v.target.type.baseSizes.size»);
					for (size_t i=0 ; i<nbCells ; ++i)
						writer->write(«v.target.writeCallContent»);
					writer->closeCellArray();
				«ENDFOR»
			«ENDIF»
			writer->closeCellData();
			writer->closeVtpFile();
			«postProcessing.lastDumpVariable.name» = «postProcessing.periodReference.name»;
			if (useTimer)
			{
				ioTimer.stop();
				cpuTimer.start();
			}
		}
	}
	«ENDIF»

	void «className»::«Utils.getCodeName(irRoot.main)»()
	{
		«backend.traceContentProvider.getBeginOfSimuTrace(it)»

		«jobCallerContentProvider.getCallsHeader(irRoot.main)»
		«jobCallerContentProvider.getCallsContent(irRoot.main)»
		«backend.traceContentProvider.getEndOfSimuTrace(irRoot, linearAlgebra)»
	}
	«IF levelDB»

	void «className»::createDB(const std::string& db_name)
	{
		leveldb::DB* db;
		leveldb::Options options;

		// Destroy if exists
		leveldb::DestroyDB(db_name, options);

		// Create data base
		options.create_if_missing = true;
		leveldb::Status status = leveldb::DB::Open(options, db_name, &db);
		assert(status.ok());
		// Batch to write all data at once
		leveldb::WriteBatch batch;
		«FOR v : irRoot.variables.filter[!option]»
		batch.Put("«Utils.getDbKey(v)»", serialize(«Utils.getDbValue(it, v, '->')»));
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
		«backend.mainContentProvider.getContentFor(it, hasLevelDB)»
		return ret;
	}
	«ENDIF»
	'''

	private def getConnectivityAccessor(Connectivity c)
	{
		if (c.inTypes.empty)
			'''mesh.getNb«c.name.toFirstUpper»()'''
		else
			'''CartesianMesh2D::MaxNb«c.name.toFirstUpper»'''
	}

	private def isLevelDB(IrModule it)
	{
		main && hasLevelDB
	}

	private def CharSequence getVariableDeclaration(Variable v)
	{
		switch v
		{
			case v.constExpr: '''static constexpr «typeContentProvider.getCppType(v.type)» «v.name» = «expressionContentProvider.getContent(v.defaultValue)»;'''
			case v.const: '''const «typeContentProvider.getCppType(v.type)» «v.name»;'''
			default: '''«typeContentProvider.getCppType(v.type)» «v.name»;'''
		}
	}

	private def isKokkosTeamThread()
	{
		backend instanceof KokkosTeamThreadBackend
	}

	private def getWriteCallContent(Variable v)
	{
		val t = v.type
		switch t
		{
			ConnectivityType: '''«v.name»«typeContentProvider.formatIterators(t, #["i"])»'''
			LinearAlgebraType: '''«v.name».getValue(i)'''
			default: throw new RuntimeException("Unexpected type: " + class.name)
		}
	}
}