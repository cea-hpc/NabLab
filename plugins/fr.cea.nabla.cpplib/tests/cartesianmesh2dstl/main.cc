/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/

#include <cassert>
#include "CartesianMesh2D.h"
#include "Utils.h"

int main()
{
	int nb_x_quads = 4;
	int nb_y_quads = 3;
	double x_size = 5.0;
	double y_size = 10.0;
	CartesianMesh2D mesh;
	mesh.create(nb_x_quads, nb_y_quads, x_size, y_size);

	vector<Id> expected_inner_nodes{6, 7, 8, 11, 12, 13};
	vector<Id> expected_outer_nodes{0, 1, 2, 3, 4, 5, 9, 10, 14, 15, 16, 17, 18, 19};
	vector<Id> expected_top_nodes{15, 16, 17, 18, 19};
	vector<Id> expected_bottom_nodes{0, 1, 2, 3, 4};
	vector<Id> expected_left_nodes{0, 5, 10, 15};
	vector<Id> expected_right_nodes{4, 9, 14, 19};

	assert(mesh.getGroup(CartesianMesh2D::InnerNodes) == expected_inner_nodes);
	assert(mesh.getGroup(CartesianMesh2D::OuterNodes) == expected_outer_nodes);
	assert(mesh.getGroup(CartesianMesh2D::TopNodes) == expected_top_nodes);
	assert(mesh.getGroup(CartesianMesh2D::BottomNodes) == expected_bottom_nodes);
	assert(mesh.getGroup(CartesianMesh2D::LeftNodes) == expected_left_nodes);
	assert(mesh.getGroup(CartesianMesh2D::RightNodes) == expected_right_nodes);

	vector<Id> expected_inner_cells{5, 6};
	vector<Id> expected_outer_cells{0, 1, 2, 3, 4, 7, 8, 9, 10, 11};
	vector<Id> expected_top_cells{8, 9, 10, 11};
	vector<Id> expected_bottom_cells{0, 1, 2, 3};
	vector<Id> expected_left_cells{0, 4, 8};
	vector<Id> expected_right_cells{3, 7, 11};

	assert(mesh.getGroup(CartesianMesh2D::InnerCells) == expected_inner_cells);
	assert(mesh.getGroup(CartesianMesh2D::OuterCells) == expected_outer_cells);
	assert(mesh.getGroup(CartesianMesh2D::TopCells) == expected_top_cells);
	assert(mesh.getGroup(CartesianMesh2D::BottomCells) == expected_bottom_cells);
	assert(mesh.getGroup(CartesianMesh2D::LeftCells) == expected_left_cells);
	assert(mesh.getGroup(CartesianMesh2D::RightCells) == expected_right_cells);

	vector<Id> expected_inner_faces{3, 5, 7, 9, 11, 12, 13, 14, 15, 16, 18, 20, 21, 22, 23, 24, 25};
	vector<Id> expected_outer_faces{0, 1, 2, 4, 6, 8, 10, 17, 19, 26, 27, 28, 29, 30};
	vector<Id> expected_inner_horizontal_faces{9, 11, 13, 15, 18, 20, 22, 24};
	vector<Id> expected_inner_vertical_faces{3, 5, 7, 12, 14, 16, 21, 23, 25};
	vector<Id> expected_top_faces{27, 28, 29, 30};
	vector<Id> expected_bottom_faces{0, 2, 4, 6};
	vector<Id> expected_left_faces{1, 10, 19};
	vector<Id> expected_right_faces{8, 17, 26};

	assert(mesh.getGroup(CartesianMesh2D::InnerFaces) == expected_inner_faces);
	assert(mesh.getGroup(CartesianMesh2D::OuterFaces) == expected_outer_faces);
	assert(mesh.getGroup(CartesianMesh2D::InnerHorizontalFaces) == expected_inner_horizontal_faces);
	assert(mesh.getGroup(CartesianMesh2D::InnerVerticalFaces) == expected_inner_vertical_faces);
	assert(mesh.getGroup(CartesianMesh2D::TopFaces) == expected_top_faces);
	assert(mesh.getGroup(CartesianMesh2D::BottomFaces) == expected_bottom_faces);
	assert(mesh.getGroup(CartesianMesh2D::LeftFaces) == expected_left_faces);
	assert(mesh.getGroup(CartesianMesh2D::RightFaces) == expected_right_faces);

	assert(mesh.getGroup(CartesianMesh2D::BottomLeftNode)[0] == 0);
	assert(mesh.getGroup(CartesianMesh2D::BottomRightNode)[0] == 4);
	assert(mesh.getGroup(CartesianMesh2D::TopLeftNode)[0] == 15);
	assert(mesh.getGroup(CartesianMesh2D::TopRightNode)[0] == 19);

	std::cout << &mesh << std::endl;
	return 0;
}
