/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __HYDRO_H_
#define __HYDRO_H_

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

using namespace nablalib::utils;
using namespace nablalib::types;

class R1;
class R2;

/******************** Module declaration ********************/

class Hydro
{
	friend class R1;
	friend class R2;
public:
	Hydro(CartesianMesh2D& aMesh);
	~Hydro();

	void jsonInit(const char* jsonContent);

	void simulate();
	void hj1() noexcept;
	void hj2() noexcept;
	void hj3() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D& mesh;
	size_t nbNodes, nbCells;

	// Additional modules
	R1* r1;
	R2* r2;

	// Option and global variables
	double maxTime;
	int maxIter;
	double deltat;
	static constexpr double t = 0.0;
	std::vector<RealArray1D<2>> X;
	std::vector<double> hv1;
	std::vector<double> hv2;
	std::vector<double> hv3;
	std::vector<double> hv4;
	std::vector<double> hv5;
	std::vector<double> hv6;
	std::vector<double> hv7;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;
};

#endif
