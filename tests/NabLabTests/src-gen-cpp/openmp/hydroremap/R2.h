/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __R2_H_
#define __R2_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <omp.h>
#include "nablalib/utils/Utils.h"
#include "nablalib/utils/Timer.h"
#include "nablalib/types/Types.h"
#include "CartesianMesh2D.h"
#include "Hydro.h"

using namespace nablalib::utils;
using namespace nablalib::types;

/******************** Module declaration ********************/

class R2
{
	friend class Hydro;
	friend class R1;
public:
	R2(CartesianMesh2D& aMesh);
	~R2();

	void jsonInit(const char* jsonContent);

	inline void setMainModule(Hydro* value)
	{
		mainModule = value,
		mainModule->r2 = this;
	}

	void simulate();
	void rj1() noexcept;
	void rj2() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D& mesh;
	size_t nbNodes, nbCells;

	// Main module
	Hydro* mainModule;

	// Option and global variables
	std::vector<double> rv2;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;
};

#endif
