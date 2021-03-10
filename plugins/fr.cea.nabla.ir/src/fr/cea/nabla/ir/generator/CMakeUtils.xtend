/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.ExtensionProvider

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class CMakeUtils
{
	static val userDir = System.getProperty("user.home")

	static def getFileHeader(boolean subDirectory)
	'''
		### GENERATED FILE - DO NOT OVERWRITE ###

		«IF subDirectory»
		# This file is in a cmake sub_directory and is called by a root CMakeLists.txt 
		«ELSE»
		cmake_minimum_required(VERSION 3.10)
		set(CMAKE_VERBOSE_MAKEFILE FALSE)
		«ENDIF»
	'''

	static def setVariables(Iterable<Pair<String, String>> variables, Iterable<ExtensionProvider> providers)
	'''
		# SET VARIABLES
		«FOR v : variables»
		«IF v.key == "N_CXX_COMPILER"»
		set(CMAKE_CXX_COMPILER «v.value» CACHE STRING "")
		«ELSE»
		set(«v.key» «formatCMakePath(v.value)»)
		«ENDIF»
		«ENDFOR»
		«FOR p : providers»
		set(«p.pathVar.key» «p.pathVar.value»)
		«ENDFOR»
	'''

	static def checkVariables(Iterable<String> variableNames)
	'''
		«IF !variableNames.empty»
			# CHECK VARIABLES
			«FOR v : variableNames»
			if (NOT DEFINED «v»)
				message(FATAL_ERROR "«v» variable must be set")
			endif()
			«ENDFOR»
		«ENDIF»
	'''

	static def addSubDirectories(boolean needNablalib, Iterable<ExtensionProvider> providers)
	'''
		«IF needNablalib || !providers.empty»
			# SUB_DIRECTORIES
			«IF needNablalib»
				if(NOT TARGET nablalib)
					add_subdirectory(${N_WS_PATH}/«fr.cea.nabla.ir.Utils::NRepository»/nablalib ${CMAKE_BINARY_DIR}/nablalib)
				endif()
			«ENDIF»
			«FOR p : providers»
				if(NOT TARGET «p.libName»)
					add_subdirectory(${«p.pathVar.key»} ${CMAKE_BINARY_DIR}/«p.dirName»)
				endif()
			«ENDFOR»
		«ENDIF»
	'''

	static def checkCompiler()
	'''
		# CHECK CXX VERSION: must be done after the project() (CMAKE_CXX_COMPILER_ID not defined before)
		if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
			if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "7.4.0")
				message(FATAL_ERROR "GCC minimum required version is 7.4.0. Please upgrade.")
			endif()
		elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
			if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
				message(FATAL_ERROR "Clang minimum required version is 9.0.0. Please upgrade.")
			endif()
		endif()
	'''

	static def getFileFooter()
	'''
		# OPTIONAL USER OPTIONS IN Project.cmake
		if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
			include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
		endif()
	'''

	private static def formatCMakePath(String path)
	{
		if (path.startsWith(userDir))
			path.replace(userDir, "$ENV{HOME}")
		else
			path
	}
}
