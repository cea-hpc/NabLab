SET(Kokkos_HOME "~/kokkos/kokkos-install")
SET(Nablalib_HOME "~/workspaces/NabLab/fr.cea.nabla.cpplib")
include_directories("${CMAKE_SOURCE_DIR};${Kokkos_HOME}/include;${Nablalib_HOME}/src")

link_directories(${Kokkos_HOME}/lib ${Nablalib_HOME}/lib)
add_executable(glace2d Glace2dFunctions.cpp Glace2d.cpp)
target_link_libraries(glace2d kokkos cppnabla dl stdc++fs pthread)

