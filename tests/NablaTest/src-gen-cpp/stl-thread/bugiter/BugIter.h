#ifndef BUGITER_H_
#define BUGITER_H_

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
#include "utils/stl/Parallel.h"

using namespace nablalib;

/******************** Module declaration ********************/

class BugIter
{
public:
	struct Options
	{
		double maxTime;
		int maxIter;
		int maxIterK;
		int maxIterL;
		double deltat;

		void jsonInit(const rapidjson::Value& json);
	};

	BugIter(CartesianMesh2D* aMesh, Options& aOptions);
	~BugIter();

	void simulate();
	void computeTn() noexcept;
	void iniTime() noexcept;
	void iniU() noexcept;
	void iniV() noexcept;
	void updateV() noexcept;
	void updateW() noexcept;
	void setUpTimeLoopK() noexcept;
	void setUpTimeLoopN() noexcept;
	void executeTimeLoopK() noexcept;
	void executeTimeLoopN() noexcept;
	void tearDownTimeLoopK() noexcept;
	void iniW() noexcept;
	void setUpTimeLoopL() noexcept;
	void executeTimeLoopL() noexcept;
	void tearDownTimeLoopL() noexcept;
	void updateU() noexcept;

private:
	// Mesh and mesh variables
	CartesianMesh2D* mesh;
	size_t nbCells, nbNodes;

	// User options
	Options& options;

	// Timers
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

public:
	// Global variables
	int n;
	int k;
	int l;
	double t_n;
	double t_nplus1;
	double t_n0;
	std::vector<RealArray1D<2>> X;
	std::vector<double> u_n;
	std::vector<double> u_nplus1;
	std::vector<double> v_n;
	std::vector<double> v_nplus1;
	std::vector<double> v_nplus1_k;
	std::vector<double> v_nplus1_kplus1;
	std::vector<double> v_nplus1_k0;
	std::vector<double> w_n;
	std::vector<double> w_nplus1;
	std::vector<double> w_nplus1_l;
	std::vector<double> w_nplus1_lplus1;
	std::vector<double> w_nplus1_l0;
};

#endif
