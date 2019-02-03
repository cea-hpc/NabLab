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
		int X_EDGE_ELEMS = 8;
		int Y_EDGE_ELEMS = 8;
		int Z_EDGE_ELEMS = 1;
		double option_stoptime = 0.1;
		int option_max_iterations = 48;
	};

private:
	Options* options;
	NumericMesh2D* mesh;
	VtkFileWriter2D writer;
	int nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbNeighbourCells;

	// Global Variables
	double t, deltat, t_n_plus_1;

	// Array Variables
	Kokkos::View<Real2*> coord;
	Kokkos::View<Real2*> center;
	Kokkos::View<double*> u;
	Kokkos::View<double*> V;
	Kokkos::View<double*> f;
	Kokkos::View<double*> tmp;
	Kokkos::View<double*> surface;
	Kokkos::View<double*> u_n_plus_1;

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
	, coord("coord", nbNodes)
	, center("center", nbCells)
	, u("u", nbCells)
	, V("V", nbCells)
	, f("f", nbCells)
	, tmp("tmp", nbCells)
	, surface("surface", nbFaces)
	, u_n_plus_1("u_n_plus_1", nbCells)
	{
		// Copy node coordinates
		auto gNodes = mesh->getGeometricMesh()->getNodes();
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			coord(rNodes) = gNodes[rNodes];
		});
	}

private:
	/**
	 * Job IniF @-1.0
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
	 * Job IniCenter @-1.0
	 * In variables: coord
	 * Out variables: center
	 */
	void iniCenter()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			Real2 sum30378343 = Real2(0.0, 0.0);
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum30378343 = sum30378343 + (coord(rNodes));
			}
			center(jCells) = 0.25 * sum30378343;
		});
	}
	
	/**
	 * Job ComputeV @-1.0
	 * In variables: coord
	 * Out variables: V
	 */
	void computeV()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum1610638964 = 0.0;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int nextRNodesOfCellJ = (rNodesOfCellJ+1+nodesOfCellJ.size())%nodesOfCellJ.size();
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int nextRId = nodesOfCellJ[nextRNodesOfCellJ];
				int rNodes = rId;
				int nextRNodes = nextRId;
				sum1610638964 = sum1610638964 + (MathFunctions::det(coord(rNodes), coord(nextRNodes)));
			}
			V(jCells) = 0.5 * sum1610638964;
		});
	}
	
	/**
	 * Job ComputeSurface @-1.0
	 * In variables: coord
	 * Out variables: surface
	 */
	void computeSurface()
	{
		Kokkos::parallel_for(nbFaces, KOKKOS_LAMBDA(const int fFaces)
		{
			int fId = fFaces;
			double sum173302234 = 0.0;
			auto nodesOfFaceF = mesh->getNodesOfFace(fId);
			for (int rNodesOfFaceF=0; rNodesOfFaceF<nodesOfFaceF.size(); rNodesOfFaceF++)
			{
				int nextRNodesOfFaceF = (rNodesOfFaceF+1+nodesOfFaceF.size())%nodesOfFaceF.size();
				int rId = nodesOfFaceF[rNodesOfFaceF];
				int nextRId = nodesOfFaceF[nextRNodesOfFaceF];
				int rNodes = rId;
				int nextRNodes = nextRId;
				sum173302234 = sum173302234 + (MathFunctions::norm(coord(rNodes) - coord(nextRNodes)));
			}
			surface(fFaces) = 0.5 * sum173302234;
		});
	}
	
	/**
	 * Job Init_ComputeUn @-1.0
	 * In variables: 
	 * Out variables: u
	 */
	void init_ComputeUn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int j0Cells)
		{
			u(j0Cells) = 0.0;
		});
	}
	
	/**
	 * Job Init_ComputeTn @-1.0
	 * In variables: 
	 * Out variables: t
	 */
	void init_ComputeTn()
	{
		t = 0.0;
	}
	
	/**
	 * Job ComputeTmp @1.0
	 * In variables: u, center, surface, deltat, V
	 * Out variables: tmp
	 */
	void computeTmp()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int j1Cells)
		{
			int j1Id = j1Cells;
			double sum225181829 = 0.0;
			auto neighbourCellsJ1 = mesh->getNeighbourCells(j1Id);
			for (int j2NeighbourCellsJ1=0; j2NeighbourCellsJ1<neighbourCellsJ1.size(); j2NeighbourCellsJ1++)
			{
				int j2Id = neighbourCellsJ1[j2NeighbourCellsJ1];
				int j2Cells = j2Id;
				sum225181829 = sum225181829 + ((u(j2Cells) - u(j1Cells)) / (MathFunctions::norm(center(j2Cells) - center(j1Cells)) * surface(mesh->getCommonFace(j1Id,j2Id))));
			}
			tmp(j1Cells) = deltat / V(j1Cells) * sum225181829;
		});
	}
	
	/**
	 * Job Compute_ComputeTn @1.0
	 * In variables: t, deltat
	 * Out variables: t_n_plus_1
	 */
	void compute_ComputeTn()
	{
		t_n_plus_1 = t + deltat;
	}
	
	/**
	 * Job Copy_t_n_plus_1_to_t @2.0
	 * In variables: t_n_plus_1
	 * Out variables: t
	 */
	void copy_t_n_plus_1_to_t()
	{
		auto tmpSwitch = t;
		t = t_n_plus_1;
		t_n_plus_1 = tmpSwitch;
	}
	
	/**
	 * Job Compute_ComputeUn @2.0
	 * In variables: f, deltat, u, tmp
	 * Out variables: u_n_plus_1
	 */
	void compute_ComputeUn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			u_n_plus_1(jCells) = f(jCells) * deltat + u(jCells) + tmp(jCells);
		});
	}
	
	/**
	 * Job Copy_u_n_plus_1_to_u @3.0
	 * In variables: u_n_plus_1
	 * Out variables: u
	 */
	void copy_u_n_plus_1_to_u()
	{
		auto tmpSwitch = u;
		u = u_n_plus_1;
		u_n_plus_1 = tmpSwitch;
	}

public:
	void simulate()
	{
		std::cout << "Début de l'exécution du module Whiteheat" << std::endl;
		iniF(); // @-1.0
		iniCenter(); // @-1.0
		computeV(); // @-1.0
		computeSurface(); // @-1.0
		init_ComputeUn(); // @-1.0
		init_ComputeTn(); // @-1.0

		int iteration = 0;
		while (t < options->option_stoptime && iteration < options->option_max_iterations)
		{
			std::cout << "A t = " << t << std::endl;
			iteration++;
			computeTmp(); // @1.0
			compute_ComputeTn(); // @1.0
			copy_t_n_plus_1_to_t(); // @2.0
			compute_ComputeUn(); // @2.0
			copy_u_n_plus_1_to_u(); // @3.0
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
