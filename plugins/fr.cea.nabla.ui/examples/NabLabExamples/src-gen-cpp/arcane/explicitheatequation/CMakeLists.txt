cmake_minimum_required(VERSION 3.15)

project(ExplicitHeatEquation LANGUAGES CXX)

set(Arcane_DIR $ENV{HOME}/arcane/install)

find_package(Arcane REQUIRED)

add_executable(ExplicitHeatEquation ExplicitHeatEquationModule.cc ExplicitHeatEquation_axl.h main.cc)

arcane_generate_axl(ExplicitHeatEquation)
arcane_add_arcane_libraries_to_target(ExplicitHeatEquation)
target_include_directories(ExplicitHeatEquation PUBLIC . ${CMAKE_CURRENT_BINARY_DIR})

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
