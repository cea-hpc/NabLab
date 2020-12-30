### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)

set(LIBCPPNABLA ${CMAKE_CURRENT_SOURCE_DIR}/../libcppnabla)
set(NABLA_CXX_COMPILER /usr/bin/g++)
set(BATILIB_HOME $ENV{HOME}/workspaces/NabLab/tests/BatiLibCpp)

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
add_subdirectory(${LIBCPPNABLA} ${LIBCPPNABLA})
add_subdirectory(${BATILIB_HOME}/src ${BATILIB_HOME}/lib)


add_executable(depthinit DepthInit.cc)
target_include_directories(depthinit PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(depthinit PUBLIC cppnabla cppnablastl pthread batilib)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
