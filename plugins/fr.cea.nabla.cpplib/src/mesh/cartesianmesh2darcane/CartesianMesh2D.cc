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
	// compute groups
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
	ENUMERATE_NODE(inode, x_node_dm.innerNodes())
	{
		Node n = *inode;
		DirNode dn = x_node_dm.node(n);
		if (dn.nextRightCellId() != -1 && dn.nextLeftCellId() != -1)
			inner_nodes[inner_node_id++] = n.localId();
	}

	ENUMERATE_NODE(inode, x_node_dm.outerNodes())
	{
		Node n = *inode;
		DirNode dn = x_node_dm.node(n);
		if (dn.nextRightCellId() == -1 && dn.nextLeftCellId() == -1)
			right_nodes[right_node_id++] = n.localId();
		else if (dn.previousRightCellId() == -1 && dn.previousLeftCellId() == -1)
			left_nodes[left_node_id++] = n.localId();
	}

	NodeDirectionMng y_node_dm(m_cartesian_mesh->nodeDirection(MD_DirY));
	ENUMERATE_NODE(inode, y_node_dm.outerNodes())
	{
		Node n = *inode;
		DirNode dn = y_node_dm.node(n);
		if (dn.nextRightCellId() == -1 && dn.nextLeftCellId() == -1)
			top_nodes[top_node_id++] = n.localId();
		else if (dn.previousRightCellId() == -1 && dn.previousLeftCellId() == -1)
			bottom_nodes[bottom_node_id++] = n.localId();
	}

	m_groups[CartesianMesh2D::InnerNodes] = node_family->createGroup(CartesianMesh2D::InnerNodes, inner_nodes);
	m_groups[CartesianMesh2D::TopNodes] = node_family->createGroup(CartesianMesh2D::TopNodes, top_nodes);
	m_groups[CartesianMesh2D::BottomNodes] = node_family->createGroup(CartesianMesh2D::BottomNodes, bottom_nodes);
	m_groups[CartesianMesh2D::LeftNodes] = node_family->createGroup(CartesianMesh2D::LeftNodes, left_nodes);
	m_groups[CartesianMesh2D::RightNodes] = node_family->createGroup(CartesianMesh2D::RightNodes, right_nodes);
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
