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
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "mesh/stl/PvdFileWriter2D.h"
#include "utils/stl/Parallel.h"
#include "linearalgebra/stl/LinearAlgebraFunctions.h"

using namespace nablalib;

/******************** Free functions declarations ********************/

template<size_t x>
double norm(RealArray1D<x> a);
template<size_t x>
double dot(RealArray1D<x> a, RealArray1D<x> b);
template<size_t x>
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);


/******************** Module declaration ********************/

class MyModule
{
public:
	struct Options
	{
		std::string outputPath;
		int outputPeriod;
		double X_LENGTH;
		double Y_LENGTH;
		int X_EDGE_ELEMS;
		int Y_EDGE_ELEMS;
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		int maxIterations;
		double stopTime;
		RealArray1D<2> vectOne;

		Options(const std::string& fileName);
	};

	const Options& options;

	MyModule(const Options& aOptions);
	~MyModule();

private:
	// Global definitions
	double t_n;
	double t_nplus1;
	static constexpr double deltat = 0.01;
	static constexpr double rho = 1.0;
	const double lambda;
	int lastDump;
	
	// Mesh (can depend on previous definitions)
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbNodesOfCell, nbNeighbourCells;
	
	// Global declarations
	int n;
	std::vector<RealArray1D<2>> X;
	std::vector<RealArray1D<2>> Xc;
	std::vector<double> xc;
	std::vector<double> yc;
	VectorType e_n;
	VectorType e_nplus1;
	NablaSparseMatrix alpha;
	LinearAlgebraFunctions::CGInfo cg_info; // CG details
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	void computeTn() noexcept;
	
	void computealphaMatrix() noexcept;
	
	void initXc() noexcept;
	
	void updateE() noexcept;
	
	void initE() noexcept;
	
	void initXcAndYc() noexcept;
	
	void executeTimeLoopN() noexcept;

	void dumpVariables(int iteration, bool useTimer=true);

public:
	void simulate();
};
