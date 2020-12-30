### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)

set(LIBCPPNABLA_DIR $ENV{HOME}/workspaces/runtime-EclipseApplication/libcppnabla)
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

project(BatiLib CXX)
MESSAGE(STATUS "Building library batilib")

add_subdirectory(${LIBCPPNABLA_DIR} ${LIBCPPNABLA_DIR})

add_library(batilib SHARED BatiLib.cc)
target_include_directories(batilib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../include)
target_link_libraries(batilib PUBLIC cppnabla)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
