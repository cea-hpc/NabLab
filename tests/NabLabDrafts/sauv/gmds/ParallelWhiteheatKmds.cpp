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

// GMDS math lib
#include <GMDS/Math/VectorND.h>
#include <GMDS/Math/Matrix.h>
// Project headers
#include "ParallelNumericMesh2D.h"
#include "CartesianMesh2DGenerator.h"

typedef gmds::math::VectorND<nablalib::ParallelNumericMesh2D::MaxNbNodesPerCell,double> NodesOfCellArray;

namespace kmds
{
template <> void
Variable<nablalib::Real2>::initialize(const TCellID AI)
{
	m_data(AI) = nablalib::Real2();
}
template <> void
Variable<NodesOfCellArray>::initialize(const TCellID AI)
{
	m_data(AI) = gmds::math::VectorND<nablalib::ParallelNumericMesh2D::MaxNbNodesPerCell,double>();
}
}

using namespace nablalib;

class ParallelWhiteheatKmds
{
public:
	// Options
	double LENGTH = 1.0;
	int X_EDGE_ELEMS = 8;
	int Y_EDGE_ELEMS = 8;
	int Z_EDGE_ELEMS = 1;
	double option_stoptime = 0.1;
	int option_max_iterations = 48;

private:
	// Mesh
	ParallelNumericMesh2D mesh;
	int nbNodes, nbCells, nbFaces;

	// Global Variables
	double t, delta_t, t_n_plus_1;

	// Node Variables
	kmds::Variable<Real2>* X;

	// Cell Variables
	kmds::Variable<double>* u;
	kmds::Variable<Real2>* center;
	kmds::Variable<double>* V;
	kmds::Variable<double>* f;
	kmds::Variable<double>* tmp;
	kmds::Variable<double>* u_n_plus_1;
	kmds::Variable<NodesOfCellArray>* C_ic; // inutile pour whiteheat, juste pour faire une double boucle

	// Face Variables
	kmds::Variable<double>* surface;

public:
	ParallelWhiteheatKmds()
	{
		// Kokkos::Serial::initialize();
		// Kokkos::Threads::initialize();
		// Kokkos::InitArguments kargs;
		// kargs.num_threads = 3;
		int num_threads = 4;
		int use_numa = 1;
		int use_core = 1;
		Kokkos::OpenMP::initialize(num_threads, use_numa, use_core);
		//Kokkos::initialize(kargs);

		// Mesh allocation
		CartesianMesh2DGenerator::generate(&mesh, X_EDGE_ELEMS, Y_EDGE_ELEMS, LENGTH, LENGTH);

		// Create connectivity
		kmds::ConnectivityHelper ch(&mesh);
		kmds::Connectivity* N2F = mesh.createConnectivity(kmds::N2F);
		ch.buildN2F();
		//mesh.createEdges();
		//kmds::Connectivity* F2E = mesh.createConnectivity(kmds::F2E);
		//ch.buildF2E();

		// Node variables
		X = mesh.createVariable<Real2>(kmds::KMDS_NODE, "X");

		// Cell Variables
		u = mesh.createVariable<double>(kmds::KMDS_FACE, "u");
		center = mesh.createVariable<Real2>(kmds::KMDS_FACE, "center");
		V = mesh.createVariable<double>(kmds::KMDS_FACE, "V");
		f = mesh.createVariable<double>(kmds::KMDS_FACE, "f");
		tmp = mesh.createVariable<double>(kmds::KMDS_FACE, "tmp");
		u_n_plus_1 = mesh.createVariable<double>(kmds::KMDS_FACE, "u_n_plus_1");
		C_ic = mesh.createVariable<NodesOfCellArray>(kmds::KMDS_FACE, "C_ic"); // inutile pour whiteheat, juste pour faire une double boucle

		// Face Variables
		surface = mesh.createVariable<double>(kmds::KMDS_EDGE, "surface");
	}

	~ParallelWhiteheatKmds()
	{
		// Kokkos::Serial::finalize();
		// Kokkos::Threads::finalize();
		Kokkos::OpenMP::finalize();
		// Kokkos::finalize();
	}

private:
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
	 * Job IniF @-1.0
	 * In variables:
	 * Out variables: f
	 */
	void iniF()
	{
	    // kmds::GrowingView<kmds::TCellID> cells("CELLS", mesh.getNbFaces());
	    // mesh.getFaceIDs(&cells);
		Kokkos::parallel_for(mesh.getNbCells(), KOKKOS_LAMBDA(const int jCells)
		{
			(*f)[jCells] = 0.0;
		});
	}
	
