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



/******************** Module declaration ********************/

class MyModule
{
public:
	struct Options
	{
		std::string outputPath;
		int outputPeriod;
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		int X_EDGE_ELEMS;
		int Y_EDGE_ELEMS;
		int maxIter;
		double maxTime;

		Options(const std::string& fileName);
	};

	const Options& options;

	MyModule(const Options& aOptions);
	~MyModule();

private:
	// Global definitions
	static constexpr double t_n = 0.0;
	static constexpr double t_nplus1 = 0.0;
	static constexpr double deltat = 0.01;
	static constexpr double v = 1.0;
	int lastDump;
	
	// Mesh (can depend on previous definitions)
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbNeighbourCells, nbNodesOfCell;
	
	// Global declarations
	int n;
	std::vector<RealArray1D<2>> X;
	std::vector<RealArray1D<2>> Xc;
	std::vector<double> xc;
	std::vector<double> yc;
	std::vector<double> e;
	std::vector<std::vector<double>> alpha;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	void executeTimeLoopN() noexcept;
	
	void initE() noexcept;

	void dumpVariables(int iteration, bool useTimer=true);

public:
	void simulate();
};
