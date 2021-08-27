/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef _CARTESIANMESH2D_H_
#define _CARTESIANMESH2D_H_

#include <map>
#include <arcane/ItemTypes.h>
#include <arcane/IMesh.h>
#include <arcane/UnstructuredMeshConnectivity.h>
#include <arcane/IndexedItemConnectivityView.h>

using namespace std;
using namespace Arcane;

class CartesianMesh2D
{
public:
	static CartesianMesh2D* createInstance(IMesh* mesh);

	CartesianMesh2D(IMesh* mesh);

	CellGroup getCells() const;
	NodeGroup getNodes() const;
	FaceGroup getFaces() const;
	ItemLocalIdView<Node> getNodesOfCell(Cell c) const;
	ItemLocalIdView<Node> getNodesOfFace(Face f) const;
	ItemLocalIdView<Cell> getCellsOfNode(Node n) const;
	ItemLocalIdView<Cell> getCellsOfFace(Face f) const;
	IndexedItemConnectivityView<Cell, Cell> getNeighbourCells(Cell c) const;
	ItemLocalIdView<Face> getFacesOfCell(Cell c) const;

private:
	IMesh* m_mesh;
	UnstructuredMeshConnectivityView m_umcv;
	IndexedItemConnectivityView<Cell, Cell> m_neighbour_cells;
	static map<IMesh*, CartesianMesh2D*> m_instances;
};

#endif /* _CARTESIANMESH2D_H_ */
