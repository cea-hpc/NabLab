### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)
set(CMAKE_VERBOSE_MAKEFILE FALSE)

# SET VARIABLES
set(N_WS_PATH $ENV{HOME}/workspaces/NabLab/tests)
set(CMAKE_CXX_COMPILER /usr/bin/g++ CACHE STRING "")
set(JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64)
set(BATILIBCPPJNI_PATH ${N_WS_PATH}/DepthInit/src-gen-interpreter/batilibcppjni)

# PROJECT
project(DepthInitProject CXX)

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

# SUB_DIRECTORIES
if(NOT TARGET batilibcppjni)
	add_subdirectory(${BATILIBCPPJNI_PATH} ${CMAKE_BINARY_DIR}/batilibcppjni)
endif()

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
