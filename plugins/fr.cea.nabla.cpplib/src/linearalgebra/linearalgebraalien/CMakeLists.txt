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

find_package(Alien REQUIRED)
find_package(Arcane REQUIRED)

# SUB_DIRECTORIES
if(NOT TARGET nablalib)
	add_subdirectory($ENV{N_WS_PATH}/nablalib ${CMAKE_BINARY_DIR}/nablalib)
endif()

# LIBRARY linearalgebraalien
add_library(linearalgebraalien
						LinearAlgebra.cc LinearAlgebra.h
						Distribution.cc Distribution
						Matrix.h
						Arcane2AlienVector.h)
set_property(TARGET linearalgebraalien PROPERTY POSITION_INDEPENDENT_CODE ON)
#target_compile_options(linearalgebraalien PUBLIC -g -Wall -O3 --std=c++17 -mtune=native)
target_compile_options(linearalgebraalien PUBLIC -Wall --std=c++17)
target_include_directories(linearalgebraalien PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(linearalgebraalien PUBLIC nablalib arcane_full Alien::hypre_wrapper Arccore::arccore_message_passing_mpi Arccore::arccore_trace Alien::alien_core Alien::alien_semantic_ref)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
