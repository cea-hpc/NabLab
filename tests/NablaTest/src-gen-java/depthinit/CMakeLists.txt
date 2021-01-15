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

add_subdirectory(/home/lelandaisb/workspaces/NabLab/tests/NablaTest/../BatiLibCppJni/src ${CMAKE_BINARY_DIR}/BatiLibCppJni)

message(STATUS "Do not forget '-Djava.library.path=${CMAKE_BINARY_DIR}' before executing java")

ADD_CUSTOM_TARGET(link_jni_so ALL COMMAND ${CMAKE_COMMAND} -E create_symlink ./BatiLibCppJni/libbatilibcppjni.so ${CMAKE_BINARY_DIR}/libbatilibcppjni.so)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
