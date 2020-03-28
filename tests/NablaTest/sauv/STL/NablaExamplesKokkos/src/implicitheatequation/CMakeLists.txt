add_executable(impl_heat_eq ImplicitHeatEquation_stl.cc)
target_link_libraries(impl_heat_eq cppnabla kokkos kokkos_kernels dl stdc++fs hwloc)

