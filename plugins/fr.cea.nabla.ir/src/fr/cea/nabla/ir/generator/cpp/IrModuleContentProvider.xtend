/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.CppGeneratorUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.Variable
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.CppGeneratorUtils.*

@Data
class IrModuleContentProvider
{
	val TraceContentProvider traceContentProvider
	val IncludesContentProvider includesContentProvider
	val FunctionContentProvider functionContentProvider
	val JobContentProvider jobContentProvider
	val TypeContentProvider typeContentProvider
	val ExpressionContentProvider expressionContentProvider
	val JsonContentProvider jsonContentProvider
	val JobCallerContentProvider jobCallerContentProvider
	val MainContentProvider mainContentProvider
	val AbstractPythonEmbeddingContentProvider pythonEmbeddingContentProvider

	protected def getTypeDefs(IrModule it) ''''''
	protected def getPrivateMethodHeaders(IrModule it) ''''''
	protected def getPrivateMethodBodies(IrModule it) ''''''

	def getHeaderFileContent(IrModule it, boolean hasLevelDB)
	'''
	/* «Utils::doNotEditWarning» */

	#ifndef «name.HDefineName»
	#define «name.HDefineName»

	«includesContentProvider.getIncludes(main && hasLevelDB, (irRoot.postProcessing !== null))»
	#include "«irRoot.mesh.className».h"
	«IF irRoot.postProcessing !== null»#include "PvdFileWriter2D.h"«ENDIF»
	«FOR provider : externalProviders»
	#include "«provider.className».h"
	«ENDFOR»
	«IF !main»
	#include "«irRoot.mainModule.className».h"
	«ENDIF»

	«includesContentProvider.getUsings(hasLevelDB)»
	
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
		«val otherModules = irRoot.modules.filter[x | x !== it]»
		«IF otherModules.size > 0»
			«FOR adm : otherModules»
				friend class «adm.className»;
			«ENDFOR»

		«ENDIF»
		«typeDefs»
	
	private:
		«IF postProcessing !== null»
		void dumpVariables(int iteration, bool useTimer=true);

		«ENDIF»
		«privateMethodHeaders»
		// Mesh and mesh variables
		«irRoot.mesh.className»& mesh;
		«FOR a : neededConnectivityAttributes»
			size_t «a.nbElemsVar»;
		«ENDFOR»
		«FOR a : neededGroupAttributes»
			size_t «a.nbElemsVar»;
		«ENDFOR»

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
		«IF postProcessing !== null»
			PvdFileWriter2D* writer;
			std::string «IrUtils.OutputPathNameAndValue.key»;
		«ENDIF»
		«FOR v : externalProviders»
			«v.className» «v.instanceName»;
		«ENDFOR»
		«IF main && hasLevelDB»
			std::string «IrUtils.NonRegressionNameAndValue.key»;
			double «IrUtils.NonRegressionToleranceNameAndValue.key»;
		«ENDIF»

		// Timers
		Timer globalTimer;
		Timer cpuTimer;
		Timer ioTimer;
		
		«pythonEmbeddingContentProvider.getPrivateMembers(it)»
	
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
		«jobContentProvider.getDeclarationContent(j)»
		«ENDFOR»
		«IF main && hasLevelDB»
			const std::string& get«IrUtils.NonRegressionNameAndValue.key.toFirstUpper»()
			{
				return «IrUtils.NonRegressionNameAndValue.key»;
			}
			const double get«IrUtils.NonRegressionToleranceNameAndValue.key.toFirstUpper»()
			{
				return «IrUtils.NonRegressionToleranceNameAndValue.key»;
			}
			void createDB(const std::string& db_name);
		«ENDIF»

		// Options and global variables.
		// Module variables are public members of the class to be accessible from Python.
		«FOR v : variables»
			«IF v.constExpr»
				static constexpr «typeContentProvider.getCppType(v.type)» «v.name» = «expressionContentProvider.getContent(v.defaultValue)»;
			«ELSE»
				««« Must not be declared const even it the const attribute is true
				««« because it will be initialized in the jsonInit function (not in cstr)
				«typeContentProvider.getCppType(v.type)» «v.name»;
			«ENDIF»
		«ENDFOR»
	};
	
	«pythonEmbeddingContentProvider.getAllScopeStructContent(it)»
	#endif
	'''

