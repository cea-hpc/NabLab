#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.15)
SET(CMAKE_CXX_COMPILER /usr/bin/g++)
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "7.4.0")
    message(FATAL_ERROR "GCC minimum required version is 7.4.0. Please upgrade.")
  endif()
endif()
project(ImplicitHeatEquationProject CXX)

set(LIBCPPNABLA_BACKEND "STL")
add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla ${CMAKE_SOURCE_DIR}/../libcppnabla)

add_executable(implicitheatequation ImplicitHeatEquation.cc)
target_include_directories(implicitheatequation PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(implicitheatequation cppnabla cppnablastl pthread)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
