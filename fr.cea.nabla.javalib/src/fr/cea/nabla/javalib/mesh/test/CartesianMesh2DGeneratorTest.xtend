package fr.cea.nabla.javalib.mesh.test

import fr.cea.nabla.javalib.mesh.CartesianMesh2DGenerator
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.*

class CartesianMesh2DGeneratorTest 
{
	@Test
	def test() 
	{
		val nbXQuads = 4
		val nbYQuads = 3
		
		val xSize = 5.0
		val ySize = 10.0
		val mesh = CartesianMesh2DGenerator::generate(nbXQuads, nbYQuads, xSize, ySize)
		mesh.dump
		
		val nbQuads = nbXQuads * nbYQuads
		assertEquals(nbQuads, mesh.quads.size)

		val nbNodes = (nbXQuads+1) * (nbYQuads+1)
		assertEquals(nbNodes, mesh.nodes.size)
		
		val nbEdges = ((nbXQuads+1) * nbYQuads) + ((nbYQuads+1) * nbXQuads)
		assertEquals(nbEdges, mesh.edges.size)
		
		var quadIndex = 0
		var double xUpperLeftNode
		var double yUpperLeftNode = 0
		for (j : 0..<nbYQuads)
		{
			xUpperLeftNode = 0
			for (i : 0..<nbXQuads)
			{
				val currentQuad = mesh.quads.get(quadIndex)
				val upperLeftNode = mesh.nodes.get(currentQuad.nodeIds.get(0))
				assertEquals(xUpperLeftNode, upperLeftNode.x)
				assertEquals(yUpperLeftNode, upperLeftNode.y)
				xUpperLeftNode += xSize
				quadIndex++
			}
			yUpperLeftNode += ySize
		}
	}
}