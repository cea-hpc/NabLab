### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)

set(LIBCPPNABLA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../../libcppnabla CACHE STRING "")
set(NABLA_CXX_COMPILER /usr/bin/g++)

project(Glace2dProject CXX)

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

add_subdirectory(${LIBCPPNABLA_DIR} ${CMAKE_CURRENT_BINARY_DIR}/libcppnabla EXCLUDE_FROM_ALL)


add_executable(glace2d Glace2d.cc)
target_include_directories(glace2d PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(glace2d PUBLIC cppnabla)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
