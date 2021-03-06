### GENERATED FILE - DO NOT OVERWRITE ###

# This file is in a cmake sub_directory and is called by a root CMakeLists.txt 

# CHECK VARIABLES
if (NOT DEFINED N_WS_PATH)
	message(FATAL_ERROR "N_WS_PATH variable must be set")
endif()

# SUB_DIRECTORIES
if(NOT TARGET nablalib)
	add_subdirectory(${N_WS_PATH}/.nablab/nablalib ${CMAKE_BINARY_DIR}/nablalib)
endif()

# LIBRARY batilibcpp
add_library(batilibcpp BatiLib.cc)
set_property(TARGET batilibcpp PROPERTY POSITION_INDEPENDENT_CODE ON)
target_compile_options(batilibcpp PUBLIC -g -Wall -O3 --std=c++17 -mtune=native)
target_include_directories(batilibcpp PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(batilibcpp PUBLIC nablalib)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
