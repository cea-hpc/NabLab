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
set(CMAKE_VERBOSE_MAKEFILE FALSE)
set(CMAKE_CXX_COMPILER /usr/bin/g++ CACHE STRING "")
project(nablacpplibs CXX)

### LIBCPPNABLA

add_library(cppnabla 
    mesh/CartesianMesh2D.cc mesh/CartesianMesh2DGenerator.cc mesh/FileWriter.cc mesh/PvdFileWriter2D.cc mesh/VtkFileWriter2D.cc
    types/MultiArray.cc
    utils/Timer.cc utils/Utils.cc)
target_include_directories(cppnabla PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_directories(cppnabla PUBLIC "/usr/lib/x86_64-linux-gnu")
target_link_libraries(cppnabla PUBLIC stdc++fs)
target_compile_options(cppnabla PUBLIC -O3 --std=c++17 -march=native -mtune=native)



### LIBCPPNABLASTL

add_library(cppnablastl 
    linearalgebra/stl/LinearAlgebraFunctions.cc linearalgebra/stl/Matrix.cc)
target_include_directories(cppnablastl PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_directories(cppnablastl PUBLIC "/usr/lib/x86_64-linux-gnu")
target_link_libraries(cppnablastl PUBLIC)
target_compile_options(cppnablastl PUBLIC -O3 --std=c++17 -march=native -mtune=native)



### LIBCPPNABLAKOKKOS
set(CMAKE_FIND_ROOT_PATH "$ENV{KOKKOS_HOME}")
find_package(Kokkos)
find_package(KokkosKernels)

if(TARGET Kokkos::kokkos AND TARGET Kokkos::kokkoskernels)
    message(STATUS "Kokkos::kokkos/Kokkos::kokkoskernels found")
    add_library(cppnablakokkos linearalgebra/kokkos/LinearAlgebraFunctions.cc linearalgebra/kokkos/Matrix.cc)
    target_include_directories(cppnablakokkos PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
    target_link_directories(cppnablakokkos PUBLIC /usr/lib/x86_64-linux-gnu)
    target_link_libraries(cppnablakokkos PUBLIC Kokkos::kokkos Kokkos::kokkoskernels)
    target_compile_options(cppnablakokkos PUBLIC -O3 --std=c++17 -fopenmp -march=native -mtune=native)
else()
    message(STATUS "Kokkos::kokkos/Kokkos::kokkoskernels not found: libcppnablakokkos will not be built (only libcppnabla)")
endif()
