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
#include <arcane/cartesianmesh/ICartesianMesh.h>

using namespace std;
using namespace Arcane;

class CartesianMesh2D
{
public:
	// NODES
	inline static const string InnerNodes = "InnerNodes";
	inline static const string TopNodes = "TopNodes";
	inline static const string BottomNodes = "BottomNodes";
	inline static const string LeftNodes = "LeftNodes";
	inline static const string RightNodes = "RightNodes";

public:
	static CartesianMesh2D* createInstance(IMesh* mesh);

	template <typename ItemType>
	Int32 indexOf(const ItemLocalIdView<ItemType> v, const ItemLocalId id)
	{
		for (Int32 i(0) ; i < v.size(); ++i)
			if (v[i] == id)
				return i;
		throw std::out_of_range("Item not in view");
	}

	ItemGroup getGroup(const string& name);

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
	ICartesianMesh* m_cartesian_mesh;
	UnstructuredMeshConnectivityView m_umcv;
	IndexedItemConnectivityView<Cell, Cell> m_neighbour_cells;

	map<string, ItemGroup> m_groups;

	static map<IMesh*, CartesianMesh2D*> m_instances;
};

#endif /* _CARTESIANMESH2D_H_ */
