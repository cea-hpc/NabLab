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
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class CppProviderGenerator extends CppGenerator implements ProviderGenerator
{
	new(Backend backend, String libCppNablaDir)
	{
		super(backend, libCppNablaDir)
	}

	override getGenerationContents(ExtensionProvider provider)
	{
		val fileContents = new ArrayList<GenerationContent>
		val pathPrefix = getNsPrefix(provider, '::').replace('::', '/')

		// .h of interface
		val interfaceHeaderFileName = pathPrefix + provider.interfaceName + ".h"
		fileContents += new GenerationContent(interfaceHeaderFileName, getInterfaceHeaderFileContent(provider), false)

		// CMakeLists.txt
		val cmakeFileName = pathPrefix + "CMakeLists.txt"
		fileContents += new GenerationContent(cmakeFileName, getCMakeFileContent(provider, libCppNablaDir), false)

		// Generates .h and .cc if they does not exists
		// .h
		val headerFileName = pathPrefix + provider.className + ".h"
		fileContents += new GenerationContent(headerFileName, getHeaderFileContent(provider), true)

		// .cc
		val sourceFileName = pathPrefix + provider.className + ".cc"
		fileContents += new GenerationContent(sourceFileName, getSourceFileContent(provider), true)

		return fileContents
	}

	private def getInterfaceHeaderFileContent(ExtensionProvider provider)
	'''
		«val defineName = '__' + getNsPrefix(provider, '::').replace('::', '_').toUpperCase + '_' + provider.interfaceName.toUpperCase»
		«Utils::fileHeader»

		#ifndef «defineName»
		#define «defineName»

		«backend.includesContentProvider.getIncludes(false, false)»

		«backend.includesContentProvider.getUsings(false)»

		«IF !provider.namespace.nullOrEmpty»
		namespace «provider.namespace»
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
			«FOR f : provider.functions»

				«backend.functionContentProvider.getDeclarationContent(f)»;
			«ENDFOR»
			*/
		};
		«IF !provider.namespace.nullOrEmpty»
		}
		«ENDIF»

		#endif // «defineName»
	'''

	private def getHeaderFileContent(ExtensionProvider provider)
	'''
		«val pathPrefix = getNsPrefix(provider, '::').replace('::', '/')»
		«val defineName = '__' + getNsPrefix(provider, '::').replace('::', '_').toUpperCase + '_' + provider.className.toUpperCase»
		#ifndef «defineName»
		#define «defineName»

		#include "«pathPrefix»«provider.interfaceName».h"

		«IF !provider.namespace.nullOrEmpty»
		namespace «provider.namespace»
		{
		«ENDIF»
		class «provider.className» : public «provider.interfaceName»
		{
		public:
			void jsonInit(const char* jsonContent) override;
			«FOR f : provider.functions»

			«backend.functionContentProvider.getDeclarationContent(f)»
			{
				// Your code here
			}
			«ENDFOR»
		};
		«IF !provider.namespace.nullOrEmpty»
		}
		«ENDIF»

		#endif // «defineName»
	'''

	private def getSourceFileContent(ExtensionProvider provider)
	'''
		«val pathPrefix = getNsPrefix(provider, '::').replace('::', '/')»
		#include "«pathPrefix»«provider.className».h"
		#include <string>

		«IF !provider.namespace.nullOrEmpty»
			namespace «provider.namespace»
			{
		«ENDIF»
		void «provider.className»::jsonInit(const char* jsonContent)
		{
			// Your code here
		}
		«IF !provider.namespace.nullOrEmpty»
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

		if(NOT TARGET cppnabla)
			add_subdirectory(${LIBCPPNABLA_DIR} ${CMAKE_BINARY_DIR}/«CppGeneratorUtils::CppLibName» EXCLUDE_FROM_ALL)
		endif()

		add_library(«provider.libName» «provider.className».cc)
		set_property(TARGET «provider.libName» PROPERTY POSITION_INDEPENDENT_CODE ON)
		target_include_directories(«provider.libName» PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
		target_link_libraries(«provider.libName» PUBLIC cppnabla)

		«CMakeUtils.fileFooter»
	'''
}
