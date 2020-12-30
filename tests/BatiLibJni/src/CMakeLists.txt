### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)

set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../include)
set(BIN_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../bin)
set(BATILIB_DIR $ENV{HOME}/workspaces/NabLab/tests/BatiLibCpp)

if(NOT DEFINED JAVA_HOME)
	message(FATAL_ERROR "JAVA_HOME variable undefined")
endif()

project(BatiLibJni CXX)

MESSAGE(STATUS "Building library batilibjni")

add_subdirectory(${BATILIB_DIR}/src ${BATILIB_DIR}/lib)

# The libbatilibjni.so library
add_library(batilibjni SHARED batilib_BatiLib.cc ${INCLUDE_DIR}/batilib_BatiLib.h)
target_include_directories(batilibjni
	PUBLIC ${INCLUDE_DIR}
	PUBLIC ${JAVA_HOME}/include
	PUBLIC ${JAVA_HOME}/include/linux)
target_link_libraries(batilibjni PUBLIC batilib)

# Generation of BatiLib.h from BatiLib.java
add_custom_command(
	OUTPUT ${INCLUDE_DIR}/batilib_BatiLib.h
	COMMENT "Generate BatiLib.h from BatiLib.java"
	COMMAND ${JAVA_HOME}/bin/javac -h ${INCLUDE_DIR} -d ${BIN_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/batilib/BatiLib.java
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/batilib/BatiLib.java)

# The batilibjni.jar
add_custom_target(batilibjnijar ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/batilibjni.jar)
add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/batilibjni.jar
	COMMENT "Built batilibjni.jar"
	WORKING_DIRECTORY ${BIN_DIR}
	COMMAND ${JAVA_HOME}/bin/jar cvf ${CMAKE_CURRENT_BINARY_DIR}/batilibjni.jar batilib/BatiLib.class
	DEPENDS ${INCLUDE_DIR}/batilib_BatiLib.h)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
