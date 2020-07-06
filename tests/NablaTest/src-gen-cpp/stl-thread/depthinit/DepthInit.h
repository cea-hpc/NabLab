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
#include "depthinit/DepthInitFunctions.h"
#include "mesh/stl/PvdFileWriter2D.h"
#include "utils/stl/Parallel.h"

using namespace nablalib;

/******************** Free functions declarations ********************/



/******************** Module declaration ********************/

class DepthInit
{
public:
	struct Options
	{
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		int X_EDGE_ELEMS;
		int Y_EDGE_ELEMS;
		double maxTime;
		int maxIter;
		double deltat;

		void jsonInit(const rapidjson::Value::ConstObject& d);
	};

	const Options& options;
	DepthInitFunctions& depthInitFunctions;

	DepthInit(const Options& aOptions, DepthInitFunctions& aDepthInitFunctions);
	~DepthInit();

private:
	// Global definitions
	static constexpr double t = 0.0;
	
	// Mesh (can depend on previous definitions)
	CartesianMesh2D* mesh;
	size_t nbCells, nbNodes;
	
	// Global declarations
	std::vector<RealArray1D<2>> X;
	std::vector<double> eta;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	void initFromFile() noexcept;

public:
	void simulate();
};
