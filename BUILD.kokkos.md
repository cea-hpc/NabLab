# Installation of Kokkos and Kokkos Kernels for NabLab

## Kokkos

Kokkos can be installed with debian packages.
Anyway, we recommend to install Kokkos using github like this:
```bash
	mkdir kokkos
	cd kokkos
	git clone https://github.com/kokkos/kokkos.git
	mkdir kokkos-install
	mkdir kokkos-build
	cd kokkos-build
	cmake ../kokkos -DCMAKE_CXX_COMPILER=g++ -DKokkos_CXX_STANDARD=17 -DCMAKE_INSTALL_PREFIX=~/kokkos/kokkos-install -DKokkos_ENABLE_OPENMP=On -DKokkos_ENABLE_HWLOC=On
	make install
	cd ..
	rm -rf kokkos-build
	rm -rf kokkos (if you don't want to keep sources)
```
The version installed is 3.0.0.

## Kokkos Kernels

We use the same process.
```bash
	# Making your way back to kokkos parent directory where is your kokkos install sub-directory
	git clone https://github.com/kokkos/kokkos-kernels.git
	mkdir kokkos-build
	cd kokkos-build
	# kokkos-install directory already exists from kokkos install
	cmake ../kokkos-kernels -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=~/kokkos/kokkos-install -DKokkos_ENABLE_OPENMP=On -DCMAKE_PREFIX_PATH=~/kokkos/kokkos-install
	make install
	cd ..
	rm -rf kokkos-build
	rm -rf kokkos-kernels (if you don't want to keep sources)
```
The version installed is 3.0.0.

## NabLab examples compilation

If you choose a generation target that does not need Kokkos, the compilation of NabLab examples will produce libcppnabla and libcppnablastl.
A warning alerts the user to the fact that the library libcppnablakokkos will not be built but it is not a problem.

If you choose a generation target that needs Kokkos, you must set the kokkos install path in your nablagen file.

Then the libcppnablakokkos will be produced and the examples can be compiled.

 
NB: when creating the standalone version of the library, default kokkos install path will be ~/kokkos/kokkos-install.
