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
# LIBRARY monilog
set(PYBIND11_PYTHON_VERSION 3.8)
find_package(pybind11 REQUIRED)
add_library(monilog MoniLog.cc)
set_property(TARGET monilog PROPERTY POSITION_INDEPENDENT_CODE ON)
target_compile_options(monilog PUBLIC -g -Wall -O3 --std=c++17 -mtune=native)
target_include_directories(monilog PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(monilog PUBLIC pybind11::embed)

# no need since clang++ 9.0 and g++ 9.1
#target_link_libraries(nablalib PUBLIC stdc++fs)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
