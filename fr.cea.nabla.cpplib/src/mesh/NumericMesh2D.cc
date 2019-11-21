/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
	 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "mesh/NumericMesh2D.h"

namespace nablalib
{

NumericMesh2D::NumericMesh2D(Mesh<2>* geometricMesh)
: m_geometricMesh(geometricMesh)
{
}

const array<int, 4>&
NumericMesh2D::getNodesOfCell(const int& cellId) const noexcept
{
	return m_geometricMesh->getQuads()[cellId].getNodeIds();
}

const array<int, 2>&
NumericMesh2D::getNodesOfFace(const int& faceId) const noexcept
{
	return m_geometricMesh->getEdges()[faceId].getNodeIds();
}

vector<int>
NumericMesh2D::getCellsOfNode(const int& nodeId) const noexcept
{
	return m_geometricMesh->getQuadIdsOfNode(nodeId);
}

vector<int>
NumericMesh2D::getCellsOfFace(const int& faceId) const
{
	std::vector<int> cellsOfFace;
	const auto& nodes(getNodesOfFace(faceId));
	for (auto nodeId : nodes)
	{
		auto adjacentCells(m_geometricMesh->getQuadIdsOfNode(nodeId));
		for (int quadId : adjacentCells)
			if (getNbCommonIds(nodes, m_geometricMesh->getQuads()[quadId].getNodeIds()) == 2)
				cellsOfFace.emplace_back(quadId);
	}
	std::sort(cellsOfFace.begin(), cellsOfFace.end());
	cellsOfFace.erase(std::unique(cellsOfFace.begin(), cellsOfFace.end()), cellsOfFace.end());
	return cellsOfFace;
}

vector<int>
NumericMesh2D::getNeighbourCells(const int& cellId) const
{
	std::vector<int> neighbours;
	const auto& nodes(getNodesOfCell(cellId));
	for (auto nodeId : nodes)
	{
		auto adjacentCells(m_geometricMesh->getQuadIdsOfNode(nodeId));
		for (int quadId : adjacentCells)
			if (quadId != cellId)
				if (getNbCommonIds(nodes, m_geometricMesh->getQuads()[quadId].getNodeIds()) == 2)
					neighbours.emplace_back(quadId);
	}
	std::sort(neighbours.begin(), neighbours.end());
	neighbours.erase(std::unique(neighbours.begin(), neighbours.end()), neighbours.end());
	return neighbours;
}

vector<int>
NumericMesh2D::getFacesOfCell(const int& cellId) const
{
	vector<int> cellEdgeIds;
	const auto& edges(m_geometricMesh->getEdges());
	for (int edgeId=0; edgeId < edges.size(); ++edgeId)
		if (getNbCommonIds(edges[edgeId].getNodeIds(), m_geometricMesh->getQuads()[cellId].getNodeIds()) == 2)
			cellEdgeIds.emplace_back(edgeId);
	return cellEdgeIds;
}

int
NumericMesh2D::getCommonFace(const int& cellId1, const int& cellId2) const noexcept
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
NumericMesh2D::getNbCommonIds(const vector<int>& as, const vector<int>& bs) const noexcept
{
	int nbCommonIds = 0;
	for (auto a : as)
		for (auto b : bs)
			if (a == b) nbCommonIds++;
	return nbCommonIds;
}

}
