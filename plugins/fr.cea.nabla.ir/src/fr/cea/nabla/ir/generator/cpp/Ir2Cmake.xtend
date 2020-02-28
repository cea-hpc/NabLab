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
import java.util.LinkedHashSet
import org.eclipse.xtend.lib.annotations.Data

@Data
class Ir2Cmake
{
	val LinkedHashSet<String> environmentVariables = new LinkedHashSet<String>
	val LinkedHashSet<String> includeDirectories = new LinkedHashSet<String>
	val LinkedHashSet<String> linkDirectories = new LinkedHashSet<String>
	val LinkedHashSet<String> targetLinkLibraries = new LinkedHashSet<String>

	def getContentFor(IrModule it)
	'''
		#
		# Generated file - Do not overwrite
		#

		cmake_minimum_required(VERSION 3.1)
		SET(CMAKE_CXX_COMPILER /usr/bin/g++)
		SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt -g")
		project(«name.toFirstUpper»Project CXX)
		«FOR ev : environmentVariables»

		SET(«ev» $ENV{«ev»})
		IF(DEFINED «ev»)
		    MESSAGE(STATUS "«ev»: ${«ev»}")
		ELSE()
		    MESSAGE(FATAL_ERROR "«ev» environment variable must be defined")
		ENDIF()
		«ENDFOR»

		ADD_SUBDIRECTORY(${CMAKE_SOURCE_DIR}/../libcppnabla libcppnabla)
		include_directories("${CMAKE_CURRENT_SOURCE_DIR}«FOR id : includeDirectories»;«id»«ENDFOR»")
		«FOR ld : linkDirectories BEFORE "link_directories(" SEPARATOR ";" AFTER ")"»«ld»«ENDFOR»

		add_executable(«name.toLowerCase» «name + '.cc'»)
		target_link_libraries(«name.toLowerCase» cppnabla dl stdc++fs«FOR tll : targetLinkLibraries» «tll»«ENDFOR»)
		if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
		include(Project.cmake)
		endif()
	'''
}

class KokkosIr2Cmake extends Ir2Cmake
{
	new()
	{
		environmentVariables += "KOKKOS_HOME"
		includeDirectories += "${KOKKOS_HOME}/include"
		linkDirectories += "${KOKKOS_HOME}/lib"
		targetLinkLibraries += "kokkos"
		targetLinkLibraries += "kokkos_kernels"
		targetLinkLibraries += "hwloc"
	}
}