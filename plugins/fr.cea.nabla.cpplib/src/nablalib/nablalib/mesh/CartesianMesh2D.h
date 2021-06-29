/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_MESH_CARTESIANMESH2D_H_
#define NABLALIB_MESH_CARTESIANMESH2D_H_

#include <utility>
#include "nablalib/types/Types.h"
#include "nablalib/mesh/MeshGeometry.h"

using namespace std;

namespace nablalib::mesh
{

class CartesianMesh2D
{
public:
	static constexpr int MaxNbNodesOfCell = 4;
	static constexpr int MaxNbNodesOfFace = 2;
	static constexpr int MaxNbCellsOfNode = 4;
	static constexpr int MaxNbCellsOfFace = 2;
	static constexpr int MaxNbFacesOfCell = 4;
	static constexpr int MaxNbNeighbourCells = 4;

	void jsonInit(const char* jsonContent);

	MeshGeometry<2>* getGeometry() noexcept { return m_geometry; }

	size_t getNbNodes() const noexcept { return m_geometry->getNodes().size(); }

	size_t getNbCells() const noexcept { return m_geometry->getQuads().size(); }

	size_t getNbFaces() const noexcept { return m_geometry->getEdges().size(); }
	const vector<Id>& getFaces() const noexcept { return m_faces; }

	size_t getNbInnerNodes() const noexcept { return m_inner_nodes.size(); }
	const vector<Id>& getInnerNodes() const noexcept { return m_inner_nodes; }
	size_t getNbTopNodes() const noexcept { return m_top_nodes.size(); }
	const vector<Id>& getTopNodes() const noexcept { return m_top_nodes; }
	size_t getNbBottomNodes() const noexcept { return m_bottom_nodes.size(); }
	const vector<Id>& getBottomNodes() const noexcept { return m_bottom_nodes; }
	size_t getNbLeftNodes() const noexcept { return m_left_nodes.size(); }
	const vector<Id>& getLeftNodes() const noexcept { return m_left_nodes; }
	size_t getNbRightNodes() const noexcept { return m_right_nodes.size(); }
	const vector<Id>& getRightNodes() const noexcept { return m_right_nodes; }

	size_t getNbInnerCells() const noexcept { return m_inner_cells.size();}
	const vector<Id>& getInnerCells() const noexcept {return m_inner_cells;}
	size_t getNbOuterCells() const noexcept { return m_outer_cells.size();}
	const vector<Id>& getOuterCells() const noexcept {return m_outer_cells;}
	size_t getNbTopCells() const noexcept { return m_top_cells.size(); }
	const vector<Id>& getTopCells() const noexcept { return m_top_cells; }
	size_t getNbBottomCells() const noexcept { return m_bottom_cells.size(); }
	const vector<Id>& getBottomCells() const noexcept { return m_bottom_cells; }
	size_t getNbLeftCells() const noexcept { return m_left_cells.size(); }
	const vector<Id>& getLeftCells() const noexcept { return m_left_cells; }
	size_t getNbRightCells() const noexcept { return m_right_cells.size(); }
	const vector<Id>& getRightCells() const noexcept { return m_right_cells; }

	size_t getNbTopFaces() const noexcept { return m_top_faces.size(); }
	const vector<Id>& getTopFaces() const noexcept { return m_top_faces; }
	size_t getNbBottomFaces() const noexcept { return m_bottom_faces.size(); }
	const vector<Id>& getBottomFaces() const noexcept { return m_bottom_faces; }
	size_t getNbLeftFaces() const noexcept { return m_left_faces.size(); }
	const vector<Id>& getLeftFaces() const noexcept { return m_left_faces; }
	size_t getNbRightFaces() const noexcept { return m_right_faces.size(); }
	const vector<Id>& getRightFaces() const noexcept { return m_right_faces; }

	size_t getNbOuterFaces() const noexcept { return m_outer_faces.size(); }
	vector<Id> getOuterFaces() const noexcept { return m_outer_faces; }
	size_t getNbInnerFaces() const noexcept { return m_inner_faces.size(); }
	vector<Id> getInnerFaces() const noexcept { return m_inner_faces; }
	size_t getNbInnerHorizontalFaces() const noexcept { return m_inner_horizontal_faces.size(); }
	vector<Id> getInnerHorizontalFaces() const noexcept { return m_inner_horizontal_faces; }
	size_t getNbInnerVerticalFaces() const noexcept { return m_inner_vertical_faces.size(); }
	vector<Id> getInnerVerticalFaces() const noexcept { return m_inner_vertical_faces; }

	Id getTopLeftNode() const noexcept { return m_top_left_node; }
	Id getTopRightNode() const noexcept { return m_top_right_node; }
	Id getBottomLeftNode() const noexcept { return m_bottom_left_node; }
	Id getBottomRightNode() const noexcept { return m_bottom_right_node; }

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
	size_t	getNbCommonIds(const array<Id, N>& as, const array<Id, M>& bs) const noexcept
	{
		size_t nbCommonIds(0);
		for (const auto& a : as)
			if (find(bs.begin(), bs.end(), a) != bs.end())
				++nbCommonIds;
		return nbCommonIds;
	}

	inline vector<Id> cellsOfNodeCollection(const vector<Id>& nodes);

	void create(size_t nb_x_quads, size_t nb_y_quads, double x_size, double y_size);

private:
	MeshGeometry<2>* m_geometry;

	size_t m_nb_x_quads;
	size_t m_nb_y_quads;

	vector<Id> m_inner_nodes;
	vector<Id> m_top_nodes;
	vector<Id> m_bottom_nodes;
	vector<Id> m_left_nodes;
	vector<Id> m_right_nodes;

	Id m_top_left_node;
	Id m_top_right_node;
	Id m_bottom_left_node;
	Id m_bottom_right_node;

	vector<Id> m_top_cells;
	vector<Id> m_bottom_cells;
	vector<Id> m_left_cells;
	vector<Id> m_right_cells;

	vector<Id> m_faces;
	vector<Id> m_outer_faces;
	vector<Id> m_inner_faces;
	vector<Id> m_inner_horizontal_faces;
	vector<Id> m_inner_vertical_faces;
	vector<Id> m_top_faces;
	vector<Id> m_bottom_faces;
	vector<Id> m_left_faces;
	vector<Id> m_right_faces;

	vector<Id> m_inner_cells;
	vector<Id> m_outer_cells;
};

}
#endif /* NABLALIB_MESH_CARTESIANMESH2D_H_ */
