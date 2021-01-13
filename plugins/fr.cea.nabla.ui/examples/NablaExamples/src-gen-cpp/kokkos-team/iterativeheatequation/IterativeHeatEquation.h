#ifndef ITERATIVEHEATEQUATION_H_
#define ITERATIVEHEATEQUATION_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <Kokkos_Core.hpp>
#include <Kokkos_hwloc.hpp>
#include "mesh/CartesianMesh2DFactory.h"
#include "mesh/CartesianMesh2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "mesh/kokkos/PvdFileWriter2D.h"
#include "utils/kokkos/Parallel.h"

using namespace nablalib;

/******************** Free functions declarations ********************/

namespace IterativeHeatEquationFuncs
{
KOKKOS_INLINE_FUNCTION
bool check(bool a);
template<size_t x>
KOKKOS_INLINE_FUNCTION
double norm(RealArray1D<x> a);
template<size_t x>
KOKKOS_INLINE_FUNCTION
double dot(RealArray1D<x> a, RealArray1D<x> b);
KOKKOS_INLINE_FUNCTION
double det(RealArray1D<2> a, RealArray1D<2> b);
template<size_t x>
KOKKOS_INLINE_FUNCTION
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);
KOKKOS_INLINE_FUNCTION
double minR0(double a, double b);
KOKKOS_INLINE_FUNCTION
double sumR0(double a, double b);
KOKKOS_INLINE_FUNCTION
double prodR0(double a, double b);
KOKKOS_INLINE_FUNCTION
double maxR0(double a, double b);
}

/******************** Module declaration ********************/

class IterativeHeatEquation
{
	typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

public:
	struct Options
	{
		std::string outputPath;
		int outputPeriod;
		double u0;
		double stopTime;
		int maxIterations;
		int maxIterationsK;
		double epsilon;

		void jsonInit(const char* jsonContent);
	};

	IterativeHeatEquation(CartesianMesh2D* aMesh, Options& aOptions);
	~IterativeHeatEquation();

	void simulate();
	KOKKOS_INLINE_FUNCTION
	void computeFaceLength(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeV(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void initD(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void initTime() noexcept;
	KOKKOS_INLINE_FUNCTION
	void initXc(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopK() noexcept;
	KOKKOS_INLINE_FUNCTION
	void updateU(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeDeltaTn(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeFaceConductivity(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeResidual(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopK() noexcept;
	KOKKOS_INLINE_FUNCTION
	void initU(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopN() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeAlphaCoeff(const member_type& teamMember) noexcept;
	KOKKOS_INLINE_FUNCTION
	void tearDownTimeLoopK() noexcept;
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

	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbNodes, nbCells, nbFaces, nbNeighbourCells, nbNodesOfFace, nbCellsOfFace, nbNodesOfCell;

	// User options
	Options& options;
	PvdFileWriter2D writer;

	// Timers
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

public:
	// Global variables
	int lastDump;
	int n;
	int k;
	static constexpr RealArray1D<2> vectOne = {1.0, 1.0};
	double deltat;
	double t_n;
	double t_nplus1;
	double t_n0;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> Xc;
	Kokkos::View<double*> u_n;
	Kokkos::View<double*> u_nplus1;
	Kokkos::View<double*> u_nplus1_k;
	Kokkos::View<double*> u_nplus1_kplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> D;
	Kokkos::View<double*> faceLength;
	Kokkos::View<double*> faceConductivity;
	Kokkos::View<double**> alpha;
	double residual;
};

#endif
