/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib.mesh

class  CartesianMesh2DGenerator
{
	static def CartesianMesh2D generate(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		val double[][] nodes = newDoubleArrayOfSize((nbXQuads + 1) * (nbYQuads + 1)).map[newDoubleArrayOfSize(2)]
		val Quad[] quads = newArrayOfSize(nbXQuads * nbYQuads)
		val Edge[] edges = newArrayOfSize(2 * quads.size + nbXQuads + nbYQuads)

		val outerNodeIds = newIntArrayOfSize(2 * (nbXQuads + nbYQuads))
		val innerNodeIds = newIntArrayOfSize(nodes.size - outerNodeIds.size)
		val topNodeIds = newIntArrayOfSize(nbXQuads + 1)
		val bottomNodeIds = newIntArrayOfSize(nbXQuads + 1)
		val leftNodeIds = newIntArrayOfSize(nbYQuads + 1)
		val rightNodeIds = newIntArrayOfSize(nbYQuads + 1)

		// node creation
		var nodeId = 0
		var innerNodeId = 0
		var topNodeId = 0
		var bottomNodeId = 0
		var leftNodeId = 0
		var rightNodeId = 0
		for (j : 0..nbYQuads)
			for (i : 0..nbXQuads)
			{
				nodes.set(nodeId, 0, xSize*i)
				nodes.set(nodeId, 1, ySize*j)
				if (i!=0 && j!=0 && i!=nbXQuads && j!=nbYQuads) 
					innerNodeIds.set(innerNodeId++, nodeId)
				else
				{
					if (j==0) topNodeIds.set(topNodeId++, nodeId)
					if (j==nbYQuads) bottomNodeIds.set(bottomNodeId++, nodeId)
					if (i==0) leftNodeIds.set(leftNodeId++, nodeId)
					if (i==nbXQuads) rightNodeIds.set(rightNodeId++, nodeId)
				}
				nodeId++
			}

		// edge creation
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
		var quadId = 0
		for (j : 0..<nbYQuads)
			for (i : 0..<nbXQuads)
			{
				val upperLeftNodeIndex = (j*nbXNodes)+i
				val lowerLeftNodeIndex = upperLeftNodeIndex + nbXNodes
				quads.set(quadId++, new Quad(upperLeftNodeIndex, upperLeftNodeIndex+1, lowerLeftNodeIndex+1, lowerLeftNodeIndex))
			}

		val meshGeometry = new MeshGeometry(nodes, edges, quads)
		return new CartesianMesh2D(meshGeometry, innerNodeIds, topNodeIds, bottomNodeIds, leftNodeIds, rightNodeIds)
	}
}