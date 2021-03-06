/*** GENERATED FILE - DO NOT OVERWRITE ***/

#ifndef __DEPTHINIT_H_
#define __DEPTHINIT_H_

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
#include "BatiLib.h"

using namespace nablalib::mesh;
using namespace nablalib::utils;
using namespace nablalib::types;
using namespace nablalib::utils::stl;

/******************** Free functions declarations ********************/

namespace depthinitfreefuncs
{
double two();
}

/******************** Module declaration ********************/

class DepthInit
{
public:
	struct Options
	{
		double maxTime;
		int maxIter;
		double deltat;
		BatiLib batiLib;

		void jsonInit(const char* jsonContent);
	};

	DepthInit(CartesianMesh2D* aMesh, Options& aOptions);
	~DepthInit();

	void simulate();
	void initFromFile() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbCells, nbNodes;

	// User options
	Options& options;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;

public:
	// Global variables
	static constexpr double t = 0.0;
	std::vector<RealArray1D<2>> X;
	std::vector<double> eta;
};

#endif
