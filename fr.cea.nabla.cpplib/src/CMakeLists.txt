cmake_minimum_required(VERSION 3.1)
project(fr.cea.nabla.cpplib CXX)
set(CMAKE_CXX_STANDARD 17)
list(APPEND CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} -O3)

SET(Kokkos_HOME "~/kokkos/kokkos-install")
include_directories("${CMAKE_SOURCE_DIR};${Kokkos_HOME}/include")

add_library(cppnabla types/Real2.cpp types/Real3.cpp types/Real2x2.cpp types/Real3x3.cpp types/MathFunctions.cpp mesh/NumericMesh2D.cpp mesh/CartesianMesh2DGenerator.cpp mesh/VtkFileWriter2D.cpp)
