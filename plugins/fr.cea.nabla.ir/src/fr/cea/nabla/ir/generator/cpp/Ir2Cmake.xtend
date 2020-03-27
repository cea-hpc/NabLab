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
abstract class Ir2Cmake
{
	val LinkedHashSet<String> targetLinkLibraries = new LinkedHashSet<String>

	def getContentFor(IrModule it)
	'''
		#
		# Generated file - Do not overwrite
		#

		cmake_minimum_required(VERSION 3.1)
		SET(CMAKE_CXX_COMPILER /usr/bin/g++)
		project(«name.toFirstUpper»Project CXX)

		add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla libcppnabla)

		add_executable(«name.toLowerCase» «name + '.cc'»)
		target_include_directories(«name.toLowerCase» PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
		target_link_libraries(«name.toLowerCase» cppnabla«FOR tll : targetLinkLibraries» «tll»«ENDFOR»)

		if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
		include(Project.cmake)
		endif()
	'''
}

class StlIr2Cmake extends Ir2Cmake
{
	new()
	{
		targetLinkLibraries += "cppnablastl"
	}
}

class KokkosIr2Cmake extends Ir2Cmake
{
	new()
	{
		targetLinkLibraries += "cppnablakokkos"
	}
}