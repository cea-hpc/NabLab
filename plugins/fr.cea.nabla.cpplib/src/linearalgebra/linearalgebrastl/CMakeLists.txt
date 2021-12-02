###############################################################################
# Copyright (c) 2021 CEA
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

# SUB_DIRECTORIES
if(NOT TARGET nablalib)
	add_subdirectory($ENV{N_WS_PATH}/nablalib ${CMAKE_BINARY_DIR}/nablalib)
endif()

# LIBRARY linearalgebrastl
add_library(linearalgebrastl Vector.cc Matrix.cc LinearAlgebra.cc)
set_property(TARGET linearalgebrastl PROPERTY POSITION_INDEPENDENT_CODE ON)
target_compile_options(linearalgebrastl PUBLIC -g -Wall -O3 --std=c++17 -mtune=native)
target_include_directories(linearalgebrastl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(linearalgebrastl PUBLIC nablalib pthread)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
