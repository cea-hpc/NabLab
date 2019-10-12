cmake_minimum_required(VERSION 3.1)
project(fr.cea.nabla.cpplib CXX)
SET(CMAKE_CXX_COMPILER /usr/bin/g++)
SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt")
SET(Kokkos_HOME "~/kokkos/kokkos-install")

include_directories("${CMAKE_SOURCE_DIR};${Kokkos_HOME}/include")
link_directories("${Kokkos_HOME}/lib;/usr/lib/x86_64-linux-gnu")

add_library(cppnabla types/LinearAlgebraFunctions.cc types/Matrix.cc mesh/NumericMesh2D.cc mesh/CartesianMesh2DGenerator.cc mesh/FileWriter.cc mesh/VtkFileWriter2D.cc mesh/PvdFileWriter2D.cc utils/Utils.cc utils/Timer.cc)

