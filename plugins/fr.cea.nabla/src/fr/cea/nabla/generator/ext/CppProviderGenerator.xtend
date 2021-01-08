package fr.cea.nabla.generator.ext

import com.google.inject.Inject
import fr.cea.nabla.generator.BackendFactoryProvider
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.cpp.CMakeUtils
import fr.cea.nabla.ir.generator.cpp.LightBackend
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nablaext.TargetType
import org.eclipse.core.resources.IProject

class CppProviderGenerator extends StandaloneGeneratorBase
{
	@Inject BackendFactoryProvider backendFactoryProvider

	def generate(NablaExtension nablaExt, IProject project, Iterable<Function> irFunctions, String libcppnablaHome)
	{
		val projectHome = project.location.toString
		dispatcher.post(MessageType::Exec, "Starting C++ extension provider generator in: " + projectHome)
		val fsa = getConfiguredFileSystemAccess(projectHome, false)

		// .h of interface
		val backend = backendFactoryProvider.getCppBackend(TargetType::CPP_SEQUENTIAL).create
		val interfaceHeaderFileName = "include/" + nablaExt.name.toLowerCase + "/I" + nablaExt.name + ".h"
		dispatcher.post(MessageType::Exec, "    Generating: " + interfaceHeaderFileName)
		fsa.generateFile(interfaceHeaderFileName, getInterfaceHeaderFileContent(nablaExt, backend, irFunctions))

		// CMakeLists.txt
		val cmakeFileName = "src/CMakeLists.txt"
		dispatcher.post(MessageType::Exec, "    Generating: " + cmakeFileName)
		fsa.generateFile(cmakeFileName, getCmakeFileContent(nablaExt, libcppnablaHome))

		// Generates .h and .cc if they does not exists
		// .h
		val headerFileName = "include/" + nablaExt.name.toLowerCase + "/" + nablaExt.name + ".h"
		if (!fsa.isFile(headerFileName))
		{
			dispatcher.post(MessageType::Exec, "    Generating: " + headerFileName)
			fsa.generateFile(headerFileName, getHeaderFileContent(nablaExt, backend, irFunctions))
		}

		// .cc
		val sourceFileName = "src/" + nablaExt.name + ".cc"
		if (!fsa.isFile(sourceFileName))
		{
			dispatcher.post(MessageType::Exec, "    Generating: " + sourceFileName)
			fsa.generateFile(sourceFileName, getSourceFileContent(nablaExt, irFunctions))
		}
	}

	private def getInterfaceHeaderFileContent(NablaExtension it, LightBackend backend, Iterable<Function> irFunctions)
	'''
	«Utils::fileHeader»

	#ifndef __«name.toUpperCase»_I«name.toUpperCase»
	#define __«name.toUpperCase»_I«name.toUpperCase»

	#include <iostream>
	#include <string>
	#include "types/Types.h"

	using namespace nablalib;

	namespace «name.toLowerCase»
	{
		class I«name»
		{
		public:
			virtual void jsonInit(const char* jsonContent) = 0;

			/* 
			 * Here are the other methods to implement in «name» class.
			 * Some of them can be templates. Therefore they can not be virtual.
			 *
			«FOR f : irFunctions»

			«backend.functionContentProvider.getDeclarationContent(f)»;
			«ENDFOR»
			*/
		};
	}

	#endif // __«name.toUpperCase»_I«name.toUpperCase»
	'''

	private def getHeaderFileContent(NablaExtension it, LightBackend backend, Iterable<Function> irFunctions)
	'''
	#ifndef __«name.toUpperCase»_«name.toUpperCase»
	#define __«name.toUpperCase»_«name.toUpperCase»

	#include <iostream>
	#include <string>
	#include "«name.toLowerCase»/I«name».h"

	using namespace nablalib;

	namespace «name.toLowerCase»
	{
		class «name» : public I«name»
		{
		public:
			void jsonInit(const char* jsonContent) override;
			«FOR f : irFunctions»

			«backend.functionContentProvider.getDeclarationContent(f)»
			{
				// Your code here
			}
			«ENDFOR»
		};
	}

	#endif // __«name.toUpperCase»_«name.toUpperCase»
	'''

	private def getSourceFileContent(NablaExtension it, Iterable<Function> irFunctions)
	'''
	#include "«name.toLowerCase»/«name».h"
	#include <string>

	namespace  «name.toLowerCase»
	{

	void «name»::jsonInit(const char* jsonContent)
	{
		// Your code here
	}

	}
	'''

	private def getCmakeFileContent(NablaExtension it, String libcppnablaHome)
	'''
	«CMakeUtils.fileHeader»

	set(LIBCPPNABLA_DIR «libcppnablaHome»)
	«CMakeUtils.setCompiler»

	project(«name» CXX)
	MESSAGE(STATUS "Building library «name.toLowerCase»")

	add_subdirectory(${LIBCPPNABLA_DIR} ${LIBCPPNABLA_DIR})

	add_library(«name.toLowerCase» SHARED «name».cc)
	target_include_directories(«name.toLowerCase» PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../include)
	target_link_libraries(«name.toLowerCase» PUBLIC cppnabla)

	«CMakeUtils.fileFooter»
	'''
}