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

class Whiteheat
{
public:
	struct Options
	{
		double LENGTH = 1.0;
		int X_EDGE_ELEMS = 10;
		int Y_EDGE_ELEMS = 10;
		int Z_EDGE_ELEMS = 1;
		double option_stoptime = 0.1;
		int option_max_iterations = 500;
		double PI = 3.1415926;
		double k = 1.0;
	};

private:
	Options* options;
	NumericMesh2D* mesh;
	VtkFileWriter2D writer;
	int nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbNeighbourCells;

	// Global Variables
	double t, deltat, t_nplus1;

	// Array Variables
	Kokkos::View<Real2*> X;
	Kokkos::View<Real2*> center;
	Kokkos::View<double*> u;
	Kokkos::View<double*> V;
	Kokkos::View<double*> f;
	Kokkos::View<double*> outgoingFlux;
	Kokkos::View<double*> surface;
	Kokkos::View<double*> u_nplus1;

public:
	Whiteheat(Options* aOptions, NumericMesh2D* aNumericMesh2D)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("Whiteheat")
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbFaces(mesh->getNbFaces())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, nbNodesOfFace(NumericMesh2D::MaxNbNodesOfFace)
	, nbNeighbourCells(NumericMesh2D::MaxNbNeighbourCells)
	, X("X", nbNodes)
	, center("center", nbCells)
	, u("u", nbCells)
	, V("V", nbCells)
	, f("f", nbCells)
	, outgoingFlux("outgoingFlux", nbCells)
	, surface("surface", nbFaces)
	, u_nplus1("u_nplus1", nbCells)
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
	 * Job IniF @-2.0
	 * In variables: 
	 * Out variables: f
	 */
	void iniF()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			f(jCells) = 0.0;
		});
	}
	
	/**
	 * Job IniCenter @-2.0
	 * In variables: X
	 * Out variables: center
	 */
	void iniCenter()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			Real2 sum162650163 = Real2(0.0, 0.0);
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum162650163 = sum162650163 + (X(rNodes));
			}
			center(jCells) = 0.25 * sum162650163;
		});
	}
	
	/**
	 * Job ComputeV @-2.0
	 * In variables: X
	 * Out variables: V
	 */
	void computeV()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum1902429391 = 0.0;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int nextRNodesOfCellJ = (rNodesOfCellJ+1+nodesOfCellJ.size())%nodesOfCellJ.size();
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int nextRId = nodesOfCellJ[nextRNodesOfCellJ];
				int rNodes = rId;
				int nextRNodes = nextRId;
				sum1902429391 = sum1902429391 + (MathFunctions::det(X(rNodes), X(nextRNodes)));
			}
			V(jCells) = 0.5 * sum1902429391;
		});
	}
	
	/**
	 * Job ComputeSurface @-2.0
	 * In variables: X
	 * Out variables: surface
	 */
	void computeSurface()
	{
		Kokkos::parallel_for(nbFaces, KOKKOS_LAMBDA(const int fFaces)
		{
			int fId = fFaces;
			double sum1056681343 = 0.0;
			auto nodesOfFaceF = mesh->getNodesOfFace(fId);
			for (int rNodesOfFaceF=0; rNodesOfFaceF<nodesOfFaceF.size(); rNodesOfFaceF++)
			{
				int nextRNodesOfFaceF = (rNodesOfFaceF+1+nodesOfFaceF.size())%nodesOfFaceF.size();
				int rId = nodesOfFaceF[rNodesOfFaceF];
				int nextRId = nodesOfFaceF[nextRNodesOfFaceF];
				int rNodes = rId;
				int nextRNodes = nextRId;
				sum1056681343 = sum1056681343 + (MathFunctions::norm(X(rNodes) - X(nextRNodes)));
			}
			surface(fFaces) = 0.5 * sum1056681343;
		});
	}
	
	/**
	 * Job IniUn @-1.0
	 * In variables: PI, k, center
	 * Out variables: u
	 */
	void iniUn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			u(jCells) = MathFunctions::cos(2 * options->PI * options->k * center(jCells).x);
		});
	}
	
	/**
	 * Job ComputeFlux @1.0
	 * In variables: u, center, surface, deltat, V
	 * Out variables: outgoingFlux
	 */
	void computeFlux()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int j1Cells)
		{
			int j1Id = j1Cells;
			double sum1427705561 = 0.0;
			auto neighbourCellsJ1 = mesh->getNeighbourCells(j1Id);
			for (int j2NeighbourCellsJ1=0; j2NeighbourCellsJ1<neighbourCellsJ1.size(); j2NeighbourCellsJ1++)
			{
				int j2Id = neighbourCellsJ1[j2NeighbourCellsJ1];
				int cfId = mesh->getCommonFace(j1Id,j2Id);
				int cfFaces = cfId;
				int j2Cells = j2Id;
				sum1427705561 = sum1427705561 + ((u(j2Cells) - u(j1Cells)) / MathFunctions::norm(center(j2Cells) - center(j1Cells)) * surface(cfFaces));
			}
			outgoingFlux(j1Cells) = deltat / V(j1Cells) * sum1427705561;
		});
	}
	
	/**
	 * Job ComputeTn @1.0
	 * In variables: t, deltat
	 * Out variables: t_nplus1
	 */
	void computeTn()
	{
		t_nplus1 = t + deltat;
	}
	
	/**
	 * Job Copy_t_nplus1_to_t @2.0
	 * In variables: t_nplus1
	 * Out variables: t
	 */
	void copy_t_nplus1_to_t()
	{
		auto tmpSwitch = t;
		t = t_nplus1;
		t_nplus1 = tmpSwitch;
	}
	
	/**
	 * Job ComputeUn @2.0
	 * In variables: f, deltat, u, outgoingFlux
	 * Out variables: u_nplus1
	 */
	void computeUn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			u_nplus1(jCells) = f(jCells) * deltat + u(jCells) + outgoingFlux(jCells);
		});
	}
	
	/**
	 * Job Copy_u_nplus1_to_u @3.0
	 * In variables: u_nplus1
	 * Out variables: u
	 */
	void copy_u_nplus1_to_u()
	{
		auto tmpSwitch = u;
		u = u_nplus1;
		u_nplus1 = tmpSwitch;
	}

