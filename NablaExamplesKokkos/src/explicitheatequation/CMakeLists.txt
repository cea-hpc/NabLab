add_executable(expl_heat_eq ExplicitHeatEquation.cc)
target_link_libraries(expl_heat_eq cppnabla kokkos kokkos_kernels dl stdc++fs hwloc)

