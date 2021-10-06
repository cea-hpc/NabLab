/* DO NOT EDIT THIS FILE - it is machine generated */

#ifndef __ITERATION_H_
#define __ITERATION_H_

#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <rapidjson/document.h>
#include "nablalib/utils/Utils.h"
#include "nablalib/utils/Timer.h"
#include "nablalib/types/Types.h"
#include "nablalib/utils/stl/Parallel.h"
#include "CartesianMesh2D.h"

using namespace nablalib::utils;
using namespace nablalib::types;
using namespace nablalib::utils::stl;

/******************** Module declaration ********************/

class Iteration
{
public:
	Iteration(CartesianMesh2D& aMesh);
	~Iteration();

	void jsonInit(const char* jsonContent);

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
	// Json block of options
	rapidjson::Document jsonDocument;

	// Mesh and mesh variables
	CartesianMesh2D& mesh;
	size_t nbNodes, nbCells;

	// Options and global variables
	int n;
	int k;
	int l;
	static constexpr double maxTime = 0.1;
	static constexpr int maxIter = 500;
	static constexpr int maxIterK = 500;
	static constexpr int maxIterL = 500;
	static constexpr double deltat = 1.0;
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

	// Timers
	Timer globalTimer;
	Timer cpuTimer;
	Timer ioTimer;
};

#endif
