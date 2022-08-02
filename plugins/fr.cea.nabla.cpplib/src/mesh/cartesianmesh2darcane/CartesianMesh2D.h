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
#include <arcane/ItemGroup.h>
#include <arcane/IMesh.h>
#include <arcane/UnstructuredMeshConnectivity.h>
#include <arcane/IndexedItemConnectivityView.h>
#include <arcane/cartesianmesh/ICartesianMesh.h>
#include <arcane/cartesianmesh/CellDirectionMng.h>
#include <arcane/cartesianmesh/NodeDirectionMng.h>
#include "arcane/ICartesianMeshGenerationInfo.h"
#include <unistd.h>

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
	inline static const string TopLeftNode = "TopLeftNode";
	inline static const string TopRightNode = "TopRightNode";
	inline static const string BottomLeftNode = "BottomLeftNode";
	inline static const string BottomRightNode = "BottomRightNode";

	// CELLS
	inline static const string InnerCells = "InnerCells";
	inline static const string TopCells = "TopCells";
	inline static const string BottomCells = "BottomCells";
	inline static const string LeftCells = "LeftCells";
	inline static const string RightCells = "RightCells";

	// FACES
	inline static const string InnerFaces = "InnerFaces";
	inline static const string LeftFaces = "LeftFaces";
	inline static const string RightFaces = "RightFaces";
	inline static const string TopFaces = "TopFaces";
	inline static const string BottomFaces = "BottomFaces";

public:
	static CartesianMesh2D* createInstance(IMesh* mesh);

	FaceLocalId getCommonFace(const CellLocalId c1Id, const CellLocalId c2Id) const;

	template <typename ItemType>
	Int32 indexOf(const ItemLocalIdViewT<ItemType> v, const ItemLocalId id)
	{
		for (Int32 i(0) ; i < v.size(); ++i)
			if (v[i] == id)
				return i;
		throw std::out_of_range("Item not in view");
	}

	inline ItemGroup getGroup(const string& name)
	{
		if (m_groups.find(name) == m_groups.end())
		{
			stringstream msg;
			msg << "Invalid item group: " << name;
			throw runtime_error(msg.str());
		}
		return m_groups[name];
	}

	inline ItemLocalIdViewT<Node> getNodesOfCell(const CellLocalId cId) const
	{ return m_umcv.cellNode().items(cId); }

	inline ItemLocalIdViewT<Node> getNodesOfFace(const FaceLocalId fId) const
	{ return m_umcv.faceNode().items(fId); }

	inline NodeLocalId getFirstNodeOfFace(const FaceLocalId fId) const
	{ return getNodesOfFace(fId)[0]; }

	inline NodeLocalId getSecondNodeOfFace(const FaceLocalId fId) const
	{ return getNodesOfFace(fId)[1]; }

	inline ItemLocalIdViewT<Cell> getCellsOfNode(const NodeLocalId nId) const
	{ return m_umcv.nodeCell().items(nId); }

	inline ItemLocalIdViewT<Cell> getCellsOfFace(const FaceLocalId fId) const
	{ return m_umcv.faceCell().items(fId); }

	inline ItemLocalIdViewT<Cell> getNeighbourCells(const CellLocalId cId) const
	{ return m_neighbour_cells.items(cId); }

	inline ItemLocalIdViewT<Face> getFacesOfCell(const CellLocalId cId) const
	{ return m_umcv.cellFace().items(cId); }

	inline CellLocalId getFrontCell(const FaceLocalId fId) const
	{ return getCellsOfFace(fId)[0]; }

	inline CellLocalId getBackCell(const FaceLocalId fId) const
	{ return getCellsOfFace(fId)[1]; }

	inline FaceLocalId getTopFaceOfCell(const CellLocalId cId) const
	{ return m_y_cell_dm.cellFace(cId).nextId(); }

	inline FaceLocalId getBottomFaceOfCell(const CellLocalId cId) const
	{ return m_y_cell_dm.cellFace(cId).previousId(); }

	inline FaceLocalId getLeftFaceOfCell(const CellLocalId cId) const
	{ return m_x_cell_dm.cellFace(cId).previousId(); }

	inline FaceLocalId getRightFaceOfCell(const CellLocalId cId) const
	{ return m_x_cell_dm.cellFace(cId).nextId(); }

	inline CellLocalId getTopCell(const CellLocalId cId) const
	{ return m_y_cell_dm.cell(cId).nextId(); }

	inline CellLocalId getBottomCell(const CellLocalId cId) const
	{ return m_y_cell_dm.cell(cId).previousId(); }

	inline CellLocalId getLeftCell(const CellLocalId cId) const
	{ return m_x_cell_dm.cell(cId).previousId(); }

	inline CellLocalId getRightCell(const CellLocalId cId) const
	{ return m_x_cell_dm.cell(cId).nextId(); }

private:
	CartesianMesh2D(IMesh* mesh);
	IMesh* m_mesh;
	ICartesianMesh* m_cartesian_mesh;
	UnstructuredMeshConnectivityView m_umcv;
	IndexedItemConnectivityViewT<Cell, Cell> m_neighbour_cells;
	CellDirectionMng m_x_cell_dm;
	CellDirectionMng m_y_cell_dm;
	NodeDirectionMng m_x_node_dm;
	NodeDirectionMng m_y_node_dm;

	map<string, ItemGroup> m_groups;

	static map<IMesh*, CartesianMesh2D*> m_instances;
};

#endif /* _CARTESIANMESH2D_H_ */
