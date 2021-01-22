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

import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.ProviderGenerator
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.Function
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class CppProviderGenerator extends CppGenerator implements ProviderGenerator
{
	new(Backend backend, String libCppNablaDir)
	{
		super(backend, libCppNablaDir)
	}

	override getGenerationContents(ExtensionProvider provider, Iterable<Function> functions)
	{
		val fileContents = new ArrayList<GenerationContent>

		// .h of interface
		val interfaceHeaderFileName = getNsPrefix(provider, '::', '/') + provider.interfaceName + ".h"
		fileContents += new GenerationContent(interfaceHeaderFileName, getInterfaceHeaderFileContent(provider, functions), false)

		// CMakeLists.txt
		val cmakeFileName = "CMakeLists.txt"
		fileContents += new GenerationContent(cmakeFileName, getCMakeFileContent(provider, libCppNablaDir), false)

		// Generates .h and .cc if they does not exists
		// .h
		val headerFileName = getNsPrefix(provider, '::', '/') + provider.facadeClass + ".h"
		fileContents += new GenerationContent(headerFileName, getHeaderFileContent(provider, functions), true)

		// .cc
		val sourceFileName = getNsPrefix(provider, '::', '/') + provider.facadeClass + ".cc"
		fileContents += new GenerationContent(sourceFileName, getSourceFileContent(provider, functions), true)

		return fileContents
	}

	private def getInterfaceHeaderFileContent(ExtensionProvider provider, Iterable<Function> irFunctions)
	'''
	«Utils::fileHeader»

	#ifndef __«getNsPrefix(provider, '::', '_').toUpperCase»«provider.interfaceName.toUpperCase»
	#define __«getNsPrefix(provider, '::', '_').toUpperCase»_«provider.interfaceName.toUpperCase»

	#include <iostream>
	#include <string>
	#include "nablalib/types/Types.h"

	using namespace nablalib::types;

	«IF !provider.facadeNamespace.nullOrEmpty»
	namespace «provider.facadeNamespace»
	{
	«ENDIF»
		class «provider.interfaceName»
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
	«IF !provider.facadeNamespace.nullOrEmpty»
	}
	«ENDIF»

	#endif // __«getNsPrefix(provider, '::', '_').toUpperCase»_«provider.interfaceName.toUpperCase»
	'''

	private def getHeaderFileContent(ExtensionProvider provider, Iterable<Function> irFunctions)
	'''
	#ifndef __«getNsPrefix(provider, '::', '_').toUpperCase»_«provider.facadeClass.toUpperCase»
	#define __«getNsPrefix(provider, '::', '_').toUpperCase»_«provider.facadeClass.toUpperCase»

	#include <iostream>
	#include <string>
	#include "«getNsPrefix(provider, '::', '/')»«provider.interfaceName».h"

	using namespace nablalib::types;

	«IF !provider.facadeNamespace.nullOrEmpty»
	namespace «provider.facadeNamespace»
	{
	«ENDIF»
		class «provider.facadeClass» : public «provider.interfaceName»
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
	«IF !provider.facadeNamespace.nullOrEmpty»
	}
	«ENDIF»

	#endif // __«getNsPrefix(provider, '::', '_').toUpperCase»_«provider.facadeClass.toUpperCase»
	'''

	private def getSourceFileContent(ExtensionProvider provider, Iterable<Function> irFunctions)
	'''
	#include "«getNsPrefix(provider, '::', '/')»«provider.facadeClass».h"
	#include <string>

	«IF !provider.facadeNamespace.nullOrEmpty»
	namespace «provider.facadeNamespace»
	{
	«ENDIF»
	void «provider.facadeClass»::jsonInit(const char* jsonContent)
	{
		// Your code here
	}
	«IF !provider.facadeNamespace.nullOrEmpty»
	}
	«ENDIF»
	'''

	private def getCMakeFileContent(ExtensionProvider provider, String libCppNablaDir)
	'''
	«CMakeUtils.fileHeader»

	set(LIBCPPNABLA_DIR «CMakeUtils.formatCMakePath(libCppNablaDir)» CACHE STRING "")

	project(«provider.providerName» CXX)

	«CMakeUtils.setCompiler»

	MESSAGE(STATUS "Building library «provider.libName»")

	add_subdirectory(${LIBCPPNABLA_DIR}/src ${CMAKE_BINARY_DIR}/«CppGeneratorUtils::CppLibName» EXCLUDE_FROM_ALL)

	add_library(«provider.libName» «getNsPrefix(provider, '::', '/')»«provider.facadeClass».cc)
	set_property(TARGET «provider.libName» PROPERTY POSITION_INDEPENDENT_CODE ON)
	target_include_directories(«provider.libName» PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
	target_link_libraries(«provider.libName» PUBLIC cppnabla)

	«CMakeUtils.fileFooter»
	'''
}