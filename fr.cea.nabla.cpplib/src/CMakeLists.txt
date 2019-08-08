cmake_minimum_required(VERSION 3.1)
project(fr.cea.nabla.cpplib CXX)
SET(CMAKE_CXX_COMPILER /cea/home/necdev/necdev/install/spack/opt/spack/linux-centos6-x86_64/gcc-4.4.7/gcc-7.3.0-7vxkc7hfpnyxucthhnx3ykp5lbct6m4o/bin/g++)
SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt")
SET(Kokkos_HOME "~/Utils/kokkos-install")

include_directories("${CMAKE_SOURCE_DIR};${Kokkos_HOME}/include")
link_directories("${Kokkos_HOME}/lib;/usr/lib/x86_64-linux-gnu")

add_library(cppnabla types/Real3.cc types/Real3x3.cc types/MathFunctions.cc types/LinearAlgebraFunctions.cc types/Matrix.cc mesh/NumericMesh2D.cc mesh/CartesianMesh2DGenerator.cc mesh/VtkFileWriter2D.cc utils/Utils.cc utils/Timer.cc)

