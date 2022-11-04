# Ngen language

A ngen file, extension `ngen`, defines an `Application` or n (or several) `ExtensionProvider`.
An `Application` reference a `module` while  an `ExtensionProvider` references an `extension`.


## Application

The application is identified by a name starting with an upper case.

```
Application Glace2d;
```


### Main module identification

The first part of the *ngen* file identifies the main module of the application. It is defined by a reference to a NabLab module and a name. It must provide some additional parameters useful for code interpretation/generation:

- `nodeCoord` identifies the NabLab variable representing node coordinates.
- `time`, `timeStep`, `iterationMax` and `timeMax` identifies respectively the NabLab variables representing the time of the simulation, the timeStep of the simulation, the maximum number of iterations of the main time loop and the maximum time of the simulation.

```
MainModule Glace2d glace2d
{
	nodeCoord = X;
	time = t;
	timeStep = delta_t;
	iterationMax = maxIterations;
	timeMax = stopTime;
}
```

!!! note
	`iterationMax` and `timeMax` variables are mandatory for C++ code generation, optional otherwise.

!!! note
	Code completion is available with *CTRL-space* for all module and variable references.


### VTK output

NabLab provides a [PVD](https://vtk.org/Wiki/ParaView/Data_formats#PVD_File_Format) file format serializer, a [VTK](https://vtk.org/) compatible file format. The next block of the *ngen* file aims at configuring this serializer. It is an optional block. The `periodReferenceVariable` field defines the module variable used as a reference for the frequency of the outputs. Most of the time, it is the iteration number (often named `n`) or the time of the simulation (often named `t`). The `outputVariables` field defines the list of nodes and cells variables to write in the output file. The name after the `as` keyword is the name displayed by [Paraview](https://www.paraview.org/).

```
VtkOutput
{
	periodReferenceVariable = glace2d.n;
	outputVariables = glace2d.ρ as "Density";
}
```

When the `VtkOutput`block exists in the *ngen* file, two options must appear in the Json data file: `outputPath` and `outputPeriod` representing respectively the VTK output directory and the frequency period of the output. For example, for an `outputPeriod` of 1 and a `periodReferenceVariable` of `n`, VTK files will be written at each iteration of the simulation.

Here is the VTK part of the default generated Json file (in `src-gen` directory):

```
"_outputPath_comment":"empty outputPath to disable output",
"outputPath":"output",
"outputPeriod":1,
```


### Dump variables

NabLab provides a mechanism to dump variable values. It uses the LevelDB library for [Java](https://github.com/dain/leveldb) and [C++](https://github.com/google/leveldb).
The Java LevelDB library is included in the NabLab environment. To use the C++ one, you have to download and install it on your computer. 

To trigger the dump of all variables (except linear algebra ones) of your code, add a `LevelDB` block. In addition to that, in case of C++ generation, provide the path to the LevelDB installation.

``` 
LevelDB
{
	leveldb_ROOT = "$ENV{HOME}/leveldb/install";
}
```

!!! note
	The `leveldb_ROOT` value supports CMake syntax like `$ENV{HOME}` in the example above.

When the `LevelDB`block exists in the *ngen* file, the `nonRegression` key must appear in the *Json* data file. If its value is `CreateReference`, variables are dumped in a directory named *ApplicationNameDB.ref*. If its value is `CompareToReference`, variables are dumped in a directory named *Application NameDB.current* and are compared to variables stored in *ApplicationNameDB.ref*.

```
"_nonRegression_comment":"empty value to disable, CreateReference or CompareToReference to take action",
"nonRegression":""
```


### Configuring interpretation

Interpreter needs to be configured only if you use an extension with no *Java* provider. See the extension section for details.


### Configuring generation

To configure generation, create as many generation blocks as desired generation targets.

Possible targets are:

- `Java` for a multi-threaded [Java](https://docs.oracle.com/javase/specs/jls/se14/html/index.html) code,
- `Kokkos` for a [Kokkos](https://github.com/kokkos) multi-threaded C++ code based on Open MP, 
- `KokkosTeamThread` for a [Kokkos](https://github.com/kokkos) hierarchical multi-threaded C++ code with team of threads,
- `OpenMP` for an [Open MP](https://www.openmp.org/) multi-threaded C++ code,
- `CppSequential` for a sequential C++ code,
- `StlThread` for a multi-threaded C++ code based on an STL threads API provided by the NabLab library.

Here is an example of a generation block:

```
Kokkos
{
	outputPath = "/NabLabExamples/src-gen-cpp/kokkos";
	CMAKE_CXX_COMPILER = "/usr/bin/g++";
	Kokkos_ROOT = "$ENV{HOME}/kokkos/install";
}
```

All targets have to define the `outputPath` of the generation and a set of variables which will be reported in the *CMakeLists.txt* file.

!!! note
	A good practice is to name "src-gen" a directory containing only generated code.

For `Kokkos`, `KokkosTeamThread`, the Kokkos library has to be installed and the path to the library has to be provided is the `Kokkos_ROOT` variable.
Moreover, if linear algebra is used, `KokkosKernels_ROOT` variable must be set to Kokkos Kernels installation directory.

!!! note
	Variables can use CMake syntax in their value like `$ENV{HOME}` for path in the example above.


## Provider

A NabLab module can import some extensions. Those extensions contain some functions. Some of them can be *external functions* i.e. functions with just a signature definition and no body. In this case, these *external functions* are defined in a native language, for example C++.

To connect definitions to signatures, providers have to be defined:

- some glue code must be written,
- providers have to be declared in a *ngen* file.

!!! note
	NabLab offers a code generator to initialize the glue code and the *ngen* file for extension providers. See [My first extension](../firstextension) for that.
	
Most of the time, all providers of an extension are declared in the same *ngen* file. For example, for *linearalgebra* extension part of the NabLab library, defined in the *linearalgebra.n* file, a *linearalgebra.ngen* file contains the providers.

```
Provider LinearAlgebraStl : LinearAlgebra
{
	target = StlThread;
	compatibleTargets = CppSequential, OpenMP;
	outputPath = "/.nablab/linearalgebra";
}

Provider LinearAlgebraKokkos : LinearAlgebra
{
	target = Kokkos;
	compatibleTargets = KokkosTeamThread;
	outputPath = "/.nablab/linearalgebra";
}

Provider LinearAlgebraJava : LinearAlgebra
{
	target = Java;
	outputPath = "/.nablab/linearalgebra";
}
```

A provider is defined by its name and the extension it implements (after the `:` character).
The provider block is composed of:

- `target` defining which generation target the provider implements.
- `compatibleTargets`, an optional field, representing a list of generation targets compatible with the `target` previously defined. In the above `LinearAlgebraKokkos` example, the `target` indicates that the provider's source code is designed for a multi-threaded C++ Kokkos source code. The `compatibleTargets` indicates that a caller generated with a `KokkosTeamThread` target can use this provider.
- `outputPath` containing the directory of the providers's source code.

