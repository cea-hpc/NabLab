#ifndef DEPTHINIT_H_
#define DEPTHINIT_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include "mesh/CartesianMesh2DFactory.h"
#include "mesh/CartesianMesh2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "depthinit/DepthInitFunctions.h"
#include "utils/stl/Parallel.h"

using namespace nablalib;

/******************** Free functions declarations ********************/


/******************** Module declaration ********************/

class DepthInit
{
public:
	struct Options
	{
		double maxTime;
		int maxIter;
		double deltat;
		DepthInitFunctions depthInitFunctions;

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
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

public:
	// Global variables
	static constexpr double t = 0.0;
	std::vector<RealArray1D<2>> X;
	std::vector<double> eta;
};

#endif
