#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.1)
SET(CMAKE_CXX_COMPILER /usr/bin/g++)
project(Glace2dProject CXX)

set(LIBCPPNABLA_BACKEND "KOKKOS")
add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla ${CMAKE_SOURCE_DIR}/../libcppnabla)

add_executable(glace2d Glace2d.cc)
target_include_directories(glace2d PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(glace2d cppnabla cppnablakokkos)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
