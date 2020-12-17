#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.10)

set(NABLA_CXX_COMPILER /usr/bin/g++)

set(WAVEHEIGHT_HOME $ENV{HOME}/workspaces/NabLab/tests/WaveHeightCpp)
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

project(DepthInitProject CXX)

set(LIBCPPNABLA_BACKEND "STL")
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../libcppnabla ${CMAKE_CURRENT_SOURCE_DIR}/../libcppnabla)
add_subdirectory(${WAVEHEIGHT_HOME}/src ${WAVEHEIGHT_HOME}/lib)


add_executable(depthinit DepthInit.cc)
target_include_directories(depthinit PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(depthinit PUBLIC cppnabla cppnablastl pthread waveheight)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