	def getSourceFileContent(IrModule it, boolean hasLevelDB)
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
	«FOR a : neededConnectivityAttributes»
	, «a.nbElemsVar»(mesh.getNb«a.name.toFirstUpper»())
	«ENDFOR»
	«FOR a : neededGroupAttributes»
	, «a.nbElemsVar»(mesh.getGroup("«a»").size())
	«ENDFOR»
	«FOR v : variables.filter[x | !(x.type instanceof BaseType)]»
		, «v.name»(«typeContentProvider.getCstrInit(v.type, v.name)»)
	«ENDFOR»
	{
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
		const rapidjson::Value::Object& options = document.GetObject();

		«IF postProcessing !== null»
		«val opName = IrUtils.OutputPathNameAndValue.key»
		assert(options.HasMember("«opName»"));
		const rapidjson::Value& «jsonContentProvider.getJsonName(opName)» = options["«opName»"];
		assert(«jsonContentProvider.getJsonName(opName)».IsString());
		«opName» = «jsonContentProvider.getJsonName(opName)».GetString();
		writer = new PvdFileWriter2D("«irRoot.name»", «opName»);
		«ENDIF»
		«FOR v : variables.filter[!constExpr]»
			«IF v.type.dynamicBaseType»
				«typeContentProvider.initCppTypeContent(v.name, v.type)»
			«ENDIF»
			«IF v.option»
				«jsonContentProvider.getJsonContent(v.name, v.type as BaseType, v.defaultValue)»
			«ELSEIF v.defaultValue !== null»
				«v.name» = «expressionContentProvider.getContent(v.defaultValue)»;
			«ENDIF»
		«ENDFOR»
		«FOR v : externalProviders»
		«val vName = v.instanceName»
		// «vName»
		if (options.HasMember("«vName»"))
		{
			rapidjson::StringBuffer strbuf;
			rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
			options["«vName»"].Accept(writer);
			«vName».jsonInit(strbuf.GetString());
		}
		«ENDFOR»
		«IF main && hasLevelDB»

		// Non regression
		«val nrName = IrUtils.NonRegressionNameAndValue.key»
		assert(options.HasMember("«nrName»"));
		const rapidjson::Value& «jsonContentProvider.getJsonName(nrName)» = options["«nrName»"];
		assert(«jsonContentProvider.getJsonName(nrName)».IsString());
		«nrName» = «jsonContentProvider.getJsonName(nrName)».GetString();
		«val nrToleranceName = IrUtils.NonRegressionToleranceNameAndValue.key»
		if (options.HasMember("«nrToleranceName»"))
		{
			const rapidjson::Value& «jsonContentProvider.getJsonName(nrToleranceName)» = options["«nrToleranceName»"];
			assert(«jsonContentProvider.getJsonName(nrToleranceName)».IsDouble());
			«nrToleranceName» = «jsonContentProvider.getJsonName(nrToleranceName)».GetDouble();
		}
		else
			«nrToleranceName» = 0.0;
		«ENDIF»
		«pythonEmbeddingContentProvider.pythonJsonInitContent»
		«IF main»

			// Copy node coordinates
			const auto& gNodes = mesh.getGeometry()->getNodes();
			«val iterator = typeContentProvider.formatIterators(irRoot.initNodeCoordVariable.type as ConnectivityType, #["rNodes"])»
			for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
			{
				«irRoot.initNodeCoordVariable.name»«iterator»[0] = gNodes[rNodes][0];
				«irRoot.initNodeCoordVariable.name»«iterator»[1] = gNodes[rNodes][1];
			}
		«ENDIF»
	}

	«privateMethodBodies»
	«FOR j : jobs SEPARATOR '\n'»
		«jobContentProvider.getDefinitionContent(j)»
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
	
	«pythonEmbeddingContentProvider.getPythonInitializeContent(it)»
	void «className»::simulate()
	{
		«pythonEmbeddingContentProvider.simulateProlog»
		«traceContentProvider.getBeginOfSimuTrace(it)»

		«jobCallerContentProvider.getCallsHeader(irRoot.main)»
		«jobCallerContentProvider.getCallsContent(irRoot.main)»
		«traceContentProvider.getEndOfSimuTrace(irRoot, linearAlgebra)»
	}
	«IF main && hasLevelDB»

	void «className»::createDB(const std::string& db_name)
	{
		leveldb::DB* db;
		leveldb::Options db_options;

		// Destroy if exists
		leveldb::DestroyDB(db_name, db_options);

		// Create data base
		db_options.create_if_missing = true;
		leveldb::Status status = leveldb::DB::Open(db_options, db_name, &db);
		assert(status.ok());
		// Batch to write all data at once
		leveldb::WriteBatch batch;
		«FOR v : irRoot.variables.filter[!option]»
		putDBDescriptor(&batch, "«Utils.getDbDescriptor(v)»", «CppGeneratorUtils.getDbBytes(v.type)», std::vector<size_t>{«CppGeneratorUtils.getDbSizes(v.type, v.name)»});
		putDBValue(&batch, "«Utils.getDbKey(v)»", «Utils.getDbValue(it, v, '->')»);
		«ENDFOR»
		status = db->Write(leveldb::WriteOptions(), &batch);
		// Checking everything was ok
		assert(status.ok());
		std::cerr << "Reference database " << db_name << " created." << std::endl;
		// Freeing memory
		delete db;
	}

	«ENDIF»

	int main(int argc, char* argv[]) 
	{
		«mainContentProvider.getContentFor(it, hasLevelDB)»
		return ret;
	}
	«ENDIF»
	'''

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

@Data
class KokkosTeamThreadIrModuleContentProvider extends IrModuleContentProvider
{
	override getTypeDefs(IrModule it)
	'''
		typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

	'''

	override getPrivateMethodHeaders(IrModule it)
	'''
		/**
		 * Utility function to get work load for each team of threads
		 * In  : thread and number of element to use for computation
		 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
		 */
		const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept;

	'''

	override getPrivateMethodBodies(IrModule it)
	'''
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

	'''
}