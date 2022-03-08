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

	// CELLS
	inline static const string InnerCells = "InnerCells";
	inline static const string TopCells = "TopCells";
	inline static const string BottomCells = "BottomCells";
	inline static const string LeftCells = "LeftCells";
	inline static const string RightCells = "RightCells";

	// FACES
	inline static const string InnerFaces = "InnerFaces";

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

	ItemLocalIdView<Node> getNodesOfCell(const CellLocalId cId) const;
	ItemLocalIdView<Node> getNodesOfFace(const FaceLocalId fId) const;
	ItemLocalIdView<Cell> getCellsOfNode(const NodeLocalId nId) const;
	ItemLocalIdView<Cell> getCellsOfFace(const FaceLocalId fId) const;
	ItemLocalIdView<Cell> getNeighbourCells(const CellLocalId cId) const;
	ItemLocalIdView<Face> getFacesOfCell(const CellLocalId cId) const;
	FaceLocalId getCommonFace(const CellLocalId c1Id, const CellLocalId c2Id) const;

	FaceLocalId getTopFaceOfCell(const CellLocalId cId) const noexcept;
	FaceLocalId getBottomFaceOfCell(const CellLocalId cId) const noexcept;
	FaceLocalId getLeftFaceOfCell(const CellLocalId cId) const noexcept;
	FaceLocalId getRightFaceOfCell(const CellLocalId cId) const noexcept;

	CellLocalId getTopCell(const CellLocalId cId) const noexcept;
	CellLocalId getBottomCell(const CellLocalId cId) const noexcept;
	CellLocalId getLeftCell(const CellLocalId cId) const noexcept;
	CellLocalId getRightCell(const CellLocalId cId) const noexcept;

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
