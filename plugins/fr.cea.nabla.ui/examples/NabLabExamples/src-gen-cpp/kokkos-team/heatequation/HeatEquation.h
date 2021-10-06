/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __HEATEQUATION_H_
#define __HEATEQUATION_H_

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
#include "PvdFileWriter2D.h"

using namespace nablalib::utils;
using namespace nablalib::types;
using namespace nablalib::utils::kokkos;

/******************** Free functions declarations ********************/

namespace heatequationfreefuncs
{
KOKKOS_INLINE_FUNCTION
double det(RealArray1D<2> a, RealArray1D<2> b);
template<size_t x>
KOKKOS_INLINE_FUNCTION
double norm(RealArray1D<x> a);
template<size_t x>
KOKKOS_INLINE_FUNCTION
double dot(RealArray1D<x> a, RealArray1D<x> b);
template<size_t x>
KOKKOS_INLINE_FUNCTION
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);
KOKKOS_INLINE_FUNCTION
double sumR0(double a, double b);
}

/******************** Module declaration ********************/

class HeatEquation
{
	typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

public:
	HeatEquation(CartesianMesh2D& aMesh);
	~HeatEquation();

	void jsonInit(const char* jsonContent);

	void simulate();
	KOKKOS_INLINE_FUNCTION
	void computeOutgoingFlux(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeSurface(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeV(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniCenter(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniF(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniTime() noexcept;
	KOKKOS_INLINE_FUNCTION
	void init_PI() noexcept;
	KOKKOS_INLINE_FUNCTION
	void init_alpha() noexcept;
	KOKKOS_INLINE_FUNCTION
	void init_lastDump() noexcept;
	KOKKOS_INLINE_FUNCTION
	void init_maxIterations() noexcept;
	KOKKOS_INLINE_FUNCTION
	void init_outputPeriod() noexcept;
	KOKKOS_INLINE_FUNCTION
	void init_stopTime() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeUn(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniUn(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopN() noexcept;
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept;

private:
	void dumpVariables(int iteration, bool useTimer=true);

	/**
	 * Utility function to get work load for each team of threads
	 * In  : thread and number of element to use for computation
	 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
	 */
	const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept;

	// Json block of options
	rapidjson::Document jsonDocument;

	// Mesh and mesh variables
	CartesianMesh2D& mesh;
	size_t nbNodes, nbCells, nbFaces, maxNodesOfCell, maxNodesOfFace, maxNeighbourCells;

	// Options and global variables
	PvdFileWriter2D* writer;
	std::string outputPath;
	int outputPeriod;
	int lastDump;
	int n;
	double stopTime;
	int maxIterations;
	double PI;
	double alpha;
	static constexpr double deltat = 0.001;
	double t_n;
	double t_nplus1;
	double t_n0;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> center;
	Kokkos::View<double*> u_n;
	Kokkos::View<double*> u_nplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> f;
	Kokkos::View<double*> outgoingFlux;
	Kokkos::View<double*> surface;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;
};

#endif
