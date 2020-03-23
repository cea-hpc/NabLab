cmake_minimum_required(VERSION 3.1)
project(fr.cea.nabla.cpplib CXX)
SET(CMAKE_CXX_FLAGS "-O3 -Wall --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt")

include_directories("${CMAKE_SOURCE_DIR}")
link_directories("/usr/lib/x86_64-linux-gnu")

add_library(cppnabla types/CrsMatrix.h types/LinearAlgebraFunctions_stl.cc types/Matrix_stl.cc types/MultiArray.cc mesh/NumericMesh2D.cc mesh/CartesianMesh2DGenerator.cc mesh/FileWriter.cc mesh/VtkFileWriter2D.cc mesh/PvdFileWriter2D.cc utils/Utils.cc utils/Timer.cc)
