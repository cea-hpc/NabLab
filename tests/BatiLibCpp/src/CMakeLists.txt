### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)

set(LIBCPPNABLA_DIR $ENV{HOME}/workspaces/runtime-EclipseApplication/LibCppNabla CACHE STRING "")

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

MESSAGE(STATUS "Building library batilib")

add_subdirectory(${LIBCPPNABLA_DIR} ${CMAKE_BINARY_DIR}/LibCppNabla EXCLUDE_FROM_ALL)

add_library(batilib batilib/BatiLibCpp.cc)
set_property(TARGET batilib PROPERTY POSITION_INDEPENDENT_CODE ON)
target_include_directories(batilib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(batilib PUBLIC cppnabla)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
