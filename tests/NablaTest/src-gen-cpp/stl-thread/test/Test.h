/*** GENERATED FILE - DO NOT OVERWRITE ***/

#ifndef TEST_H_
#define TEST_H_

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

using namespace nablalib::mesh;
using namespace nablalib::utils;
using namespace nablalib::types;
using namespace nablalib::utils::stl;

/******************** Module declaration ********************/

class Test
{
public:
	struct Options
	{
		double maxTime;
		int maxIter;
		double deltat;

		void jsonInit(const char* jsonContent);
	};

	Test(CartesianMesh2D* aMesh, Options& aOptions);
	~Test();

	void simulate();
	void computeE1() noexcept;
	void computeE2() noexcept;
	void initE() noexcept;
	void initTime() noexcept;
	void updateT() noexcept;
	void initE2() noexcept;
	void setUpTimeLoopN() noexcept;
	void executeTimeLoopN() noexcept;
	void setUpTimeLoopK() noexcept;
	void executeTimeLoopK() noexcept;
	void tearDownTimeLoopK() noexcept;
	void updateE() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbNodes, nbCells;

	// User options
	Options& options;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;

public:
	// Global variables
	int n;
	int k;
	double t_n;
	double t_nplus1;
	double t_n0;
	std::vector<RealArray1D<2>> X;
	std::vector<double> e1;
	std::vector<double> e2_n;
	std::vector<double> e2_nplus1;
	std::vector<double> e2_nplus1_k;
	std::vector<double> e2_nplus1_kplus1;
	std::vector<double> e2_nplus1_k0;
	std::vector<double> e_n;
	std::vector<double> e_nplus1;
	std::vector<double> e_n0;
};

#endif
