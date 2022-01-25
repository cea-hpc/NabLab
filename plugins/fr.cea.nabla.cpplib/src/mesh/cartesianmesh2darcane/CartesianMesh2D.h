/*******************************************************************************
 * Copyright (c) 2022 CEA
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

	Integer getNbNodes() const { return m_mesh->nbNode(); }
	Integer getNbCells() const { return m_mesh->nbCell(); }
	Integer getNbFaces() const { return m_mesh->nbFace(); }
	CellGroup getCells() const;
	NodeGroup getNodes() const;
	FaceGroup getFaces() const;
	ItemLocalIdView<Node> getNodesOfCell(CellLocalId cId) const;
	ItemLocalIdView<Node> getNodesOfFace(FaceLocalId fId) const;
	ItemLocalIdView<Cell> getCellsOfNode(NodeLocalId nId) const;
	ItemLocalIdView<Cell> getCellsOfFace(FaceLocalId fId) const;
	ItemLocalIdView<Cell> getNeighbourCells(CellLocalId cId) const;
	ItemLocalIdView<Face> getFacesOfCell(CellLocalId cId) const;
	FaceLocalId getCommonFace(CellLocalId c1Id, CellLocalId c2Id) const;

private:
	CartesianMesh2D(IMesh* mesh);
	IMesh* m_mesh;
	UnstructuredMeshConnectivityView m_umcv;
	IndexedItemConnectivityView<Cell, Cell> m_neighbour_cells;
	static map<IMesh*, CartesianMesh2D*> m_instances;
};

#endif /* _CARTESIANMESH2D_H_ */