public:
	void simulate()
	{
		std::cout << "Début de l'exécution du module Whiteheat" << std::endl;
		iniF(); // @-2.0
		iniCenter(); // @-2.0
		computeV(); // @-2.0
		computeSurface(); // @-2.0
		iniUn(); // @-1.0

		map<string, Kokkos::View<double*>> cellVariables;
		map<string, Kokkos::View<double*>> nodeVariables;
		cellVariables.insert(pair<string,Kokkos::View<double*>>("Temperature", u));
		int iteration = 0;
		while (t < options->option_stoptime && iteration < options->option_max_iterations)
		{
			iteration++;
			std::cout << "[" << iteration << "] t = " << t << std::endl;
			computeFlux(); // @1.0
			computeTn(); // @1.0
			copy_t_nplus1_to_t(); // @2.0
			computeUn(); // @2.0
			copy_u_nplus1_to_u(); // @3.0
			auto quads = mesh->getGeometricMesh()->getQuads();
			writer.writeFile(iteration, X, quads, cellVariables, nodeVariables);
		}
		std::cout << "Fin de l'exécution du module Whiteheat" << std::endl;
	}	
};	

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto o = new Whiteheat::Options();
	auto gm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->LENGTH, o->LENGTH);
	auto nm = new NumericMesh2D(gm);
	auto c = new Whiteheat(o, nm);
	c->simulate();
	delete c;
	delete nm;
	delete gm;
	delete o;
	Kokkos::finalize();
	return 0;
}
