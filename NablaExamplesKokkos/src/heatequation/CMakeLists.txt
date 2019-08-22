add_executable(heatequation HeatEquation.cc)
target_link_libraries(heatequation cppnabla kokkos kokkos_kernels dl stdc++fs hwloc)

