#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/CartesianMesh2D.h"
#include "mesh/PvdFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "utils/stl/Parallel.h"

using namespace nablalib;

/******************** Free functions declarations ********************/

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


/******************** Module declaration ********************/

class ExplicitHeatEquation
{
public:
	struct Options
	{
		double X_LENGTH;
		double Y_LENGTH;
		double u0;
		RealArray1D<2> vectOne;
		size_t X_EDGE_ELEMS;
		size_t Y_EDGE_ELEMS;
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		double option_stoptime;
		size_t option_max_iterations;

		Options(const std::string& fileName);
	};

	Options* options;

	ExplicitHeatEquation(Options* aOptions, CartesianMesh2D* aCartesianMesh2D, string output);

private:
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbCellsOfFace, nbNeighbourCells;
	double t_n;
	double t_nplus1;
	double deltat;
	int lastDump;
	int n;
	std::vector<RealArray1D<2>> X;
	std::vector<RealArray1D<2>> Xc;
	std::vector<double> xc;
	std::vector<double> yc;
	std::vector<double> u_n;
	std::vector<double> u_nplus1;
	std::vector<double> V;
	std::vector<double> D;
	std::vector<double> faceLength;
	std::vector<double> faceConductivity;
	std::vector<std::vector<double>> alpha;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	void computeFaceLength() noexcept;
	
	void computeTn() noexcept;
	
	void computeV() noexcept;
	
	void initD() noexcept;
	
	void initXc() noexcept;
	
	void updateU() noexcept;
	
	void computeFaceConductivity() noexcept;
	
	void initU() noexcept;
	
	void initXcAndYc() noexcept;
	
	void computeDeltaTn() noexcept;
	
	void computeAlphaCoeff() noexcept;
	
	void executeTimeLoopN() noexcept;

	void dumpVariables(int iteration);

public:
	void simulate();
};
