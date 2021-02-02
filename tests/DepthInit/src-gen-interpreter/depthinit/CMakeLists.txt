### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)

set(NABLA_CXX_COMPILER /usr/bin/g++)
set(JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64)

project(DepthInitProject LANGUAGES NONE)

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

add_subdirectory($ENV{HOME}/workspaces/NabLab/tests/DepthInit/../BatiLib/src-cpp-jni ${CMAKE_BINARY_DIR}/BatiLibCppJni)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
