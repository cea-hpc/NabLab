#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.1)
SET(CMAKE_CXX_COMPILER /usr/bin/g++)
project(IterativeHeatEquationProject CXX)

add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla libcppnabla)

add_executable(iterativeheatequation IterativeHeatEquation.cc)
target_include_directories(iterativeheatequation PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(iterativeheatequation cppnabla cppnablakokkos)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
