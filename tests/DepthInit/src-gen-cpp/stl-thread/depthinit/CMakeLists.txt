### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)
set(CMAKE_VERBOSE_MAKEFILE FALSE)

project(DepthInitProject CXX)

# SET VARIABLES
set(N_CXX_COMPILER /usr/bin/g++)
set(N_WS_PATH $ENV{HOME}/workspaces/NabLab/tests)
set(BATILIBCPP_PATH ${N_WS_PATH}/BatiLib/src-cpp/batilibcpp)

# CHECK VARIABLES
if (NOT DEFINED N_WS_PATH)
	message(FATAL_ERROR "N_WS_PATH variable must be set")
endif()

# CHECK CXX VERSION
set(CMAKE_CXX_COMPILER ${N_CXX_COMPILER} CACHE STRING "")
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "7.4.0")
		message(FATAL_ERROR "GCC minimum required version is 7.4.0. Please upgrade.")
	endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
	if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
		message(FATAL_ERROR "Clang minimum required version is 9.0.0. Please upgrade.")
	endif()
endif()

# SUB_DIRECTORIES
if(NOT TARGET nablalib)
	add_subdirectory(${N_WS_PATH}/.nablab/nablalib ${CMAKE_BINARY_DIR}/nablalib)
endif()
if(NOT TARGET batilibcpp)
	add_subdirectory(${BATILIBCPP_PATH} ${CMAKE_BINARY_DIR}/batilibcpp)
endif()

# EXECUTABLE depthinit
add_executable(depthinit DepthInit.cc)
target_link_libraries(depthinit PUBLIC nablalib pthread batilibcpp)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
