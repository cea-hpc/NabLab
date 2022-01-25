###############################################################################
# Copyright (c) 2022 CEA
# This program and the accompanying materials are made available under the 
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.
#
# SPDX-License-Identifier: EPL-2.0
# Contributors: see AUTHORS file
###############################################################################

# This file is in a cmake sub_directory and is called by a root CMakeLists.txt 

# CHECK VARIABLES
if (NOT DEFINED N_WS_PATH)
	message(FATAL_ERROR "N_WS_PATH variable must be set")
endif()

# FIND PACKAGES
find_package(Kokkos)
find_package(KokkosKernels)

# SUB_DIRECTORIES
if(NOT TARGET nablalib)
	add_subdirectory($ENV{N_WS_PATH}/nablalib ${CMAKE_BINARY_DIR}/nablalib)
endif()

# LIBRARY linearalgebrakokkos
add_library(linearalgebrakokkos Vector.cc Matrix.cc LinearAlgebra.cc)
set_property(TARGET linearalgebrakokkos PROPERTY POSITION_INDEPENDENT_CODE ON)
target_compile_options(linearalgebrakokkos PUBLIC -g -Wall -O3 --std=c++17 -fopenmp -mtune=native)
target_include_directories(linearalgebrakokkos PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(linearalgebrakokkos PUBLIC nablalib Kokkos::kokkos Kokkos::kokkoskernels)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
