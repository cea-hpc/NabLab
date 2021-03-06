### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)
set(CMAKE_VERBOSE_MAKEFILE FALSE)

project(ImplicitHeatEquationProject CXX)

# SET VARIABLES
set(N_CXX_COMPILER /usr/bin/g++)
set(N_WS_PATH $ENV{HOME}/workspaces/NabLab/plugins/fr.cea.nabla.ui/examples)
set(LINEARALGEBRASTL_PATH ${N_WS_PATH}/.nablab/linearalgebra/linearalgebrastl)

# CHECK VARIABLES
if (NOT DEFINED N_WS_PATH)
	message(FATAL_ERROR "N_WS_PATH variable must be set")
endif()

# CHECK CXX VERSION
set(CMAKE_CXX_COMPILER ${N_CXX_COMPILER} CACHE STRING "")
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "7.4.0")
		message(FATAL_ERROR "GCC minimum required version is 7.4.0. Please upgrade.")
	endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
		message(FATAL_ERROR "Clang minimum required version is 9.0.0. Please upgrade.")
	endif()
endif()

# SUB_DIRECTORIES
if(NOT TARGET nablalib)
	add_subdirectory(${N_WS_PATH}/.nablab/nablalib ${CMAKE_BINARY_DIR}/nablalib)
endif()
if(NOT TARGET linearalgebrastl)
	add_subdirectory(${LINEARALGEBRASTL_PATH} ${CMAKE_BINARY_DIR}/linearalgebrastl)
endif()

# EXECUTABLE implicitheatequation
add_executable(implicitheatequation ImplicitHeatEquation.cc)
target_link_libraries(implicitheatequation PUBLIC nablalib pthread linearalgebrastl)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
