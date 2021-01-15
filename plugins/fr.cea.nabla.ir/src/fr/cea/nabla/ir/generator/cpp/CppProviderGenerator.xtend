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

import static extension fr.cea.nabla.ir.generator.ExtensionProviderExtensions.*

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
		val interfaceHeaderFileName = provider.namespaceName + '/' + provider.interfaceName + ".h"
		fileContents += new GenerationContent(interfaceHeaderFileName, getInterfaceHeaderFileContent(provider, functions), false)

		// CMakeLists.txt
		val cmakeFileName = "CMakeLists.txt"
		fileContents += new GenerationContent(cmakeFileName, getCMakeFileContent(provider, libCppNablaDir), false)

		// Generates .h and .cc if they does not exists
		// .h
		val headerFileName = provider.namespaceName + '/' + provider.className + ".h"
		fileContents += new GenerationContent(headerFileName, getHeaderFileContent(provider, functions), true)

		// .cc
		val sourceFileName = provider.namespaceName + '/' + provider.className + ".cc"
		fileContents += new GenerationContent(sourceFileName, getSourceFileContent(provider, functions), true)

		return fileContents
	}

	private def getInterfaceHeaderFileContent(ExtensionProvider provider, Iterable<Function> irFunctions)
	'''
	«Utils::fileHeader»

	#ifndef __«provider.namespaceName.toUpperCase»_«provider.interfaceName.toUpperCase»
	#define __«provider.namespaceName.toUpperCase»_«provider.interfaceName.toUpperCase»

	#include <iostream>
	#include <string>
	#include "types/Types.h"

	using namespace nablalib;

	namespace «provider.namespaceName»
	{
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
	}

	#endif // __«provider.namespaceName.toUpperCase»_«provider.interfaceName.toUpperCase»
	'''

	private def getHeaderFileContent(ExtensionProvider provider, Iterable<Function> irFunctions)
	'''
	#ifndef __«provider.namespaceName.toUpperCase»_«provider.className.toUpperCase»
	#define __«provider.namespaceName.toUpperCase»_«provider.className.toUpperCase»

	#include <iostream>
	#include <string>
	#include "«provider.namespaceName.toLowerCase»/«provider.interfaceName».h"

	using namespace nablalib;

	namespace «provider.namespaceName»
	{
		class «provider.className» : public «provider.interfaceName»
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

	#endif // __«provider.namespaceName.toUpperCase»_«provider.className.toUpperCase»
	'''

	private def getSourceFileContent(ExtensionProvider provider, Iterable<Function> irFunctions)
	'''
	#include "«provider.namespaceName.toLowerCase»/«provider.className».h"
	#include <string>

	namespace «provider.namespaceName»
	{
	void «provider.className»::jsonInit(const char* jsonContent)
	{
		// Your code here
	}
	}
	'''

	private def getCMakeFileContent(ExtensionProvider provider, String libCppNablaDir)
	'''
	«CMakeUtils.fileHeader»

	set(LIBCPPNABLA_DIR «libCppNablaDir» CACHE STRING "")

	project(«provider.projectName» CXX)

	«CMakeUtils.setCompiler»

	MESSAGE(STATUS "Building library «provider.libName»")

	add_subdirectory(${LIBCPPNABLA_DIR} ${CMAKE_BINARY_DIR}/libcppnabla EXCLUDE_FROM_ALL)

	add_library(«provider.libName» SHARED «provider.namespaceName.toLowerCase»/«provider.className».cc)
	target_include_directories(«provider.libName» PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
	target_link_libraries(«provider.libName» PUBLIC cppnabla)

	«CMakeUtils.fileFooter»
	'''
}