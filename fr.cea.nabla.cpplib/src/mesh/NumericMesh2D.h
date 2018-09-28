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
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
#ifndef MESH_NUMERICMESH2D_H_
#define MESH_NUMERICMESH2D_H_

#include "mesh/Mesh.h"
#include "types/Real2.h"

using namespace std;

namespace nablalib
{

class NumericMesh2D
{
public:
	static const int MaxNbNodesOfCell = 4;
	static const int MaxNbNodesOfFace = 2;
	static const int MaxNbNeighbourCells = 2;

	NumericMesh2D(Mesh<Real2>* geometricMesh);
	Mesh<Real2>* getGeometricMesh() { return m_geometricMesh; }

	int getNbNodes() const { return m_geometricMesh->getNodes().size(); }
	int getNbCells() const { return m_geometricMesh->getQuads().size(); }
	int getNbFaces() const { return m_geometricMesh->getEdges().size(); }

	const vector<int> getNodesOfCell(int cellId) const;
	const vector<int> getNodesOfFace(int faceId) const;
	const vector<int> getFacesOfCell(int cellId) const;
	const vector<int> getNeighbourCells(int cellId) const;
	const int getCommonFace(const int cellId1, const int cellId2) const;

private:
	Mesh<Real2>* m_geometricMesh;

	const int getNbCommonIds(const vector<int>& a, const vector<int>& b) const;
};

}
#endif /* MESH_NUMERICMESH2D_H_ */
