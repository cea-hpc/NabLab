#include <iostream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/CartesianMesh2D.h"
#include "mesh/PvdFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "types/MathFunctions.h"
#include "utils/stl/Parallel.h"

using namespace nablalib;

class Test
{
public:
	struct Options
	{
		// Should be const but usefull to set them from main args
		double X_EDGE_LENGTH = 0.01;
		double Y_EDGE_LENGTH = X_EDGE_LENGTH;
		size_t X_EDGE_ELEMS = 100;
		size_t Y_EDGE_ELEMS = 100;
		size_t max_time_iterations = 500000000;
		double final_time = 1.0;
	};
	Options* options;

private:
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbNodesOfCell;
	
	// Global Variables
	double t, deltat;
	
	// Connectivity Variables
	std::vector<RealArray1D<2>> X;
	std::vector<double> U;
	std::vector<std::vector<RealArray1D<2>>> C;
	std::vector<double> c1;
	std::vector<double> c2;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

public:
	Test(Options* aOptions, CartesianMesh2D* aCartesianMesh2D, string output)
	: options(aOptions)
	, mesh(aCartesianMesh2D)
	, writer("Test", output)
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbNodesOfCell(CartesianMesh2D::MaxNbNodesOfCell)
	, t(0.0)
	, deltat(0.001)
	, X(nbNodes)
	, U(nbCells)
	, C(nbCells, std::vector<RealArray1D<2>>(nbNodesOfCell))
	, c1(nbCells)
	, c2(nbCells)
	{
		// Copy node coordinates
		const auto& gNodes = mesh->getGeometry()->getNodes();
		for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
			X[rNodes] = gNodes[rNodes];
	}

private:
	/**
	 * Job ComputeCjr called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: C
	 */
	void computeCjr() noexcept
	{
		{
			const auto cells(mesh->getCells());
			const size_t nbCells(cells.size());
			parallel::parallel_exec(nbCells, [&](const size_t& jCells)
			{
				const Id jId(cells[jCells]);
				const auto rCellsJ(mesh->getNodesOfCell(jId));
				const int cardRCellsJ(rCellsJ.size());
				RealArray1D<cardRCellsJ> tmp;
				{
					const size_t nbRCellsJ(rCellsJ.size());
					for (size_t rRCellsJ=0; rRCellsJ<nbRCellsJ; rRCellsJ++)
					{
						const Id rId(rCellsJ[rRCellsJ]);
						const Id rPlus1Id(rCellsJ[(rRCellsJ+1+nbNodesOfCell)%nbNodesOfCell]);
						const Id rMinus1Id(rCellsJ[(rRCellsJ-1+nbNodesOfCell)%nbNodesOfCell]);
						const size_t rNodes(rId);
						const size_t rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId), rId));
						const size_t rPlus1Nodes(rPlus1Id);
						const size_t rMinus1Nodes(rMinus1Id);
						tmp[rRCellsJ] = X[rNodes][0];
						C[jCells][rNodesOfCellJ] = 0.5 * (X[rPlus1Nodes] - X[rMinus1Nodes]);
					}
				}
			});
		}
	}

public:
	void simulate()
	{
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Test ..." << __RESET__ << "\n\n";
		
		std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options->X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options->Y_EDGE_ELEMS
			<< __RESET__ << ", X length=" << __BOLD__ << options->X_EDGE_LENGTH << __RESET__ << ", Y length=" << __BOLD__ << options->Y_EDGE_LENGTH << __RESET__ << std::endl;
		
		std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
		
		if (!writer.isDisabled())
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
		else
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

		computeCjr(); // @1.0
		
		std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << globalTimer.print() << __RESET__ << std::endl;
	}
};

int main(int argc, char* argv[]) 
{
	auto o = new Test::Options();
	string output;
	if (argc == 5)
	{
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->X_EDGE_LENGTH = std::atof(argv[3]);
		o->Y_EDGE_LENGTH = std::atof(argv[4]);
	}
	else if (argc == 6)
	{
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->X_EDGE_LENGTH = std::atof(argv[3]);
		o->Y_EDGE_LENGTH = std::atof(argv[4]);
		output = argv[5];
	}
	else if (argc != 1)
	{
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 4 or 5 args: X Y Xlength Ylength (output)." << std::endl;
		std::cerr << "(X=100, Y=10, Xlength=0.01, Ylength=0.01 output=current directory with no args)" << std::endl;
	}
	auto nm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->X_EDGE_LENGTH, o->Y_EDGE_LENGTH);
	auto c = new Test(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete o;
	return 0;
}
