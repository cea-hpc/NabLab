#ifndef IMPLICITHEATEQUATION_H_
#define IMPLICITHEATEQUATION_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include "mesh/CartesianMesh2DFactory.h"
#include "mesh/CartesianMesh2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "mesh/stl/PvdFileWriter2D.h"
#include "linearalgebra/stl/LinearAlgebraFunctions.h"

using namespace nablalib;

/******************** Free functions declarations ********************/

namespace ImplicitHeatEquationFuncs
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
}

/******************** Module declaration ********************/

class ImplicitHeatEquation
{
public:
	struct Options
	{
		std::string outputPath;
		int outputPeriod;
		double u0;
		double stopTime;
		int maxIterations;
		LinearAlgebraFunctions linearAlgebraFunctions;

		void jsonInit(const char* jsonContent);
	};

	ImplicitHeatEquation(CartesianMesh2D* aMesh, Options& aOptions);
	~ImplicitHeatEquation();

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
	static constexpr RealArray1D<2> vectOne = {1.0, 1.0};
	double deltat;
	double t_n;
	double t_nplus1;
	double t_n0;
	std::vector<RealArray1D<2>> X;
	std::vector<RealArray1D<2>> Xc;
	VectorType u_n;
	VectorType u_nplus1;
	std::vector<double> V;
	std::vector<double> D;
	std::vector<double> faceLength;
	std::vector<double> faceConductivity;
	NablaSparseMatrix alpha;
};

#endif
