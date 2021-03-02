### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)

set(LIBCPPNABLA_DIR $ENV{HOME}/workspaces/NabLab/plugins/fr.cea.nabla.ui/examples/NablaExamples/../LibCppNabla CACHE STRING "")
set(NABLA_CXX_COMPILER /usr/bin/g++)
set(LINEARALGEBRA_DIR $ENV{HOME}/workspaces/NabLab/plugins/fr.cea.nabla.ui/examples/NablaExamples/../LibCppNabla)

project(ImplicitHeatEquationProject CXX)

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
if(NOT TARGET cppnablastl)
	add_subdirectory(${LINEARALGEBRA_DIR} ${CMAKE_BINARY_DIR}/LinearAlgebraStl EXCLUDE_FROM_ALL)
endif()
if(NOT TARGET cppnabla)
	add_subdirectory(${LIBCPPNABLA_DIR} ${CMAKE_BINARY_DIR}/LibCppNabla EXCLUDE_FROM_ALL)
endif()


add_executable(implicitheatequation ImplicitHeatEquation.cc)
target_include_directories(implicitheatequation PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(implicitheatequation PUBLIC cppnabla OpenMP::OpenMP_CXX cppnablastl pthread cppnablastl)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
