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

project(Schema_chap2Project CXX)

set(LIBCPPNABLA_BACKEND "KOKKOS")
set(NABLA_KOKKOS_PATH "$ENV{HOME}/kokkos/kokkos-install")
add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla ${CMAKE_SOURCE_DIR}/../libcppnabla)


add_executable(schema_chap2 Schema_chap2.cc)
target_include_directories(schema_chap2 PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(schema_chap2 PUBLIC cppnabla cppnablakokkos)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
include(Project.cmake)
endif()
