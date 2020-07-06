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

class Test
{
public:
	struct Options
	{
		double maxTime;
		int maxIter;
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		int X_EDGE_ELEMS;
		int Y_EDGE_ELEMS;
		double deltat;

		void jsonInit(const rapidjson::Value::ConstObject& d);
	};

	const Options& options;

	Test(const Options& aOptions);
	~Test();

private:
	// Global definitions
	double t_n;
	double t_nplus1;
	
	// Mesh (can depend on previous definitions)
	CartesianMesh2D* mesh;
	size_t nbNodes, nbCells;
	
	// Global declarations
	int n;
	int k;
	std::vector<RealArray1D<2>> X;
	std::vector<double> e1;
	std::vector<double> e2_n;
	std::vector<double> e2_nplus1;
	std::vector<double> e2_nplus1_k;
	std::vector<double> e2_nplus1_kplus1;
	std::vector<double> e2_nplus1_k0;
	std::vector<double> e_n;
	std::vector<double> e_nplus1;
	std::vector<double> e_n0;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	void computeE1() noexcept;
	
	void computeE2() noexcept;
	
	void initE() noexcept;
	
	void updateT() noexcept;
	
	void initE2() noexcept;
	
	void setUpTimeLoopN() noexcept;
	
	void executeTimeLoopN() noexcept;
	
	void setUpTimeLoopK() noexcept;
	
	void executeTimeLoopK() noexcept;
	
	void tearDownTimeLoopK() noexcept;
	
	void updateE() noexcept;

public:
	void simulate();
};
