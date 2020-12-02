#ifndef H_H_
#define H_H_

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
#include "utils/stl/Parallel.h"

using namespace nablalib;
class R1;
class R2;

/******************** Module declaration ********************/

class H
{
public:
	struct Options
	{
		double maxTime;
		int maxIter;
		double deltat;

		void jsonInit(const char* jsonContent);
	};

	H(CartesianMesh2D* aMesh, Options& aOptions);
	~H();

	inline void setR1(R1* value) { r1 = value; }
	inline void setR2(R2* value) { r2 = value; }

	void simulate();
	void hj1() noexcept;
	void hj2() noexcept;
	void hj3() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbNodes, nbCells;

	// User options
	Options& options;

	// Additional modules
	R1* r1;
	R2* r2;

	// Timers
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

public:
	// Global variables
	static constexpr double t = 0.0;
	std::vector<RealArray1D<2>> X;
	std::vector<double> hv1;
	std::vector<double> hv2;
	std::vector<double> hv3;
	std::vector<double> hv4;
	std::vector<double> hv5;
	std::vector<double> hv6;
	std::vector<double> hv7;
};

#endif
