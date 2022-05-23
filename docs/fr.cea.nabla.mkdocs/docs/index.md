# What is NabLab ?

## Presentation of the project

NabLab is a open-source research project led by [HPC initiative of the CEA](http://www-hpc.cea.fr/index-en.htm).
It aims is to provide a productive development way for exascale HPC technologies, flexible enough to be competitive in terms of performances.
It is composed of:

- a numerical analysis Domain Specific Language (DSL) to improve applied mathematicians productivity throughput and enables new algorithmic developments for the construction of hierarchical and composable high-performance scientific applications.
- an full-fledged environment to edit, interpret, debug specific numerical-analysis sources and to generate optimized code for various C++ targets.


## Motivation

Addressing the major challenges of software productivity and performance portability is becoming necessary to take advantage of emerging extreme-scale computing architectures. As software development costs will continuously increase to address exascale hardware issues, higher-level programming abstraction will facilitate the path to go. There is a growing demand for new programming environments in order to improve scientific productivity, to facilitate the design and implementation, and to optimize large production codes.


## How it works

NabLab is based on [Eclipse Modeling Framework (EMF)](https://www.eclipse.org/modeling/emf). The NabLab DSL is realized with [Xtext](https://www.eclipse.org/Xtext) that allows to offer a rich textual editor with syntax coloring, code completion, quick fixes... The DSL raises the level of abstraction close to domain scientist concerns and allows them to write multi-physics applications.

The code in the editor has an internal EMF model representation. This representation, close to the language, is transformed into a numerical analysis specific Intermediate Representation (IR) also implemented as an Ecore metamodel. The transformation chain, based on the IR model, allows HPC engineers to introduce software engineering practices and performance optimization before the code generation. Currently NabLab generates multi threaded C++ for various backends: [Kokkos](https://github.com/kokkos), [Open MP](https://www.openmp.org/) and STL based threads. 

Consequently, NabLab provides a way for domain scientists and software engineers to work for the same project onto separate processes.


## Publications

- [Fostering metamodels and grammars within a dedicated environment for HPC: the NabLab environment](https://hal.inria.fr/hal-01910139)
- [Applying Model-Driven Engineering to High-Performance Computing: Experience Report, Lessons Learned, and Remaining Challenges](https://hal.inria.fr/hal-02296030)
- [Monilogging for Executable Domain-Specific Languages](https://hal.inria.fr/hal-03358061)


## Licence and copyright

This program and the accompanying materials are made available under the terms of the [Eclipse Public License v. 2.0](https://www.eclipse.org/legal/epl-v20.html). SPDX-License-Identifier: EPL-2.0. Please refer to the license for details.

<img src="http://www.cea.fr/PublishingImages/cea.jpg" width="20%" height="20%" align="right" />

Written by CEA and Contributors.

(C) Copyright 2022, by CEA. All rights reserved.

All content is the property of the respective authors or their employers.
For more information regarding authorship of content, please consult the
listed source code repository logs.

