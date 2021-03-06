/*** GENERATED FILE - DO NOT OVERWRITE ***/

#ifndef __R1_H_
#define __R1_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include "nablalib/mesh/CartesianMesh2DFactory.h"
#include "nablalib/mesh/CartesianMesh2D.h"
#include "nablalib/utils/Utils.h"
#include "nablalib/utils/Timer.h"
#include "nablalib/types/Types.h"
#include "nablalib/utils/stl/Parallel.h"
#include "H.h"

using namespace nablalib::mesh;
using namespace nablalib::utils;
using namespace nablalib::types;
using namespace nablalib::utils::stl;

/******************** Module declaration ********************/

class R1
{
public:
	struct Options
	{

		void jsonInit(const char* jsonContent);
	};

	R1(CartesianMesh2D* aMesh, Options& aOptions);
	~R1();

	inline void setMainModule(H* value)
	{
		mainModule = value,
		mainModule->setR1(this);
	}

	void simulate();
	void rj1() noexcept;
	void rj2() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbNodes, nbCells;

	// User options
	Options& options;

	// Main module
	H* mainModule;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;

public:
	// Global variables
	std::vector<double> rv3;
};

#endif
