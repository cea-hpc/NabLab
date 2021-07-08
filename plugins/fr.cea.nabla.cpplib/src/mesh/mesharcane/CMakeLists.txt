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

# FIND PACKAGES
find_package(Arcane)

# LIBRARY mesharcane
add_library(mesharcane CartesianMesh2DHelper.cc)
set_property(TARGET mesharcane PROPERTY POSITION_INDEPENDENT_CODE ON)
target_compile_options(mesharcane PUBLIC -g -Wall -O3 --std=c++17 -mtune=native)
arcane_add_arcane_libraries_to_target(mesharcane)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
