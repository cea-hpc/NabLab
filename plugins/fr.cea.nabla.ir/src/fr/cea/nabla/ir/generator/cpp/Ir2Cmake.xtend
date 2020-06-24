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

import fr.cea.nabla.ir.ir.IrModule

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

abstract class Ir2Cmake
{
	protected String compiler
	protected String compilerPath

	abstract def CharSequence getLibraryBackend(IrModule m)
	abstract def Iterable<String> getTargetLinkLibraries(IrModule m)

	def getContentFor(IrModule it)
	'''
		#
		# Generated file - Do not overwrite
		#

		cmake_minimum_required(VERSION 3.15)
		
		set(NABLA_CXX_COMPILER «getCompilerPath(compiler, compilerPath)»)

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
		
		project(«name.toFirstUpper»Project CXX)

		«libraryBackend»
		add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla ${CMAKE_SOURCE_DIR}/../libcppnabla)

		add_executable(«name.toLowerCase» «name + '.cc'»)
		target_include_directories(«name.toLowerCase» PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
		target_link_libraries(«name.toLowerCase» cppnabla«FOR tll : targetLinkLibraries» «tll»«ENDFOR»)

		if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
		include(Project.cmake)
		endif()
	'''
	
	private def getCompilerPath(String compiler, String compilerPath)
	{
		if (compilerPath.nullOrEmpty)
			if (compiler == "GNU")
				"/usr/bin/g++"
			else // (compiler == "LLVM")
				"/usr/bin/clang++"
		else
			compilerPath
	}
}

class StlIr2Cmake extends Ir2Cmake
{
	new(String compiler, String compilerPath)
	{
		this.compiler = compiler
		this.compilerPath = compilerPath
	}

	override getLibraryBackend(IrModule m)
	'''set(LIBCPPNABLA_BACKEND "STL")'''

	override getTargetLinkLibraries(IrModule m)
	{
		#["cppnablastl", "pthread"]
	}
}

class KokkosIr2Cmake extends Ir2Cmake
{
	val String kokkosPath

	new(String compiler, String compilerPath, String kokkosPath)
	{
		this.kokkosPath = kokkosPath
		this.compiler = compiler
		this.compilerPath = compilerPath
	}

	override getLibraryBackend(IrModule m)
	'''
		set(LIBCPPNABLA_BACKEND "KOKKOS")
		set(NABLA_KOKKOS_PATH "«kokkosPath»")
	'''

	override getTargetLinkLibraries(IrModule m)
	{
		#["cppnablakokkos"]
	}
}

class SequentialIr2Cmake extends Ir2Cmake
{
	new(String compiler, String compilerPath)
	{
		this.compiler = compiler
		this.compilerPath = compilerPath
	}

	override getLibraryBackend(IrModule m)
	{
		if (m.linearAlgebra)
			'''
				# libcppnabla for linear algebra
				set(LIBCPPNABLA_BACKEND "STL")
			'''
		else
			'''set(LIBCPPNABLA_BACKEND "NONE")'''
	}

	override getTargetLinkLibraries(IrModule m)
	{
		if (m.linearAlgebra)
			#["cppnablastl", "pthread"]
		else
			#[]
	}
}

class OpenMpCmake extends Ir2Cmake
{
	new(String compiler, String compilerPath)
	{
		this.compiler = compiler
		this.compilerPath = compilerPath
	}

	override getLibraryBackend(IrModule m)
	{
		if (m.linearAlgebra)
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

	override getTargetLinkLibraries(IrModule m)
	{
		if (m.linearAlgebra)
			#["OpenMP::OpenMP_CXX", "cppnablastl", "pthread"]
		else
			#["OpenMP::OpenMP_CXX"]
	}
}
