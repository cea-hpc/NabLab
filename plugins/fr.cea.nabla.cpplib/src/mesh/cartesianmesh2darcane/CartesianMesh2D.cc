/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
	 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "CartesianMesh2D.h"

#include <arcane/IItemFamily.h>
#include <arcane/mesh/IncrementalItemConnectivity.h>

map<IMesh*, CartesianMesh2D*> CartesianMesh2D::m_instances;

CartesianMesh2D*
CartesianMesh2D::createInstance(IMesh* mesh)
{
	CartesianMesh2D* instance = m_instances[mesh];
	if (instance == NULL)
	{
		instance = new CartesianMesh2D(mesh);
		m_instances[mesh] = instance;
	}
	return instance;
}

CartesianMesh2D::CartesianMesh2D(IMesh* mesh)
: m_mesh(mesh)
{
	m_cartesian_mesh = ICartesianMesh::getReference(mesh);
	m_cartesian_mesh->computeDirections();

	m_x_cell_dm = m_cartesian_mesh->cellDirection(MD_DirX);
	m_y_cell_dm = m_cartesian_mesh->cellDirection(MD_DirY);
	m_x_node_dm = m_cartesian_mesh->nodeDirection(MD_DirX);
	m_y_node_dm = m_cartesian_mesh->nodeDirection(MD_DirY);

	m_umcv.setMesh(mesh);

	IItemFamily* cell_family = mesh->cellFamily();
	IItemFamily* node_family = mesh->nodeFamily();
	IItemFamily* face_family = mesh->faceFamily();

	//
	// compute neightbour cells
	//

	// NOTE: l'objet est automatiquement détruit par le maillage
	auto* cn = new mesh::IncrementalItemConnectivity(cell_family, cell_family, "getNeighbourCells");
	ENUMERATE_CELL(icell, mesh->allCells())
	{
		Cell c = *icell;
		cn->notifySourceItemAdded(c);
		ENUMERATE_FACE(iface, c.faces())
		{
			Face f = *iface;
			Cell oppositeCell = (f.backCell() == c ? f.frontCell() : f.backCell());
			if (!oppositeCell.null())
				cn->addConnectedItem(c, oppositeCell);
		}
	}

	m_neighbour_cells = cn->connectivityView();

	// infomation du mesh global
	auto* info_mesh = ICartesianMeshGenerationInfo::getReference(mesh, true);

	const auto nb_total_cell = info_mesh->globalNbCells();
	const auto cell_offset = info_mesh->ownCellOffsets();

	const Int32 nb_x_total = nb_total_cell[0];
	const Int32 nb_y_total = nb_total_cell[1];
	const Int32 nb_x_quads = m_x_cell_dm.ownNbCell();
	const Int32 nb_y_quads = m_y_cell_dm.ownNbCell();
	Int64 nb_face_x = nb_x_quads + 1;

	const bool has_neighbour_top = (cell_offset[1] + nb_y_quads) == nb_y_total ? false : true;
	const bool has_neighbour_bottom = (cell_offset[1] == 0) ? false : true;
	const bool has_neighbour_left = (cell_offset[0] == 0) ? false : true;
	const bool has_neighbour_right = (cell_offset[0] + nb_x_quads) == nb_x_total ? false : true;

	//
	// compute node groups
	//
	Int32 nb_inner_nodes = (nb_x_quads - 1) * (nb_y_quads - 1);
	Int32 nb_top_nodes = has_neighbour_top ? 0 : nb_x_quads;
	Int32 nb_bottom_nodes = has_neighbour_bottom ? 0 : nb_x_quads;
	Int32 nb_left_nodes = has_neighbour_left ? 0 : nb_y_quads;
	Int32 nb_right_nodes = has_neighbour_right ? 0 : nb_y_quads;

	if(has_neighbour_top)
		nb_inner_nodes += nb_x_quads - 1;
	if(has_neighbour_right)
		nb_inner_nodes += nb_y_quads - 1;
	if(has_neighbour_top && has_neighbour_right)
		nb_inner_nodes++;

	if(!has_neighbour_left)
	{
		if(!has_neighbour_top) nb_top_nodes++;
		if(!has_neighbour_bottom) nb_bottom_nodes++;
	}
	if(!has_neighbour_bottom)
	{
		if(!has_neighbour_left) nb_left_nodes++;
		if(!has_neighbour_right) nb_right_nodes++;
	}

	UniqueArray<Int32> inner_nodes(nb_inner_nodes);
	UniqueArray<Int32> top_nodes(nb_top_nodes);
	UniqueArray<Int32> bottom_nodes(nb_bottom_nodes);
	UniqueArray<Int32> left_nodes(nb_left_nodes);
	UniqueArray<Int32> right_nodes(nb_right_nodes);

	UniqueArray<Int32> top_left_node(1);
	UniqueArray<Int32> top_right_node(1);
	UniqueArray<Int32> bottom_left_node(1);
	UniqueArray<Int32> bottom_right_node(1);

	Int32 inner_node_id(0);
	Int32 top_node_id(0);
	Int32 bottom_node_id(0);
	Int32 left_node_id(0);
	Int32 right_node_id(0);

	ENUMERATE_NODE(inode, mesh->ownNodes())
	{
		Node n = *inode;
		const Int64 unique_id(n.uniqueId());

		if(unique_id % (nb_x_total + 1) != 0 &&
			 unique_id % (nb_x_total + 1) != nb_x_total &&
			 unique_id / (nb_x_total + 1) != 0 &&
			 unique_id / (nb_x_total + 1) != nb_y_total)
			inner_nodes[inner_node_id++] = n.localId();
		if (unique_id == nb_x_quads)
			bottom_right_node[0] = n.localId();
		if (unique_id == 0)
			bottom_left_node[0] = n.localId();
		if (unique_id == (nb_x_quads +1) * (nb_y_quads +1) - 1)
			top_right_node[0] = n.localId();
		if (unique_id == (nb_x_quads +1) * nb_y_quads)
			top_left_node[0] = n.localId();
		if(unique_id / (nb_x_total + 1) == 0)
			bottom_nodes[bottom_node_id++] = n.localId();
		else if(unique_id / (nb_x_total + 1) == nb_y_total)
			top_nodes[top_node_id++] = n.localId();
		if(unique_id % (nb_x_total + 1) == 0)
			left_nodes[left_node_id++] = n.localId();
		else if(unique_id % (nb_x_total + 1) == nb_x_total)
			right_nodes[right_node_id++] = n.localId();
	}

	//
	// compute cell groups
	//
	Int32 nb_inner_cells = (nb_x_quads - 2) * (nb_y_quads - 2);
	const Int32 nb_top_cells = has_neighbour_top ? 0 : nb_x_quads;
	const Int32 nb_bottom_cells = has_neighbour_bottom ? 0 : nb_x_quads;
	const Int32 nb_left_cells = has_neighbour_left ? 0 : nb_y_quads;
	const Int32 nb_right_cells = has_neighbour_right ? 0 : nb_y_quads;

	if(has_neighbour_top)
		nb_inner_cells += nb_x_quads - 2;
	if(has_neighbour_bottom)
		nb_inner_cells += nb_x_quads - 2;
	if(has_neighbour_left)
		nb_inner_cells += nb_y_quads - 2;
	if(has_neighbour_right)
		nb_inner_cells += nb_y_quads - 2;
	if(has_neighbour_top && has_neighbour_left)
		nb_inner_cells++;
	if(has_neighbour_top && has_neighbour_right)
		nb_inner_cells++;
	if(has_neighbour_bottom && has_neighbour_left)
		nb_inner_cells++;
	if(has_neighbour_bottom && has_neighbour_right)
		nb_inner_cells++;

	UniqueArray<Int32> inner_cells(nb_inner_cells);
	UniqueArray<Int32> top_cells(nb_top_cells);
	UniqueArray<Int32> bottom_cells(nb_bottom_cells);
	UniqueArray<Int32> left_cells(nb_left_cells);
	UniqueArray<Int32> right_cells(nb_right_cells);

	Int32 inner_cell_id(0);
	Int32 top_cell_id(0);
	Int32 bottom_cell_id(0);
	Int32 left_cell_id(0);
	Int32 right_cell_id(0);

	ENUMERATE_CELL(icell, mesh->ownCells())
	{
		Cell c = *icell;
		const Int64 unique_id(c.uniqueId());

		if((unique_id % nb_x_total != 0) &&
			 (unique_id % nb_x_total != nb_x_total - 1) &&
			 (unique_id / nb_x_total != 0) &&
			 (unique_id / nb_x_total != nb_y_total - 1))
				 inner_cells[inner_cell_id++] = c.localId();
		if(unique_id % nb_x_total == 0)
			left_cells[left_cell_id++] = c.localId();
		else if(unique_id % nb_x_total == nb_x_total - 1)
			right_cells[right_cell_id++] = c.localId();
		if(unique_id / nb_x_total == 0)
			bottom_cells[bottom_cell_id++] = c.localId();
		else if(unique_id / nb_x_total == nb_y_total - 1)
			top_cells[top_cell_id++] = c.localId();
	}

	//
	// compute face groups
	//
	Int32 nb_inner_faces = 2 * nb_x_quads * nb_y_quads - nb_x_quads - nb_y_quads;

	if(has_neighbour_top)
		nb_inner_faces += nb_x_quads;
	if(has_neighbour_right)
		nb_inner_faces += nb_y_quads;

	const Int32 nb_left_faces = nb_y_quads;
	const Int32 nb_right_faces = nb_y_quads;
	const Int32 nb_top_faces = nb_x_quads;
	const Int32 nb_bottom_faces = nb_x_quads;

	UniqueArray<Int32> inner_faces(nb_inner_faces);
	UniqueArray<Int32> left_faces(nb_left_faces);
	UniqueArray<Int32> right_faces(nb_right_faces);
	UniqueArray<Int32> top_faces(nb_top_faces);
	UniqueArray<Int32> bottom_faces(nb_bottom_faces);

	Int32 inner_face_id(0);
	Int32 left_face_id(0);
	Int32 right_face_id(0);
	Int32 top_face_id(0);
	Int32 bottom_face_id(0);

	ENUMERATE_FACE(iface, mesh->ownFaces())
	{
		Face f = *iface;
		const Int64 unique_id(f.uniqueId());

		if (f.nbCell() == 2)
			inner_faces[inner_face_id++] = f.localId();
		else
		{
			// outer_faces
			if ((unique_id % nb_face_x == 0) && (unique_id / nb_face_x < nb_y_quads) )
				left_faces[left_face_id++] = f.localId();

			if ((unique_id % nb_face_x == nb_x_quads) && (unique_id / nb_face_x < nb_y_quads) )
				right_faces[right_face_id++] = f.localId();

			if ((unique_id >= nb_face_x * nb_y_quads) && (unique_id < nb_face_x * nb_y_quads + nb_x_quads))
				bottom_faces[bottom_face_id++] = f.localId();

			if (unique_id >= nb_face_x * nb_y_quads + nb_x_quads * nb_y_quads)
				top_faces[top_face_id++] = f.localId();
		}
	}

	m_groups[CartesianMesh2D::InnerNodes] = node_family->createGroup(CartesianMesh2D::InnerNodes, inner_nodes);
	m_groups[CartesianMesh2D::TopNodes] = node_family->createGroup(CartesianMesh2D::TopNodes, top_nodes);
	m_groups[CartesianMesh2D::BottomNodes] = node_family->createGroup(CartesianMesh2D::BottomNodes, bottom_nodes);
	m_groups[CartesianMesh2D::LeftNodes] = node_family->createGroup(CartesianMesh2D::LeftNodes, left_nodes);
	m_groups[CartesianMesh2D::RightNodes] = node_family->createGroup(CartesianMesh2D::RightNodes, right_nodes);
	m_groups[CartesianMesh2D::TopLeftNode] = node_family->createGroup(CartesianMesh2D::TopLeftNode, top_left_node);
	m_groups[CartesianMesh2D::TopRightNode] = node_family->createGroup(CartesianMesh2D::TopRightNode, top_right_node);
	m_groups[CartesianMesh2D::BottomLeftNode] = node_family->createGroup(CartesianMesh2D::BottomLeftNode, bottom_left_node);
	m_groups[CartesianMesh2D::BottomRightNode] = node_family->createGroup(CartesianMesh2D::BottomRightNode, bottom_right_node);

	m_groups[CartesianMesh2D::InnerCells] = cell_family->createGroup(CartesianMesh2D::InnerCells, inner_cells);
	m_groups[CartesianMesh2D::TopCells] = cell_family->createGroup(CartesianMesh2D::TopCells, top_cells);
	m_groups[CartesianMesh2D::BottomCells] = cell_family->createGroup(CartesianMesh2D::BottomCells, bottom_cells);
	m_groups[CartesianMesh2D::LeftCells] = cell_family->createGroup(CartesianMesh2D::LeftCells, left_cells);
	m_groups[CartesianMesh2D::RightCells] = cell_family->createGroup(CartesianMesh2D::RightCells, right_cells);

	m_groups[CartesianMesh2D::InnerFaces] = face_family->createGroup(CartesianMesh2D::InnerFaces, inner_faces);
	m_groups[CartesianMesh2D::LeftFaces] = face_family->createGroup(CartesianMesh2D::LeftFaces, left_faces);
	m_groups[CartesianMesh2D::RightFaces] = face_family->createGroup(CartesianMesh2D::RightFaces, right_faces);
	m_groups[CartesianMesh2D::TopFaces] = face_family->createGroup(CartesianMesh2D::TopFaces, top_faces);
	m_groups[CartesianMesh2D::BottomFaces] = face_family->createGroup(CartesianMesh2D::BottomFaces, bottom_faces);
}

FaceLocalId
CartesianMesh2D::getCommonFace(const CellLocalId c1Id, const CellLocalId c2Id) const
{
	IItemFamily* face_family = m_mesh->faceFamily();
	ItemInternalArrayView faces = face_family->itemsInternal();
	const auto facesOfCellC1(m_umcv.cellFace().items(c1Id));
	auto nbFacesOfCellC1(facesOfCellC1.size());
	for (Int32 fFacesOfCellC1=0; fFacesOfCellC1<nbFacesOfCellC1; fFacesOfCellC1++)
	{
		FaceLocalId fId(facesOfCellC1[fFacesOfCellC1]);
		Face f(faces[fId]);
		Cell oppositeCell = (f.backCell().localId() == c1Id ? f.frontCell() : f.backCell());
		if (!oppositeCell.null() && (oppositeCell.localId() == c2Id))
			return fId;
	}
	throw std::range_error("No common face between cells " + std::to_string(c1Id.asInteger()) + " and cells " + std::to_string(c2Id.asInteger()));
}
