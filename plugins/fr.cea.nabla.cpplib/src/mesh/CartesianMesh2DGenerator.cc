/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/CartesianMesh2D.h"

namespace nablalib
{

CartesianMesh2D*
CartesianMesh2DGenerator::generate(int nbXQuads, int nbYQuads, double xSize, double ySize)
{
	vector<RealArray1D<2>> nodes_((nbXQuads + 1) * (nbYQuads + 1));
	vector<Quad> quads_(nbXQuads * nbYQuads);
	vector<Edge> edges_(2 * quads_.size() + nbXQuads + nbYQuads);

	vector<int> outer_node_ids_(2 * (nbXQuads + nbYQuads));
	vector<int> inner_node_ids_(nodes_.size() - outer_node_ids_.size());
	vector<int> top_node_ids_(nbXQuads + 1);
	vector<int> bottom_node_ids_(nbXQuads + 1);
	vector<int> left_node_ids_(nbYQuads + 1);
	vector<int> right_node_ids_(nbYQuads + 1);

	// node creation
	int node_id_(0);
	int inner_node_id_(0);
	int top_node_id_(0);
	int bottom_node_id_(0);
	int left_node_id_(0);
	int right_node_id_(0);
	int top_left_node_id_, top_right_node_id_, bottom_left_node_id_, bottom_right_node_id_;
	for (int j(0); j <= nbYQuads; ++j) {
		for (int i(0); i <= nbXQuads; ++i) {
			RealArray1D<2> tmp = { xSize * i, ySize * j };
			nodes_[node_id_] = move(tmp);
			if (i!=0 && j!=0 && i!=nbXQuads && j!=nbYQuads)
				inner_node_ids_[inner_node_id_++] = node_id_;
			else
			{
				if (j==0) bottom_node_ids_[bottom_node_id_++] = node_id_;
				if (j==nbYQuads) top_node_ids_[top_node_id_++] = node_id_;
				if (i==0) left_node_ids_[left_node_id_++] = node_id_;
				if (i==nbXQuads) right_node_ids_[right_node_id_++] = node_id_;
				if (i==0 && j==0) bottom_left_node_id_ = node_id_;
				if (i==nbXQuads && j==0) bottom_right_node_id_ = node_id_;
				if (i==0 && j==nbYQuads) top_left_node_id_ = node_id_;
				if (i==nbXQuads && j==nbYQuads) top_right_node_id_ = node_id_;
			}
			++node_id_;
		}
	}

	// edge creation
	const int nb_x_nodes_(nbXQuads + 1);
	int edge_id_(0);
	for (int i(0); i < nodes_.size(); ++i)	{
		const int right_node_index_(i + 1);
		if (right_node_index_ % nb_x_nodes_!=0)
		  edges_[edge_id_++] = move(Edge(i, right_node_index_));
		const int below_node_index_(i + nb_x_nodes_);
		if (below_node_index_ < nodes_.size())
		  edges_[edge_id_++] = Edge(i, below_node_index_);
	}

	// quad creation
	int quad_id_(0);
	for (int j(0); j < nbYQuads; ++j) {
		for (int i(0); i < nbXQuads; ++i) {
			const int upper_left_node_index_((j * nb_x_nodes_) + i);
			const int lower_left_node_index_(upper_left_node_index_ + nb_x_nodes_);
			quads_[quad_id_++] = move(Quad(upper_left_node_index_, upper_left_node_index_ + 1,
			                                      lower_left_node_index_ + 1, lower_left_node_index_));
		}
	}

	auto mesh_geometry = new MeshGeometry<2>(nodes_, edges_, quads_);
	return new CartesianMesh2D(
		mesh_geometry, 
		inner_node_ids_, 
		top_node_ids_, 
		bottom_node_ids_, 
		left_node_ids_, 
		right_node_ids_,
		top_left_node_id_,
		top_right_node_id_,
		bottom_left_node_id_,
		bottom_right_node_id_);
}

}
