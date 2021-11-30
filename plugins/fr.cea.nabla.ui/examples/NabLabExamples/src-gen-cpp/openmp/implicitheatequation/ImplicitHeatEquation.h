/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __IMPLICITHEATEQUATION_H_
#define __IMPLICITHEATEQUATION_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <rapidjson/document.h>
#include <omp.h>
#include "nablalib/utils/Utils.h"
#include "nablalib/utils/Timer.h"
#include "nablalib/types/Types.h"
#include "CartesianMesh2D.h"
#include "PvdFileWriter2D.h"
#include "LinearAlgebra.h"

using namespace nablalib::utils;
using namespace nablalib::types;

/******************** Free functions declarations ********************/

namespace implicitheatequationfreefuncs
{
template<size_t x>
double norm(RealArray1D<x> a);
template<size_t x>
double dot(RealArray1D<x> a, RealArray1D<x> b);
double det(RealArray1D<2> a, RealArray1D<2> b);
template<size_t x>
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);
double minR0(double a, double b);
double sumR0(double a, double b);
double prodR0(double a, double b);
template<size_t x0>
RealArray1D<x0> operator+(RealArray1D<x0> a, RealArray1D<x0> b);
template<size_t x0>
RealArray1D<x0> operator*(double a, RealArray1D<x0> b);
template<size_t x0>
RealArray1D<x0> operator-(RealArray1D<x0> a, RealArray1D<x0> b);
}

/******************** Module declaration ********************/

class ImplicitHeatEquation
{
public:
	ImplicitHeatEquation(CartesianMesh2D& aMesh);
	~ImplicitHeatEquation();

	void jsonInit(const char* jsonContent);

	void simulate();
	void computeFaceLength() noexcept;
	void computeTn() noexcept;
	void computeV() noexcept;
	void initD() noexcept;
	void initTime() noexcept;
	void initXc() noexcept;
	void updateU() noexcept;
	void computeDeltaTn() noexcept;
	void computeFaceConductivity() noexcept;
	void initU() noexcept;
	void setUpTimeLoopN() noexcept;
	void computeAlphaCoeff() noexcept;
	void executeTimeLoopN() noexcept;

private:
	void dumpVariables(int iteration, bool useTimer=true);

	// Mesh and mesh variables
	CartesianMesh2D& mesh;
	size_t nbNodes, nbCells, nbFaces, maxNodesOfCell, maxNodesOfFace, maxCellsOfFace, maxNeighbourCells;

	// Options and global variables
	PvdFileWriter2D* writer;
	std::string outputPath;
	LinearAlgebra linearAlgebra;
	int outputPeriod;
	int lastDump;
	int n;
	static constexpr double u0 = 1.0;
	static constexpr RealArray1D<2> vectOne = {1.0, 1.0};
	double stopTime;
	int maxIterations;
	double deltat;
	double t_n;
	double t_nplus1;
	double t_n0;
	std::vector<RealArray1D<2>> X;
	std::vector<RealArray1D<2>> Xc;
	Vector u_n;
	Vector u_nplus1;
	std::vector<double> V;
	std::vector<double> D;
	std::vector<double> faceLength;
	std::vector<double> faceConductivity;
	Matrix alpha;

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;
};

#endif
