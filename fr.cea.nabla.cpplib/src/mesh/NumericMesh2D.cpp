/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
#include "mesh/NumericMesh2D.h"

namespace nablalib
{

NumericMesh2D::NumericMesh2D(Mesh<Real2>* geometricMesh)
: m_geometricMesh(geometricMesh)
{
}

const vector<int>
NumericMesh2D::getNodesOfCell(int cellId) const
{
	auto geometricCell = m_geometricMesh->getQuads()[cellId];
	return geometricCell.getNodeIds();
}

const vector<int>
NumericMesh2D::getNodesOfFace(int faceId) const
{
	auto geometricFace = m_geometricMesh->getEdges()[faceId];
	return geometricFace.getNodeIds();
}

const vector<int>
NumericMesh2D::getFacesOfCell(int cellId) const
{
	auto geometricCell = m_geometricMesh->getQuads()[cellId];
	vector<int> cellEdgeIds;
	auto edges = m_geometricMesh->getEdges();
	for (int edgeId=0; edgeId<edges.size(); ++edgeId)
		if (getNbCommonIds(edges[edgeId].getNodeIds(), geometricCell.getNodeIds()) == 2)
			cellEdgeIds.push_back(edgeId);
	return cellEdgeIds;
}

const vector<int>
NumericMesh2D::getNeighbourCells(int cellId) const
{
	std::vector<int> neighbours;
	auto nodes = getNodesOfCell(cellId);
	for (auto nodeId : nodes)
	{
		auto adjacentCells = m_geometricMesh->getQuadIdsOfNode(nodeId);
		for (int quadId : adjacentCells)
		 {
			if (quadId != cellId)
			{
				auto adjacentQuad = m_geometricMesh->getQuads()[quadId];
				auto adjacentQuadNodes = adjacentQuad.getNodeIds();
				if (getNbCommonIds(nodes, adjacentQuadNodes) == 2)
					neighbours.push_back(quadId);
			}
		}
	}
	return neighbours;
}

const int
NumericMesh2D::getCommonFace(const int cellId1, const int cellId2) const
{
	auto cell1Faces = getFacesOfCell(cellId1);
	auto cell2Faces = getFacesOfCell(cellId2);
	auto result = find_first_of(cell1Faces.begin(), cell1Faces.end(), cell2Faces.begin(), cell2Faces.end());
	if (result == cell1Faces.end()) return -1;
	else return *result;
}

const int
NumericMesh2D::getNbCommonIds(const vector<int>& as, const vector<int>& bs) const
{
	int nbCommonIds = 0;
	for (auto a : as)
		for (auto b : bs)
			if (a == b) nbCommonIds++;
	return nbCommonIds;
}

}
