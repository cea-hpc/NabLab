cmake_minimum_required(VERSION 3.15)

project(ExplicitHeatEquation LANGUAGES CXX)

set(Arcane_DIR /home/lelandaisb/arcane/install)

find_package(Arcane REQUIRED)

add_executable(ExplicitHeatEquation ExplicitHeatEquationModule.cc main.cc ExplicitHeatEquation_axl.h)

arcane_generate_axl(ExplicitHeatEquation)
arcane_add_arcane_libraries_to_target(ExplicitHeatEquation)
target_include_directories(ExplicitHeatEquation PUBLIC . ${CMAKE_CURRENT_BINARY_DIR})
