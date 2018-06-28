package fr.cea.nabla.javalib.mesh

import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

/** T vaut Real2 ou Real3 */
class Mesh<T> 
{
	@Accessors val ArrayList<T> nodes
	@Accessors val Edge[] edges
	@Accessors val Quad[] quads
	@Accessors val int[] innerNodeIds

	new(int nbNodes, int nbEdges, int nbQuads, int nbInnerNodes)
	{
		nodes = new ArrayList<T>(nbNodes)
		edges = newArrayOfSize(nbEdges)
		quads = newArrayOfSize(nbQuads)
		innerNodeIds = newIntArrayOfSize(nbInnerNodes)
	}
	
	def getQuadIdsOfNode(int nodeId)
	{
		val size = quads.filter[q|q.nodeIds.contains(nodeId)].size
		val candidateQuadIds = newIntArrayOfSize(size)
		var int quadId = 0
		var int candidateQuadId = 0
		for (q : quads)
		{
			if (q.nodeIds.contains(nodeId))
			{
				candidateQuadIds.set(candidateQuadId, quadId)
				candidateQuadId++
			}
			quadId++
		}
		return candidateQuadIds
	}
	
	def getOuterEdgeIds()
	{
		val size = edges.filter[e|!e.innerEdge].size
		val candidateEdgeIds = newIntArrayOfSize(size)
		var int edgeId = 0
		var int candidateEdgeId = 0
		for (e : edges)
		{
			if (!e.innerEdge)
			{
				candidateEdgeIds.set(candidateEdgeId, edgeId)
				candidateEdgeId++
			}
			edgeId++
		}
		return candidateEdgeIds
	}
	
	def isInnerEdge(Edge it)
	{
		innerNodeIds.contains(nodeIds.get(0)) || innerNodeIds.contains(nodeIds.get(1))
	}
	
	def dump()
	{
		println('Mesh ')
		println('  nodes : ' + nodes.map[toString].join(','))	
		println('  edges : ' + edges.map[toString].join(','))	
		println('  quads : ' + quads.map[toString].join(','))
		println('  outer edges : ' + outerEdgeIds.map[toString].join(','))
	}
}