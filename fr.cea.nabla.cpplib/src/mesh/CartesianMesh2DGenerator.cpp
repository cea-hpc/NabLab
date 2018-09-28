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
#include "mesh/CartesianMesh2DGenerator.h"

namespace nablalib
{

Mesh<Real2>*
CartesianMesh2DGenerator::generate(int nbXQuads, int nbYQuads, double xSize, double ySize)
{
	const int nbNodes = (nbXQuads + 1) * (nbYQuads + 1);
	const int nbQuads = nbXQuads * nbYQuads;
	const int nbEdges = 2 * nbQuads + nbXQuads + nbYQuads;
	const int nbOuterNodes = 2 * (nbXQuads + nbYQuads);
	const int nbInnerNodes = nbNodes - nbOuterNodes;
	auto mesh = new Mesh<Real2>(nbNodes, nbEdges, nbQuads, nbInnerNodes);

	// node creation
	auto& nodes = mesh->getNodes();
	auto& innerNodeIds = mesh->getInnerNodeIds();
	int nodeId = 0;
	int innerNodeId = 0;
	cout << "creation des noeuds "<< endl;
	for (int j=0; j<=nbYQuads; ++j)
		for (int i=0; i<=nbXQuads; ++i)
		{
			nodes[nodeId] = Real2(xSize*i, ySize*j);
			cout << "noeud " << nodeId << " = " << nodes[nodeId] <<endl;
			if (i==0 || j==0 || i==nbXQuads-1 || j==nbYQuads-1)
				innerNodeIds[innerNodeId++] = nodeId;
			nodeId++;
		}

	// edge creation
	auto& edges = mesh->getEdges();
	const int nbXNodes = nbXQuads+1;
	int edgeId = 0;
	for (int i=0; i<nodes.size(); ++i)
	{
		const int rightNodeIndex = i+1;
		if (rightNodeIndex%nbXNodes!=0) edges[edgeId++] = Edge(i, rightNodeIndex);
		const int belowNodeIndex = i + nbXNodes;
		if (belowNodeIndex<nodes.size()) edges[edgeId++] = Edge(i, belowNodeIndex);
	}

	// quad creation
	auto& quads = mesh->getQuads();
	int quadId = 0;
	for (int j=0; j<nbYQuads; ++j)
		for (int i=0; i<nbXQuads; ++i)
		{
			const int upperLeftNodeIndex = (j*nbXNodes)+i;
			const int lowerLeftNodeIndex = upperLeftNodeIndex + nbXNodes;
			quads[quadId++] = Quad(upperLeftNodeIndex, upperLeftNodeIndex+1, lowerLeftNodeIndex+1, lowerLeftNodeIndex);
		}

	return mesh;
}

}
