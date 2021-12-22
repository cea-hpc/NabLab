import unittest
import numpy as np

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
        self.__nbXQuads = 4
        self.__nbYQuads = 3
        self.__xSize = 5.0
        self.__ySize = 10.0
        
    def testGeometry(self):
        mesh = CartesianMesh2D(self.__nbXQuads, self.__nbYQuads, self.__xSize, self.__ySize)
        mesh.dump()
        nbQuads = self.__nbXQuads * self.__nbYQuads
        self.assertEquals(nbQuads, len(mesh.geometry.quads))
        nbNodes = (self.__nbXQuads + 1) * (self.__nbYQuads + 1)
        self.assertEquals(nbNodes, len(mesh.geometry.nodes))
        nbEdges = ((self.__nbXQuads + 1) * self.__nbYQuads) + ((self.__nbYQuads + 1) * self.__nbXQuads)
        self.assertEquals(nbEdges, len(mesh.geometry.edges))
        
        quadIndex = 0
        yUpperLeftNode = 0
        for j in range(self.__nbYQuads):
            xUpperLeftNode = 0
            for i in range(self.__nbXQuads):
                currentQuad = mesh.geometry.quads[quadIndex]
                upperLeftNode = mesh.geometry.nodes[currentQuad[0]]
                self.assertEquals(xUpperLeftNode, upperLeftNode[0], 0.0)
                self.assertEquals(yUpperLeftNode, upperLeftNode[1], 0.0)
                xUpperLeftNode += self.__xSize
                quadIndex += 1
            yUpperLeftNode += self.__ySize
    
    def testConnectivity(self):
        assert 1 == 1

if __name__ == '__main__':
    unittest.main()