###############################################################################
# Copyright (c) 2020 CEA
# This program and the accompanying materials are made available under the 
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.
#
# SPDX-License-Identifier: EPL-2.0
# Contributors: see AUTHORS file
###############################################################################

cmake_minimum_required(VERSION 3.1)
set(CMAKE_CXX_COMPILER /usr/bin/g++ CACHE STRING "")
set(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt -Wall"  CACHE STRING "")
project(libcppnabla CXX)

set(KOKKOS_HOME $ENV{KOKKOS_HOME})
if(DEFINED KOKKOS_HOME)
    message(STATUS "KOKKOS_HOME: ${KOKKOS_HOME}")
else()
    message(FATAL_ERROR "KOKKOS_HOME environment variable must be defined")
endif()

link_directories("${KOKKOS_HOME}/lib;/usr/lib/x86_64-linux-gnu")
add_library(cppnabla 
    linearalgebra/LinearAlgebraFunctions.cc linearalgebra/Matrix.cc 
    mesh/CartesianMesh2D.cc mesh/CartesianMesh2DGenerator.cc mesh/FileWriter.cc mesh/PvdFileWriter2D.cc mesh/VtkFileWriter2D.cc
    types/MultiArray.cc
    utils/Timer.cc utils/Utils.cc
    kokkos/linearalgebra/LinearAlgebraFunctions.cc kokkos/linearalgebra/Matrix.cc)

target_include_directories(cppnabla PUBLIC "${CMAKE_CURRENT_SOURCE_DIR};${KOKKOS_HOME}/include")
