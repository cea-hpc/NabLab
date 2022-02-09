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

#include <utility>
#include <map>

#include "MeshGeometry.h"
#include "nablalib/types/Types.h"

using namespace std;

class CartesianMesh2D
{
public:
	// NODES
	inline static const string InnerNodes = "InnerNodes";
	inline static const string OuterNodes = "OuterNodes";
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
	inline static const string OuterCells = "OuterCells";
	inline static const string TopCells = "TopCells";
	inline static const string BottomCells = "BottomCells";
	inline static const string LeftCells = "LeftCells";
	inline static const string RightCells = "RightCells";

	// FACES
	inline static const string InnerFaces = "InnerFaces";
	inline static const string OuterFaces = "OuterFaces";
	inline static const string InnerHorizontalFaces = "InnerHorizontalFaces";
	inline static const string InnerVerticalFaces = "InnerVerticalFaces";
	inline static const string TopFaces = "TopFaces";
	inline static const string BottomFaces = "BottomFaces";
	inline static const string LeftFaces = "LeftFaces";
	inline static const string RightFaces = "RightFaces";

public:
	void jsonInit(const char* jsonContent);

	MeshGeometry<2>* getGeometry() noexcept { return m_geometry; }

	void create(size_t nb_x_quads, size_t nb_y_quads, double x_size, double y_size);

	size_t getNbNodes() const noexcept { return m_geometry->getNodes().size(); }
	size_t getNbCells() const noexcept { return m_geometry->getQuads().size(); }
	size_t getNbFaces() const noexcept { return m_geometry->getEdges().size(); }

	vector<Id> getGroup(const string& name);

	const array<Id, 4>& getNodesOfCell(const Id& cellId) const noexcept;
	const array<Id, 2>& getNodesOfFace(const Id& faceId) const noexcept;
	Id getFirstNodeOfFace(const Id& faceId) const noexcept;
	Id getSecondNodeOfFace(const Id& faceId) const noexcept;

	vector<Id> getCellsOfNode(const Id& nodeId) const noexcept;
	vector<Id> getCellsOfFace(const Id& faceId) const;

	vector<Id> getNeighbourCells(const Id& cellId) const;
	vector<Id> getFacesOfCell(const Id& cellId) const;

	Id getCommonFace(const Id& cellId1, const Id& cellId2) const;

	Id getBackCell(const Id& faceId) const;
	Id getFrontCell(const Id& faceId) const;
	Id getTopFaceOfCell(const Id& cellId) const noexcept;
	Id getBottomFaceOfCell(const Id& cellId) const noexcept;
	Id getLeftFaceOfCell(const Id& cellId) const noexcept;
	Id getRightFaceOfCell(const Id& cellId) const noexcept;

	Id getTopCell(const Id& cellId) const noexcept;
	Id getBottomCell(const Id& cellId) const noexcept;
	Id getLeftCell(const Id& cellId) const noexcept;
	Id getRightCell(const Id& cellId) const noexcept;

	Id getBottomFaceNeighbour(const Id& faceId) const;
	Id getBottomLeftFaceNeighbour(const Id& faceId) const;
	Id getBottomRightFaceNeighbour(const Id& faceId) const;

	Id getTopFaceNeighbour(const Id& faceId) const;
	Id getTopLeftFaceNeighbour(const Id& faceId) const;
	Id getTopRightFaceNeighbour(const Id& faceId) const;

	Id getRightFaceNeighbour(const Id& faceId) const;
	Id getLeftFaceNeighbour(const Id& faceId) const;

 private:
	Id index2IdCell(const size_t& i, const size_t& j) const noexcept;
	Id index2IdNode(const size_t& i, const size_t& j) const noexcept;
	pair<size_t, size_t> id2IndexCell(const Id& k) const noexcept;
	pair<size_t, size_t> id2IndexNode(const Id& k) const noexcept;

	bool isInnerEdge(const Edge& e) const noexcept;
	bool isVerticalEdge(const Edge& e) const noexcept;
	bool isHorizontalEdge(const Edge& e) const noexcept;
	bool isInnerVerticalEdge(const Edge& e) const noexcept;
	bool isInnerHorizontalEdge(const Edge& e) const noexcept;

	size_t getNbCommonIds(const vector<Id>& a, const vector<Id>& b) const noexcept;
	template <size_t N, size_t M>
	size_t getNbCommonIds(const array<Id, N>& as, const array<Id, M>& bs) const noexcept
	{
		size_t nbCommonIds(0);
		for (const auto& a : as)
			if (find(bs.begin(), bs.end(), a) != bs.end())
				++nbCommonIds;
		return nbCommonIds;
	}

	inline vector<Id> cellsOfNodeCollection(const vector<Id>& nodes);

private:
	MeshGeometry<2>* m_geometry;
	size_t m_nb_x_quads;
	size_t m_nb_y_quads;

	map<string, vector<Id>> m_groups;
};

#endif /* _CARTESIANMESH2D_H_ */
