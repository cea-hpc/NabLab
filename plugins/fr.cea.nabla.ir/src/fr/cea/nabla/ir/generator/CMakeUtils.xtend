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

class CMakeUtils
{
	static val userDir = System.getProperty("user.home")

	static def formatCMakePath(String path)
	{
		if (path.startsWith(userDir))
			path.replace(userDir, "$ENV{HOME}")
		else
			path
	}

	static def getFileHeader()
	'''
		### GENERATED FILE - DO NOT OVERWRITE ###

		cmake_minimum_required(VERSION 3.10)
	'''

	/**
	 * Must be done after the project() command to work (CMAKE_CXX_COMPILER_ID not defined before)
	 */
	static def setCompiler()
	'''
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
	'''

	static def getFileFooter()
	'''
		if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
			include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
		endif()
	'''
}
