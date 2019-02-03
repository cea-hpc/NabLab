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
package fr.cea.nabla.javalib.mesh

import fr.cea.nabla.javalib.types.Real2

class  CartesianMesh2DGenerator
{
	static def Mesh<Real2> generate(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		val nbNodes = (nbXQuads + 1) * (nbYQuads + 1)
		val nbQuads = nbXQuads * nbYQuads
		val nbEdges = 2 * nbQuads + nbXQuads + nbYQuads
		val nbOuterNodes = 2 * (nbXQuads + nbYQuads)
		val nbInnerNodes = nbNodes - nbOuterNodes
		val mesh = new Mesh(nbNodes, nbEdges, nbQuads, nbInnerNodes)
		
		// node creation
		val nodes = mesh.nodes
		val innerNodeIds = mesh.innerNodeIds
		var nodeId = 0
		var innerNodeId = 0
		for (j : 0..nbYQuads)
			for (i : 0..nbXQuads)
			{
				val coord = new Real2(xSize*i, ySize*j)
				nodes.add(coord)
				if (i!=0 && j!=0 && i!=nbXQuads && j!=nbYQuads) 
					innerNodeIds.set(innerNodeId++, nodeId)
				nodeId++
			}
				
		// edge creation
		val edges = mesh.edges
		val nbXNodes = nbXQuads+1
		var edgeId = 0
		for (i : 0..<nodes.size)
		{
			val rightNodeIndex = i+1
			if (rightNodeIndex%nbXNodes!=0) edges.set(edgeId++, new Edge(i, rightNodeIndex))
			val belowNodeIndex = i + nbXNodes
			if (belowNodeIndex<nodes.size) edges.set(edgeId++, new Edge(i, belowNodeIndex))
		}
		
		// quad creation
		val quads = mesh.quads
		var quadId = 0
		for (j : 0..<nbYQuads)
			for (i : 0..<nbXQuads)
			{
				val upperLeftNodeIndex = (j*nbXNodes)+i
				val lowerLeftNodeIndex = upperLeftNodeIndex + nbXNodes
				quads.set(quadId++, new Quad(upperLeftNodeIndex, upperLeftNodeIndex+1, lowerLeftNodeIndex+1, lowerLeftNodeIndex))
			}

		return mesh
	}
}