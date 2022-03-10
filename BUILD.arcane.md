# Installation of Arcane for NabLab

## Arcane installation

Arcane is a development platform for unstructured 2D or 3D parallel computing codes.

To install Arcane follow instructions on GitHub repository https://github.com/arcaneframework/framework.
Do not forget prerequisites, for ubuntu: https://github.com/arcaneframework/framework#ubuntu-2004

``` bash
	cd
	mkdir arcane; cd arcane
	git clone --recurse-submodules https://github.com/arcaneframework/framework.git
	mkdir install; mkdir build; cd build
	cmake ../framework -DCMAKE_INSTALL_PREFIX=~/leveldb/install
	make; make install
	cd ..; rm -rf build
```

If you need documentation, launch `make devdoc` and `make userdoc` in the `build` directory.

## NabLab examples compilation

If you choose Arcane generation target, you must set the Arcane install path in your nablagen file.

```
Arcane
{
	outputPath = "/NabLabExamples/src-gen-arcane";
	extension LinearAlgebra providedBy LinearAlgebraStl;
	CMAKE_CXX_COMPILER = "/usr/bin/g++";
	Arcane_ROOT = "$ENV{HOME}/arcane/install";
}
```
 
## NabLabExamplesTest

To run NabLabExamplesTest, you have to set Arcane_ROOT

```bash
export Arcane_ROOT=$HOME/arcane/install
```

