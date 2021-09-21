/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __ITERATION_H_
#define __ITERATION_H_

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

class Iteration
{
public:
	Iteration(CartesianMesh2D& aMesh);
	~Iteration();

	void jsonInit(const char* jsonContent);

	void simulate();
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniTime() noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniU() noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniV() noexcept;
	KOKKOS_INLINE_FUNCTION
	void updateV() noexcept;
	KOKKOS_INLINE_FUNCTION
	void updateW() noexcept;
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopK() noexcept;
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopN() noexcept;
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopK() noexcept;
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept;
	KOKKOS_INLINE_FUNCTION
	void tearDownTimeLoopK() noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniW() noexcept;
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopL() noexcept;
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopL() noexcept;
	KOKKOS_INLINE_FUNCTION
	void tearDownTimeLoopL() noexcept;
	KOKKOS_INLINE_FUNCTION
	void updateU() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D& mesh;
	size_t nbNodes, nbCells;

	// Option and global variables
	int n;
	int k;
	int l;
	static constexpr double maxTime = 0.1;
	static constexpr int maxIter = 500;
	static constexpr int maxIterK = 500;
	static constexpr int maxIterL = 500;
	static constexpr double deltat = 1.0;
	double t_n;
	double t_nplus1;
	double t_n0;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<double*> u_n;
	Kokkos::View<double*> u_nplus1;
	Kokkos::View<double*> v_n;
	Kokkos::View<double*> v_nplus1;
	Kokkos::View<double*> v_nplus1_k;
	Kokkos::View<double*> v_nplus1_kplus1;
	Kokkos::View<double*> v_nplus1_k0;
	Kokkos::View<double*> w_n;
	Kokkos::View<double*> w_nplus1;
	Kokkos::View<double*> w_nplus1_l;
	Kokkos::View<double*> w_nplus1_lplus1;
	Kokkos::View<double*> w_nplus1_l0;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;
};

#endif