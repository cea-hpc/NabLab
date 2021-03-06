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

project(nablacpplibs CXX)

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

### LIBCPPNABLA
add_library(cppnabla 
    nablalib/mesh/CartesianMesh2D.cc nablalib/mesh/CartesianMesh2DFactory.cc nablalib/mesh/PvdFileWriter2D.cc
    nablalib/types/MultiArray.cc
    nablalib/utils/Timer.cc nablalib/utils/Utils.cc)
target_include_directories(cppnabla PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(cppnabla PUBLIC stdc++fs)
target_compile_options(cppnabla PUBLIC -fPIC -g -Wall -O3 --std=c++17 -mtune=native)

### LIBCPPNABLASTL
add_library(cppnablastl 
    nablalib/linearalgebra/stl/LinearAlgebra.cc nablalib/linearalgebra/stl/Vector.cc nablalib/linearalgebra/stl/Matrix.cc nablalib/utils/stl/Serializer.cc)
target_include_directories(cppnablastl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_options(cppnablastl PUBLIC -fPIC -g -Wall -O3 --std=c++17 -mtune=native)

### LIBCPPNABLAKOKKOS
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
      nablalib/linearalgebra/kokkos/LinearAlgebra.cc nablalib/linearalgebra/kokkos/Vector.cc nablalib/linearalgebra/kokkos/Matrix.cc nablalib/utils/kokkos/Serializer.cc)
  target_include_directories(cppnablakokkos PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
  target_link_libraries(cppnablakokkos PUBLIC Kokkos::kokkos Kokkos::kokkoskernels)
  target_compile_options(cppnablakokkos PUBLIC -fPIC -g -Wall -O3 --std=c++17 -fopenmp -mtune=native)
else()
  message(STATUS "Kokkos::kokkos/Kokkos::kokkoskernels not found: libcppnablakokkos will not be built")
endif()