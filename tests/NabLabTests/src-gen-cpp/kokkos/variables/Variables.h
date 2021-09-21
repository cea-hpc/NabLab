/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __VARIABLES_H_
#define __VARIABLES_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <Kokkos_Core.hpp>
#include <Kokkos_hwloc.hpp>
#include "nablalib/utils/Utils.h"
#include "nablalib/utils/Timer.h"
#include "nablalib/types/Types.h"
#include "nablalib/utils/kokkos/Parallel.h"
#include "CartesianMesh2D.h"

using namespace nablalib::utils;
using namespace nablalib::types;
using namespace nablalib::utils::kokkos;

/******************** Module declaration ********************/

class Variables
{
public:
	Variables(CartesianMesh2D& aMesh);
	~Variables();

	void jsonInit(const char* jsonContent);

	void simulate();
	KOKKOS_INLINE_FUNCTION
	void newVar() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D& mesh;
	size_t nbNodes, maxCellsOfNode;

	// Option and global variables
	static constexpr double maxTime = 0.1;
	static constexpr int maxIter = 500;
	static constexpr double deltat = 1.0;
	double t;
	static constexpr int dim = 2;
	RealArray1D<2> v1;
	RealArray1D<dim> v2;
	Kokkos::View<RealArray1D<dim>*> X;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;
};

#endif
