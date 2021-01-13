#ifndef GLACE2D_H_
#define GLACE2D_H_

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

namespace Glace2dFuncs
{
KOKKOS_INLINE_FUNCTION
double det(RealArray2D<2,2> a);
KOKKOS_INLINE_FUNCTION
RealArray1D<2> perp(RealArray1D<2> a);
template<size_t x>
KOKKOS_INLINE_FUNCTION
double dot(RealArray1D<x> a, RealArray1D<x> b);
template<size_t x>
KOKKOS_INLINE_FUNCTION
double norm(RealArray1D<x> a);
template<size_t l>
KOKKOS_INLINE_FUNCTION
RealArray2D<l,l> tensProduct(RealArray1D<l> a, RealArray1D<l> b);
template<size_t x, size_t y>
KOKKOS_INLINE_FUNCTION
RealArray1D<x> matVectProduct(RealArray2D<x,y> a, RealArray1D<y> b);
template<size_t l>
KOKKOS_INLINE_FUNCTION
double trace(RealArray2D<l,l> a);
KOKKOS_INLINE_FUNCTION
RealArray2D<2,2> inverse(RealArray2D<2,2> a);
template<size_t x>
KOKKOS_INLINE_FUNCTION
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);
KOKKOS_INLINE_FUNCTION
double sumR0(double a, double b);
template<size_t x>
KOKKOS_INLINE_FUNCTION
RealArray2D<x,x> sumR2(RealArray2D<x,x> a, RealArray2D<x,x> b);
KOKKOS_INLINE_FUNCTION
double minR0(double a, double b);
}

/******************** Module declaration ********************/

class Glace2d
{
public:
	struct Options
	{
		std::string outputPath;
		int outputPeriod;
		double stopTime;
		int maxIterations;
		double gamma;
		double xInterface;
		double deltatIni;
		double deltatCfl;
		double rhoIniZg;
		double rhoIniZd;
		double pIniZg;
		double pIniZd;

		void jsonInit(const char* jsonContent);
	};

	Glace2d(CartesianMesh2D* aMesh, Options& aOptions);
	~Glace2d();

	void simulate();
	KOKKOS_INLINE_FUNCTION
	void computeCjr() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeInternalEnergy() noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniCjrIc() noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniTime() noexcept;
	KOKKOS_INLINE_FUNCTION
	void iniTimeStep() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeLjr() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeV() noexcept;
	KOKKOS_INLINE_FUNCTION
	void initialize() noexcept;
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopN() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeDensity() noexcept;
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeEOSp() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeEOSc() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeAjr() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computedeltatj() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeAr() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeBr() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeDt() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeBoundaryConditions() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeBt() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeMt() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeU() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeFjr() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeXn() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeEn() noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeUn() noexcept;

private:
	void dumpVariables(int iteration, bool useTimer=true);

	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbNodes, nbCells, nbInnerNodes, nbTopNodes, nbBottomNodes, nbLeftNodes, nbRightNodes, nbNodesOfCell, nbCellsOfNode;

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
	double t_n;
	double t_nplus1;
	double t_n0;
	double deltat_n;
	double deltat_nplus1;
	double deltat_n0;
	Kokkos::View<RealArray1D<2>*> X_n;
	Kokkos::View<RealArray1D<2>*> X_nplus1;
	Kokkos::View<RealArray1D<2>*> X_n0;
	Kokkos::View<RealArray1D<2>*> b;
	Kokkos::View<RealArray1D<2>*> bt;
	Kokkos::View<RealArray2D<2,2>*> Ar;
	Kokkos::View<RealArray2D<2,2>*> Mt;
	Kokkos::View<RealArray1D<2>*> ur;
	Kokkos::View<double*> c;
	Kokkos::View<double*> m;
	Kokkos::View<double*> p;
	Kokkos::View<double*> rho;
	Kokkos::View<double*> e;
	Kokkos::View<double*> E_n;
	Kokkos::View<double*> E_nplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> deltatj;
	Kokkos::View<RealArray1D<2>*> uj_n;
	Kokkos::View<RealArray1D<2>*> uj_nplus1;
	Kokkos::View<double**> l;
	Kokkos::View<RealArray1D<2>**> Cjr_ic;
	Kokkos::View<RealArray1D<2>**> C;
	Kokkos::View<RealArray1D<2>**> F;
	Kokkos::View<RealArray2D<2,2>**> Ajr;
};

#endif
