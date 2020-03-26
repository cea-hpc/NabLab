#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.1)
SET(CMAKE_CXX_COMPILER /usr/bin/g++)
SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt -g")
project(Glace2dProject CXX)

ADD_SUBDIRECTORY(${CMAKE_SOURCE_DIR}/../libcppnabla libcppnabla)
include_directories("${CMAKE_CURRENT_SOURCE_DIR}")

add_executable(glace2d Glace2d.cc)
target_link_libraries(glace2d cppnabla stdc++fs)
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
