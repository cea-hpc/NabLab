# Getting started

## Download and install

### Prerequisite

NabLab requires [Java 11](https://openjdk.java.net/projects/jdk/11/) or later to build & run.

Do not forget to set the `JAVA_HOME` variable to the java installation directory and to update your path.

### Installing NabLab

The latest NabLab environment can be downloaded [here](https://github.com/cea-hpc/NabLab/releases/tag/v0.6.0) for Linux, Mac OS and Windows platforms.

Download the file corresponding to your platform, unzip it and launch the NabLab executable in the root directory.

For Mac users, depending on your security configuration, you have to enter the following command to execute NabLab: `xattr -d com.apple.quarantine NabLab.app`.

### Build via Maven 3.x

If you need to build NabLab products (Windows/Linux/MacOS and Eclipse update-site) from the source code (instead of downloading it), run the following command from the root of the repository:

`mvn clean -P build,updatesite; mvn verify -P build,updatesite`.

Note the `';'` after `mvn clean -P build,updatesite`.

The products resulting from the build will be accessible in _/releng/fr.cea.nabla.updatesite/target/products/NabLab-X.Y.Z.yyyymmddHHMM-YOUR_PLATFORM.zip_.

The Eclipse update-site resulting from the build will be accessible in _/releng/fr.cea.nabla.updatesite/target/fr.cea.nabla.updatesite-X.Y.Z.yyyymmddHHMM.zip_.

If you only need to compile NabLab code and execute tests, run the following command from the root of the repository:
`mvn clean; mvn verify`

If you want to skip tests execution, you can run the following command:
`mvn clean; mvn verify -Dmaven.test.skip=true`

### Build VSCode extension

If you need to build NabLab VSCode extension from the source code (instead of downloading it), run the following command from the root of the repository:

`mvn clean -P build,vscode; mvn verify -P build,vscode`.

Note the `';'` after `mvn clean -P build,vscode`.

Then, in _/plugins/fr.cea.nabla.vscode.extension/_, run the [vsce](https://github.com/microsoft/vscode-vsce) tool:
`vsce package --no-yarn`

A resulting VSIX extension will be available in _/plugins/fr.cea.nabla.vscode.extension/cea-nablab-vscode-extension-X.Y.Z.vsix_

## First step in the environment

### Overview

The NabLab environment is based on the [Eclipse Modeling Framework](https://www.eclipse.org/modeling/emf/) (EMF). The central part of the NabLab environment displays a textual editor, based on [Xtext](https://www.eclipse.org/Xtext/) which provides contextual code completion, code folding, syntax highlighting, error detection, quick fixes, variable scoping, and type checking. The left part of the environment proposes a model explorer and a dedicated interactive outline view to navigate easily through the textual editor. The bottom part is composed of several views including a rich LaTeX visualization of the selection in the editor. A graphical editor based on [Sirius](https://www.eclipse.org/sirius/) allows to visualize the data flow graph between jobs.

<img src="img/NabLab_main_window.png" alt="NabLab Main Window" title="NabLab Main Window" width="100%" height="100%" />

### Perspective

Once the NabLab environment has been launched, the NabLab perspective should be selected. If it is not the case, just select the NabLab perspective from the _Window > Perspective > Open Perspective > Other ... > NabLab_ menu.

<img src="img/NabLab_perspective_menu.png" alt="NabLab Perspective Menu" title="NabLab Perspective Menu" width="40%" height="40%" />

The NabLab perspective provides a set of _Views_ and wizards shortcuts allowing to easily create and develop NabLab projects.

### Examples project

Just click on the main menu From the _File > New > NabLab Examples_ to import the examples project:

<img src="img/NabLab_new_examples_menu.png" alt="NabLab Examples" title="NabLab Examples" width="60%" height="60%" />

A new wizard is launched:

<img src="img/NabLab_examples_wizard.png" alt="NabLab Examples Wizard" title="NabLab Examples Wizard" width="80%" height="80%" />

Just click on the _Finish_ button to import the examples project that becomes available in the _Model Explorer_ view on the left of the perspective. It contains a set of examples including Glace2D, HeatEquation, ExplicitHeatEquation, IterativeHeatEquation and ImplicitHeatEquation.

<img src="img/NabLab_examples_generated_files.png" alt="NabLab Examples Generated Files" title="NabLab Examples Generated Files" width="100%" height="100%" />

### Code generation

To launch code generation corresponding to the NabLab module, just right-click on the ngen file of the project of your choice, for example _NabLabExamples/src/explicitheatequation/ExplicitHeatEquation.ngen_ and select _Generate Code_

<img src="img/NabLab_generate_code.png" alt="NabLab Generate Code" title="NabLab Generate Code" width="40%" height="40%" />

Java and C++ source code files are generated in _src-gen-java_ and _src-gen-cpp_ folders respectively. For each C++ folder a _CMakeLists.txt_ file is generated.
A LaTeX file containing the content of the jobs and an example of json data file are also generated in the _src-gen_ folder.

<img src="img/NabLab_generated_files.png" alt="NabLab Generated Files" title="NabLab Generated Files" width="30%" height="30%" />

!!! note
A good practice is to name _src-gen_ a directory containing only generated code.

### Interpretation

To launch code interpretation corresponding to the NabLab module, just right-click on the _ngen_ file of the project of your choice, for example _NabLabExamples/src/explicitheatequation/ExplicitHeatEquation.ngen_ and select _Run As > Start Interpretation_.

<img src="img/NabLab_start_interpretation.png" alt="NabLab Start Interpretation" title="NabLab Start Interpretation" width="50%" height="50%" />

To change the _json_ file of your interpretation, right-click on the _ngen_ file and select _Run As > Run Configurations_, select your configuration, for example _ExplicitHeatEquation.ngen_, and change the _json_ file in the dialog window.

<img src="img/NabLab_interpretation_configuration.png" alt="NabLab Interpretation Configuration" title="NabLab Interpretation Configuration" width="80%" height="80%" />

!!! note
If you have installed and configured GraalVM for NabLab, you can interpret your module using GraalVM: just select _Run As > Start Truffle-Based Interpretation_ instead of _Run As > Start Interpretation_. You can set configuration like previously and set the monilog file and python executable path.

### LaTeX view

The _LaTeX View_ is located on the bottom of the NabLab environment. It allows to visualize in an elegant way the formulas contained in a .n file.

If you do not use the NabLab perspective the _The LaTeX View_ is not visible. You can access it through the _Window > Show View > Other... > NabLab > LaTeX View_ main menu.

This view is automatically updated and synchronized with the selection in the current NabLab editor.

<img src="img/NabLab_latex_view.png" alt="NabLab Latex View" title="NabLab Latex View" width="100%" height="100%" />

!!! note
If you can not see formulas in the LaTeX view, Java probably encounters a ClassNotFoundException on java.awt.Font (see log file) due to font installation issue on your computer.
To fix the problem, add `-Djava.awt.headless=true` at the end of the _NabLab.ini_ file located in NabLab root directory.
For contributors using NabLab as an Eclipse runtime application, add the same option into the Run As > Run Configurations... > Arguments > VM arguments text box.

### Job graph

NabLab offers 2 visualization modes for job graph: a fast rendering view and an editor with a more efficient layout.
In case of job cycles, both of the modes will display the cycle graphically to highlight the error.

!!! note
In both visualization modes, let the mouse over a job node to display its input and output variables.

#### View

The _Job Graph View_ can be opened from a _ngen_ file containing an _Application_, by clicking on F1.

It allows to quickly visualize the data flow graph of the application described in the ngen file.

<img src="img/NabLab_job_graph_view.png" alt="NabLab Job Graph View" title="NabLab Job Graph View" width="100%" height="100%" />

#### Editor

NabLab offers another way of visualizing the data flow graph of an application.

The _Job Graph Editor_ can be opened from a _ngen_ file containing an _Application_, by clicking on F2.

It allows to visualize bigger graphs than the _Job Graph View_ thanks to an efficient layout.

<img src="img/NabLab_job_graph_editor.png" alt="NabLab Job Graph Editor" title="NabLab Job Graph Editor" width="100%" height="100%"/>

## First step in the VSCode extension

### Extension Overview

The NabLab VSCode extension is based on the [VSCode](https://code.visualstudio.com/). The central part of the NabLab VSCode extension displays a textual editor, based on [Xtext](https://www.eclipse.org/Xtext/) and [LSP](https://code.visualstudio.com/api/language-extensions/language-server-extension-guide) which provides contextual code completion, code folding, syntax highlighting, error detection, quick fixes, variable scoping, and type checking. The left part of the environment proposes a model explorer. The bottom part is composed of several views including a rich LaTeX visualization of the selection in the editor. A graphical editor based on [SiriusWeb](https://www.eclipse.org/sirius/sirius-web.html) allows to visualize the data flow graph between jobs.

<img src="img/NabLab_VSCode_main_window.png" alt="NabLab VSCode Main Window" title="NabLab VSCode Main Window" width="100%" height="100%" />

### Code generation in the extension

To launch code generation corresponding to the NabLab module, just right-click on the ngen file of the project of your choice, for example _NabLabExamples/src/explicitheatequation/ExplicitHeatEquation.ngen_ and select _Generate Code_

<img src="img/NabLab_VSCode_generate_code.png" alt="NabLab VSCode Generate Code" title="NabLab VSCode Generate Code" width="40%" height="40%" />

Java and C++ source code files are generated in _src-gen-java_ and _src-gen-cpp_ folders respectively. For each C++ folder a _CMakeLists.txt_ file is generated.
A LaTeX file containing the content of the jobs and an example of json data file are also generated in the _src-gen_ folder.

<img src="img/NabLab_VSCode_generated_files.png" alt="NabLab VSCode Generated Files" title="NabLab VSCode Generated Files" width="30%" height="30%" />

!!! note
A good practice is to name _src-gen_ a directory containing only generated code.

### LaTeX view in the extension

The _LaTeX View_ is located on the bottom of the NabLab environment. It allows to visualize in an elegant way the formulas contained in a .n file.

You can access it through the _View > Command Palette_ main menu, and then select _NabLab: Display Latex View_ in the search box.

This view is automatically updated and synchronized with the selection in the current NabLab editor.

<img src="img/NabLab_VSCode_latex_view.png" alt="NabLab VSCode Latex View" title="NabLab VSCode Latex View" width="100%" height="100%" />

### Job graph in the extension

NabLab offers a visualization mode for job graph with an efficient layout.
In case of job cycles, it will display the cycle graphically to highlight the error.

The _Job Graph View_ can be opened from a _ngen_ file containing an _Application_, by clicking on F2.

It allows to quickly visualize the data flow graph of the application described in the ngen file.

<img src="img/NabLab_VSCode_job_graph_view.png" alt="NabLab VSCode Job Graph View" title="NabLab VSCode Job Graph View" width="100%" height="100%" />
