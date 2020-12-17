cmake_minimum_required(VERSION 3.10)

set(CMAKE_CXX_COMPILER /usr/bin/g++)
set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../include)
set(BIN_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../bin)
set(WAVE_HEIGHT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../WaveHeightCpp)

project(WaveHeightJni CXX)
MESSAGE(STATUS "Building library waveheightjni")

# The libwaveheightjni.so library
set(JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64)
add_library(waveheightjni SHARED waveheight_WaveHeightJni.cc ${INCLUDE_DIR}/waveheight_WaveHeightJni.h)
target_include_directories(waveheightjni
	PUBLIC ${INCLUDE_DIR}
	PUBLIC ${WAVE_HEIGHT_DIR}/include
	PUBLIC ${JAVA_HOME}/include
	PUBLIC ${JAVA_HOME}/include/linux)
target_link_directories(waveheightjni PUBLIC ${WAVE_HEIGHT_DIR}/lib)
target_link_libraries(waveheightjni waveheight)

# Generation of WaveHeightJni.h from WaveHeightJni.java
add_custom_command(
	OUTPUT ${INCLUDE_DIR}/waveheight_WaveHeightJni.h
	COMMENT "Generate WaveHeightJni.h from WaveHeightJni.java"
	COMMAND ${JAVA_HOME}/bin/javac -h ${INCLUDE_DIR} -d ${BIN_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/waveheight/WaveHeightJni.java
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/waveheight/WaveHeightJni.java)

# The waveheightjni.jar
add_custom_target(waveheightjnijar ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/waveheightjni.jar)
add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/waveheightjni.jar
	COMMENT "Built waveheightjni.jar"
	WORKING_DIRECTORY ${BIN_DIR}
	COMMAND ${JAVA_HOME}/bin/jar cvf ${CMAKE_CURRENT_BINARY_DIR}/waveheightjni.jar waveheight/WaveHeightJni.class
	DEPENDS ${INCLUDE_DIR}/waveheight_WaveHeightJni.h)
