
# NabLab

<img src="https://github.com/cea-hpc/NabLab/edit/master/docs/logo_512.png" width="20%" height="20%" align="right" /> 

NabLab is a open-source research project led by [HPC initiative of the CEA](http://www-hpc.cea.fr/index-en.htm). Its aim is to realize a modeling environment for the [Nabla language](http://nabla-lang.org/index.html) to provide a productive development way for exascale HPC technologies, flexible enough to be competitive in terms of performances.

It is composed of:
- an evolution of the Domain Specific Language (DSL) Nabla to improve applied mathematicians productivity throughput and enables new algorithmic developments for the construction of hierarchical and composable high-performance scientific applications. 
- an full-fledged environment to edit, interpret and debug Nabla programs and to generate optimized code for various libraries.

# Motivation

Addressing the major challenges of software productivity and performance portability is becoming necessary to take advantage of emerging extreme-scale computing architectures. As software development costs will continuously increase to address exascale hardware issues, higher-level programming abstraction will facilitate the path to go. There is a growing demand for new programming environments in order to improve scientific productivity, to facilitate the design and implementation, and to optimize large production codes. 

# Publications

- [Fostering metamodels and grammars within a dedicated environment for HPC: the NabLab environment](https://hal.inria.fr/hal-01910139)
- [Applying Model-Driven Engineering to High-Performance Computing: Experience Report, Lessons Learned, and Remaining Challenges ](https://hal.inria.fr/hal-02296030)

# How it works

NabLab is based on [Eclipse Modeling Framework (EMF)](https://www.eclipse.org/modeling/emf). The Nabla DSL is realized with [Xtext](https://www.eclipse.org/Xtext) that allows to offer a rich textual editor with syntax coloring, code completion, quick fixes... The code in the editor has an internal EMF model representation. This representation, close to the language, is transformed into a numerical analysis specific Intermediate Representation (IR) also implemented as an Ecore metamodel. The concepts of the IR facilitate the code generation. Currently, multithreaded Java and C++ [Kokkos](https://github.com/kokkos) backends are implemented.


# Licence and copyright

This program and the accompanying materials are made available under the terms of the Eclipse Public License v. 2.0 which is available at https://www.eclipse.org/legal/epl-v20.html.

SPDX-License-Identifier: EPL-2.0

Please refer to the license for details.
