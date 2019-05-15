#SET(CMAKE_CXX_COMPILER "g++")
#list(APPEND CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} -O3)
SET(CMAKE_CXX_FLAGS "-O3 --std=c++17 -fopenmp -march=core-avx2 -mtune=core-avx2 -fopt-info-vec-missed=vec_opt_miss.txt")

SET(Kokkos_HOME "~/kokkos/kokkos-install")
SET(Nablab_HOME "~/workspaces/NabLab/fr.cea.nabla.cpplib")
#SET(Hwloc_HOME "~/hwloc/1.11.5")

include_directories("${CMAKE_SOURCE_DIR};${Kokkos_HOME}/include;${Nablab_HOME}/src")

link_directories(${Kokkos_HOME}/lib ${Nablab_HOME}/lib/Release)
add_executable(glace2d Glace2dFunctions.cc Glace2d.cc)
target_link_libraries(glace2d kokkos cppnabla dl stdc++fs hwloc)

