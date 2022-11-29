# Mapping NabLab --> Arcane

## Time and time step

Arcane manages the simulation time automatically:

- time is incremented automatically at each time loop like this: *tn+1 = tn + deltatn+1*.
- time and time step are reserved variables called *m_global_time* and *m_global_time_step*. Setting those variables will change time/time step of the next loop, i.e. *tn+1*, *deltatn+1*.
- *tn-1* and *deltatn-1* are stored in the *m_old_time* and *m_old_time_step* variables.

In some numerical schemes, the current time step is set while the iteration has started, like in the following pseudo code example:

```
y = 0.0;
tn = 0.0;

do
{
   y = f(x, tn);
   deltat = g(y);
   z = h(y);
   tn+1 = tn + deltat
} while (true); // time loop stop condition

```

In NabLab, the example will be implemented like this:

```
module Example1;

with CartesianMesh2D.*;

def real f(real a, real b) {
	return 0.0;
}

def real g(real a) {
	return 0.0;
}

def real h(real a) {
	return 0.0;
}

real[2] X{nodes};
real t, delta_t;
real x, y, z;

iterate n while (true);

IniX: x = 0.0;
IniT: t^{n=0} = 0.0;

ComputeY: y = f(x, t^{n});
ComputeDeltaT: delta_t = g(y);
ComputeZ: z = h(y);
ComputeT: t^{n+1} = t^{n} + delta_t;
```

The above example will give the following job graph for the initialzation:

<img src="img/NabLab_example1_init.png" alt="Example 1 initialization graph" title="Example 1 initialization graph" width="50%" height="50%" />

The above example will give the following job graph for the time loop:

<img src="img/NabLab_example1_loop.png" alt="Example 1 loop graph" title="Example 1 loop graph" width="50%" height="50%" />

This graph shows that the *ComputeDeltaT* job is executed at each time loop iteration.

In Arcane, setting the *m_global_time_step* variable changes the value of the *deltatn+1* numerical value. Consequently, the pseudo code algorithm presented above must be refactored as follows:

```
x = 0.0;
tn = 0.0;
yn = f(x, tn);
deltatn = g(y);

do
{
   z = h(yn);
   yn+1 = f(x, tn);
   deltatn+1 = g(y+1);
   tn+1 = tn + deltatn+1
} while (true); // time loop stop condition

```

How such configuration can be detected
