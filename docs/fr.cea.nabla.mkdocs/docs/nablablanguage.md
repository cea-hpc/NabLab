# NabLab language

## Module and extensions

A NabLab file, extension `n`, defines a `module` or an `extension`.

### Module

```
module Glace2d;
```

A `module` represents a NabLab program and its definition strictly follows the following sequence:

- Imports
- Reductions
- Functions
- Variables
- Time iterators
- Jobs

A module is generally associated with a [NabLab application](../ngenlanguage). Several modules can also be composed into a single application: see [module composition](../modulecomposition) documentation.

### Extension

```
extension Math;
```

An `extension` is a way to extend the language with external functions.

Its definition strictly follows the following sequence:

- Imports
- Reductions
- Functions

Functions of an extension can be called from a NabLab module.
To use an extension X, a module has to import the extension with the instruction `with X.*;` (see below).

Extensions provide external functions, i.e. functions with no NabLab body. 
Those functions are implemented in an another language, generally C or C++. 
To link NabLab function declaration to its native definition, providers have to be defined: see [NabLab extension providers](../ngenlanguage#provider) for details.

The extension and extension provider mechanisms are the way to call legacy libraries from NabLab applications.

!!! note
	NabLab library provides a [mathematical extension](https://github.com/cea-hpc/NabLab/blob/master/plugins/fr.cea.nabla/nablalib/Math.n) containing the sum(∑), prod(∏), Min and Max reductions and the usual mathematical functions (sin, cos, √...).

#### Linear algebra extension

```
linearalgebra extension LinearAlgebra;
```

A linear algebra extension is an extension with no reductions, only functions.
Moreover, functions' arguments of type real[x] and real[x, x] will be respectively interpreted as vector and matrix.

!!! note
	NabLab library provides a [linear algebra extension](https://github.com/cea-hpc/NabLab/blob/master/plugins/fr.cea.nabla/nablalib/LinearAlgebra.n) containing some *Ax=B* functions to solve linear systems.

#### Mesh extension

```
mesh extension CartesianMesh2D;
```

This kind of extension defines the interface of a mesh library.

Its definition strictly follows the following sequence:

- Item types
- Connectivities

The syntax of item types and connectivities is described below.

!!! note
	NabLab library provides a [mesh extension](https://github.com/cea-hpc/NabLab/blob/master/plugins/fr.cea.nabla/nablalib/CartesianMesh2D.n) containing the signature of a 2D cartesian mesh used by NabLab examples.

## Imports

The `with` keyword allows to import NabLab extensions, libraries of reductions and functions external to the module.

NabLab provides two native extensions: [Math](https://github.com/cea-hpc/NabLab/blob/master/plugins/fr.cea.nabla/nablalib/Math.n) and [Linear Algebra](https://github.com/cea-hpc/NabLab/blob/master/plugins/fr.cea.nabla/nablalib/LinearAlgebra.n) (follow the link to see the available functions and reductions).

To use them in your own module, just create an import section as follow:

```
module ImplicitHeatEquation;

with Math.*;
with LinearAlgebra.*;
```

## Item types and connectivities

Items are elements of a set, typically mesh elements. The various types of items are defined in a set.

```
itemtypes { node, cell, face }
```

!!! note
	Sets are surrounded by curly brackets and separated by a comma.

A connectivity declaration id defined by a name, its inputs items and an output item or a set of output items.

```
connectivity {node} nodes();                 // mesh nodes
connectivity {cell} cells();                 // mesh cells
connectivity {face} faces();                 // mesh faces
connectivity {cell} neighbourCells(cell);    // neighbor cells of a cell
connectivity {node} nodesOfFace(face);       // nodes of a face
connectivity {node} nodesOfCell(cell);       // nodes of a cell
connectivity face commonFace(cell , cell);   // common face of two cells
```

NabLab provides Java and C++ mesh libraries. They implement the above connectivities. You can also use yous own library. A documentation will be available shortly. 


## Reductions and functions

### Reductions

Reductions are defined by their name, neutral element (seed of the reduction) and type corresponding to the type of their arguments and also their return type. They can be overloaded: it is possible to create multiple reductions with same name and different type.

```
red real prod(1.0) (a, b) : return a * b;
red <x> real[x] prod(1.0) (a, b) : return a * b;
```

### Functions

Functions are defined by their name, input arguments, return type and body. They can be overloaded: it is possible to create multiple functions with same name and different input arguments. Function's body is a unique instruction or a block of instructions. It cannot refer to global variables. That is the reason why functions are declared before variables.

```
def int one() : return 1;         // function with no in arg

def int inc(int a) : return a+1;       // overloaded function inc on int
def real inc(real a) : return a+1.0;  // overloaded function inc on real

def <x> real dot(real[x] a, real[x] b)
{
	let real result = 0.0;
	forall i in [0;x[,
		result = result + a[i]*b[i];
	return result;
}
```

In an extension, functions can be external, without body definition. In this case the definition of an [extension provider](../ngenlanguage) allows to call a native function (C, C++...). This mechanism allows to use legacy libraries, like linear algebra libraries.

!!! note
	External functions, i.e. functions with no body, are not allowed in modules, only in extensions.


## Global variables

Global variables are defined by their type, name and eventually one or several supports representing the connectivity on which the variable lives.

!!! note
	UTF-8 characters for variable names are not supported (for example δt, rho...).

The type of the variable is one of the 3 NabLab base types: boolean, integer or real. It can be scalar or array. Arrays are defined by giving a comma separated list of sizes between brackets.

!!! note
	NabLab text editor offers a contextual code completion.

```
bool is_ok;                            // boolean
int i, j;                              // integers
real t, δt;                            // reals
real[2] x;                             // 1 dimension real array
real[2, 2] xx;                         // 2 dimensions real array
real[2] X{nodes};                      // array of 2 reals on each node
real[2, 2] Ajr{cells, nodesOfCell};    // 2x2 matrix on each node of each cell
```

Multiple variables can be declared in the same instruction into a comma separated list.

```
real t, delta_t;
real c{cells}, m{cells}, p{cells};
```

A variable initialized with a default value is preceded by the `let` keyword. It is not possible to assign several variables in one definition.
A variable with no default value and not set in the module is considered as a user's option: its value has to be set by the final user in a [Json](https://www.json.org) data file.

```
let real gamma = 3.0;                  // real scalar
let real[2] N = [0.0, 1.0];            // 1 dimension real array
let real[2, 2] N = [ [0.0, 1.0], N ];  // 2 dimensions real array
let int[2,2] I = [ [1, 0], [0, 1] ];   // 2 dimensions int array
```

## Time iterators

The `iterate` section is used to define time iterators and the stop conditions of their time loop.

```
// definition of time iterator n
iterate n while (residual > epsilon);
```

Variables can be referenced with defined iterators. In the above example defining a `n` time iterator, a variable can be referenced at `n=0`, `n` and `n+1`. A variable named `t` can be referenced like this: `t^{n=0}`, `t^{n}` and `t^{n+1}`.

!!! note
	For the moment, only the `+1` increment of the iterator is allowed.

It is possible to define several time iterators into a comma separated list: the iterator of index *k+1* is then nested into the iterator of index *k*.

```
// definition of time iterators n and k.
iterate n while (t^{n+1} < stopTime && n+1 < maxIterations),
        k while (residual > epsilon && check(k+1 < maxIterationsK));

```

In case of several iterators, variables can be referenced by a list of defined time iterators, respecting the order of inclusion.
In the above example defining n and k inside n, a variable can be referenced by `n=0`, `n`, `n+1`, `n+1, k=0`, `n+1, n`, and `n+1, k+1`. Variable named `t` can be referenced like this: `t^{n=0}`, `t^{n}`, `t^{n+1}`, `t^{n+1, k=0}`, `t^{n+1, k}`, `t^{n+1, k+1}`.

It is also possible to define a block of inner iterators to define several loops included in a main time loop.

```
iterate n while (t^{n+1} < maxTime && n+1 < maxIter), { 
	k while (k+1 < maxIterK);
	l while (l+1 < maxIterL);
}
```

In the above example defining n, k inside n and l inside n, a variable can be referenced by `n=0`, `n`, `n+1` and either `n+1, k=0`, `n+1, n`, `n+1, k+1` or `n+1, l=0`, `n+1, l`, `n+1, l+1`. A variable named `t` can be referenced like this: `t^{n=0}`, `t^{n}`, `t^{n+1}` and either `t^{n+1, k=0}`, `t^{n+1, k}`, `t^{n+1, k+1}` or `t^{n+1, l=0}`, `t^{n+1, l}`, `t^{n+1, l+1}`.

!!! note
	For a time iterator `n`, if a variable is initialized at `n=0`, NabLab automatically initializes `n` with `n=0` value of the variable at the beginning of the time loop and with `n+1` value during loop iterations.



## Jobs

Jobs are identified by a name, starting with an upper case. They are composed of an instruction, or a block of instructions.

```
Ini: j = 0;
IniTime: t^{n=0} = 0.0;
ComputeDensity: forall j in cells(), rho{j} = m{j} / V{j};
```

The execution of a NabLab program does not start at its beginning and jobs execution order does not correspond to their position in the file. During the compilation phase, the data flow graph of the program is computed according to input and output variables of each job. Jobs are annotated with an *at* statement corresponding to its hierarchical logical time (HLT). The *HLT* concept is explicitly expressed to go beyond the classical single-program-multiple-data or bulk-synchronous-parallel programming models. The *at* logical timestamp explicitly declares the task-based parallelism of jobs.

However, this way to schedule jobs imposes to have a dedicated tool to visualize the graph representing the program execution. This feature has been developed and integrated into the NabLab environment (see [getting started](../gettingstarted) documentation  for details).

## Instructions

The main instructions of the language are: local variable and set definitions, affectations, blocks, loops, conditionals.
An instruction ends with the `;` character except blocks surrounded by curly brackets.

### Local variables and set definitions

Local variables can be defined with the same syntax than global ones but local definitions include no variables with supports.

Set of items can be defined locally by calling a connectivity, like this:
```
set my_cells = cells();
```

### Affectations

An affectation is composed of a variable reference, the `=` character and an expression.

```
rho_ic = rhoIniZg;
t^{n=0} = 0.0;
N = [0.0, 1.0];
Cjr_ic{j,r} = 0.5 * perp(X^{n=0}{r+1} - X^{n=0}{r-1});
```

### Blocks

A block is a list of instructions. It follows the [Composite Design Pattern](https://en.wikipedia.org/wiki/Composite_pattern): The block is an instruction and contains itself a list of instructions. The block is surrounded with curly brackets.

```
{
	rho_ic = rhoIniZd;
	p_ic = pIniZd;
}
```

### Loops

NabLab provides two instructions for loops: `while` and `forall`.

The `while` is composed of a condition, which is an expression, and an instruction that can be a block.

```
while (t^{n} < 5.0) x = 0;
while (residual > epsilon) {
	alpha = 1.0 / det(a);
	I = [ [1.0, 0.0], [0.0, 1.0] ];
}
```

The `forall` loop provides two kinds of iteration blocks: interval and space iterators.

Interval are going from 0 to n-1 with n an integer result of an expression.

```
forall i in [0;5[, x = 0;
forall i in [0;x+4[, {
	beta = i * a;
	A = [i, 0];
}
```

Space iterators allows to loop on connectivity sets. 

```
// loop on cells
forall j in cells(),
	rho{j} = m{j} / V{j};

// loop on topNodes
forall r in topNodes(), {
	let real[2] N = [0.0, 1.0];
	let real[2,2] NxN = tensProduct(N,N);
	let real[2,2] IcP = I - NxN;
	bt{r} = matVectProduct(IcP, b{r});
}

// loop on cells with a reduction on nodesOfCell
forall j in cells(),
	V{j} = 0.5 * sum{r in nodesOfCell(j)}(dot(C{j,r}, X^{n}{r}));

// loop on cells and inner loop on nodesOfCell
forall j in cells(), forall r in nodesOfCell(j),
	Ajr{j,r} = ((rho{j} * c{j}) / l{j,r}) * tensProduct(C{j,r}, C{j,r});
```

It is possible to define a loop iterator counter viewed as an integer local variable.
```
forall j, ij  in cells(),
	rho{j} = V{j} * ij;
```

### Conditionals

Conditionals are defined with the classical `if`, `else` sequence. The condition in the `if` instruction is an expression, like for the `while` instruction. The `else` clause is optional.

```
if (center[0] < xInterface) {
	rho_ic = rhoIniZg;
	p_ic = pIniZg;
} else {
	rho_ic = rhoIniZd;
	p_ic = pIniZd;
}
```


## Expressions

Expressions are composed of the following elements:

- Unary operators minus `-` and not `!`
- Binary operators add `+`, substract `-`, multiply `*`, divide `/` and modulo `%`
- Comparison operators greater than `>`, greater than or equal `>=`, less than `<`, less than or equal `<=`, equal `==`, not equal `!=`
- Boolean operators and `&&` and or `||`
- Contracted if operator `(condition) ? true : false`
- Min and max constants for integer and real base types: `int.MinValue`, `int.MaxValue`, `real.MinValue`, `real.MaxValue`
- Array initializations by comma separated list of expressions between brackets, for example `[1, 2+3, -5]` for `int[3]`, `[ [1.1, 1.2], [2.1, 2.2], [3.1, 3.2] ]` for `real[3,2]`
- Argument/variable references and reduction/function calls detailed below.

### Arguments and variable references

Function arguments and variables are referenced by their name that can be followed by:

- A list of time iterators surrounded by the `^{ }` and separated by a comma: `t^{n+1}`, `t^{n+1, k}`
- For variables with a support, a list of space iterators surrounded by the `{ }` and separated by a comma: `P{j}`, `Ajr{j, r}`. Iterators are defined by loops and reductions. Iterators can have an increment, like `X{r+1}` or `X{r-1}`, to access the item before or after the original iterator in the set where it is defined.
- For arrays, a list of indices surrounded by `[ ]` and separated by a comma: `X[0]`, `Y[i, 0]`. Indices are expressions.


### Reduction and function calls

A reduction call includes an iteration on a set or interval, like for a space iterator loop, and an expression of the type of the reduction. For example, to compute the sum of a real variable P defined on cells, the call includes the cells set iterator and the variable reference `P{j}`:
```
let real sum = sum{j in cells()}(P{j});
```

A function call is defined by the name of the function and the right number and type of input arguments as expressions:
```
let real my_cos = cos(3.14 + 3.14);
```

