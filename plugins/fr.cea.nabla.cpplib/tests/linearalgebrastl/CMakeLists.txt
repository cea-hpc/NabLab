###############################################################################
# Copyright (c) 2022 CEA
# This program and the accompanying materials are made available under the 
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.
#
# SPDX-License-Identifier: EPL-2.0
# Contributors: see AUTHORS file
###############################################################################

cmake_minimum_required(VERSION 3.10)
cmake_policy(SET CMP0074 NEW)
set(CMAKE_VERBOSE_MAKEFILE FALSE)

# SET VARIABLES
set(CMAKE_CXX_COMPILER /usr/bin/g++)
set(PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../..)

project(teststllinearalgebra CXX)

include_directories(${PROJECT_DIR}/src/linearalgebra/linearalgebrastl)
include_directories(${PROJECT_DIR}/src/nablalib)
link_directories(${PROJECT_DIR}/lib/linearalgebrastl)
link_directories(${PROJECT_DIR}/lib/nablalib)
add_executable(teststllinearalgebra main.cc)
target_link_libraries(teststllinearalgebra nablalib linearalgebrastl)
