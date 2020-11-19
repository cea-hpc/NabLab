#ifndef HEATEQUATION_H_
#define HEATEQUATION_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
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

/******************** Module declaration ********************/

class HeatEquation
{
public:
	struct Options
	{
		std::string outputPath;
		int outputPeriod;
		double stopTime;
		int maxIterations;
		double PI;
		double alpha;

		void jsonInit(const rapidjson::Value& json);
	};

	HeatEquation(CartesianMesh2D* aMesh, Options& aOptions);
	~HeatEquation();

private:
	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbNodes, nbCells, nbFaces, nbNeighbourCells, nbNodesOfFace, nbNodesOfCell;
	
	// User options
	Options& options;
	PvdFileWriter2D writer;
	
	// Global variables
	int lastDump;
	int n;
	double t_n;
	double t_nplus1;
	static constexpr double deltat = 0.001;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> center;
	Kokkos::View<double*> u_n;
	Kokkos::View<double*> u_nplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> f;
	Kokkos::View<double*> outgoingFlux;
	Kokkos::View<double*> surface;
	
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	void dumpVariables(int iteration, bool useTimer=true);

public:
	KOKKOS_INLINE_FUNCTION
	void computeOutgoingFlux() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeSurface() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeV() noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniCenter() noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniF() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeUn() noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniUn() noexcept;
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept;
	void simulate();
};

#endif
