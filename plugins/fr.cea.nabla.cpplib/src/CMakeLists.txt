###############################################################################
# Copyright (c) 2020 CEA
# This program and the accompanying materials are made available under the 
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.
#
# SPDX-License-Identifier: EPL-2.0
# Contributors: see AUTHORS file
###############################################################################

cmake_minimum_required(VERSION 3.10)
set(CMAKE_VERBOSE_MAKEFILE FALSE)

# Standalone build of the library is made with system default GCC, change it if you want.
if(NOT DEFINED NABLA_CXX_COMPILER)
  set(CMAKE_CXX_COMPILER /usr/bin/g++ CACHE STRING "")
else()
  set(CMAKE_CXX_COMPILER ${NABLA_CXX_COMPILER} CACHE STRING "")
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "7.4.0")
		message(FATAL_ERROR "GCC minimum required version is 7.4.0. Please upgrade.")
	endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
		message(FATAL_ERROR "Clang minimum required version is 9.0.0. Please upgrade.")
	endif()
endif()

project(nablacpplibs CXX)

### LIBCPPNABLA
add_library(cppnabla 
    mesh/CartesianMesh2D.cc mesh/CartesianMesh2DFactory.cc mesh/AbstractPvdFileWriter2D.cc
    types/MultiArray.cc
    utils/Timer.cc utils/Utils.cc)
target_include_directories(cppnabla PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_directories(cppnabla PUBLIC)
target_link_libraries(cppnabla PUBLIC stdc++fs)
target_compile_options(cppnabla PUBLIC -fPIC -g -Wall -O3 --std=c++17 -march=native -mtune=native ${NABLAB_TEST_SUITE_FLAGS})

### LIBCPPNABLASTL
if(NOT DEFINED LIBCPPNABLA_BACKEND OR LIBCPPNABLA_BACKEND STREQUAL "STL")
message(STATUS "Building library with STL.")
add_library(cppnablastl 
    linearalgebra/stl/LinearAlgebraFunctions.cc linearalgebra/stl/Matrix.cc utils/stl/Serializer.cc)
target_include_directories(cppnablastl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_directories(cppnablastl PUBLIC)
target_link_libraries(cppnablastl PUBLIC)
target_compile_options(cppnablastl PUBLIC -fPIC -g -Wall -O3 --std=c++17 -march=native -mtune=native ${NABLAB_TEST_SUITE_FLAGS})
endif()

### LIBCPPNABLAKOKKOS
if(NOT DEFINED LIBCPPNABLA_BACKEND OR LIBCPPNABLA_BACKEND STREQUAL "KOKKOS")
  message(STATUS "Building library with KOKKOS.")
if (DEFINED NABLA_KOKKOS_PATH)
	set(CMAKE_FIND_ROOT_PATH ${NABLA_KOKKOS_PATH})
else()
	set(CMAKE_FIND_ROOT_PATH $ENV{HOME}/kokkos/kokkos-install)
endif()
find_package(Kokkos)
find_package(KokkosKernels)

if(TARGET Kokkos::kokkos AND TARGET Kokkos::kokkoskernels)
  message(STATUS "Kokkos::kokkos/Kokkos::kokkoskernels found")
  add_library(cppnablakokkos
      linearalgebra/kokkos/LinearAlgebraFunctions.cc linearalgebra/kokkos/Matrix.cc utils/kokkos/Serializer.cc)
  target_include_directories(cppnablakokkos PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
  target_link_directories(cppnablakokkos PUBLIC)
  target_link_libraries(cppnablakokkos PUBLIC Kokkos::kokkos Kokkos::kokkoskernels)
  target_compile_options(cppnablakokkos PUBLIC -fPIC -g -Wall -O3 --std=c++17 -fopenmp -march=native -mtune=native ${NABLAB_TEST_SUITE_FLAGS})
else()
  message(STATUS "Kokkos::kokkos/Kokkos::kokkoskernels not found: libcppnablakokkos will not be built (only libcppnabla)")
endif()
endif()