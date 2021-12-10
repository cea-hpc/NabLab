/*******************************************************************************
 * Copyright (c) 2021 CEA
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

ItemLocalIdView<Node>
CartesianMesh2D::getNodesOfCell(Cell c) const
{
	return m_umcv.cellNode().items(c);
}

ItemLocalIdView<Node>
CartesianMesh2D::getNodesOfFace(Face f) const
{
	return m_umcv.faceNode().items(f);
}

ItemLocalIdView<Cell>
CartesianMesh2D::getCellsOfNode(Node n) const
{
	return m_umcv.nodeCell().items(n);
}

ItemLocalIdView<Cell>
CartesianMesh2D::getCellsOfFace(Face f) const
{
	return m_umcv.faceCell().items(f);
}

ItemLocalIdView<Cell>
CartesianMesh2D::getNeighbourCells(Cell c) const
{
	return m_neighbour_cells.items(c);
}

ItemLocalIdView<Face>
CartesianMesh2D::getFacesOfCell(Cell c) const
{
	return m_umcv.cellFace().items(c);
}
