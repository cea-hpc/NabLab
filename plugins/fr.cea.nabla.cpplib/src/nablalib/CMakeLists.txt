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

# LIBRARY nablalib
add_library(nablalib 
    nablalib/mesh/CartesianMesh2D.cc nablalib/mesh/PvdFileWriter2D.cc
    nablalib/types/MultiArray.cc
    nablalib/utils/Timer.cc nablalib/utils/Utils.cc)
set_property(TARGET nablalib PROPERTY POSITION_INDEPENDENT_CODE ON)
target_compile_options(nablalib PUBLIC -g -Wall -O3 --std=c++17 -mtune=native)
target_include_directories(nablalib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
# no need since clang++ 9.0 and g++ 9.1
#target_link_libraries(nablalib PUBLIC stdc++fs)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
