/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_MESH_MESHGEOMETRY_H_
#define NABLALIB_MESH_MESHGEOMETRY_H_

#include <vector>
#include <algorithm>

#include "nablalib/mesh/NodeIdContainer.h"

using namespace std;

namespace nablalib::mesh
{
template<size_t N>
class MeshGeometry
{
public:
	MeshGeometry(const vector<RealArray1D<N>>& nodes, const vector<Edge>& edges, const vector<Quad>& quads)
	  : m_nodes(nodes), m_edges(edges), m_quads(quads) { }

	const vector<RealArray1D<N>>& getNodes() noexcept { return m_nodes; }
	const vector<Edge>& getEdges() noexcept { return m_edges; }
	const vector<Quad>& getQuads() noexcept { return m_quads; }

private:
	vector<RealArray1D<N>> m_nodes;
	vector<Edge> m_edges;
	vector<Quad> m_quads;
};

}
#endif /* NABLALIB_MESH_MESHGEOMETRY_H_ */
