[![License](https://img.shields.io/badge/license-EPL%202.0-blue.svg)](http://www.eclipse.org/legal/epl-2.0)
[![Language](http://img.shields.io/badge/language-java-brightgreen.svg)](https://www.java.com/)

<img src="./README_images/logo_full.png" width="70%" height="70%"/>

NabLab is a full-fledged industrial environment for scientific computing and High Performance Computing based on [Eclipse](https://www.eclipse.org/).

The NabLab documentation is available [here](https://cea-hpc.github.io/NabLab/).

The latest NabLab environment can be downloaded [here](https://github.com/cea-hpc/NabLab/releases/tag/v0.6.0).

# Dependencies

NabLab requires Java 11 or later to build & run.
The NabLab VSCode extension requires Java 11, Node.js 16 and VSCode 1.50 or later to build & run.

It as based on:

Eclipse 2021-09 for Java and DSL Developers

- License: EPL-2.0
- Project: https://www.eclipse.org/downloads/packages/release/2021-09/r/eclipse-ide-java-and-dsl-developers

Xtext (2.26.0)

- License: EPL-2.0
- Project: http://projects.eclipse.org/projects/modeling.tmf.xtext
- Source: https://github.com/eclipse/xtext

Sirius (6.5.1)

- License: EPL-2.0
- Project: http://projects.eclipse.org/projects/modeling.sirius
- Source: https://git.eclipse.org/c/sirius/org.eclipse.sirius.git

JGraphT (1.3.0)

- License: LGPL-2.1, EPL-2.0
- Project: http://jgrapht.org
- Source: https://github.com/jgrapht/jgrapht

JLatexMath (1.0.7)

- License: GPL-2.0
- Project: http://www.scilab.org/projects/thirdparty_project/jlatexmath
- Source: https://github.com/opencollab/jlatexmath

Commons-Math3 (3.6.1)

- License: Apache v2
- Project: https://commons.apache.org/proper/commons-math/
- Source: https://github.com/apache/commons-math

# Guidelines for NabLab contributors

## Installing Eclipse

- Download and install [Eclipse 2021-09](https://www.eclipse.org/downloads/packages/release/2021-09/r/eclipse-ide-java-and-dsl-developers)
- Install Zest: Help>Install New Software..., Work with http://download.eclipse.org/releases/2021-09, select Modeling>Zest SDK and install
- Install Sirius via the MarketPlace: Help>Eclipse Marketplace... and Find Sirius 6.5.1. Do not forget to select _Sirius Integration With Xtext_ and _Sirius ELK Integration_. In case of message, choose proceed anyway
- Install Hamcrest 2.2.0 and AssertJ fluent assertions 3.20.2 : Help>Install New Software..., Work with https://download.eclipse.org/tools/orbit/downloads/drops/R20210825222808/repository
  NotaBene : update sites to install all the necessary librairies for NabLab contributors can be found in nablab.tpd.

Then clone NabLab from GitHub and import existing projects located in plugins, tests, releng and docs directories.

It is recommended to install a Markdown editor thanks to Eclipse Marketplace to contribute to the documentation.

It is also recommended to install a Json editor thanks to Eclipse Marketplace to visualize/modify user data files.

The launch of a runtime Eclipse displays a warning of unsatisfied dependency on `javax.xml.bind`. To suppress it: Help>Install New Software..., Work with https://download.eclipse.org/tools/orbit/downloads/drops/R20210825222808/repository and select _Java XML Streaming API_ in Orbit.Bundles By Name:javax.\*.

To first build NabLab from source

- open fr.cea.nabla.ir/model/Ir.genmodel and Generate Model Code by right click on NablaIR
- right click on fr.cea.nabla/src/fr.cea.nabla/GenerateNabla.mwe2 and choose Run As > MWE2 Workflow

## Commit messages rules

The title of the message can contain one of our standard keywords such as cleanup, doc, fix, releng, test, perf or dev in the following fashion:
[doc] Title or even [cleanup] title.

Those keywords should only be used in very specific situations, most of the time the title of a commit message should have a reference to a bug. On top of that the full bug URL should be available later in the commit message. [XXX] Title.

The commit must always be signed-off.

# Licence and copyright

This program and the accompanying materials are made available under the terms of the [Eclipse Public License v. 2.0](https://www.eclipse.org/legal/epl-v20.html). SPDX-License-Identifier: EPL-2.0. Please refer to the license for details.

<img src="http://www.cea.fr/PublishingImages/cea.jpg" width="20%" height="20%" align="right" />

Written by CEA and Contributors.

(C) Copyright 2022, by CEA. All rights reserved.

All content is the property of the respective authors or their employers.
For more information regarding authorship of content, please consult the
listed source code repository logs.