	// delta_t = 1/4 * ∑{j in cells()}(V{j})
	void bidonVolume()
	{
	    // kmds::GrowingView<kmds::TCellID> cells("CELLS", mesh.getNbFaces());
	    // mesh.getFaceIDs(&cells);
		double sum = 0.0;
		Kokkos::parallel_reduce(mesh.getNbCells(), KOKKOS_LAMBDA(const int jCells, double& s)
		{
			s+= (*V)[jCells];
		}, sum);
		double bidon = 1/4 * sum;
	}

	// forall j in cells(),forall r in nodesOfCell(j), C_ic{j,r} = 0.5 * norm(X{r});
	void bidonDoubleBoucle()
	{
	    // kmds::GrowingView<kmds::TCellID> cells("CELLS", mesh.getNbFaces());
	    // mesh.getFaceIDs(&cells);
		Kokkos::parallel_for(mesh.getNbCells(), KOKKOS_LAMBDA(const int jCells)
		{
			Kokkos::View<TCellID*> nodesOfCell;
			mesh.getNodesOfCell(jCells, nodesOfCell);
			for (auto rNodesOfCell=0; rNodesOfCell<nodesOfCell.size(); rNodesOfCell++)
			{
				int rId = nodesOfCell(rNodesOfCell);
				int rNodes = rId; // int rNodes = nodes.indexOf(rId);
				(*C_ic)[jCells][rNodesOfCell] = 0.5 * norm((*X)[rNodes]);
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
	    // kmds::GrowingView<kmds::TCellID> cells("CELLS", mesh.getNbFaces());
	    // mesh.getFaceIDs(&cells);
		Kokkos::parallel_for(mesh.getNbCells(), KOKKOS_LAMBDA(const int jCells)
		{
			Kokkos::View<TCellID*> nodesOfCell;
			mesh.getNodesOfCell(jCells, nodesOfCell);
			Real2 sum1;
			for (auto rNodesOfCell=0; rNodesOfCell<nodesOfCell.size(); rNodesOfCell++)
			{
				int rId = nodesOfCell(rNodesOfCell);
				int rNodes = rId; // int rNodes = nodes.indexOf(rId);
				sum1 += (*X)[rNodes];
			}
			(*center)[jCells] = 0.25 * sum1;
		});
	}

	/**
	 * Job ComputeV @-1.0
	 * In variables: X
	 * Out variables: V
	 */
	void computeV()
	{
	    // kmds::GrowingView<kmds::TCellID> cells("CELLS", mesh.getNbFaces());
	    // mesh.getFaceIDs(&cells);
		Kokkos::parallel_for(mesh.getNbCells(), KOKKOS_LAMBDA(const int jCells)
		{
			Kokkos::View<TCellID*> nodesOfCell;
			mesh.getNodesOfCell(jCells, nodesOfCell);
			double sum1 = 0.0;
			for (auto rNodesOfCell=0; rNodesOfCell<nodesOfCell.size(); rNodesOfCell++)
			{
				int rId = nodesOfCell(rNodesOfCell);
				int rNodes = rId; // int rNodes = nodes.indexOf(rId);
				int nextRNodesOfCell = (rNodesOfCell+1+nodesOfCell.size())%nodesOfCell.size();
				int nextRId = nodesOfCell(nextRNodesOfCell);
				int nextRNodes = nextRId; // int nextRNodes = nodes.indexOf(nextRId);
				sum1 += det((*X)[rNodes],(*X)[nextRNodes]);
			}
			(*V)[jCells] = 0.5 * sum1;
		});
	}

	/**
	 * Job ComputeSurface @-1.0
	 * In variables: X
	 * Out variables: surface
	 */
	void computeSurface()
	{
	    // kmds::GrowingView<kmds::TCellID> faces("CELLS", mesh.getNbEdges());
	    // mesh.getEdgeIDs(&faces);
		Kokkos::parallel_for(mesh.getNbFaces(), KOKKOS_LAMBDA(const int fFaces)
		{
			Kokkos::View<TCellID*> nodesOfFace;
			mesh.getNodesOfFace(fFaces, nodesOfFace);
			double sum1;
			for (auto rNodesOfFace=0; rNodesOfFace<nodesOfFace.size(); rNodesOfFace++)
			{
				int rId = nodesOfFace(rNodesOfFace);
				int rNodes = rId; // int rNodes = nodes.indexOf(rId);
				int nextRNodesOfFace = (rNodesOfFace+1+nodesOfFace.size())%nodesOfFace.size();
				int nextRId = nodesOfFace(nextRNodesOfFace);
				int nextRNodes = nextRId; // int nextRNodes = nodes.indexOf(nextRId);
				sum1 += norm((*X)[rNodes] - (*X)[nextRNodes]);
			}
			(*surface)[fFaces] = 0.5 * sum1;
		});
	}

	/**
	 * Job Init_ComputeUnPlus1 @-1.0
	 * In variables:
	 * Out variables: u
	 */
	void init_ComputeUn()
	{
	    // kmds::GrowingView<kmds::TCellID> cells("CELLS", mesh.getNbFaces());
	    // mesh.getFaceIDs(&cells);
		Kokkos::parallel_for(mesh.getNbCells(), KOKKOS_LAMBDA(const int jCells)
		{
			(*u)[jCells] = 0.0;
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
	 * In variables: delta_t, V, u, center, surface
	 * Out variables: tmp
	 */
	void computeTmp()
	{
	    // kmds::GrowingView<kmds::TCellID> cells("CELLS", mesh.getNbFaces());
	    // mesh.getFaceIDs(&cells);
		Kokkos::parallel_for(mesh.getNbCells(), KOKKOS_LAMBDA(const int j1Cells)
		{
			Kokkos::View<TCellID*> neighbourCells;
			mesh.getNeighbourCells(j1Cells, neighbourCells);
			int j1Id = j1Cells; // int j1Id = cells(j1Cells);
			double sum1;
			for (auto j2NeighbourCells=0; j2NeighbourCells<neighbourCells.size(); j2NeighbourCells++)
			{
				int j2Id = neighbourCells(j2NeighbourCells);
				int j2Cells = j2Id; // int j2Cells = cells.indexOf(j2Id);
				sum1 += (((*u)[j2Cells] - (*u)[j1Cells]) / (norm((*center)[j2Cells] -(*center)[j1Cells])) * (*surface)[mesh.getCommonFace(j1Id, j2Id)]);
			}
			(*tmp)[j1Cells] = delta_t / (*V)[j1Cells] * sum1;
		});
	}


	/**
	 * Job Compute_ComputeUnPlus1 @2.0
	 * In variables: f, delta_t, u, tmp
	 * Out variables: u_n_plus_1
	 */
	void compute_ComputeUn()
	{
	    // kmds::GrowingView<kmds::TCellID> cells("CELLS", mesh.getNbFaces());
	    // mesh.getFaceIDs(&cells);
		Kokkos::parallel_for(mesh.getNbCells(), KOKKOS_LAMBDA(const int jCells)
		{
			(*u_n_plus_1)[jCells] = (*f)[jCells] * delta_t + (*u)[jCells] + (*tmp)[jCells];
		});
	}

	/**
	 * Job Copy_u_n_plus_1_to_u @3.0
	 * In variables: u_n_plus_1
	 * Out variables: u
	 */
	void copy_u_n_plus_1_to_u()
	{
		kmds::Variable<double>* tmpSwitch = u;
		u = u_n_plus_1;
		u_n_plus_1 = tmpSwitch;
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
		double tmpSwitch = t;
		t = t_n_plus_1;
		t_n_plus_1 = tmpSwitch;
	}

		
public:
	void simulate()
	{
		std::cout << "Début de l'exécution du module whiteheat" << std::endl;
		init_delta_t(); // @-1.0
		iniF(); // @-1.0
		iniCenter(); // @-1.0
		computeV(); // @-1.0
		computeSurface(); // @-1.0
		init_ComputeUn(); // @-1.0
		init_ComputeTn(); // @-1.0

		int iteration = 0;
		while (t < option_stoptime && iteration < option_max_iterations)
		{
			std::cout << "A t = " << t << std::endl;
			iteration++;
			computeTmp();
			compute_ComputeTn();
			copy_t_n_plus_1_to_t();
			compute_ComputeUn();
			std::cout << "Val de u[0] = " << (*u)[0] << std::endl;
			copy_u_n_plus_1_to_u();
		}
		std::cout << "Fin de l'exécution du module whiteheat" << std::endl;
	}
};

int main() 
{
	ParallelWhiteheatKmds i;
	i.simulate();
}
