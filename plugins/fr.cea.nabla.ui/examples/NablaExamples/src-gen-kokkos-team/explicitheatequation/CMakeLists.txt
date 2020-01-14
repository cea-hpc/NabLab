#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.1)
SET(CMAKE_CXX_COMPILER /usr/bin/g++)
SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt -g")
project(ExplicitHeatEquationProject CXX)

SET(KOKKOS_HOME $ENV{KOKKOS_HOME})
IF(DEFINED KOKKOS_HOME)
    MESSAGE(STATUS "KOKKOS_HOME: ${KOKKOS_HOME}")
ELSE()
    MESSAGE(FATAL_ERROR "KOKKOS_HOME environment variable must be defined")
ENDIF()

ADD_SUBDIRECTORY(${CMAKE_SOURCE_DIR}/../libcppnabla libcppnabla)
include_directories("${CMAKE_CURRENT_SOURCE_DIR};${KOKKOS_HOME}/include")
link_directories(${KOKKOS_HOME}/lib)

add_executable(explicitheatequation ExplicitHeatEquation.cc)
target_link_libraries(explicitheatequation cppnabla kokkos kokkos_kernels dl stdc++fs hwloc)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
