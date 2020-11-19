#ifndef R1_H_
#define R1_H_

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

class R1
{
public:
	struct Options
	{

		void jsonInit(const rapidjson::Value& json);
	};

	R1(CartesianMesh2D* aMesh, Options& aOptions);
	~R1();

	void setMainModule(H* value)
	{
		mainModule = value,
		mainModule->r1 = this;
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
	std::vector<double> rv3;
	
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

public:
	void rj1() noexcept;
	void rj2() noexcept;
	void simulate();
};

#endif
