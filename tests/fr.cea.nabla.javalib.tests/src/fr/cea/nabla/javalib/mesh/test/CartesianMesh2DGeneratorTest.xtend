/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib.mesh.test

import fr.cea.nabla.javalib.mesh.CartesianMesh2DGenerator
import org.junit.Test

import static org.junit.Assert.*

class CartesianMesh2DGeneratorTest
{
	val nbXQuads = 4
	val nbYQuads = 3
	val xSize = 5.0
	val ySize = 10.0
	val mesh = CartesianMesh2DGenerator::generate(nbXQuads, nbYQuads, xSize, ySize)

	@Test
	def void testGeometry()
	{
		mesh.dump

		val nbQuads = nbXQuads * nbYQuads
		assertEquals(nbQuads, mesh.geometry.quads.size)

		val nbNodes = (nbXQuads+1) * (nbYQuads+1)
		assertEquals(nbNodes, mesh.geometry.nodes.size)

		val nbEdges = ((nbXQuads+1) * nbYQuads) + ((nbYQuads+1) * nbXQuads)
		assertEquals(nbEdges, mesh.geometry.edges.size)

		var quadIndex = 0
		var double xUpperLeftNode
		var double yUpperLeftNode = 0
		for (j : 0..<nbYQuads)
		{
			xUpperLeftNode = 0
			for (i : 0..<nbXQuads)
			{
				val currentQuad = mesh.geometry.quads.get(quadIndex)
				val upperLeftNode = mesh.geometry.nodes.get(currentQuad.nodeIds.get(0))
				assertEquals(xUpperLeftNode, upperLeftNode.get(0), 0.0)
				assertEquals(yUpperLeftNode, upperLeftNode.get(1), 0.0)
				xUpperLeftNode += xSize
				quadIndex++
			}
			yUpperLeftNode += ySize
		}
	}

	@Test
	def void testTopology()
	{
		assertArrayEquals(mesh.innerNodes, #[6, 7, 8, 11, 12, 13])
		assertArrayEquals(mesh.bottomNodes, #[0, 1, 2, 3, 4])
		assertArrayEquals(mesh.topNodes, #[15, 16, 17, 18, 19])
		assertArrayEquals(mesh.leftNodes, #[0, 5, 10, 15])
		assertArrayEquals(mesh.rightNodes, #[4, 9, 14, 19])
		assertArrayEquals(mesh.outerFaces, #[0, 1, 2, 4, 6, 8, 10, 17, 19, 26, 27, 28, 29, 30])

		assertEquals(mesh.bottomLeftNode, 0)
		assertEquals(mesh.bottomRightNode, 4)
		assertEquals(mesh.topLeftNode, 15)
		assertEquals(mesh.topRightNode, 19)
	}

}