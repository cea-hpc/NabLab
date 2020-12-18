cmake_minimum_required(VERSION 3.10)

set(CMAKE_CXX_COMPILER /usr/bin/g++)
set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../include)
set(BIN_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../bin)
set(WAVE_HEIGHT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../BatiLibCpp)

project(BatiLibJni CXX)
MESSAGE(STATUS "Building library batilibjni")

# The libbatilibjni.so library
set(JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64)
add_library(batilibjni SHARED batilib_BatiLibJni.cc ${INCLUDE_DIR}/batilib_BatiLibJni.h)
target_include_directories(batilibjni
	PUBLIC ${INCLUDE_DIR}
	PUBLIC ${WAVE_HEIGHT_DIR}/include
	PUBLIC ${JAVA_HOME}/include
	PUBLIC ${JAVA_HOME}/include/linux)
target_link_directories(batilibjni PUBLIC ${WAVE_HEIGHT_DIR}/lib)
target_link_libraries(batilibjni batilib)

# Generation of BatiLibJni.h from BatiLibJni.java
add_custom_command(
	OUTPUT ${INCLUDE_DIR}/batilib_BatiLibJni.h
	COMMENT "Generate BatiLibJni.h from BatiLibJni.java"
	COMMAND ${JAVA_HOME}/bin/javac -h ${INCLUDE_DIR} -d ${BIN_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/batilib/BatiLibJni.java
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/batilib/BatiLibJni.java)

# The batilibjni.jar
add_custom_target(batilibjnijar ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/batilibjni.jar)
add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/batilibjni.jar
	COMMENT "Built batilibjni.jar"
	WORKING_DIRECTORY ${BIN_DIR}
	COMMAND ${JAVA_HOME}/bin/jar cvf ${CMAKE_CURRENT_BINARY_DIR}/batilibjni.jar batilib/BatiLibJni.class
	DEPENDS ${INCLUDE_DIR}/batilib_BatiLibJni.h)
