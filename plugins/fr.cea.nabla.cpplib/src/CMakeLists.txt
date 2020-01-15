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
SET(CMAKE_CXX_COMPILER /usr/bin/g++ CACHE STRING "")
SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt"  CACHE STRING "")
project(libcppnabla CXX)

SET(KOKKOS_HOME $ENV{KOKKOS_HOME})
IF(DEFINED KOKKOS_HOME)
    MESSAGE(STATUS "KOKKOS_HOME: ${KOKKOS_HOME}")
ELSE()
    MESSAGE(FATAL_ERROR "KOKKOS_HOME environment variable must be defined")
ENDIF()

link_directories("${KOKKOS_HOME}/lib;/usr/lib/x86_64-linux-gnu")
add_library(cppnabla types/LinearAlgebraFunctions.cc types/Matrix.cc mesh/NumericMesh2D.cc mesh/CartesianMesh2DGenerator.cc mesh/FileWriter.cc mesh/VtkFileWriter2D.cc mesh/PvdFileWriter2D.cc utils/Utils.cc utils/Timer.cc)
target_include_directories(cppnabla PUBLIC "${CMAKE_CURRENT_SOURCE_DIR};${KOKKOS_HOME}/include")