cmake_minimum_required(VERSION 3.10)

set(NABLA_CXX_COMPILER /usr/bin/g++)

set(CMAKE_CXX_COMPILER ${NABLA_CXX_COMPILER} CACHE STRING "")

project(WaveHeight CXX)
MESSAGE(STATUS "Building library waveheight")

add_library(waveheight WaveHeight.cc)
set_property(TARGET waveheight PROPERTY POSITION_INDEPENDENT_CODE ON) # -fPIC
target_include_directories(waveheight PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../include)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
