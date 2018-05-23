package fr.cea.nabla.javalib.mesh

import fr.cea.nabla.javalib.types.Real2
import java.util.HashSet
import org.eclipse.xtend.lib.annotations.Accessors

class NumericMesh2D
{
	public static val MaxNbNodesOfCell = 4
	public static val MaxNbNodesOfFaces = 2
	
	@Accessors val Mesh<Real2> geometricMesh
	
	new(Mesh<Real2> geometricMesh)
	{
		this.geometricMesh = geometricMesh
	}
	
	def getNbNodes() { geometricMesh.nodes.size }
	def getNbCells() { geometricMesh.quads.size }
	def getNbFaces() { geometricMesh.edges.size }
	
	def getNodesOfCell(int cellId)
	{
		val geometricCell = geometricMesh.quads.get(cellId)
		geometricCell.nodeIds.toList
		val int[] a = geometricCell.nodeIds.map[intValue]
		return a
	}
	
	def getNodesOfFace(int faceId)
	{
		val geometricFace = geometricMesh.edges.get(faceId)
		val int[] a = geometricFace.nodeIds.map[intValue]
		return a
	}

	def getNeighbourCells(int cellId)
	{
		val neighbours = new HashSet<Integer>
		val nodes = getNodesOfCell(cellId)
		for (nodeId : nodes)
		{
			for (quadId : geometricMesh.getQuadIdsOfNode(nodeId))
				if (quadId != cellId)
				{
					val adjacentQuad = geometricMesh.quads.get(quadId)
					if (adjacentQuad.nodeIds.filter(n | nodes.contains(n)).size == 2)
						neighbours.add(quadId)
				}
		}
		val int[] a = neighbours.map[intValue]
		return a
	}
	
	def getFacesOfCell(int cell) 
	{
		val geometricCell = geometricMesh.quads.get(cell)
		val size = geometricMesh.edges.filter[e|geometricCell.nodeIds.containsAll(e.nodeIds)].size
		val candidateEdgeIds = newIntArrayOfSize(size)
		var int edgeId = 0
		var int candidateEdgeId = 0
		for (e : geometricMesh.edges)
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
		cell1Faces.findFirst[x|cell2Faces.exists[y|y==x]]
	}
}
