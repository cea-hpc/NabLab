### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)

set(LIBCPPNABLA_DIR $ENV{HOME}/workspaces/runtime-EclipseApplication/libcppnabla CACHE STRING "")

project(BatiLibCpp CXX)

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

MESSAGE(STATUS "Building library batilibcpp")

add_subdirectory(${LIBCPPNABLA_DIR} ${CMAKE_BINARY_DIR}/libcppnabla EXCLUDE_FROM_ALL)

add_library(batilibcpp SHARED batilib/BatiLibCpp.cc)
target_include_directories(batilibcpp PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(batilibcpp PUBLIC cppnabla)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
