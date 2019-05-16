/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/Mesh.h"

namespace nablalib
{

Mesh<Real2>*
CartesianMesh2DGenerator::generate(int nbXQuads, int nbYQuads, double xSize, double ySize)
{
	const int nb_nodes_((nbXQuads + 1) * (nbYQuads + 1));
	const int nb_quads_(nbXQuads * nbYQuads);
	const int nb_edges_(2 * nb_quads_ + nbXQuads + nbYQuads);
	const int nb_outer_nodes_(2 * (nbXQuads + nbYQuads));
	const int nb_inner_nodes_(nb_nodes_ - nb_outer_nodes_);
	Mesh<Real2>* mesh(new Mesh<Real2>(nb_nodes_, nb_edges_, nb_quads_, nb_inner_nodes_));

	// node creation
	int node_id_(0);
	int inner_node_id_(0);
	for (int j(0); j <= nbYQuads; ++j) {
		for (int i(0); i <= nbXQuads; ++i) {
		  mesh->m_nodes[node_id_] = move(Real2(xSize * i, ySize * j));
			if (i!=0 && j!=0 && i!=nbXQuads && j!=nbYQuads)
				mesh->m_innerNodeIds[inner_node_id_++] = node_id_;
			++node_id_;
		}
	}

	// edge creation
	const int nb_x_nodes_(nbXQuads + 1);
	int edge_id_(0);
	for (int i(0); i < mesh->m_nodes.size(); ++i)	{
		const int right_node_index_(i + 1);
		if (right_node_index_ % nb_x_nodes_!=0)
		  mesh->m_edges[edge_id_++] = move(Edge(i, right_node_index_));
		const int below_node_index_(i + nb_x_nodes_);
		if (below_node_index_ < mesh->m_nodes.size())
		  mesh->m_edges[edge_id_++] = Edge(i, below_node_index_);
	}

	// quad creation
	int quad_id_(0);
	for (int j(0); j < nbYQuads; ++j) {
		for (int i(0); i < nbXQuads; ++i) {
			const int upper_left_node_index_((j * nb_x_nodes_) + i);
			const int lower_left_node_index_(upper_left_node_index_ + nb_x_nodes_);
			mesh->m_quads[quad_id_++] = move(Quad(upper_left_node_index_, upper_left_node_index_ + 1,
			                                      lower_left_node_index_ + 1, lower_left_node_index_));
		}
	}
	return mesh;
}

}
