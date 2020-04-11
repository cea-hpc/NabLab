#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.1)
SET(CMAKE_CXX_COMPILER /usr/bin/g++)
project(TestProject CXX)

set(LIBCPPNABLA_BACKEND "KOKKOS")
add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla ${CMAKE_SOURCE_DIR}/../libcppnabla)

add_executable(test Test.cc)
target_include_directories(test PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(test cppnabla cppnablakokkos)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
