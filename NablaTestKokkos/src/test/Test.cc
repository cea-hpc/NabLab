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
#include "mesh/VtkFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "types/MathFunctions.h"

using namespace nablalib;

class Test
{
public:
	struct Options
	{
		double LENGTH = 1.0;
		int X_EDGE_ELEMS = 10;
		int Y_EDGE_ELEMS = 10;
		int Z_EDGE_ELEMS = 1;
	};
	Options* options;

private:
	NumericMesh2D* mesh;
	VtkFileWriter2D writer;
	int nbNodes, nbCells, nbNodesOfCell;

	// Global Variables
	double total;

	// Array Variables
	Kokkos::View<Real2*> X;
	Kokkos::View<double*> u;
	Kokkos::View<double**> Cjr;
	
	const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();

public:
	Test(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("Test", output)
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, X("X", nbNodes)
	, u("u", nbCells)
	, Cjr("Cjr", nbCells, nbNodesOfCell)
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
	 * Job TestFunctionCall @-1.0
	 * In variables: Cjr
	 * Out variables: u
	 */
	KOKKOS_INLINE_FUNCTION
	void testFunctionCall() noexcept
	{
		auto cells(mesh->getCells());
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(cells[jCells]);
			double sum1007414498 = 0.0;
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				sum1007414498 = sum1007414498 + (Cjr(jCells,rNodesOfCellJ));
			}
			u(jCells) = sum1007414498;
		});
	}

public:
	void simulate()
	{
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Glace2d ..." << __RESET__ << "\n\n";

		std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options->X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options->Y_EDGE_ELEMS
			<< __RESET__ << ", length=" << __BOLD__ << options->LENGTH << __RESET__ << std::endl;


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

		testFunctionCall(); // @-1.0
		timer.stop();
	}
};	

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto o = new Test::Options();
	string output;
	if (argc == 4) {
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->LENGTH = std::atof(argv[3]);
	} else if (argc == 5) {
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->LENGTH = std::atof(argv[3]);
		output = argv[4];
	} else if (argc != 1) {
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 3 or 4 args: X Y length (output)." << std::endl;
		std::cerr << "(X=100, Y=10, length=0.01 output=current directory with no args)" << std::endl;
	}
	auto gm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->LENGTH, o->LENGTH);
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
