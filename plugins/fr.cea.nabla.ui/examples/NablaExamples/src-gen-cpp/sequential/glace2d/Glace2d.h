/*** GENERATED FILE - DO NOT OVERWRITE ***/

#ifndef __GLACE2D_H_
#define __GLACE2D_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include "nablalib/mesh/CartesianMesh2DFactory.h"
#include "nablalib/mesh/CartesianMesh2D.h"
#include "nablalib/mesh/PvdFileWriter2D.h"
#include "nablalib/utils/Utils.h"
#include "nablalib/utils/Timer.h"
#include "nablalib/types/Types.h"

using namespace nablalib::mesh;
using namespace nablalib::utils;
using namespace nablalib::types;

/******************** Free functions declarations ********************/

namespace glace2dfreefuncs
{
double det(RealArray2D<2,2> a);
RealArray1D<2> perp(RealArray1D<2> a);
template<size_t x>
double dot(RealArray1D<x> a, RealArray1D<x> b);
template<size_t x>
double norm(RealArray1D<x> a);
template<size_t l>
RealArray2D<l,l> tensProduct(RealArray1D<l> a, RealArray1D<l> b);
template<size_t x, size_t y>
RealArray1D<x> matVectProduct(RealArray2D<x,y> a, RealArray1D<y> b);
template<size_t l>
double trace(RealArray2D<l,l> a);
RealArray2D<2,2> inverse(RealArray2D<2,2> a);
template<size_t x>
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);
double sumR0(double a, double b);
template<size_t x>
RealArray2D<x,x> sumR2(RealArray2D<x,x> a, RealArray2D<x,x> b);
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
	void computeCjr() noexcept;
	void computeInternalEnergy() noexcept;
	void iniCjrIc() noexcept;
	void iniTime() noexcept;
	void iniTimeStep() noexcept;
	void computeLjr() noexcept;
	void computeV() noexcept;
	void initialize() noexcept;
	void setUpTimeLoopN() noexcept;
	void computeDensity() noexcept;
	void executeTimeLoopN() noexcept;
	void computeEOSp() noexcept;
	void computeEOSc() noexcept;
	void computeAjr() noexcept;
	void computedeltatj() noexcept;
	void computeAr() noexcept;
	void computeBr() noexcept;
	void computeDt() noexcept;
	void computeBoundaryConditions() noexcept;
	void computeBt() noexcept;
	void computeMt() noexcept;
	void computeTn() noexcept;
	void computeU() noexcept;
	void computeFjr() noexcept;
	void computeXn() noexcept;
	void computeEn() noexcept;
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
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;

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
	std::vector<RealArray1D<2>> X_n;
	std::vector<RealArray1D<2>> X_nplus1;
	std::vector<RealArray1D<2>> X_n0;
	std::vector<RealArray1D<2>> b;
	std::vector<RealArray1D<2>> bt;
	std::vector<RealArray2D<2,2>> Ar;
	std::vector<RealArray2D<2,2>> Mt;
	std::vector<RealArray1D<2>> ur;
	std::vector<double> c;
	std::vector<double> m;
	std::vector<double> p;
	std::vector<double> rho;
	std::vector<double> e;
	std::vector<double> E_n;
	std::vector<double> E_nplus1;
	std::vector<double> V;
	std::vector<double> deltatj;
	std::vector<RealArray1D<2>> uj_n;
	std::vector<RealArray1D<2>> uj_nplus1;
	std::vector<std::vector<double>> l;
	std::vector<std::vector<RealArray1D<2>>> Cjr_ic;
	std::vector<std::vector<RealArray1D<2>>> C;
	std::vector<std::vector<RealArray1D<2>>> F;
	std::vector<std::vector<RealArray2D<2,2>>> Ajr;
};

#endif
