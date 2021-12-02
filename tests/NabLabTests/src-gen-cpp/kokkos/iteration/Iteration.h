/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __ITERATION_H_
#define __ITERATION_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <rapidjson/document.h>
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

/******************** Free functions declarations ********************/

namespace iterationfreefuncs
{
bool assertEquals(double expected, double actual);
}

/******************** Module declaration ********************/

class Iteration
{
public:
	Iteration(CartesianMesh2D& aMesh);
	~Iteration();

	void jsonInit(const char* jsonContent);

	void simulate();
	void computeTn() noexcept;
	void iniTime() noexcept;
	void iniVk() noexcept;
	void iniVn() noexcept;
	void setUpTimeLoopK() noexcept;
	void updateVk() noexcept;
	void updateVl() noexcept;
	void executeTimeLoopK() noexcept;
	void setUpTimeLoopN() noexcept;
	void executeTimeLoopN() noexcept;
	void tearDownTimeLoopK() noexcept;
	void iniVl() noexcept;
	void oracleVk() noexcept;
	void setUpTimeLoopL() noexcept;
	void executeTimeLoopL() noexcept;
	void tearDownTimeLoopL() noexcept;
	void oracleVl() noexcept;
	void updateVn() noexcept;
	void oracleVn() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D& mesh;
	size_t nbNodes, nbCells;

	// Options and global variables
	int n;
	int k;
	int l;
	static constexpr double maxTime = 0.1;
	static constexpr double deltat = 1.0;
	double t_n;
	double t_nplus1;
	double t_n0;
	Kokkos::View<RealArray1D<2>*> X;
	static constexpr int maxIterN = 10;
	static constexpr int maxIterK = 6;
	static constexpr int maxIterL = 7;
	Kokkos::View<double*> vn_n;
	Kokkos::View<double*> vn_nplus1;
	Kokkos::View<double*> vn_n0;
	Kokkos::View<double*> vk_n;
	Kokkos::View<double*> vk_nplus1;
	Kokkos::View<double*> vk_nplus1_k;
	Kokkos::View<double*> vk_nplus1_kplus1;
	Kokkos::View<double*> vk_nplus1_k0;
	Kokkos::View<double*> vl_n;
	Kokkos::View<double*> vl_nplus1;
	Kokkos::View<double*> vl_nplus1_l;
	Kokkos::View<double*> vl_nplus1_lplus1;
	Kokkos::View<double*> vl_nplus1_l0;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;
};

#endif
