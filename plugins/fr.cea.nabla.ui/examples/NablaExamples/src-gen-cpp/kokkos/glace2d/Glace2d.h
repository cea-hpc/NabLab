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
#include "mesh/PvdFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "utils/kokkos/Parallel.h"

using namespace nablalib;

/******************** Free functions declarations ********************/

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


/******************** Module declaration ********************/

class Glace2d
{
public:
	struct Options
	{
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		int X_EDGE_ELEMS;
		int Y_EDGE_ELEMS;
		double option_stoptime;
		int option_max_iterations;
		double gamma;
		double option_x_interface;
		double option_deltat_ini;
		double option_deltat_cfl;
		double option_rho_ini_zg;
		double option_rho_ini_zd;
		double option_p_ini_zg;
		double option_p_ini_zd;

		Options(const std::string& fileName);
	};

	Options* options;

	Glace2d(Options* aOptions, CartesianMesh2D* aCartesianMesh2D, string output);

private:
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;
	double t_n;
	double t_nplus1;
	double deltat_n;
	double deltat_nplus1;
	int lastDump;
	int n;
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
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	KOKKOS_INLINE_FUNCTION
	void computeCjr() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeInternalEnergy() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void iniCjrIc() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopN() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeLjr() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeV() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initialize() noexcept;
	
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

	void dumpVariables(int iteration);

public:
	void simulate();
};
