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

		void jsonInit(const rapidjson::Value::ConstObject& d);
	};

	DepthInit(CartesianMesh2D* aMesh, const Options& aOptions, DepthInitFunctions& aDepthInitFunctions);
	~DepthInit();

private:
	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbCells, nbNodes;
	
	// User options and external classes
	const Options& options;
	DepthInitFunctions& depthInitFunctions;
	
	// Global variables
	static constexpr double t = 0.0;
	std::vector<RealArray1D<2>> X;
	std::vector<double> eta;
	
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	void initFromFile() noexcept;

public:
	void simulate();
};
