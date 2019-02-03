list(APPEND CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} -O3)

SET(Kokkos_HOME "/home/lelandaisb/kokkos")
SET(Nablalib_HOME "/home/lelandaisb/workspaces/NabLab/fr.cea.nabla.cpplib/src")
include_directories("${CMAKE_SOURCE_DIR};${Kokkos_HOME}/kokkos;${Kokkos_HOME}/kokkos/core/src;${Kokkos_HOME}/kokkos-build;${Nablalib_HOME}")

link_directories(${Kokkos_HOME}/kokkos-build ${Nablalib_HOME})
add_executable(glace2d Glace2dFunctions.cpp Glace2d.cpp)
target_link_libraries(glace2d kokkos nabla dl stdc++fs)

