/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib.mesh.test

import fr.cea.nabla.javalib.mesh.CartesianMesh2D
import org.junit.Test

import static org.junit.Assert.*

/* Numbering nodes and cells			Numbering faces
 *
 *  15---16---17---18---19          |-27-|-28-|-29-|-30-|
 *   | 8  | 9  | 10 | 11 |         19   21   23   25   26
 *  10---11---12---13---14          |-18-|-20-|-22-|-24-|
 *   | 4  | 5  | 6  | 7  |         10   12   14   16   17
 *   5----6----7----8----9          |--9-|-11-|-13-|-15-|
 *   | 0  | 1  | 2  | 3  |          1    3    5    7    8
 *   0----1----2----3----4          |-0--|-2--|-4--|-6--|
 */
class CartesianMesh2DTest
{
	val nbXQuads = 4
	val nbYQuads = 3
	val xSize = 5.0
	val ySize = 10.0

	@Test
	def void testGeometry()
	{
		val mesh = new CartesianMesh2D(nbXQuads, nbYQuads, xSize, ySize)
		mesh.dump()

		val nbQuads = nbXQuads * nbYQuads
		assertEquals(nbQuads, mesh.geometry.getQuads.size)

		val nbNodes = (nbXQuads + 1) * (nbYQuads + 1)
		assertEquals(nbNodes, mesh.geometry.getNodes.size)

		val nbEdges = ((nbXQuads + 1) * nbYQuads) + ((nbYQuads + 1) * nbXQuads)
		assertEquals(nbEdges, mesh.geometry.getEdges.size)

		var quadIndex = 0
		var double xUpperLeftNode
		var double yUpperLeftNode = 0
		for (j : 0 ..< nbYQuads)
		{
			xUpperLeftNode = 0
			for (i : 0 ..< nbXQuads)
			{
				val currentQuad = mesh.geometry.getQuads.get(quadIndex)
				val upperLeftNode = mesh.geometry.getNodes.get(currentQuad.nodeIds.get(0))
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
		val mesh = new CartesianMesh2D(nbXQuads, nbYQuads, xSize, ySize)

		assertEquals((nbXQuads + 1) * (nbYQuads + 1), mesh.nbNodes)
		assertEquals(nbXQuads * nbYQuads, mesh.nbCells)
		assertEquals(2 * nbXQuads * nbYQuads + nbXQuads + nbYQuads, mesh.nbFaces);

		assertArrayEquals(#[6, 7, 8, 11, 12, 13], mesh.innerNodes)
		assertArrayEquals(#[15, 16, 17, 18, 19], mesh.topNodes)
		assertArrayEquals(#[0, 1, 2, 3, 4], mesh.bottomNodes)
		assertArrayEquals(#[0, 5, 10, 15], mesh.leftNodes)
		assertArrayEquals(#[4, 9, 14, 19], mesh.rightNodes)

		assertArrayEquals(#[5, 6], mesh.innerCells)
		assertArrayEquals(#[0, 1, 2, 3, 4, 7, 8, 9, 10, 11], mesh.outerCells)
		assertArrayEquals(#[8, 9, 10, 11], mesh.topCells)
		assertArrayEquals(#[0, 1, 2, 3], mesh.bottomCells)
		assertArrayEquals(#[0, 4, 8], mesh.leftCells)
		assertArrayEquals(#[3, 7, 11], mesh.rightCells)

		assertArrayEquals(#[27, 28, 29, 30], mesh.topFaces)
		assertArrayEquals(#[0, 2, 4, 6], mesh.bottomFaces)
		assertArrayEquals(#[1, 10, 19], mesh.leftFaces)
		assertArrayEquals(#[8, 17, 26], mesh.rightFaces)
		assertArrayEquals(#[0, 1, 2, 4, 6, 8, 10, 17, 19, 26, 27, 28, 29, 30], mesh.outerFaces)
		assertArrayEquals(#[3, 5, 7, 9, 11, 12, 13, 14, 15, 16, 18, 20, 21, 22, 23, 24, 25], mesh.innerFaces)
		assertArrayEquals(#[9, 11, 13, 15, 18, 20, 22, 24], mesh.innerHorizontalFaces)
		assertArrayEquals(#[3, 5, 7, 12, 14, 16, 21, 23, 25], mesh.innerVerticalFaces)

		assertEquals(0, mesh.bottomLeftNode)
		assertEquals(4, mesh.bottomRightNode)
		assertEquals(15, mesh.topLeftNode)
		assertEquals(19, mesh.topRightNode)
	}

	@Test
	def void testConnectivity()
	{
		val mesh = new CartesianMesh2D(nbXQuads, nbYQuads, xSize, ySize)

		assertArrayEquals(#[0, 1, 6, 5], mesh.getNodesOfCell(0))

		assertArrayEquals(#[0, 1], mesh.getNodesOfFace(0))
		assertArrayEquals(#[0, 5], mesh.getNodesOfFace(1))

		assertEquals(0, mesh.getFirstNodeOfFace(0))
		assertEquals(1, mesh.getSecondNodeOfFace(0))

		assertArrayEquals(#[0], mesh.getCellsOfNode(0))
		assertArrayEquals(#[0, 4], mesh.getCellsOfNode(5))
		assertArrayEquals(#[0, 1, 4, 5], mesh.getCellsOfNode(6))

		assertArrayEquals(#[0], mesh.getCellsOfFace(0))
		assertArrayEquals(#[0, 1], mesh.getCellsOfFace(3))

		assertArrayEquals(#[1, 4], mesh.getNeighbourCells(0))
		assertArrayEquals(#[0, 2, 5], mesh.getNeighbourCells(1))
		assertArrayEquals(#[1, 4, 6, 9], mesh.getNeighbourCells(5))

		assertArrayEquals(#[0, 1, 3, 9], mesh.getFacesOfCell(0))

		assertEquals(3, mesh.getCommonFace(0, 1))
		assertEquals(-1, mesh.getCommonFace(0, 5))

		assertEquals(0, mesh.getBackCell(3))
		assertEquals(1, mesh.getFrontCell(3))
		try {
			assertEquals(-1, mesh.getBackCell(1))
			fail()
		} catch (Exception e1) {
		}
		try {
			assertEquals(-1, mesh.getFrontCell(1))
			fail()
		} catch (Exception e2) {
		}

		assertEquals(9, mesh.getTopFaceOfCell(0))
		assertEquals(0, mesh.getBottomFaceOfCell(0))
		assertEquals(1, mesh.getLeftFaceOfCell(0))
		assertEquals(3, mesh.getRightFaceOfCell(0))

		assertEquals(4, mesh.getTopCell(0))
		assertEquals(11, mesh.getTopCell(11))
		assertEquals(4, mesh.getBottomCell(8))
		assertEquals(0, mesh.getBottomCell(0))
		assertEquals(0, mesh.getLeftCell(1))
		assertEquals(8, mesh.getLeftCell(8))
		assertEquals(3, mesh.getRightCell(2))
		assertEquals(11, mesh.getRightCell(11))

		assertEquals(2, mesh.getBottomFaceNeighbour(11))
		assertEquals(3, mesh.getBottomLeftFaceNeighbour(11))
		assertEquals(5, mesh.getBottomRightFaceNeighbour(11))
		assertEquals(20, mesh.getTopFaceNeighbour(11))
		assertEquals(12, mesh.getTopLeftFaceNeighbour(11))
		assertEquals(14, mesh.getTopRightFaceNeighbour(11))

		assertEquals(3, mesh.getBottomFaceNeighbour(12))
		assertEquals(9, mesh.getBottomLeftFaceNeighbour(12))
		assertEquals(11, mesh.getBottomRightFaceNeighbour(12))
		assertEquals(21, mesh.getTopFaceNeighbour(12))
		assertEquals(18, mesh.getTopLeftFaceNeighbour(12))
		assertEquals(20, mesh.getTopRightFaceNeighbour(12))

		assertEquals(1, mesh.getLeftFaceNeighbour(3))
		assertEquals(5, mesh.getRightFaceNeighbour(3))
	}

	@Test
	def void testConnectivityOnBigMesh()
	{
//		var startTime = LocalDateTime.now
		val mesh = new CartesianMesh2D(40, 30, xSize, ySize)

//		var endTime = LocalDateTime.now()
//		var duration = Duration.between(startTime, endTime);
//		println("  Elapsed time : " + duration.toMillis + "ms")
		assertArrayEquals(#[182, 183, 185, 263], mesh.getFacesOfCell(90))
	}

	@Test
	def void testConnectivityOnHugeMesh()
	{
//		var startTime = LocalDateTime.now
		val mesh = new CartesianMesh2D(400, 300, xSize, ySize)

//		var endTime = LocalDateTime.now()
//		var duration = Duration.between(startTime, endTime);
//		println("  Elapsed time : " + duration.toMillis + "ms")
		assertArrayEquals(#[1742, 1743, 1745, 2543], mesh.getFacesOfCell(870))
	}
}
