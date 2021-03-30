## Presentation of the problem

The aim of this tutorial is to implement a simple equation of diffusion in NabLab:

$$
\begin{equation}
\begin{cases}
\partial_t u - div(K \nabla u) &= f \text{ in } \Omega \\
(K \nabla u)n &= g \text{ on } \partial \Omega
\end{cases}
\end{equation}
$$

In this tutorial the equation is discretized with a finite volume scheme on a 2D cartesian mesh.
A constant approximation of u by cell gives:

$$
\begin{equation}
\begin{aligned}
\frac{u_M^{n+1} - u_M^n}{\Delta t} &= f_M + \frac{1}{V_M}\int_{M}{div(K \nabla u^n)} \\
&= f_M + \frac{1}{V_M}\int_{\partial M}{div(K \nabla u^n)} \nu \\
&= f_M + \frac{1}{V_M}\sum_{M' \text{neighbor of } M}{K_{MM'} \frac{u_{M'}^n - u_{M}^n}{MM'}}
\end{aligned}
\end{equation}
$$

with

$$
\begin{equation}
K_{MM'} = K \text{ on } M \cap  M'
\end{equation}
$$

Consequently
 
$$
\begin{equation}
\begin{aligned}
u_M^{n+1} &= \Delta t f_M + 1 + \frac{\Delta t}{V_M} + \sum_{M' \text{ neighbor of } M}{\frac{K_{MM'}}{MM'}} . u_M^n \\
&- \frac{\Delta t}{V_M} \sum_{M' \text{ neighbor of } M}{\frac{K_{MM'} u_{M'}^n}{MM'}}
\end{aligned}
\end{equation}
$$


## Creating the project

Just click on the main menu *File > New > NabLab Project* to create a new project: 

<img src="/images/tuto/NabLab_new_menu.png" alt="NabLab New Project" title="NabLab New Project" width="60%" height="60%" />

A new wizard is launched, asking for a project name and a module name:

<img src="/images/tuto/NabLab_new_project_wizard.png" alt="NabLab New Project Wizard" title="NabLab New Project Wizard" width="50%" height="50%" />

Enter *Tutorial* as project name and *HeatEquation* as module name and click on the *Finish* button to create the new project. The new project is available in the *Model Explorer* on the left of the window. It contains two files (*HeatEquation.n*, and *HeatEquation.ngen*) in the *Tutorial/src/heatequation/* folder:

<img src="/images/tuto/NabLab_new_project_result.png" alt="NabLab New Project Result" title="NabLab New Project Result" width="30%" height="30%" />


**TO BE CONTINUED**

