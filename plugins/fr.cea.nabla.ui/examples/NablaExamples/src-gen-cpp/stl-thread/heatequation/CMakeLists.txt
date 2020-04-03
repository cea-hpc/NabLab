#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.1)
SET(CMAKE_CXX_COMPILER /usr/bin/g++)
project(HeatEquationProject CXX)

set(LIBCPPNABLA_BACKEND "STL")
add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla ${CMAKE_SOURCE_DIR}/../libcppnabla)

add_executable(heatequation HeatEquation.cc)
target_include_directories(heatequation PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(heatequation cppnabla cppnablastl)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
