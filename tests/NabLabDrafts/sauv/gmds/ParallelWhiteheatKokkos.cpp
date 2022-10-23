/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include <iostream>

// Kokkos headers
#include <Kokkos_Core.hpp>

// Project headers
#include "mesh/NumericMesh2D.h"
#include "mesh/CartesianMesh2DGenerator.h"
#include "types/MathFunctions.h"

using namespace nablalib;

class ParallelWhiteheatKokkos
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
	int nbNodes, nbCells, nbFaces, nbNodesOfCell;

	// Global Variables
	double t, delta_t, t_n_plus_1;

	// Array Variables
	Kokkos::View<Real2*> X;
	Kokkos::View<Real2*> center;
	Kokkos::View<double*> u;
	Kokkos::View<double*> V;
	Kokkos::View<double*> f;
	Kokkos::View<double*> tmp;
	Kokkos::View<double*> surface;
	Kokkos::View<double*> u_n_plus_1;
	Kokkos::View<double**> C_ic; // inutile pour whiteheat, juste pour faire une double boucle

public:
	ParallelWhiteheatKokkos(Options* o, NumericMesh2D* m)
	: options(o)
	, mesh(m)
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbFaces(mesh->getNbFaces())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, X("X", nbNodes)
	, center("center", nbCells)
	, u("u", nbCells)
	, V("V", nbCells)
	, f("f", nbCells)
	, tmp("tmp", nbCells)
	, surface("surface", nbFaces)
	, u_n_plus_1("u_n_plus_1", nbCells)
	, C_ic("C_ic", nbCells, nbNodesOfCell)
	{
		// Copy node coordinates
		auto gNodes = m->getGeometricMesh()->getNodes();
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			X(rNodes) = gNodes[rNodes];
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
	
	// delta_t = 1/4 * ∑{j in cells()}(V{j})
	void bidonVolume()
	{
		double sum = 0.0;
		Kokkos::parallel_reduce(nbCells, KOKKOS_LAMBDA(const int jCells, double& s)
		{
			s+= V(jCells);
		}, sum);
		double bidon = 1/4 * sum;
	}

	// forall j in cells(),forall r in nodesOfCell(j), C_ic{j,r} = 0.5 * norm(X{r});
	void bidonDoubleBoucle()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			auto nodesOfCell = mesh->getNodesOfCell(jCells);
			for (auto rNodesOfCell=0; rNodesOfCell<nodesOfCell.size(); rNodesOfCell++)
			{
				int rId = nodesOfCell[rNodesOfCell];
				int rNodes = rId;
				C_ic(jCells, rNodesOfCell) = 0.5 * MathFunctions::norm(X(rNodes));
			}
		});
	}
	
	/**
	 * Job IniCenter @-1.0
	 * In variables: X
	 * Out variables: center
	 */
	void iniCenter()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			Real2 sum1 = Real2(0.0, 0.0);
			auto nodesOfCell = mesh->getNodesOfCell(jId);
			for (int rNodesOfCell=0; rNodesOfCell<nodesOfCell.size(); rNodesOfCell++)
			{
				int rId = nodesOfCell[rNodesOfCell];
				int rNodes = rId;
				sum1 += X(rNodes);
			}
			center(jCells) = 0.25 * sum1;
		});
	}
	
	/**
	 * Job ComputeV @-1.0
	 * In variables: X
	 * Out variables: V
	 */
	void computeV()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum1 = 0.0;
			auto nodesOfCell = mesh->getNodesOfCell(jId);
			for (int rNodesOfCell=0; rNodesOfCell<nodesOfCell.size(); rNodesOfCell++)
			{
				int nextRNodesOfCell = (rNodesOfCell+1+nodesOfCell.size())%nodesOfCell.size();
				int rId = nodesOfCell[rNodesOfCell];
				int nextRId = nodesOfCell[nextRNodesOfCell];
				int rNodes = rId;
				int nextRNodes = nextRId;
				sum1 += MathFunctions::det(X(rNodes), X(nextRNodes));
			}
			V(jCells) = 0.5 * sum1;
		});
	}
	
	/**
	 * Job ComputeSurface @-1.0
	 * In variables: X
	 * Out variables: surface
	 */
	void computeSurface()
	{
		Kokkos::parallel_for(nbFaces, KOKKOS_LAMBDA(const int fFaces)
		{
			int fId = fFaces;
			double sum1 = 0.0;
			auto nodesOfFace = mesh->getNodesOfFace(fId);
			for (int rNodesOfFace=0; rNodesOfFace<nodesOfFace.size(); rNodesOfFace++)
			{
				int nextRNodesOfFace = (rNodesOfFace+1+nodesOfFace.size())%nodesOfFace.size();
				int rId = nodesOfFace[rNodesOfFace];
				int nextRId = nodesOfFace[nextRNodesOfFace];
				int rNodes = rId;
				int nextRNodes = nextRId;
				sum1 += MathFunctions::norm(X(rNodes) - X(nextRNodes));
			}
			surface(fFaces) = 0.5 * sum1;
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
	 * Job Init_deltat @-1.0
	 * In variables: 
	 * Out variables: delta_t
	 */
	void init_deltat()
	{
		delta_t = 0.001;
	}

	/**
	 * Job ComputeTmp @1.0
	 * In variables: u, center, surface, delta_t, V
	 * Out variables: tmp
	 */
	void computeTmp()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int j1Cells)
		{
			int j1Id = j1Cells;
			double sum1 = 0.0;
			auto neighbourCells = mesh->getNeighbourCells(j1Id);
			for (int j2NeighbourCells=0; j2NeighbourCells<neighbourCells.size(); j2NeighbourCells++)
			{
				int j2Id = neighbourCells[j2NeighbourCells];
				int j2Cells = j2Id;
				sum1 += ((u(j2Cells) - u(j1Cells)) / (MathFunctions::norm(center(j2Cells) - center(j1Cells))) * surface(mesh->getCommonFace(j1Id, j2Id)));
			}
			tmp(j1Cells) = delta_t / V(j1Cells) * sum1;
		});
	}
	
	/**
	 * Job Compute_ComputeTn @1.0
	 * In variables: t, delta_t
	 * Out variables: t_n_plus_1
	 */
	void compute_ComputeTn()
	{
		t_n_plus_1 = t + delta_t;
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
	 * In variables: f, delta_t, u, tmp
	 * Out variables: u_n_plus_1
	 */
	void compute_ComputeUn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			u_n_plus_1(jCells) = f(jCells) * delta_t + u(jCells) + tmp(jCells);
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
		std::cout << "Début de l'exécution du module whiteheat" << std::endl;
		iniF(); // @-1.0
		iniCenter(); // @-1.0
		computeV(); // @-1.0
		computeSurface(); // @-1.0
		init_ComputeUn(); // @-1.0
		init_ComputeTn(); // @-1.0
		init_deltat(); // @-1.0

		int iteration = 0;
		while (t < options->option_stoptime && iteration < options->option_max_iterations)
		{
			std::cout << "A t = " << t << std::endl;
			iteration++;
			computeTmp();
			compute_ComputeTn();
			copy_t_n_plus_1_to_t();
			compute_ComputeUn();
			std::cout << "Val de u[0] = " << u(0) << std::endl;
			copy_u_n_plus_1_to_u();
		}
		std::cout << "Fin de l'exécution du module whiteheat" << std::endl;
	}
};

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto options = new ParallelWhiteheatKokkos::Options();
	auto geometricMesh = CartesianMesh2DGenerator::generate(options->X_EDGE_ELEMS, options->Y_EDGE_ELEMS, options->LENGTH, options->LENGTH);
	auto numericMesh = new NumericMesh2D(geometricMesh);
	ParallelWhiteheatKokkos c(options, numericMesh);
	c.simulate();
	delete numericMesh;
	delete geometricMesh;
	delete options;
	Kokkos::finalize();
}
