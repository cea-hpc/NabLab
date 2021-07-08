# Installation of Kokkos and Kokkos Kernels for NabLab

## HWloc

The Portable Hardware Locality (hwloc) software package provides a portable abstraction (across OS, versions, architectures, ...) of the hierarchical topology of modern architectures, 
including NUMA memory nodes, sockets, shared caches, cores and simultaneous multithreading. Kokkos can be configured using hwloc so we need to install it before

```bash
sudo apt-get update; sudo apt-get install -y libhwloc-dev --fix-missing
```

## Kokkos

Kokkos can be installed with debian packages.
Anyway, we recommend to install Kokkos using github like this:
```bash
	cd
	mkdir kokkos;  cd kokkos
	wget http://github.com/kokkos/kokkos/archive/refs/tags/3.0.00.tar.gz -O kokkos.tar.gz
	tar -zxf kokkos.tar.gz; rm kokkos.tar.gz
	mkdir install; mkdir build; cd build
	cmake ../kokkos-3.0.00 -DCMAKE_CXX_COMPILER=g++ -DKokkos_CXX_STANDARD=17 -DCMAKE_INSTALL_PREFIX=~/kokkos/install -DKokkos_ENABLE_OPENMP=On -DKokkos_ENABLE_HWLOC=On
	make; make install
	cd ..; rm -rf build
```
The version installed is 3.0.0.

## Kokkos Kernels

We use the same process.
```bash
	# Making your way back to kokkos parent directory where is your kokkos install sub-directory
	cd ~/kokkos
	wget http://github.com/kokkos/kokkos-kernels/archive/refs/tags/3.0.00.tar.gz -O kernels.tar.gz
	tar -zxf kernels.tar.gz; rm kernels.tar.gz
	mkdir build; cd build
	# kokkos/install directory already exists from kokkos install
	cmake ../kokkos-kernels-3.0.00 -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=~/kokkos/install -DKokkos_DIR=~/kokkos/install
	make; make install
	cd ..; rm -rf build
```
The version installed is 3.0.0.

## NabLab examples compilation

If you choose a generation target that needs Kokkos, you must set the kokkos install path in your nablagen file.

```
Kokkos
{
	outputPath = "/NabLabExamples/src-gen-cpp/kokkos";
	CMAKE_CXX_COMPILER = "/usr/bin/g++";
	Kokkos_ROOT = "$ENV{HOME}/kokkos/kokkos-install";
}
```

## NabLabExamplesTest

To run NabLabExamplesTest, you have to set KOKKOS_HOME

```bash
export KOKKOS_HOME=$HOME/kokkos/install
```