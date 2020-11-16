#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include "mesh/CartesianMesh2DFactory.h"
#include "mesh/CartesianMesh2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "depthinit/DepthInitFunctions.h"
#include "utils/stl/Parallel.h"

using namespace nablalib;

/******************** Free functions declarations ********************/


/******************** Module declaration ********************/

class DepthInit
{
public:
	struct Options
	{
		double maxTime;
		int maxIter;
		double deltat;
		DepthInitFunctions depthInitFunctions;

		void jsonInit(const rapidjson::Value& json);
	};

	DepthInit(CartesianMesh2D* aMesh, Options& aOptions);
	~DepthInit();

private:
	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbCells, nbNodes;
	
	// User options
	Options& options;
	
	// Global variables
	static constexpr double t = 0.0;
	std::vector<RealArray1D<2>> X;
	std::vector<double> eta;
	
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

public:
	void initFromFile() noexcept;
	void simulate();
};
