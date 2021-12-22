import unittest
import numpy as np
import numpy.testing

from cartesianmesh2d import CartesianMesh2D
from numpy.testing import assert_array_equal

''' Numbering nodes and cells            Numbering faces

  15---16---17---18---19          |-27-|-28-|-29-|-30-|
   | 8  | 9  | 10 | 11 |         19   21   23   25   26
  10---11---12---13---14          |-18-|-20-|-22-|-24-|
   | 4  | 5  | 6  | 7  |         10   12   14   16   17
   5----6----7----8----9          |--9-|-11-|-13-|-15-|
   | 0  | 1  | 2  | 3  |          1    3    5    7    8
   0----1----2----3----4          |-0--|-2--|-4--|-6--|
'''

class CartesianMesh2DTest(unittest.TestCase):
    def setUp(self):
        self.nbXQuads = 4
        self.nbYQuads = 3
        self.xSize = 5.0
        self.ySize = 10.0
    
    def testGeometry(self):
        mesh = CartesianMesh2D()
        mesh.create(self.nbXQuads, self.nbYQuads, self.xSize, self.ySize)
        mesh.dump()
        nbQuads = self.nbXQuads * self.nbYQuads
        
        self.assertEqual(nbQuads, len(mesh.geometry.quads))
        nbNodes = (self.nbXQuads + 1) * (self.nbYQuads + 1)
        self.assertEqual(nbNodes, len(mesh.geometry.nodes))
        nbEdges = ((self.nbXQuads + 1) * self.nbYQuads) + ((self.nbYQuads + 1) * self.nbXQuads)
        self.assertEqual(nbEdges, len(mesh.geometry.edges))
        
        quadIndex = 0
        yUpperLeftNode = 0
        for j in range(self.nbYQuads):
            xUpperLeftNode = 0
            for i in range(self.nbXQuads):
                currentQuad = mesh.geometry.quads[quadIndex]
                upperLeftNode = mesh.geometry.nodes[currentQuad[0]]
                self.assertEqual(xUpperLeftNode, upperLeftNode[0], 0.0)
                self.assertEqual(yUpperLeftNode, upperLeftNode[1], 0.0)
                xUpperLeftNode += self.xSize
                quadIndex += 1
            yUpperLeftNode += self.ySize
    
    def testTopology(self):
        mesh = CartesianMesh2D()
        mesh.create(self.nbXQuads, self.nbYQuads, self.xSize, self.ySize)
        self.assertEqual((self.nbXQuads + 1) * (self.nbYQuads + 1), mesh.nbNodes)
        self.assertEqual(self.nbXQuads * self.nbYQuads, mesh.nbCells)
        self.assertEqual(2 * self.nbXQuads * self.nbYQuads + self.nbXQuads + self.nbYQuads, mesh.nbFaces);
        
        assert_array_equal([6, 7, 8, 11, 12, 13], mesh.innerNodes)
        assert_array_equal([15, 16, 17, 18, 19], mesh.topNodes)
        assert_array_equal([0, 1, 2, 3, 4], mesh.bottomNodes)
        assert_array_equal([0, 5, 10, 15], mesh.leftNodes)
        assert_array_equal([4, 9, 14, 19], mesh.rightNodes)
        
        assert_array_equal([5, 6], mesh.innerCells)
        assert_array_equal([0, 1, 2, 3, 4, 7, 8, 9, 10, 11], mesh.outerCells)
        assert_array_equal([8, 9, 10, 11], mesh.topCells)
        assert_array_equal([0, 1, 2, 3], mesh.bottomCells)
        assert_array_equal([0, 4, 8], mesh.leftCells)
        assert_array_equal([3, 7, 11], mesh.rightCells)
        
        assert_array_equal([27, 28, 29, 30], mesh.topFaces)
        assert_array_equal([0, 2, 4, 6], mesh.bottomFaces)
        assert_array_equal([1, 10, 19], mesh.leftFaces)
        assert_array_equal([8, 17, 26], mesh.rightFaces)
        assert_array_equal([0, 1, 2, 4, 6, 8, 10, 17, 19, 26, 27, 28, 29, 30], mesh.outerFaces)
        assert_array_equal([3, 5, 7, 9, 11, 12, 13, 14, 15, 16, 18, 20, 21, 22, 23, 24, 25], mesh.innerFaces)
        assert_array_equal([9, 11, 13, 15, 18, 20, 22, 24], mesh.innerHorizontalFaces)
        assert_array_equal([3, 5, 7, 12, 14, 16, 21, 23, 25], mesh.innerVerticalFaces)
        
        self.assertEqual(0, mesh.bottomLeftNode)
        self.assertEqual(4, mesh.bottomRightNode)
        self.assertEqual(15, mesh.topLeftNode)
        self.assertEqual(19, mesh.topRightNode)
    
    def testConnectivity(self):
        mesh = CartesianMesh2D()
        mesh.create(self.nbXQuads, self.nbYQuads, self.xSize, self.ySize)
        assert_array_equal([0, 1, 6, 5], mesh.getNodesOfCell(0))

        assert_array_equal([0, 1], mesh.getNodesOfFace(0))
        assert_array_equal([0, 5], mesh.getNodesOfFace(1))

        self.assertEqual(0, mesh.getFirstNodeOfFace(0))
        self.assertEqual(1, mesh.getSecondNodeOfFace(0))

        assert_array_equal([0], mesh.getCellsOfNode(0))
        assert_array_equal([0, 4], mesh.getCellsOfNode(5))
        assert_array_equal([0, 1, 4, 5], mesh.getCellsOfNode(6))

        assert_array_equal([0], mesh.getCellsOfFace(0))
        assert_array_equal([0, 1], mesh.getCellsOfFace(3))
        '''
        assert_array_equal([1, 4], mesh.getNeighbourCells(0))
        assert_array_equal([0, 2, 5], mesh.getNeighbourCells(1))
        assert_array_equal([1, 4, 6, 9], mesh.getNeighbourCells(5))

        assert_array_equal([0, 1, 3, 9], mesh.getFacesOfCell(0))

        self.assertEqual(3, mesh.getCommonFace(0, 1))
        self.assertEqual(-1, mesh.getCommonFace(0, 5))

        self.assertEqual(0, mesh.getBackCell(3))
        self.assertEqual(1, mesh.getFrontCell(3))
        try {
            self.assertEqual(-1, mesh.getBackCell(1))
            fail()
        } catch (Exception e1) {
        }
        try {
            self.assertEqual(-1, mesh.getFrontCell(1))
            fail()
        } catch (Exception e2) {
        }

        self.assertEqual(9, mesh.getTopFaceOfCell(0))
        self.assertEqual(0, mesh.getBottomFaceOfCell(0))
        self.assertEqual(1, mesh.getLeftFaceOfCell(0))
        self.assertEqual(3, mesh.getRightFaceOfCell(0))

        self.assertEqual(4, mesh.getTopCell(0))
        self.assertEqual(11, mesh.getTopCell(11))
        self.assertEqual(4, mesh.getBottomCell(8))
        self.assertEqual(0, mesh.getBottomCell(0))
        self.assertEqual(0, mesh.getLeftCell(1))
        self.assertEqual(8, mesh.getLeftCell(8))
        self.assertEqual(3, mesh.getRightCell(2))
        self.assertEqual(11, mesh.getRightCell(11))

        self.assertEqual(2, mesh.getBottomFaceNeighbour(11))
        self.assertEqual(3, mesh.getBottomLeftFaceNeighbour(11))
        self.assertEqual(5, mesh.getBottomRightFaceNeighbour(11))
        self.assertEqual(20, mesh.getTopFaceNeighbour(11))
        self.assertEqual(12, mesh.getTopLeftFaceNeighbour(11))
        self.assertEqual(14, mesh.getTopRightFaceNeighbour(11))

        self.assertEqual(3, mesh.getBottomFaceNeighbour(12))
        self.assertEqual(9, mesh.getBottomLeftFaceNeighbour(12))
        self.assertEqual(11, mesh.getBottomRightFaceNeighbour(12))
        self.assertEqual(21, mesh.getTopFaceNeighbour(12))
        self.assertEqual(18, mesh.getTopLeftFaceNeighbour(12))
        self.assertEqual(20, mesh.getTopRightFaceNeighbour(12))

        self.assertEqual(1, mesh.getLeftFaceNeighbour(3))
        self.assertEqual(5, mesh.getRightFaceNeighbour(3))
        '''
if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(CartesianMesh2DTest)
    unittest.TextTestRunner().run(suite)