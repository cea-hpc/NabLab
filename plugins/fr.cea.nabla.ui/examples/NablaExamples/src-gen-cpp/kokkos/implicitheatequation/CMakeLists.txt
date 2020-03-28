#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.1)
SET(CMAKE_CXX_COMPILER /usr/bin/g++)
project(ImplicitHeatEquationProject CXX)

add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla libcppnabla)

add_executable(implicitheatequation ImplicitHeatEquation.cc)
target_include_directories(implicitheatequation PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(implicitheatequation cppnabla cppnablakokkos)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
