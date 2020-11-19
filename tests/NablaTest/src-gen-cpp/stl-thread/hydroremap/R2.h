#ifndef R2_H_
#define R2_H_

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
#include "hydroremap/H.h"
#include "utils/stl/Parallel.h"

using namespace nablalib;

/******************** Module declaration ********************/

class R2
{
public:
	struct Options
	{

		void jsonInit(const rapidjson::Value& json);
	};

	R2(CartesianMesh2D* aMesh, Options& aOptions);
	~R2();

	void setMainModule(H* value)
	{
		mainModule = value,
		mainModule->r2 = this;
	}

private:
	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbNodes, nbCells;
	
	// User options
	Options& options;
	
	// Main module
	H* mainModule;
	
	// Global variables
	std::vector<double> rv2;
	
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

public:
	void rj1() noexcept;
	void rj2() noexcept;
	void simulate();
};

#endif
