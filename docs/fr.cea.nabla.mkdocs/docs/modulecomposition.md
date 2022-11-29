# Composing modules

## Presentation of the problem

Let us imagine a dummy hydrodynamic module *Hydro* defined in *Hydro.n* file and its own application defined in *Hydro.ngen* file. You now want to introduce a new remapping module *Remap*. This module does not have its own application. It is designed to be coupled with the hydrodynamic module into one application defined in a *HydroRemap.ngen* file.

From a NabLab point of view, it consists in merging the data flow graphs of the two modules in defining equalities between module's variables.

## Creating the project

Just click on the main menu *File > New > NabLab Project* to create a new project: 

<img src="img/NabLab_new_project_menu.png" alt="NabLab New Project" title="NabLab New Project" width="60%" height="60%" />

A new wizard is launched, asking for a project name and a module name:

<img src="img/NabLab_new_project_wizard.png" alt="NabLab New Project Wizard" title="NabLab New Project Wizard" width="50%" height="50%" />

Enter *Tutorial* as project name, select the *Module* radio button, enter *Hydro* as module name and click on the *Finish* button to create the new project. The new project is available in the *Model Explorer* on the left of the window. It contains two files (*Hydro.n*, and *Hydro.ngen*) in the *Tutorial/src/hydro/* folder:

<img src="img/NabLab_new_project_result.png" alt="NabLab New Project Result" title="NabLab New Project Result" width="30%" height="30%" />

## A dummy Hydro module

Here is an example code of a dummy Hydro module. Copy and paste it in *Hydro.n* file.

```
module Hydro;

with CartesianMesh2D.*;

int maxIter;
real maxTime, delta_t;
let real t = 0.0;
real[2] X{nodes};
real hv1{cells}, hv2{cells}, hv3{cells}, hv4{cells}, hv5{cells};

Hj1: forall c in cells(), hv2{c} = hv1{c};
Hj2: forall c in cells(), hv3{c} = hv2{c};
Hj3: forall c in cells(), hv5{c} = hv3{c} + hv4{c};
```

The algorithm is stupid: the goal is just to introduce dependencies between variables and jobs.

| Job | In Variables | Out Variables |
|-----|--------------|---------------|
| Hj1 | hv1          | hv2           |
| Hj2 | hv2          | hv3           |
| Hj3 | hv3, hv4     | hv5           |

The *Hydro* application is defined in a classical *Hydro.ngen* file (see [Ngen language reference](../ngenlanguage) for details). Copy and paste it in *Hydro.ngen* file.


```
Application Hydro;

MainModule Hydro hydro
{
	nodeCoord = X;
	time = t;
	timeStep = delta_t;
	iterationMax = maxIter;
	timeMax = maxTime;
}

StlThread
{
	outputPath = "/NablaTest/src-gen-cpp/stl-thread";
	CMAKE_CXX_COMPILER = "/usr/bin/g++";
}
```

The *Job Graph Editor*, triggered by pressing F2 key on *Hydro.ngen* file, displays:

<img src="img/NabLab_hydro_job_graph.png" alt="NabLab Hydro Job Graph" title="NabLab Hydro Job Graph" width="20%" height="20%"/>

!!! note
	Let the mouse over a job to display its in/out variables.
	
	<img src="img/NabLab_hydro_job_in_out_variables.png" alt="NabLab Hydro Job In/Out Variables" title="NabLab Hydro Job In/Out Variables" width="30%" height="30%"/>

## A dummy Remap module

Create now a new file for the *Remap* module. Just type `CTRL-N` or click on the main menu *File > New > Other* to create a new file:

<img src="img/NabLab_new_other_menu.png" alt="NabLab New File" title="NabLab New File" width="60%" height="60%" />

A new wizard is launched, select File:

<img src="img/NabLab_new_file_wizard.png" alt="NabLab New File Wizard" title="NabLab New File Wizard" width="50%" height="50%" />

Click *Next>*, select the *Tutorial/src/hydro* folder and enter *Remap.n* as file name:

<img src="img/NabLab_new_remap_file.png" alt="NabLab New Remap File" title="NabLab New Remap File" width="50%" height="50%" />

Here is an example code of a dummy Remap module. Copy and paste it in *Remap.n* file.


```
module Remap;

with CartesianMesh2D.*;

real rv1{cells}, rv2{cells}, rv3{cells};

Rj1: forall c in cells(), rv2{c} = rv1{c};
Rj2: forall c in cells(), rv3{c} = rv2{c};
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

We will create a new application from the previous one. In the explorer, copy *Hydro.ngen* file and paste it in the same folder. A wizard will ask you for the name of the new file, enter *HydroRemap.ngen*. The new file must appears in the *src/hydro* folder as follows:

<img src="img/NabLab_hydro_remap_files.png" alt="NabLab Hydro/Remap Files" title="NabLab Hydro/Remap Files" width="30%" height="30%"/>

The *HydroRemap.ngen* file defines the application coupling between *Hydro* and *Remap* modules. Change the name of the application from *Hydro* to *HydroRemap* at the beginning of the file.

```
Application HydroRemap;
```

The *Hydro* module stays the main module of the application. The *Remap* module will be added to the application: in the *HydroRemap.ngen* file, between the `MainModule` and the `StlThread` blocks, introduce a block to add the additional module *Remap* and define variable equalities like they appear in the graph above:

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

!!! note
	In this example, there is no `iterate` instruction to define time iterators and consequently no variable with time iterators like `t^{n}`. If it is the case, time iterators must belong to the main module: they are forbidden in additional modules.


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

with CartesianMesh2D.*;

int maxIter;
real maxTime, delta_t;
let real t = 0.0;
real[2] X{nodes};
real hv1{cells}, hv2{cells}, hv3{cells}, hv4{cells}, hv5{cells}, hv6{cells}, hv7{cells};

Hj1: forall c in cells(), hv3{c} = hv2{c};
Hj2: forall c in cells(), hv5{c} = hv3{c};
Hj3: forall c in cells(), hv7{c} = hv4{c} + hv5{c} + hv6{c};
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

The above picture shows that generated files have the same name as the module instances (defined in the *HydroRemap.ngen* file) starting with an upper case, i.e. *Hydro*, *R1* and *R2*.

The *Job Graph Editor*, triggered by pressing F2 key on *HydroRemap.ngen* file, now displays:

<img src="img/NabLab_hydro_2_remap_job_graph.png" alt="NabLab Hydro and 2 Remap Job Graph" title="NabLab Hydro and 2 Remap Job Graph" width="60%" height="60%"/>

