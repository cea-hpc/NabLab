/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef MESH_MESH_H_
#define MESH_MESH_H_

#include <vector>
#include <algorithm>

#include "mesh/NodeIdContainer.h"
#include "mesh/CartesianMesh2DGenerator.h"

using namespace std;

namespace nablalib
{

template<size_t N>
class Mesh
{
  friend class CartesianMesh2DGenerator;

 public:
  Mesh(int nbNodes, int nbEdges, int nbQuads, int nbInnerNodes)
	  : m_nodes(nbNodes), m_edges(nbEdges), m_quads(nbQuads) , m_innerNodeIds(nbInnerNodes) { }

	const vector<Edge>& getEdges() noexcept { return m_edges; }
	const vector<int>& getInnerNodeIds() noexcept { return m_innerNodeIds; }
	const vector<RealArray1D<N>>& getNodes() noexcept { return m_nodes; }
	const vector<Quad>& getQuads() noexcept { return m_quads; }

	vector<int> getQuadIdsOfNode(const int& nodeId) const
	{
		vector<int> candidateQuadIds;
		for (int quadId(0); quadId < m_quads.size(); ++quadId) {
			if (find(m_quads[quadId].getNodeIds().begin(), m_quads[quadId].getNodeIds().end(),
			         nodeId) != m_quads[quadId].getNodeIds().end())
				candidateQuadIds.emplace_back(quadId);
		}
		return candidateQuadIds;
	}

	vector<int> getOuterEdgeIds() const
	{
		vector<int> candidateEdgeIds;
		for (int edgeId(0); edgeId < m_edges.size(); ++edgeId)
			if (!isInnerEdge(m_edges[edgeId]))
				candidateEdgeIds.emplace_back(edgeId);
		return candidateEdgeIds;
	}

	bool isInnerEdge(const Edge& e) const noexcept
	{
		return (find(m_innerNodeIds.begin(), m_innerNodeIds.end(), e.getNodeIds()[0]) != m_innerNodeIds.end()) ||
		       (find(m_innerNodeIds.begin(), m_innerNodeIds.end(), e.getNodeIds()[1]) != m_innerNodeIds.end());
	}

private:
	vector<RealArray1D<N>> m_nodes;
	vector<Edge> m_edges;
	vector<Quad> m_quads;
	vector<int> m_innerNodeIds;
};

}
#endif /* MESH_MESH_H_ */
