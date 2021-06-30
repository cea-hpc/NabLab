###############################################################################
# Copyright (c) 2021 CEA
# This program and the accompanying materials are made available under the 
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.
#
# SPDX-License-Identifier: EPL-2.0
# Contributors: see AUTHORS file
###############################################################################

cmake_minimum_required(VERSION 3.10)
cmake_policy(SET CMP0074 NEW)
set(CMAKE_VERBOSE_MAKEFILE FALSE)

# SET VARIABLES
set(N_WS_PATH ${CMAKE_SOURCE_DIR})
set(Kokkos_ROOT $ENV{HOME}/kokkos/kokkos-install)
set(KokkosKernels_ROOT $ENV{HOME}/kokkos/kokkos-install)

# PROJECT
project(fr_cea_nabla_cpplib CXX)

# CHECK CXX VERSION: must be done after the project() (CMAKE_CXX_COMPILER_ID not defined before)
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.1.0")
		message(FATAL_ERROR "GCC minimum required version is 9.1.0. Please upgrade.")
	endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
		message(FATAL_ERROR "Clang minimum required version is 9.0.0. Please upgrade.")
	endif()
endif()

# SUB_DIRECTORIES
add_subdirectory(nablalib ${CMAKE_BINARY_DIR}/nablalib)
add_subdirectory(linearalgebra/linearalgebrastl ${CMAKE_BINARY_DIR}/linearalgebrastl)
add_subdirectory(linearalgebra/linearalgebrakokkos ${CMAKE_BINARY_DIR}/linearalgebrakokkos)
