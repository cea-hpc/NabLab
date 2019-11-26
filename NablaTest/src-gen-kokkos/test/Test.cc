#include <iostream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <cfenv>
#pragma STDC FENV_ACCESS ON

// Kokkos headers
#include <Kokkos_Core.hpp>
#include <Kokkos_hwloc.hpp>

// Project headers
#include "mesh/NumericMesh2D.h"
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/PvdFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "types/MathFunctions.h"
#include "types/ArrayOperations.h"

using namespace nablalib;

class Test
{
public:
	struct Options
	{
		// Should be const but usefull to set them from main args
		double X_EDGE_LENGTH = 0.01;
		double Y_EDGE_LENGTH = X_EDGE_LENGTH;
		int X_EDGE_ELEMS = 100;
		int Y_EDGE_ELEMS = 10;
		int Z_EDGE_ELEMS = 1;
		double option_stoptime = 0.2;
		int option_max_iterations = 20000;
	};
	Options* options;

private:
	int iteration;
	NumericMesh2D* mesh;
	PvdFileWriter2D writer;
	int nbNodes;

	// Global Variables
	double t, u, v, w1, w2, w3, w4, w5, w6;

	// Connectivity Variables
	Kokkos::View<RealArray1D<2>*> X;

	const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();

public:
	Test(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("Test")
	, nbNodes(mesh->getNbNodes())
	, u({{0.0, 0.1}})
	, v({{0.0, 0.1, 0.2}})
	, X("X", nbNodes)
	{
		// Copy node coordinates
		const auto& gNodes = mesh->getGeometricMesh()->getNodes();
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
		{
			X(rNodes) = gNodes[rNodes];
		});
	}

private:
	/**
	 * Job j1 @-1.0
	 * In variables: u
	 * Out variables: w1
	 */
	KOKKOS_INLINE_FUNCTION
	void j1() noexcept
	{
		w1 = h(u);
	}
	
	/**
	 * Job j2 @-1.0
	 * In variables: u
	 * Out variables: w2
	 */
	KOKKOS_INLINE_FUNCTION
	void j2() noexcept
	{
		w2 = i(u);
	}
	
	/**
	 * Job j3 @-1.0
	 * In variables: v
	 * Out variables: w3
	 */
	KOKKOS_INLINE_FUNCTION
	void j3() noexcept
	{
		w3 = i(v);
	}
	
	/**
	 * Job j4 @-1.0
	 * In variables: u
	 * Out variables: w4
	 */
	KOKKOS_INLINE_FUNCTION
	void j4() noexcept
	{
		w4 = j(u);
	}
	
	/**
	 * Job j5 @-1.0
	 * In variables: v
	 * Out variables: w5
	 */
	KOKKOS_INLINE_FUNCTION
	void j5() noexcept
	{
		w5 = j(v);
	}
	
	/**
	 * Job j6 @-1.0
	 * In variables: u
	 * Out variables: w6
	 */
	KOKKOS_INLINE_FUNCTION
	void j6() noexcept
	{
		w6 = k(u);
	}

	template<size_t a>
	KOKKOS_INLINE_FUNCTION
	RealArray1D<a> j(RealArray1D<a> x) 
	{
		RealArray1D<a> y;
		for (size_t i=0; i<a; i++)
			y[i] = 2 * x[i];
		return y;
	}

	KOKKOS_INLINE_FUNCTION
	RealArray1D<2> h(RealArray1D<2> a) 
	{
		return ArrayOperations::multiply(2, a);
	}

	template<size_t a>
	KOKKOS_INLINE_FUNCTION
	RealArray1D<a> i(RealArray1D<a> x) 
	{
		return ArrayOperations::multiply(2, x);
	}

	template<size_t b>
	KOKKOS_INLINE_FUNCTION
	RealArray1D<b> k(RealArray1D<b> x) 
	{
		return j(x);
	}

public:
	void simulate()
	{
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Test ..." << __RESET__ << "\n\n";

		std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options->X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options->Y_EDGE_ELEMS
			<< __RESET__ << ", X length=" << __BOLD__ << options->X_EDGE_LENGTH << __RESET__ << ", Y length=" << __BOLD__ << options->Y_EDGE_LENGTH << __RESET__ << std::endl;

		if (Kokkos::hwloc::available()) {
			std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_numa_count()
				<< __RESET__ << ", Cores/NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_cores_per_numa()
				<< __RESET__ << ", Threads/Core=" << __BOLD__ << Kokkos::hwloc::get_available_threads_per_core() << __RESET__ << std::endl;
		} else {
			std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
		}

		// std::cout << "[" << __GREEN__ << "KOKKOS" << __RESET__ << "]    " << __BOLD__ << (is_same<MyLayout,Kokkos::LayoutLeft>::value?"Left":"Right")" << __RESET__ << " layout" << std::endl;

		if (!writer.isDisabled())
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
		else
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

		utils::Timer timer(true);

		j1(); // @-1.0
		j2(); // @-1.0
		j3(); // @-1.0
		j4(); // @-1.0
		j5(); // @-1.0
		j6(); // @-1.0
		timer.stop();

		timer.stop();
	}
};	

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto o = new Test::Options();
	string output;
	if (argc == 5) {
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->X_EDGE_LENGTH = std::atof(argv[3]);
		o->Y_EDGE_LENGTH = std::atof(argv[4]);
	} else if (argc == 6) {
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->X_EDGE_LENGTH = std::atof(argv[3]);
		o->Y_EDGE_LENGTH = std::atof(argv[4]);
		output = argv[5];
	} else if (argc != 1) {
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 4 or 5 args: X Y Xlength Ylength (output)." << std::endl;
		std::cerr << "(X=100, Y=10, Xlength=0.01, Ylength=0.01 output=current directory with no args)" << std::endl;
	}
	auto gm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->X_EDGE_LENGTH, o->Y_EDGE_LENGTH);
	auto nm = new NumericMesh2D(gm);
	auto c = new Test(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete gm;
	delete o;
	Kokkos::finalize();
	return 0;
}
