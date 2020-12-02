#
# Generated file - Do not overwrite
#

cmake_minimum_required(VERSION 3.10)

set(NABLA_CXX_COMPILER /usr/bin/g++)

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
add_subdirectory(${CMAKE_SOURCE_DIR}/../libcppnabla ${CMAKE_SOURCE_DIR}/../libcppnabla)


add_executable(depthinit DepthInit.cc)
target_include_directories(depthinit PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(depthinit PUBLIC cppnabla cppnablastl pthread)

# The libdepthinitjni.so library
set(JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64)
add_library(depthinitjni SHARED depthinit_DepthInitFunctions.cc depthinit_DepthInitFunctions.h)
target_include_directories(depthinitjni
	PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..
	PUBLIC ${JAVA_HOME}/include
	PUBLIC ${JAVA_HOME}/include/linux)
target_link_libraries(depthinitjni PUBLIC cppnabla cppnablastl pthread)

# Generation of DepthInitFunctionsJni.h from DepthInitFunctionsJni.java
add_custom_command(
	OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/depthinit_DepthInitFunctions.h
	COMMENT "Generate depthinit_DepthInitFunctions.h from DepthInitFunctions.java"
	COMMAND ${JAVA_HOME}/bin/javac -h ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/DepthInitFunctions.java
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/DepthInitFunctions.java)

add_custom_target(jardepthinit DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/depthinitjni.jar)
add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/depthinitjni.jar
	COMMENT "Built depthinit.jar"
	WORKING_DIRECTORY ../..
	COMMAND ${JAVA_HOME}/bin/jar cvf ${CMAKE_CURRENT_BINARY_DIR}/depthinitjni.jar depthinit/DepthInitFunctions.class
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/DepthInitFunctions.java)

if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
  include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
