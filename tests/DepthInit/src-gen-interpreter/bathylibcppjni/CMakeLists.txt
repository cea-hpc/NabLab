### GENERATED FILE - DO NOT OVERWRITE ###

# This file is in a cmake sub_directory and is called by a root CMakeLists.txt 

# CHECK VARIABLES
if (NOT DEFINED N_WS_PATH)
	message(FATAL_ERROR "N_WS_PATH variable must be set")
endif()
if (NOT DEFINED JAVA_HOME)
	message(FATAL_ERROR "JAVA_HOME variable must be set")
endif()

# SET VARIABLES
set(BATHYLIBCPP_PATH ${N_WS_PATH}/BathyLib/src-cpp/bathylibcpp)

# SUB_DIRECTORIES
if(NOT TARGET nablalib)
	add_subdirectory(${N_WS_PATH}/.nablab/nablalib ${CMAKE_BINARY_DIR}/nablalib)
endif()
if(NOT TARGET bathylibcpp)
	add_subdirectory(${BATHYLIBCPP_PATH} ${CMAKE_BINARY_DIR}/bathylibcpp)
endif()

# LIBRARY bathylibcppjni
add_library(bathylibcppjni SHARED bathylibcppjni_BathyLib.cc)
target_include_directories(bathylibcppjni
	PUBLIC ${INCLUDE_DIR}
	PUBLIC ${JAVA_HOME}/include
	PUBLIC ${JAVA_HOME}/include/linux)
target_link_libraries(bathylibcppjni PUBLIC bathylibcpp)

# GENERATE bathylibcppjni_BathyLib.h FROM BathyLib.java
add_custom_command(
	OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/bathylibcppjni_BathyLib.h bathylibcppjni/BathyLib.class
	COMMENT "Generate bathylibcppjni_BathyLib.h from BathyLib.java"
	COMMAND ${JAVA_HOME}/bin/javac -h ${CMAKE_CURRENT_SOURCE_DIR} -d ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*.java
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/BathyLib.java)

# JAR bathylibcppjni
add_custom_target(bathylibcppjnijar ALL DEPENDS bathylibcppjni.jar)
add_custom_command(
	OUTPUT bathylibcppjni.jar
	COMMENT "Built bathylibcppjni.jar"
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	COMMAND ${JAVA_HOME}/bin/jar cvf bathylibcppjni.jar bathylibcppjni/*.class
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/bathylibcppjni_BathyLib.h)

INSTALL(TARGETS bathylibcppjni DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/lib)
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/bathylibcppjni.jar DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/lib)

# OPTIONAL USER OPTIONS IN Project.cmake
if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
	include(${CMAKE_CURRENT_SOURCE_DIR}/Project.cmake)
endif()
