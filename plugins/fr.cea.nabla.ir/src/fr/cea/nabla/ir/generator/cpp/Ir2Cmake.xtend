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

import fr.cea.nabla.ir.ir.IrRoot
import java.util.HashMap

import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

abstract class Ir2Cmake
{
	protected String levelDBPath
	protected HashMap<String, String> variables

	abstract def CharSequence getLibraryBackend(IrRoot ir)
	abstract def Iterable<String> getTargetLinkLibraries(IrRoot ir)

	def getContentFor(IrRoot it)
	'''
		#
		# Generated file - Do not overwrite
		#

		cmake_minimum_required(VERSION 3.10)

		«FOR entry : variables.entrySet»
		set(«entry.key» «entry.value»)
		«ENDFOR»

		set(CMAKE_CXX_COMPILER ${NABLA_CXX_COMPILER} CACHE STRING "")

		if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
			if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "7.4.0")
				message(FATAL_ERROR "GCC minimum required version is 7.4.0. Please upgrade.")
			endif()
		elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
			if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
				message(FATAL_ERROR "Clang minimum required version is 9.0.0. Please upgrade.")
			endif()
		endif()

		project(«name»Project CXX)

		«libraryBackend»
		add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla ${CMAKE_SOURCE_DIR}/../libcppnabla)

		«IF !levelDBPath.nullOrEmpty»
		set(CMAKE_FIND_ROOT_PATH «levelDBPath»)
		find_package(leveldb)
		find_package(Threads REQUIRED)
		if(TARGET leveldb::leveldb)
			message(STATUS "levelDB found")
		else()
			message(STATUS "levelDB NOT found !!!")
		endif()
		«ENDIF»

		add_executable(«name.toLowerCase»«FOR m : modules» «m.className + '.cc'»«ENDFOR»)
		«val externalProviders = providers.filter[x | x != "Math"]»
		target_include_directories(«name.toLowerCase» PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..«FOR ep : externalProviders» «ep.libHome»/include«ENDFOR»)
		«IF !externalProviders.empty»
		target_link_directories(«name.toLowerCase» PUBLIC«FOR ep : externalProviders» «ep.libHome»/lib«ENDFOR»)
		«ENDIF»
		target_link_libraries(«name.toLowerCase» PUBLIC cppnabla«FOR tll : targetLinkLibraries» «tll»«ENDFOR»«IF !levelDBPath.nullOrEmpty» leveldb::leveldb Threads::Threads«ENDIF»«FOR ep : externalProviders» «ep.libName»«ENDFOR»)

		if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
			include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
		endif()
	'''
}

class StlIr2Cmake extends Ir2Cmake
{
	new(String levelDBPath, HashMap<String, String> variables)
	{
		this.levelDBPath = levelDBPath
		this.variables = variables
	}

	override getLibraryBackend(IrRoot ir)
	'''set(LIBCPPNABLA_BACKEND "STL")'''

	override getTargetLinkLibraries(IrRoot ir)
	{
		#["cppnablastl", "pthread"]
	}
}

class KokkosIr2Cmake extends Ir2Cmake
{
	new(String levelDBPath, HashMap<String, String> variables)
	{
		this.levelDBPath = levelDBPath
		this.variables = variables
	}

	override getLibraryBackend(IrRoot ir)
	'''
		set(LIBCPPNABLA_BACKEND "KOKKOS")
	'''

	override getTargetLinkLibraries(IrRoot ir)
	{
		#["cppnablakokkos"]
	}
}

class SequentialIr2Cmake extends Ir2Cmake
{
	new(String levelDBPath, HashMap<String, String> variables)
	{
		this.levelDBPath = levelDBPath
		this.variables = variables
	}

	override getLibraryBackend(IrRoot ir)
	{
		if (ir.linearAlgebra)
			'''
				# libcppnabla for linear algebra
				set(LIBCPPNABLA_BACKEND "STL")
			'''
		else
			'''set(LIBCPPNABLA_BACKEND "NONE")'''
	}

	override getTargetLinkLibraries(IrRoot ir)
	{
		if (ir.linearAlgebra)
			#["cppnablastl", "pthread"]
		else
			#[]
	}
}

class OpenMpCmake extends Ir2Cmake
{
	new(String levelDBPath, HashMap<String, String> variables)
	{
		this.levelDBPath = levelDBPath
		this.variables = variables
	}

	override getLibraryBackend(IrRoot ir)
	{
		if (ir.linearAlgebra)
			'''
				# libcppnabla for linear algebra
				set(LIBCPPNABLA_BACKEND "STL")
				find_package(OpenMP)
			'''
		else
			'''
				set(LIBCPPNABLA_BACKEND "NONE")
				find_package(OpenMP)
			'''
	}

	override getTargetLinkLibraries(IrRoot ir)
	{
		if (ir.linearAlgebra)
			#["OpenMP::OpenMP_CXX", "cppnablastl", "pthread"]
		else
			#["OpenMP::OpenMP_CXX"]
	}
}
