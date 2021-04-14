### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)
set(CMAKE_VERBOSE_MAKEFILE FALSE)

# SET VARIABLES
set(CMAKE_CXX_COMPILER /usr/bin/g++ CACHE STRING "")
set(N_KOKKOS_PATH $ENV{HOME}/kokkos/kokkos-install)
set(N_WS_PATH $ENV{HOME}/workspaces/NabLab/plugins/fr.cea.nabla.ui/examples)

# CHECK VARIABLES
if (NOT DEFINED N_KOKKOS_PATH)
	message(FATAL_ERROR "N_KOKKOS_PATH variable must be set")
endif()
if (NOT DEFINED N_WS_PATH)
	message(FATAL_ERROR "N_WS_PATH variable must be set")
endif()

# PROJECT
project(HeatEquationProject CXX)

# CHECK CXX VERSION: must be done after the project() (CMAKE_CXX_COMPILER_ID not defined before)
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.1.0")
		message(FATAL_ERROR "GCC minimum required version is 9.1.0. Please upgrade.")
	endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
		message(FATAL_ERROR "Clang minimum required version is 9.0.0. Please upgrade.")
	endif()
endif()

# FIND PACKAGES
set(CMAKE_FIND_ROOT_PATH ${N_KOKKOS_PATH})
find_package(Kokkos REQUIRED)

# SUB_DIRECTORIES
if(NOT TARGET nablalib)
	add_subdirectory(${N_WS_PATH}/.nablab/nablalib ${CMAKE_BINARY_DIR}/nablalib)
endif()

# EXECUTABLE heatequation
add_executable(heatequation HeatEquation.cc)
target_link_libraries(heatequation PUBLIC nablalib Kokkos::kokkos)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
