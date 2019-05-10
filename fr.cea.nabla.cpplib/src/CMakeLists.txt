cmake_minimum_required(VERSION 3.1)
project(fr.cea.nabla.cpplib CXX)
SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt")

SET(Kokkos_HOME "~/kokkos/kokkos-install")
include_directories("${CMAKE_SOURCE_DIR};${Kokkos_HOME}/include")

add_library(cppnabla types/Real3.cc types/Real3x3.cc types/MathFunctions.cc mesh/NumericMesh2D.cc mesh/CartesianMesh2DGenerator.cc mesh/VtkFileWriter2D.cc utils/Utils.cc utils/Timer.cc)
