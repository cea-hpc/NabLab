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

#include <arcane/ItemGroup.h>
#include <arcane/IItemFamily.h>
#include <arcane/mesh/IncrementalItemConnectivity.h>
#include <arcane/cartesianmesh/CellDirectionMng.h>
#include <arcane/cartesianmesh/NodeDirectionMng.h>

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

	m_umcv.setMesh(mesh);

	//
	// compute neightbour cells
	//
	IItemFamily* cell_family = mesh->cellFamily();
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
	CellDirectionMng x_cell_dm(m_cartesian_mesh->cellDirection(MD_DirX));
	CellDirectionMng y_cell_dm(m_cartesian_mesh->cellDirection(MD_DirY));
	Int32 nb_x_quads = x_cell_dm.ownNbCell();
	Int32 nb_y_quads = y_cell_dm.ownNbCell();

	auto node_family = mesh->nodeFamily();

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

	NodeDirectionMng x_node_dm(m_cartesian_mesh->nodeDirection(MD_DirX));
	NodeDirectionMng y_node_dm(m_cartesian_mesh->nodeDirection(MD_DirY));
	ENUMERATE_NODE(inode, mesh->allNodes())
	{
		Node n = *inode;

		DirNode xdn = x_node_dm.node(n);
		if (xdn.nextRightCellId() != -1 && xdn.previousRightCellId() != -1 && xdn.nextLeftCellId() != -1 && xdn.previousLeftCellId() != -1)
			inner_nodes[inner_node_id++] = n.localId();
		else
		{
			if (xdn.nextRightCellId() == -1 && xdn.nextLeftCellId() == -1)
				right_nodes[right_node_id++] = n.localId();
			if (xdn.previousRightCellId() == -1 && xdn.previousLeftCellId() == -1)
				left_nodes[left_node_id++] = n.localId();

			DirNode ydn = y_node_dm.node(n);
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

		DirCell xdc = x_cell_dm.cell(c);
		DirCell ydc = y_cell_dm.cell(c);
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

	m_groups[CartesianMesh2D::InnerCells] = node_family->createGroup(CartesianMesh2D::InnerCells, inner_cells);
	m_groups[CartesianMesh2D::TopCells] = node_family->createGroup(CartesianMesh2D::TopCells, top_cells);
	m_groups[CartesianMesh2D::BottomCells] = node_family->createGroup(CartesianMesh2D::BottomCells, bottom_cells);
	m_groups[CartesianMesh2D::LeftCells] = node_family->createGroup(CartesianMesh2D::LeftCells, left_cells);
	m_groups[CartesianMesh2D::RightCells] = node_family->createGroup(CartesianMesh2D::RightCells, right_cells);

	m_groups[CartesianMesh2D::InnerFaces] = node_family->createGroup(CartesianMesh2D::InnerFaces, inner_faces);
}

ItemGroup
CartesianMesh2D::getGroup(const string& name)
{
	if (m_groups.find(name) == m_groups.end())
	{
		stringstream msg;
		msg << "Invalid item group: " << name;
		throw runtime_error(msg.str());
	}
	return m_groups[name];
}

ItemLocalIdView<Node>
CartesianMesh2D::getNodesOfCell(const CellLocalId cId) const
{
	return m_umcv.cellNode().items(cId);
}

ItemLocalIdView<Node>
CartesianMesh2D::getNodesOfFace(const FaceLocalId fId) const
{
	return m_umcv.faceNode().items(fId);
}

ItemLocalIdView<Cell>
CartesianMesh2D::getCellsOfNode(const NodeLocalId nId) const
{
	return m_umcv.nodeCell().items(nId);
}

ItemLocalIdView<Cell>
CartesianMesh2D::getCellsOfFace(const FaceLocalId fId) const
{
	return m_umcv.faceCell().items(fId);
}

ItemLocalIdView<Cell>
CartesianMesh2D::getNeighbourCells(const CellLocalId cId) const
{
	return m_neighbour_cells.items(cId);
}

ItemLocalIdView<Face>
CartesianMesh2D::getFacesOfCell(const CellLocalId cId) const
{
	return m_umcv.cellFace().items(cId);
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

FaceLocalId
CartesianMesh2D::getTopFaceOfCell(const CellLocalId cId) const noexcept
{
	CellDirectionMng cell_dm(m_cartesian_mesh->cellDirection(MD_DirY));
	DirCellFace dn = cell_dm.cellFace(cId);
	return dn.nextId();
}

FaceLocalId
CartesianMesh2D::getBottomFaceOfCell(const CellLocalId cId) const noexcept
{
	CellDirectionMng cell_dm(m_cartesian_mesh->cellDirection(MD_DirY));
	DirCellFace dn = cell_dm.cellFace(cId);
	return dn.previousId();
}

FaceLocalId
CartesianMesh2D::getLeftFaceOfCell(const CellLocalId cId) const noexcept
{
	CellDirectionMng cell_dm(m_cartesian_mesh->cellDirection(MD_DirX));
	DirCellFace dn = cell_dm.cellFace(cId);
	return dn.previousId();
}

FaceLocalId
CartesianMesh2D::getRightFaceOfCell(const CellLocalId cId) const noexcept
{
	CellDirectionMng cell_dm(m_cartesian_mesh->cellDirection(MD_DirX));
	DirCellFace dn = cell_dm.cellFace(cId);
	return dn.nextId();
}

CellLocalId
CartesianMesh2D::getTopCell(const CellLocalId cId) const noexcept
{
	CellDirectionMng cell_dm(m_cartesian_mesh->cellDirection(MD_DirY));
	DirCell dn = cell_dm.cell(cId);
	return dn.nextId();
}

CellLocalId
CartesianMesh2D::getBottomCell(const CellLocalId cId) const noexcept
{
	CellDirectionMng cell_dm(m_cartesian_mesh->cellDirection(MD_DirY));
	DirCell dn = cell_dm.cell(cId);
	return dn.previousId();
}

CellLocalId
CartesianMesh2D::getLeftCell(const CellLocalId cId) const noexcept
{
	CellDirectionMng cell_dm(m_cartesian_mesh->cellDirection(MD_DirX));
	DirCell dn = cell_dm.cell(cId);
	return dn.previousId();
}

CellLocalId
CartesianMesh2D::getRightCell(const CellLocalId cId) const noexcept
{
	CellDirectionMng cell_dm(m_cartesian_mesh->cellDirection(MD_DirX));
	DirCell dn = cell_dm.cell(cId);
	return dn.nextId();
}
