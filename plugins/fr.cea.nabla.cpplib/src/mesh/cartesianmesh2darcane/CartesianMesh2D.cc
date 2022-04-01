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
	CellGroup cells = cell_family->allItems();

	// NOTE: l'objet est automatiquement détruit par le maillage
	auto* cn = new mesh::IncrementalItemConnectivity(cell_family, cell_family, "getNeighbourCells");
	ENUMERATE_CELL(icell, cells)
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

	//
	// compute node groups
	//
	Int32 nb_x_quads = m_x_cell_dm.ownNbCell();
	Int32 nb_y_quads = m_y_cell_dm.ownNbCell();

	Int32 nb_outer_nodes = 2 * (nb_x_quads + nb_y_quads);
	UniqueArray<Int32> inner_nodes(mesh->nbNode() - nb_outer_nodes);
	UniqueArray<Int32> top_nodes(nb_x_quads + 1);
	UniqueArray<Int32> bottom_nodes(nb_x_quads + 1);
	UniqueArray<Int32> left_nodes(nb_y_quads + 1);
	UniqueArray<Int32> right_nodes(nb_y_quads + 1);

	Int32 inner_node_id(0);
	Int32 top_node_id(0);
	Int32 bottom_node_id(0);
	Int32 left_node_id(0);
	Int32 right_node_id(0);

	ENUMERATE_NODE(inode, mesh->allNodes())
	{
		Node n = *inode;

		DirNode xdn = m_x_node_dm.node(n);
		if (xdn.nextRightCellId() != -1 && xdn.previousRightCellId() != -1 && xdn.nextLeftCellId() != -1 && xdn.previousLeftCellId() != -1)
			inner_nodes[inner_node_id++] = n.localId();
		else
		{
			if (xdn.nextRightCellId() == -1 && xdn.nextLeftCellId() == -1)
				right_nodes[right_node_id++] = n.localId();
			if (xdn.previousRightCellId() == -1 && xdn.previousLeftCellId() == -1)
				left_nodes[left_node_id++] = n.localId();

			DirNode ydn = m_y_node_dm.node(n);
			if (ydn.nextRightCellId() == -1 && ydn.nextLeftCellId() == -1)
				top_nodes[top_node_id++] = n.localId();
			if (ydn.previousRightCellId() == -1 && ydn.previousLeftCellId() == -1)
				bottom_nodes[bottom_node_id++] = n.localId();
		}
	}

	//
	// compute cell groups
	//
	UniqueArray<Int32> inner_cells((nb_x_quads - 2)*(nb_y_quads - 2));
	UniqueArray<Int32> top_cells(nb_x_quads);
	UniqueArray<Int32> bottom_cells(nb_x_quads);
	UniqueArray<Int32> left_cells(nb_y_quads);
	UniqueArray<Int32> right_cells(nb_y_quads);

	Int32 inner_cell_id(0);
	Int32 top_cell_id(0);
	Int32 bottom_cell_id(0);
	Int32 left_cell_id(0);
	Int32 right_cell_id(0);

	ENUMERATE_CELL(icell, mesh->allCells())
	{
		Cell c = *icell;

		DirCell xdc = m_x_cell_dm.cell(c);
		DirCell ydc = m_y_cell_dm.cell(c);
		if (xdc.nextId() != -1 && xdc.previousId() != -1 && ydc.nextId() != -1 && ydc.previousId() != -1)
			inner_cells[inner_cell_id++] = c.localId();
		else
		{
			if (xdc.nextId() == -1)
				right_cells[right_cell_id++] = c.localId();
			if (xdc.previousId() == -1)
				left_cells[left_cell_id++] = c.localId();
			if (ydc.nextId() == -1)
				top_cells[top_cell_id++] = c.localId();
			if (ydc.previousId() == -1)
				bottom_cells[bottom_cell_id++] = c.localId();
		}
	}

	//
	// compute face groups
	//
	UniqueArray<Int32> inner_faces(2*nb_y_quads*nb_x_quads - nb_x_quads - nb_y_quads);

	Int32 inner_face_id(0);

	ENUMERATE_FACE(iface, mesh->allFaces())
	{
		Face f = *iface;
		if (f.nbCell() == 2)
			inner_faces[inner_face_id++] = f.localId();
	}

	m_groups[CartesianMesh2D::InnerNodes] = node_family->createGroup(CartesianMesh2D::InnerNodes, inner_nodes);
	m_groups[CartesianMesh2D::TopNodes] = node_family->createGroup(CartesianMesh2D::TopNodes, top_nodes);
	m_groups[CartesianMesh2D::BottomNodes] = node_family->createGroup(CartesianMesh2D::BottomNodes, bottom_nodes);
	m_groups[CartesianMesh2D::LeftNodes] = node_family->createGroup(CartesianMesh2D::LeftNodes, left_nodes);
	m_groups[CartesianMesh2D::RightNodes] = node_family->createGroup(CartesianMesh2D::RightNodes, right_nodes);

	m_groups[CartesianMesh2D::InnerCells] = cell_family->createGroup(CartesianMesh2D::InnerCells, inner_cells);
	m_groups[CartesianMesh2D::TopCells] = cell_family->createGroup(CartesianMesh2D::TopCells, top_cells);
	m_groups[CartesianMesh2D::BottomCells] = cell_family->createGroup(CartesianMesh2D::BottomCells, bottom_cells);
	m_groups[CartesianMesh2D::LeftCells] = cell_family->createGroup(CartesianMesh2D::LeftCells, left_cells);
	m_groups[CartesianMesh2D::RightCells] = cell_family->createGroup(CartesianMesh2D::RightCells, right_cells);

	m_groups[CartesianMesh2D::InnerFaces] = face_family->createGroup(CartesianMesh2D::InnerFaces, inner_faces);
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
