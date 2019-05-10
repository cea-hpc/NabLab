#include <iostream>
#include <limits>

// Kokkos headers
#include <Kokkos_Core.hpp>

// Project headers
#include "mesh/NumericMesh2D.h"
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/VtkFileWriter2D.h"
#include "Utils.h"
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

private:
	Options* options;
	NumericMesh2D* mesh;
	VtkFileWriter2D writer;
	int nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode;

	// Global Variables
	double total;

	// Array Variables
	Kokkos::View<Real2*> X;
	Kokkos::View<double*> u;
	Kokkos::View<double**> Cjr;

public:
	Test(Options* aOptions, NumericMesh2D* aNumericMesh2D)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("Test")
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, nbCellsOfNode(NumericMesh2D::MaxNbCellsOfNode)
	, X("X", nbNodes)
	, u("u", nbCells)
	, Cjr("Cjr", nbCells, nbNodesOfCell)
	{
		// Copy node coordinates
		auto gNodes = mesh->getGeometricMesh()->getNodes();
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			X(rNodes) = gNodes[rNodes];
		});
	}

private:
	/**
	 * Job IniCjr @-1.0
	 * In variables: X
	 * Out variables: Cjr
	 */
	void iniCjr()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				Cjr(jCells,rNodesOfCellJ) = 1.0 + X(rNodes).y;
			}
		});
	}
	
	/**
	 * Job IniCjrBad @-1.0
	 * In variables: 
	 * Out variables: Cjr
	 */
	void iniCjrBad()
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			int rId = rNodes;
			int rPlus1Id = (rNodes+1+nbNodes)%nbNodes;
			auto cellsOfNodeRPlus1 = mesh->getCellsOfNode(rPlus1Id);
			for (int jCellsOfNodeRPlus1=0; jCellsOfNodeRPlus1<cellsOfNodeRPlus1.size(); jCellsOfNodeRPlus1++)
			{
				int jId = cellsOfNodeRPlus1[jCellsOfNodeRPlus1];
				int jCells = jId;
				int rNodesOfCellJ = Utils::indexOf(mesh->getNodesOfCell(jId),rId);
				Cjr(jCells,rNodesOfCellJ) = 1.0;
			}
		});
	}

public:
	void simulate()
	{
		std::cout << "Début de l'exécution du module Test" << std::endl;
		iniCjr(); // @-1.0
		iniCjrBad(); // @-1.0
		std::cout << "Fin de l'exécution du module Test" << std::endl;
	}	
};	

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto o = new Test::Options();
	auto gm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->LENGTH, o->LENGTH);
	auto nm = new NumericMesh2D(gm);
	auto c = new Test(o, nm);
	c->simulate();
	delete c;
	delete nm;
	delete gm;
	delete o;
	Kokkos::finalize();
	return 0;
}
