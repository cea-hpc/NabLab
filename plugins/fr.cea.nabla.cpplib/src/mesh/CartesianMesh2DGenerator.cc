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
  
  /*
   *  15---16---17---18---19          |-27-|-28-|-29-|-30-|
   *   | 8  | 9  | 10 | 11 |         19   21   23   25   26
   *  10---11---12---13---14          |-18-|-20-|-22-|-24-|
   *   | 4  | 5  | 6  | 7  |         10   12   14   16   17
   *   5----6----7----8----9          |--9-|-11-|-13-|-15-|
   *   | 0  | 1  | 2  | 3  |          1    3    5    7    8
   *   0----1----2----3----4          |-0--|-2--|-4--|-6--|
   */

CartesianMesh2D*
CartesianMesh2DGenerator::generate(size_t nbXQuads, size_t nbYQuads, double xSize, double ySize)
{
	vector<RealArray1D<2>> nodes_((nbXQuads + 1) * (nbYQuads + 1));
	vector<Quad> quads_(nbXQuads * nbYQuads);
	vector<Edge> edges_(2 * quads_.size() + nbXQuads + nbYQuads);

	vector<Id> outer_node_ids_(2 * (nbXQuads + nbYQuads));
	vector<Id> inner_node_ids_(nodes_.size() - outer_node_ids_.size());
	vector<Id> top_node_ids_(nbXQuads + 1);
	vector<Id> bottom_node_ids_(nbXQuads + 1);
	vector<Id> left_node_ids_(nbYQuads + 1);
	vector<Id> right_node_ids_(nbYQuads + 1);

	//test guillaume

	vector<Id> inner_cells_ids_((nbXQuads - 2)*(nbYQuads - 2));
	vector<Id> outer_cells_ids_( 2 * nbXQuads + 2 * (nbYQuads - 2));

	vector<Id> top_row_cells_(nbXQuads);
	vector<Id> bottom_row_cells_(nbXQuads);
	vector<Id> left_column_cells_(nbYQuads);
	vector<Id> right_column_cells_(nbYQuads);
	//fin test

	// node creation
	Id node_id_(0);
	Id inner_node_id_(0);
	Id top_node_id_(0);
	Id bottom_node_id_(0);
	Id left_node_id_(0);
	Id right_node_id_(0);
	Id top_left_node_id_(0);
	Id top_right_node_id_(0);
	Id bottom_left_node_id_(0);
	Id bottom_right_node_id_(0);
  
	for(size_t j(0); j <= nbYQuads; ++j) {
		for(size_t i(0); i <= nbXQuads; ++i) {
			nodes_[node_id_] = RealArray1D<2>{xSize * i, ySize * j};
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
	const size_t nb_x_nodes_(nbXQuads + 1);
	Id edge_id_(0);
	for(size_t i(0); i < nodes_.size(); ++i)	{
		const size_t right_node_index_(i + 1);
		if (right_node_index_ % nb_x_nodes_ != 0)
		  edges_[edge_id_++] = move(Edge(static_cast<Id>(i), right_node_index_));
		const size_t above_node_index_(i + nb_x_nodes_);
		if (above_node_index_ < nodes_.size())
		  edges_[edge_id_++] = Edge(static_cast<Id>(i), above_node_index_);
	}

	// quad creation
	Id quad_id_(0);
	Id inner_id_(0);
	Id outer_id_(0);
	Id left_id_(0);
	Id right_id_(0);
	Id top_id_(0);
	Id bottom_id_(0);
	for(size_t j(0); j < nbYQuads; ++j) {
		for(size_t i(0); i < nbXQuads; ++i) {
			if( (i != 0) && (i != nbXQuads - 1) && (j != 0) && (j!= nbYQuads - 1) )
			{
				inner_cells_ids_[inner_id_++] = quad_id_;
			}
			else
			{
				outer_cells_ids_[outer_id_++] = quad_id_;
				if (i == 0) {left_column_cells_[left_id_++] = quad_id_;}
				if (i == nbXQuads - 1) {right_column_cells_[right_id_++] = quad_id_;}
				if (j == 0) {bottom_row_cells_[bottom_id_++] = quad_id_;}
				if (j == nbYQuads - 1) {top_row_cells_[top_id_++] = quad_id_;}
			}
			const size_t upper_left_node_index_((j * static_cast<size_t>(nb_x_nodes_)) + i);
			const size_t lower_left_node_index_(upper_left_node_index_ + static_cast<size_t>(nb_x_nodes_));
			quads_[quad_id_++] = move(Quad(upper_left_node_index_, upper_left_node_index_ + 1,
                                     lower_left_node_index_ + 1, lower_left_node_index_));
		}
	}

	auto mesh_geometry = new MeshGeometry<2>(nodes_, edges_, quads_);
	return new CartesianMesh2D(mesh_geometry, inner_node_ids_, 
		                         top_node_ids_, bottom_node_ids_, 
		                         left_node_ids_, right_node_ids_,
		                         top_left_node_id_, top_right_node_id_,
		                         bottom_left_node_id_, bottom_right_node_id_,
								 inner_cells_ids_, outer_cells_ids_,
								 top_row_cells_, bottom_row_cells_,
								 left_column_cells_,right_column_cells_);
}

}
