### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)

set(LIBCPPNABLA_DIR $ENV{HOME}/workspaces/NabLab/tests/fr.cea.nabla.tests/../../plugins/fr.cea.nabla.ui/examples/NablaExamples//../LibCppNabla CACHE STRING "")
set(NABLA_CXX_COMPILER /usr/bin/g++)

project(IterativeHeatEquationProject CXX)

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

find_package(OpenMP)
if(NOT TARGET cppnabla)
	add_subdirectory(${LIBCPPNABLA_DIR}/src ${CMAKE_BINARY_DIR}/LibCppNabla EXCLUDE_FROM_ALL)
endif()


add_executable(iterativeheatequation IterativeHeatEquation.cc)
target_include_directories(iterativeheatequation PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(iterativeheatequation PUBLIC cppnabla OpenMP::OpenMP_CXX)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
