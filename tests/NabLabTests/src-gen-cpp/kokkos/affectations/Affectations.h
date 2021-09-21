/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __AFFECTATIONS_H_
#define __AFFECTATIONS_H_

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

class Affectations
{
public:
	Affectations(CartesianMesh2D& aMesh);
	~Affectations();

	void jsonInit(const char* jsonContent);

	void simulate();
	KOKKOS_INLINE_FUNCTION
	void computeE1() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeE2() noexcept;
	KOKKOS_INLINE_FUNCTION
	void initE() noexcept;
	KOKKOS_INLINE_FUNCTION
	void initTandU() noexcept;
	KOKKOS_INLINE_FUNCTION
	void updateT() noexcept;
	KOKKOS_INLINE_FUNCTION
	void updateU() noexcept;
	KOKKOS_INLINE_FUNCTION
	void initE2() noexcept;
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopN() noexcept;
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept;
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopK() noexcept;
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopK() noexcept;
	KOKKOS_INLINE_FUNCTION
	void tearDownTimeLoopK() noexcept;
	KOKKOS_INLINE_FUNCTION
	void updateE() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D& mesh;
	size_t nbNodes, nbCells;

	// Option and global variables
	int n;
	int k;
	static constexpr double maxTime = 0.1;
	static constexpr int maxIter = 500;
	static constexpr double deltat = 1.0;
	double t_n;
	double t_nplus1;
	double t_n0;
	RealArray1D<2> u_n;
	RealArray1D<2> u_nplus1;
	RealArray1D<2> u_n0;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> e1;
	Kokkos::View<RealArray1D<2>*> e2_n;
	Kokkos::View<RealArray1D<2>*> e2_nplus1;
	Kokkos::View<RealArray1D<2>*> e2_nplus1_k;
	Kokkos::View<RealArray1D<2>*> e2_nplus1_kplus1;
	Kokkos::View<RealArray1D<2>*> e2_nplus1_k0;
	Kokkos::View<RealArray1D<2>*> e_n;
	Kokkos::View<RealArray1D<2>*> e_nplus1;
	Kokkos::View<RealArray1D<2>*> e_n0;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;
};

#endif