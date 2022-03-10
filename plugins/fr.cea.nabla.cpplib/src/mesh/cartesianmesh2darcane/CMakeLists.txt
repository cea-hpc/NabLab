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

# FIND PACKAGES
find_package(Arcane)

# LIBRARY cartesianmesh2darcane
add_library(cartesianmesh2darcane CartesianMesh2D.cc)
set_property(TARGET cartesianmesh2darcane PROPERTY POSITION_INDEPENDENT_CODE ON)
target_compile_options(cartesianmesh2darcane PUBLIC -g -Wall -O3 --std=c++17 -mtune=native)
target_include_directories(cartesianmesh2darcane PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
arcane_add_arcane_libraries_to_target(cartesianmesh2darcane)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
