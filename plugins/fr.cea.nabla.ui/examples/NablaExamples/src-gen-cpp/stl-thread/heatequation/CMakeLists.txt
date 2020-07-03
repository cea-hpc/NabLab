#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.15)

set(NABLA_CXX_COMPILER /usr/bin/g++)

set(CMAKE_CXX_COMPILER ${NABLA_CXX_COMPILER} CACHE STRING "")

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "7.4.0")
		message(FATAL_ERROR "GCC minimum required version is 7.4.0. Please upgrade.")
	endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
		message(FATAL_ERROR "Clang minimum required version is 9.0.0. Please upgrade.")
	endif()
endif()

project(HeatEquationProject CXX)

set(LIBCPPNABLA_BACKEND "STL")
add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla ${CMAKE_SOURCE_DIR}/../libcppnabla)


add_executable(heatequation HeatEquation.cc)
target_include_directories(heatequation PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(heatequation PUBLIC cppnabla cppnablastl pthread)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
