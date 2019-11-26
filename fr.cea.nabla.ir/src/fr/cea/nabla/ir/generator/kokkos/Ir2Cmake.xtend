package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.IrModule

class Ir2Cmake
{
	static def getFileContent(IrModule it) 
	'''
		#
		# Generated file - Do not overwrite
		#

		cmake_minimum_required(VERSION 3.1)
		project(«name.toFirstUpper»Project CXX)
		SET(CMAKE_CXX_COMPILER /usr/bin/g++)
		SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt -g")

		SET(KOKKOS_HOME $ENV{KOKKOS_HOME})
		IF(DEFINED KOKKOS_HOME)
		    MESSAGE(STATUS "KOKKOS_HOME: ${KOKKOS_HOME}")
		ELSE()
		    MESSAGE(FATAL_ERROR "KOKKOS_HOME environment variable must be defined")
		ENDIF()

		SET(CPPLIB_HOME $ENV{CPPLIB_HOME})
		IF(DEFINED CPPLIB_HOME)
		    MESSAGE(STATUS "CPPLIB_HOME: ${CPPLIB_HOME}")
		ELSE()
		    MESSAGE(FATAL_ERROR "CPPLIB_HOME environment variable must be defined")
		ENDIF()

		include_directories("${CMAKE_SOURCE_DIR};${KOKKOS_HOME}/include;${CPPLIB_HOME}/src")

		link_directories(${KOKKOS_HOME}/lib ${CPPLIB_HOME}/lib)

		add_executable(«name.toLowerCase» «name + '.cc'»)
		target_link_libraries(«name.toLowerCase» cppnabla kokkos kokkos_kernels dl stdc++fs hwloc)

		if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
		include(Project.cmake)
		endif()
	'''
}