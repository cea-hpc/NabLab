# Composing modules

## Presentation of the problem

Let us imagine a dummy hydrodynamic module *Hydro* defined in *Hydro.n* file and its own application defined in *Hydro.ngen* file. You now want to introduce a new remapping module Remap. This module does not have its own application. It is designed to be coupled with the hydrodynamic module into one application defined in a *HydroRemap.ngen* file.

From a NabLab point of view, it consists in merging the data flow graphs of the two modules in defining equalities between module's variables.

## The dummy Hydro module

You can find an example code of a dummy Hydro module.

```
module Hydro;

itemtypes { node, cell }
connectivity nodes: → {node};
connectivity cells: → {cell};

option ℝ maxTime = 0.1;
option ℕ maxIter = 500;
option ℝ δt = 1.0;
let ℝ t = 0.0;
ℝ[2] X{nodes};
ℝ hv1{cells}, hv2{cells}, hv3{cells}, hv4{cells}, hv5{cells};

Hj1: ∀c∈cells(), hv2{c} = hv1{c};
Hj2: ∀c∈cells(), hv3{c} = hv2{c};
Hj3: ∀c∈cells(), hv5{c} = hv3{c} + hv4{c};
```

The algorithm is stupid: the goal is just to introduce dependencies between variables and jobs.

| Job | In Variables | Out Variables |
|-----|--------------|---------------|
| Hj1 | hv1          | hv2           |
| Hj2 | hv2          | hv3           |
| Hj3 | hv3, hv4     | hv5           |

The *Hydro* application is defined in a classical *Hydro.ngen* file (see [Ngen language reference](../ngenlanguage/index.html) for details).

```
Application Hydro;

MainModule Hydro hydro
{
	meshClassName = "CartesianMesh2D";
	nodeCoord = X;
	time = t;
	timeStep = δt;
	iterationMax = maxIter;
	timeMax = maxTime;
}

StlThread
{
	outputPath = "/NablaTest/src-gen-cpp/stl-thread";
	N_CXX_COMPILER = "/usr/bin/g++";
}
```

The *Job Graph Editor*, triggered by pressing F2 key on *Hydro.ngen* file, displays:

<img src="img/NabLab_hydro_job_graph.png" alt="NabLab Hydro Job Graph" title="NabLab Hydro Job Graph" width="20%" height="20%"/>

!!! note
	Let the mouse over a job to display its in/out variables.
	
	<img src="img/NabLab_hydro_job_in_out_variables.png" alt="NabLab Hydro Job In/Out Variables" title="NabLab Hydro Job In/Out Variables" width="30%" height="30%"/>

## The dummy Remap module
	
You can find an example code of a dummy Remap module.

```
module Remap;

itemtypes { cell }
connectivity cells: → {cell};

ℝ rv1{cells}, rv2{cells}, rv3{cells};

Rj1: ∀c∈cells(), rv2{c} = rv1{c};
Rj2: ∀c∈cells(), rv3{c} = rv2{c};
```

The algorithm is as stupid as the Hydro one: the goal is just to introduce dependencies between variables and jobs.

| Job | In Variables | Out Variables |
|-----|--------------|---------------|
| Rj1 | rv1          | rv2           |
| Rj2 | rv2          | rv3           |

It is not possible to display the graph of jobs because there is no *ngen* application file for the *Remap* module. It is not a standalone module and it is designed to be coupled with the *Hydro* one.

## Hydro/Remap association

The aim is to associate the *Hydro* and *Remap* modules by coupling their data flow as follows:

<img src="img/HydroAnd1Remap.png" alt="NabLab Hydro/Remap Association" title="NabLab Hydro/Remap Association" width="30%" height="30%"/>

The *Hydro* module stays the main module of the application. The *Remap* module will be added to the application.

!!! note
	In this example, there is no `iterate` instruction to define time iterators and consequently no variable with time iterators like `t^{n}`. If it is the case, time iterators must belong to the main module: they are forbidden in additional modules.

Rename *Hydro.ngen* file to *HydroRemap.ngen* to define the new application associating *Hydro* and *Remap* modules. The content of the *src* folder must be as follows:

<img src="img/NabLab_hydro_remap_files.png" alt="NabLab Hydro/Remap Files" title="NabLab Hydro/Remap Files" width="20%" height="20%"/>

In the *HydroRemap.ngen* file, between the `MainModule` and the `StlThread` blocks, introduce a block to add the additional module *Remap* and define variable equalities like they appear in the graph above:

```
AdditionalModule Remap remap
{
	remap.rv1 = hydro.hv1;
	remap.rv2 = hydro.hv4;
}
```

!!! note
	Module names and their variables are available by contextual code completion with `CTRL-Space` keys.

Only variables of the same type can be declared as equals: the *ngen* editor will display an error if it is not the case.

<img src="img/NabLab_association_error.png" alt="NabLab Association Error" title="NabLab Association Error" width="60%" height="60%"/>

The *Job Graph Editor*, triggered by pressing F2 key on *HydroRemap.ngen* file, displays:

<img src="img/NabLab_hydro_remap_job_graph.png" alt="NabLab Hydro/Remap Job Graph" title="NabLab Hydro/Remap Job Graph" width="40%" height="40%"/>


## Code generation

Generate the code in the same way as usual: right-click on the *HydroRemap.ngen* file and select *Generate Code*. 
The `StlThread` generation target will produce the following files, as expected:

<img src="img/NabLab_hydro_remap_generated_files.png" alt="NabLab Hydro/Remap Generated Files" title="NabLab Hydro/Remap Generated Files" width="20%" height="20%"/>


## Multiple additional modules

It is possible to define multiple additional modules, even if they have the same type, as long as they have different name. For example, you can couple 2 *Remap* modules named *r1* and *r2* to the *Hydro* module *hydro* in the following scenario:

<img src="img/HydroAnd2Remaps.png" alt="NabLab Multiple Additional Modules" title="NabLab Multiple Additional Modules" width="40%" height="40%"/>

The content of the *Hydro.n* file becomes:

```
module Hydro;

itemtypes { node, cell }
connectivity nodes: → {node};
connectivity cells: → {cell};

option ℝ maxTime = 0.1;
option ℕ maxIter = 500;
option ℝ δt = 1.0;
let ℝ t = 0.0;
ℝ[2] X{nodes};
ℝ hv1{cells}, hv2{cells}, hv3{cells}, hv4{cells}, hv5{cells}, hv6{cells}, hv7{cells};

Hj1: ∀c∈cells(), hv3{c} = hv2{c};
Hj2: ∀c∈cells(), hv5{c} = hv3{c};
Hj3: ∀c∈cells(), hv7{c} = hv4{c} + hv5{c} + hv6{c};
```

The *Remap* module does not change while the content of the *HydroRemap.ngen* file integrates two additional modules instead of the previous *remap* one:

```
AdditionalModule Remap r1
{
	r1.rv1 = h.hv1;
	r1.rv2 = h.hv4;
}

AdditionalModule Remap r2
{
	r2.rv1 = h.hv3;
	r2.rv3 = h.hv6;
}
```

The `StlThread` target will generate the following files:

<img src="img/NabLab_hydro_2remaps_generated_files.png" alt="NabLab Multiple Additional Module Generated Files" title="NabLab Multiple Additional Module Generated Files" width="20%" height="20%"/>

The generated file have the names of the instance starting with an upper case. Consequently, if you create two
