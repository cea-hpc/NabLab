###############################################################################
# Copyright (c) 2022 CEA
# This program and the accompanying materials are made available under the 
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.
#
# SPDX-License-Identifier: EPL-2.0
# Contributors: see AUTHORS file
###############################################################################

cmake_minimum_required(VERSION 3.1)
SET(CMAKE_CXX_COMPILER /usr/bin/g++ CACHE STRING "")
SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt -Wall"  CACHE STRING "")
project(libcppnablatests CXX)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../src)
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/../lib)
add_executable(testscppnabla TestMesh.cc)
target_link_libraries(testscppnabla cppnabla dl stdc++fs hwloc)
