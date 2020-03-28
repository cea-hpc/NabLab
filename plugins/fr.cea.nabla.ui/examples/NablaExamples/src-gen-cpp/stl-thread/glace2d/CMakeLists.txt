#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.1)
SET(CMAKE_CXX_COMPILER /usr/bin/g++)
project(Glace2dProject CXX)

add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla libcppnabla)

add_executable(glace2d Glace2d.cc)
target_include_directories(glace2d PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(glace2d cppnabla cppnablastl)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
