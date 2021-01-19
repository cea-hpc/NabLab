### GENERATED FILE - DO NOT OVERWRITE ###

cmake_minimum_required(VERSION 3.10)

set(BATILIB_DIR $ENV{HOME}/workspaces/NabLab/tests/BatiLibCpp)

if(NOT DEFINED JAVA_HOME)
	message(FATAL_ERROR "JAVA_HOME variable undefined.\n"
		"You can launch cmake with -D option, for example: "
		"cmake -D JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 ../src")
endif()

project(BatiLibCppJni CXX)

MESSAGE(STATUS "Building library batilibcppjni")

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

add_subdirectory(${BATILIB_DIR}/src ${CMAKE_BINARY_DIR}/BatiLibCpp)

# The libbatilibcppjni.so library
add_library(batilibcppjni SHARED batilib_BatiLibCppJni.cc batilib_BatiLibCppJni.h)
target_include_directories(batilibcppjni
	PUBLIC ${INCLUDE_DIR}
	PUBLIC ${JAVA_HOME}/include
	PUBLIC ${JAVA_HOME}/include/linux)
target_link_libraries(batilibcppjni PUBLIC batilibcpp)

# Generation of BatiLibCppJni.h from BatiLibCppJni.java
add_custom_command(
	OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/batilib_BatiLibCppJni.h batilib/BatiLibCppJni.class
	COMMENT "Generate BatiLibCppJni.h from BatiLibCppJni.java"
	COMMAND ${JAVA_HOME}/bin/javac -h ${CMAKE_CURRENT_SOURCE_DIR} -d ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/batilib/BatiLibCppJni.java
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/batilib/BatiLibCppJni.java)

# The batilibcppjni.jar
add_custom_target(batilibcppjnijar ALL DEPENDS batilibcppjni.jar)
add_custom_command(
	OUTPUT batilibcppjni.jar
	COMMENT "Built batilibcppjni.jar"
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	COMMAND ${JAVA_HOME}/bin/jar cvf batilibcppjni.jar batilib/BatiLibCppJni.class
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/batilib_BatiLibCppJni.h)

INSTALL(TARGETS batilibcppjni DESTINATION ${CMAKE_SOURCE_DIR}/lib)
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/batilibcppjni.jar DESTINATION ${CMAKE_SOURCE_DIR}/lib)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
