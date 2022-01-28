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
}


CellGroup
CartesianMesh2D::getCells() const
{
	return m_mesh->allCells();
}

NodeGroup
CartesianMesh2D::getNodes() const
{
	return m_mesh->allNodes();
}

FaceGroup
CartesianMesh2D::getFaces() const
{
	return m_mesh->allFaces();
}


ItemGroup
CartesianMesh2D::getGroup(const string& name) const
{
	return m_mesh->findGroup(name);
}

ItemLocalIdView<Node>
CartesianMesh2D::getNodesOfCell(CellLocalId cId) const
{
	return m_umcv.cellNode().items(cId);
}

ItemLocalIdView<Node>
CartesianMesh2D::getNodesOfFace(FaceLocalId fId) const
{
	return m_umcv.faceNode().items(fId);
}

ItemLocalIdView<Cell>
CartesianMesh2D::getCellsOfNode(NodeLocalId nId) const
{
	return m_umcv.nodeCell().items(nId);
}

ItemLocalIdView<Cell>
CartesianMesh2D::getCellsOfFace(FaceLocalId fId) const
{
	return m_umcv.faceCell().items(fId);
}

ItemLocalIdView<Cell>
CartesianMesh2D::getNeighbourCells(CellLocalId cId) const
{
	return m_neighbour_cells.items(cId);
}

ItemLocalIdView<Face>
CartesianMesh2D::getFacesOfCell(CellLocalId cId) const
{
	return m_umcv.cellFace().items(cId);
}

FaceLocalId
CartesianMesh2D::getCommonFace(CellLocalId c1Id, CellLocalId c2Id) const
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
