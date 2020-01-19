/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
	 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "mesh/CartesianMesh2D.h"

namespace nablalib
{

CartesianMesh2D::CartesianMesh2D(
	MeshGeometry<2>* geometry,
	const vector<int>& inner_nodes_ids,
	const vector<int>& top_nodes_ids,
	const vector<int>& bottom_nodes_ids,
	const vector<int>& left_nodes_ids,
	const vector<int>& right_nodes_ids,
	const int top_left_node_id,
	const int top_right_node_id,
	const int bottom_left_node_id,
	const int bottom_right_node_id)
: m_geometry(geometry)
, m_inner_nodes(inner_nodes_ids)
, m_top_nodes(top_nodes_ids)
, m_bottom_nodes(bottom_nodes_ids)
, m_left_nodes(left_nodes_ids)
, m_right_nodes(right_nodes_ids)
, m_top_left_node(top_left_node_id)
, m_top_right_node(top_right_node_id)
, m_bottom_left_node(bottom_left_node_id)
, m_bottom_right_node(bottom_right_node_id)
{
	// outer faces
	auto edges = m_geometry->getEdges();
	for (int edgeId(0); edgeId < edges.size(); ++edgeId)
		if (!isInnerEdge(edges[edgeId]))
			m_outer_faces.emplace_back(edgeId);
}

const array<int, 4>&
CartesianMesh2D::getNodesOfCell(const int& cellId) const noexcept
{
	return m_geometry->getQuads()[cellId].getNodeIds();
}

const array<int, 2>&
CartesianMesh2D::getNodesOfFace(const int& faceId) const noexcept
{
	return m_geometry->getEdges()[faceId].getNodeIds();
}

vector<int>
CartesianMesh2D::getCellsOfNode(const int& nodeId) const noexcept
{
	vector<int> candidateQuadIds;
	auto quads = m_geometry->getQuads();
	for (int quadId(0); quadId < quads.size(); ++quadId) {
		if (find(quads[quadId].getNodeIds().begin(), quads[quadId].getNodeIds().end(), nodeId) != quads[quadId].getNodeIds().end())
			candidateQuadIds.emplace_back(quadId);
	}
	return candidateQuadIds;
}

vector<int>
CartesianMesh2D::getCellsOfFace(const int& faceId) const
{
	std::vector<int> cellsOfFace;
	const auto& nodes(getNodesOfFace(faceId));
	for (auto nodeId : nodes)
	{
		auto adjacentCells(getCellsOfNode(nodeId));
		for (int quadId : adjacentCells)
			if (getNbCommonIds(nodes, m_geometry->getQuads()[quadId].getNodeIds()) == 2)
				cellsOfFace.emplace_back(quadId);
	}
	std::sort(cellsOfFace.begin(), cellsOfFace.end());
	cellsOfFace.erase(std::unique(cellsOfFace.begin(), cellsOfFace.end()), cellsOfFace.end());
	return cellsOfFace;
}

vector<int>
CartesianMesh2D::getNeighbourCells(const int& cellId) const
{
	std::vector<int> neighbours;
	const auto& nodes(getNodesOfCell(cellId));
	for (auto nodeId : nodes)
	{
		auto adjacentCells(getCellsOfNode(nodeId));
		for (int quadId : adjacentCells)
			if (quadId != cellId)
				if (getNbCommonIds(nodes, m_geometry->getQuads()[quadId].getNodeIds()) == 2)
					neighbours.emplace_back(quadId);
	}
	std::sort(neighbours.begin(), neighbours.end());
	neighbours.erase(std::unique(neighbours.begin(), neighbours.end()), neighbours.end());
	return neighbours;
}

vector<int>
CartesianMesh2D::getFacesOfCell(const int& cellId) const
{
	vector<int> cellEdgeIds;
	const auto& edges(m_geometry->getEdges());
	for (int edgeId=0; edgeId < edges.size(); ++edgeId)
		if (getNbCommonIds(edges[edgeId].getNodeIds(), m_geometry->getQuads()[cellId].getNodeIds()) == 2)
			cellEdgeIds.emplace_back(edgeId);
	return cellEdgeIds;
}

int
CartesianMesh2D::getCommonFace(const int& cellId1, const int& cellId2) const noexcept
{
	auto cell1Faces{getFacesOfCell(cellId1)};
	auto cell2Faces{getFacesOfCell(cellId2)};
	auto result = find_first_of(cell1Faces.begin(), cell1Faces.end(), cell2Faces.begin(), cell2Faces.end());
	if (result == cell1Faces.end())
	  return -1;
	else
	  return *result;
}

int
CartesianMesh2D::getNbCommonIds(const vector<int>& as, const vector<int>& bs) const noexcept
{
	int nbCommonIds = 0;
	for (auto a : as)
		for (auto b : bs)
			if (a == b) nbCommonIds++;
	return nbCommonIds;
}

bool
CartesianMesh2D::isInnerEdge(const Edge& e) const noexcept
{
	return (find(m_inner_nodes.begin(), m_inner_nodes.end(), e.getNodeIds()[0]) != m_inner_nodes.end()) ||
	       (find(m_inner_nodes.begin(), m_inner_nodes.end(), e.getNodeIds()[1]) != m_inner_nodes.end());
}

}
