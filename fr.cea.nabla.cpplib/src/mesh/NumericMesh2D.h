/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef MESH_NUMERICMESH2D_H_
#define MESH_NUMERICMESH2D_H_

#include "types/Types.h"
#include "mesh/Mesh.h"

using namespace std;

namespace nablalib
{

class NumericMesh2D
{
public:
	static constexpr int MaxNbNodesOfCell = 4;
	static constexpr int MaxNbNodesOfFace = 2;
	static constexpr int MaxNbCellsOfNode = 4;
	static constexpr int MaxNbCellsOfFace = 2;
	static constexpr int MaxNbNeighbourCells = 2;

	NumericMesh2D(Mesh<2>* geometricMesh);
	Mesh<2>* getGeometricMesh() noexcept { return m_geometricMesh; }

	size_t getNbNodes() const noexcept { return m_geometricMesh->getNodes().size(); }
	size_t getNbCells() const noexcept { return m_geometricMesh->getQuads().size(); }
	size_t getNbFaces() const noexcept { return m_geometricMesh->getEdges().size(); }

	size_t getNbInnerNodes() const noexcept { return getInnerNodes().size(); }
	size_t getNbOuterFaces() const noexcept { return getOuterFaces().size(); }
	const vector<int>& getInnerNodes() const noexcept { return m_geometricMesh->getInnerNodeIds(); }
	vector<int> getOuterFaces() const noexcept { return m_geometricMesh->getOuterEdgeIds(); }

	const array<int, 4>& getNodesOfCell(const int& cellId) const noexcept;
	const array<int, 2>& getNodesOfFace(const int& faceId) const noexcept;
	vector<int> getCellsOfNode(const int& nodeId) const noexcept;
	vector<int> getCellsOfFace(const int& faceId) const;
	vector<int> getNeighbourCells(const int& cellId) const;
	vector<int> getFacesOfCell(const int& cellId) const;
	int getCommonFace(const int& cellId1, const int& cellId2) const noexcept;

private:
	Mesh<2>* m_geometricMesh;

	int getNbCommonIds(const vector<int>& a, const vector<int>& b) const noexcept;
	template <std::size_t T, std::size_t U>
	int	getNbCommonIds(const std::array<int, T>& as, const std::array<int, U>& bs) const noexcept
	{
		int nbCommonIds(0);
		for (const auto& a : as)
			if (find(bs.begin(), bs.end(), a) != bs.end())
				++nbCommonIds;
		return nbCommonIds;
	}
};

}
#endif /* MESH_NUMERICMESH2D_H_ */
