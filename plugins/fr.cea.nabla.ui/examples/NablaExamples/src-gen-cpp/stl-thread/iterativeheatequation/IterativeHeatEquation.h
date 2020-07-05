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

using namespace nablalib;

/******************** Free functions declarations ********************/

bool check(bool a);
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
double maxR0(double a, double b);


/******************** Module declaration ********************/

class IterativeHeatEquation
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
		int maxIterationsK;
		double epsilon;

		void jsonInit(const rapidjson::Value::ConstObject& d);
	};

	const Options& options;

	IterativeHeatEquation(const Options& aOptions);
	~IterativeHeatEquation();

private:
	// Global definitions
	double t_n;
	double t_nplus1;
	double deltat;
	int lastDump;
	
	// Mesh (can depend on previous definitions)
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbFaces, nbNeighbourCells, nbNodesOfFace, nbCellsOfFace, nbNodesOfCell;
	
	// Global declarations
	int n;
	int k;
	std::vector<RealArray1D<2>> X;
	std::vector<RealArray1D<2>> Xc;
	std::vector<double> xc;
	std::vector<double> yc;
	std::vector<double> u_n;
	std::vector<double> u_nplus1;
	std::vector<double> u_nplus1_k;
	std::vector<double> u_nplus1_kplus1;
	std::vector<double> V;
	std::vector<double> D;
	std::vector<double> faceLength;
	std::vector<double> faceConductivity;
	std::vector<std::vector<double>> alpha;
	double residual;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	void computeFaceLength() noexcept;
	
	void computeTn() noexcept;
	
	void computeV() noexcept;
	
	void initD() noexcept;
	
	void initXc() noexcept;
	
	void setUpTimeLoopK() noexcept;
	
	void updateU() noexcept;
	
	void computeDeltaTn() noexcept;
	
	void computeFaceConductivity() noexcept;
	
	void computeResidual() noexcept;
	
	void executeTimeLoopK() noexcept;
	
	void initU() noexcept;
	
	void initXcAndYc() noexcept;
	
	void computeAlphaCoeff() noexcept;
	
	void tearDownTimeLoopK() noexcept;
	
	void executeTimeLoopN() noexcept;

	void dumpVariables(int iteration, bool useTimer=true);

public:
	void simulate();
};
