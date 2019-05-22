add_executable(glace2d Glace2dFunctions.cc Glace2d.cc)
target_link_libraries(glace2d kokkos cppnabla dl stdc++fs hwloc)

