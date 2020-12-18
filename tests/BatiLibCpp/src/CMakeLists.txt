cmake_minimum_required(VERSION 3.10)

set(NABLA_CXX_COMPILER /usr/bin/g++)

set(CMAKE_CXX_COMPILER ${NABLA_CXX_COMPILER} CACHE STRING "")

project(BatiLib CXX)
MESSAGE(STATUS "Building library batilib")

add_library(batilib BatiLib.cc)
set_property(TARGET batilib PROPERTY POSITION_INDEPENDENT_CODE ON) # -fPIC
target_include_directories(batilib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../include)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
