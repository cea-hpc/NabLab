cmake_minimum_required(VERSION 3.1)
project(NablaExamples CXX)

SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt")

SET(Kokkos_HOME "~/kokkos/kokkos-install")
SET(Nablab_HOME "~/workspaces/NabLab/fr.cea.nabla.cpplib")

include_directories("${CMAKE_SOURCE_DIR};${Kokkos_HOME}/include;${Nablab_HOME}/src")

link_directories(${Kokkos_HOME}/lib ${Nablab_HOME}/lib)

add_subdirectory(glace2d)
add_subdirectory(heatequation)
