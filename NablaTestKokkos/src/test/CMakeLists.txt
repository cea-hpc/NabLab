SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt")

SET(Kokkos_HOME "~/kokkos/kokkos-install")
SET(Nablalib_HOME "~/workspaces/NabLab/fr.cea.nabla.cpplib")

include_directories("${CMAKE_SOURCE_DIR};${Kokkos_HOME}/include;${Nablalib_HOME}/src")

link_directories(${Kokkos_HOME}/lib ${Nablalib_HOME}/lib)
add_executable(test Test.cc)
target_link_libraries(test kokkos cppnabla dl stdc++fs hwloc)

