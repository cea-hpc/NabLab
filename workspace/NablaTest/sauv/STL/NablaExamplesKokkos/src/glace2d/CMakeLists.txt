add_executable(glace2d Glace2d_stl.cc)
target_link_libraries(glace2d cppnabla kokkos kokkos_kernels dl stdc++fs hwloc)

