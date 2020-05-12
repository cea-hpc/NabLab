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
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/CartesianMesh2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "mesh/kokkos/PvdFileWriter2D.h"
#include "utils/kokkos/Parallel.h"

using namespace nablalib;

/******************** Free functions declarations ********************/

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


/******************** Module declaration ********************/

class ExplicitHeatEquation
{
public:
	struct Options
	{
		std::string outputPath;
		int outputPeriod;
		double u0;
		RealArray1D<2> vectOne;
		double X_LENGTH;
		double Y_LENGTH;
		int X_EDGE_ELEMS;
		int Y_EDGE_ELEMS;
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		double stopTime;
		int maxIterations;

		Options(const std::string& fileName);
	};

	Options* options;

	ExplicitHeatEquation(Options* aOptions, CartesianMesh2D* aCartesianMesh2D);

private:
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbCellsOfFace, nbNeighbourCells;
	double t_n;
	double t_nplus1;
	double deltat;
	int lastDump;
	int n;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> Xc;
	Kokkos::View<double*> xc;
	Kokkos::View<double*> yc;
	Kokkos::View<double*> u_n;
	Kokkos::View<double*> u_nplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> D;
	Kokkos::View<double*> faceLength;
	Kokkos::View<double*> faceConductivity;
	Kokkos::View<double**> alpha;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	KOKKOS_INLINE_FUNCTION
	void computeFaceLength() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeV() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initD() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initXc() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateU() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeFaceConductivity() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initU() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initXcAndYc() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeDeltaTn() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeAlphaCoeff() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept;

	void dumpVariables(int iteration);

public:
	void simulate();
};
