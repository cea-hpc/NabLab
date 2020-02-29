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

import java.util.HashSet
import java.util.stream.IntStream
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.Map
import java.util.concurrent.ConcurrentHashMap

class CartesianMesh2D
{
	public static val MaxNbNodesOfCell = 4
	public static val MaxNbNodesOfFace = 2
	public static val MaxNbCellsOfNode = 4
	public static val MaxNbCellsOfFace = 2
	public static val MaxNbNeighbourCells = 4

	@Accessors val MeshGeometry geometry
	@Accessors val int[] innerNodes
	@Accessors val int[] topNodes
	@Accessors val int[] bottomNodes
	@Accessors val int[] leftNodes
	@Accessors val int[] rightNodes
	@Accessors val int[] outerFaces

	@Accessors val int topLeftNode
	@Accessors val int topRightNode
	@Accessors val int bottomLeftNode
	@Accessors val int bottomRightNode

	new(MeshGeometry meshGeometry, int[] innerNodeIds, int[] topNodeIds, int[] bottomNodeIds, int[] leftNodeIds, int[] rightNodeIds)
	{
		this.geometry = meshGeometry
		this.innerNodes = innerNodeIds
		this.topNodes = topNodeIds
		this.bottomNodes = bottomNodeIds
		this.leftNodes = leftNodeIds
		this.rightNodes = rightNodeIds
		this.topLeftNode = topNodes.findFirst[x | leftNodes.contains(x)]
		this.topRightNode = topNodes.findFirst[x | rightNodes.contains(x)]
		this.bottomLeftNode = bottomNodes.findFirst[x | leftNodes.contains(x)]
		this.bottomRightNode = bottomNodes.findFirst[x | rightNodes.contains(x)]

		// outer faces
		val size = geometry.edges.filter[e|!e.innerEdge].size
		outerFaces = newIntArrayOfSize(size)
		var int edgeId = 0
		var int outerFaceId = 0
		for (e : geometry.edges)
		{
			if (!e.innerEdge) outerFaces.set(outerFaceId++, edgeId)
			edgeId++
		}
	}

	def getNbNodes() { geometry.nodes.size }
	def getNodes() { IntStream.range(0, nbNodes).toArray }

	def getNbCells() { geometry.quads.size }
	def getCells() { IntStream.range(0, nbCells).toArray }

	def getNbFaces() { geometry.edges.size }
	def getFaces() { IntStream.range(0, nbFaces).toArray }

	def getNbInnerNodes() { innerNodes.size }
	def getNbTopNodes() { topNodes.size }
	def getNbBottomNodes() { bottomNodes.size }
	def getNbLeftNodes() { leftNodes.size }
	def getNbRightNodes() { rightNodes.size }
	def getNbOuterFaces() { outerFaces.size }

	def getNodesOfCell(int cellId)
	{
		val geometricCell = geometry.quads.get(cellId)
		geometricCell.nodeIds
	}

	def getNodesOfFace(int faceId)
	{
		val geometricFace = geometry.edges.get(faceId)
		geometricFace.nodeIds
	}

	// Store effectively constant data requiring intensive computations
	val nodeIdToCells = new ConcurrentHashMap<Integer, int[]>
	val faceIdToCells = new ConcurrentHashMap<Integer, int[]>
	val cellIdToNeighbourCell = new ConcurrentHashMap<Integer, int[]>

	def getCellsOfNode(int nodeId)
	{
		return nodeIdToCells.computeIfAbsent(nodeId, [id|
			val size = geometry.quads.filter[q|q.nodeIds.contains(id)].size
			val candidateQuadIds = newIntArrayOfSize(size)
			var int quadId = 0
			var int candidateQuadId = 0
			for (q : geometry.quads) {
				if (q.nodeIds.contains(id)) candidateQuadIds.set(candidateQuadId++, quadId)
				quadId++
			}
			return candidateQuadIds
		])
	}

	def getCellsOfFace(int faceId)
	{
		return faceIdToCells.computeIfAbsent(faceId, [id|
			val cellsOfFace = new HashSet<Integer>
			val nodes = getNodesOfFace(id)
			for (nodeId : nodes)
			{
				for (quadId : getCellsOfNode(nodeId))
				{
					val adjacentQuad = geometry.quads.get(quadId)
					if (adjacentQuad.nodeIds.filter(n | nodes.contains(n)).size == 2)
						cellsOfFace.add(quadId)
				}
			}
			val int[] a = cellsOfFace.map[intValue]
			return a
		])
	}

	def getNeighbourCells(int cellId)
	{
		return cellIdToNeighbourCell.computeIfAbsent(cellId, [id|
			val neighbours = new HashSet<Integer>
			val nodes = getNodesOfCell(id)
			for (nodeId : nodes)
			{
				for (quadId : getCellsOfNode(nodeId))
					if (quadId != id)
					{
						val adjacentQuad = geometry.quads.get(quadId)
						if (adjacentQuad.nodeIds.filter(n | nodes.contains(n)).size == 2)
							neighbours.add(quadId)
					}
			}
			val int[] a = neighbours.map[intValue]
			return a
		])
	}

	def getFacesOfCell(int cell)
	{
		val geometricCell = geometry.quads.get(cell)
		val size = geometry.edges.filter[e|geometricCell.nodeIds.containsAll(e.nodeIds)].size
		val candidateEdgeIds = newIntArrayOfSize(size)
		var int edgeId = 0
		var int candidateEdgeId = 0
		for (e : geometry.edges)
		{
			if (geometricCell.nodeIds.containsAll(e.nodeIds))
			{
				candidateEdgeIds.set(candidateEdgeId, edgeId)
				candidateEdgeId++
			}
			edgeId++
		}
		return candidateEdgeIds
	}

	def int getCommonFace(int cell1, int cell2)
	{
		val cell1Faces = getFacesOfCell(cell1)
		val cell2Faces = getFacesOfCell(cell2)
		val result = cell1Faces.findFirst[x|cell2Faces.exists[y|y==x]]
		if (result === null) -1
		else result.intValue
	}

	def dump()
	{
		geometry.dump
		println('Mesh Topology')
		println('  inner nodes  : ' + innerNodes.map[toString].join(', '))
		println('  top nodes    : ' + topNodes.map[toString].join(', '))
		println('  bottom nodes : ' + bottomNodes.map[toString].join(', '))
		println('  left nodes   : ' + leftNodes.map[toString].join(', '))
		println('  right nodes  : ' + rightNodes.map[toString].join(', '))
		println('  outer faces  : ' + outerFaces.map[toString].join(', '))
	}

	private def isInnerEdge(Edge it)
	{
		innerNodes.contains(nodeIds.get(0)) || innerNodes.contains(nodeIds.get(1))
	}
}
