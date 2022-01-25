"""
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
"""
import numpy as np

from meshgeometry import MeshGeometry

class CartesianMesh2D:
    def jsonInit(self, jsonContent):
        self.create(jsonContent["nbXQuads"], jsonContent["nbYQuads"], jsonContent["xSize"], jsonContent["ySize"])
    
    @property
    def geometry(self):
        return self.__geometry
    
    @property
    def nbNodes(self):
        return len(self.__geometry.nodes)
    @property
    def nodes(self):
        return range(self.nbNodes)
    
    @property
    def nbCells(self):
        return len(self.__geometry.quads)
    @property
    def cells(self):
        return range(self.nbCells)
    
    @property
    def nbFaces(self):
        return len(self.__geometry.edges)
    @property
    def faces(self):
        return range(self.nbFaces)
    
    @property
    def nbInnerNodes(self):
        return len(self.__innerNodes)
    @property
    def innerNodes(self):
        return self.__innerNodes
    @property
    def nbTopNodes(self):
        return len(self.__topNodes)
    @property
    def topNodes(self):
        return self.__topNodes
    @property
    def nbBottomNodes(self):
        return len(self.__bottomNodes)
    @property
    def bottomNodes(self):
        return self.__bottomNodes
    @property
    def nbLeftNodes(self):
        return len(self.__leftNodes)
    @property
    def leftNodes(self):
        return self.__leftNodes
    @property
    def nbRightNodes(self):
        return len(self.__rightNodes)
    @property
    def rightNodes(self):
        return self.__rightNodes
    
    @property
    def nbInnerCells(self):
        return len(self.__innerCells)
    @property
    def innerCells(self):
        return self.__innerCells
    @property
    def nbOuterCells(self):
        return len(self.__outerCells)
    @property
    def outerCells(self):
        return self.__outerCells
    @property
    def nbTopCells(self):
        return len(self.__topCells)
    @property
    def topCells(self):
        return self.__topCells
    @property
    def nbBottomCells(self):
        return len(self.__bottomCells)
    @property
    def bottomCells(self):
        return self.__bottomCells
    @property
    def nbLeftCells(self):
        return len(self.__leftCells)
    @property
    def leftCells(self):
        return self.__leftCells
    @property
    def nbRightCells(self):
        return len(self.__rightCells)
    @property
    def rightCells(self):
        return self.__rightCells
    
    @property
    def nbTopFaces(self):
        return len(self.__topFaces)
    @property
    def topFaces(self):
        return self.__topFaces
    @property
    def nbBottomFaces(self):
        return len(self.__bottomFaces)
    @property
    def bottomFaces(self):
        return self.__bottomFaces
    @property
    def nbLeftFaces(self):
        return len(self.__leftFaces)
    @property
    def leftFaces(self):
        return self.__leftFaces
    @property
    def nbRightFaces(self):
        return len(self.__rightFaces)
    @property
    def rightFaces(self):
        return self.__rightFaces
    @property
    def nbOuterFaces(self):
        return len(self.__outerFaces)
    @property
    def outerFaces(self):
        return self.__outerFaces
    @property
    def nbInnerFaces(self):
        return len(self.__innerFaces)
    @property
    def innerFaces(self):
        return self.__innerFaces
    @property
    def nbInnerHorizontalFaces(self):
        return len(self.__innerHorizontalFaces)
    @property
    def innerHorizontalFaces(self):
        return self.__innerHorizontalFaces
    @property
    def nbInnerVerticalFaces(self):
        return len(self.__innerVerticalFaces)
    @property
    def innerVerticalFaces(self):
        return self.__innerVerticalFaces
    
    @property
    def topLeftNode(self):
        return self.__topLeftNode
    @property
    def topRightNode(self):
        return self.__topRightNode
    @property
    def bottomLeftNode(self):
        return self.__bottomLeftNode
    @property
    def bottomRightNode(self):
        return self.__bottomRightNode
    
    def getNodesOfCell(self, cellId):
        return self.__geometry.quads[cellId]
    def getNodesOfFace(self, faceId):
        return self.__geometry.edges[faceId]
    def getFirstNodeOfFace(self, faceId):
        return self.getNodesOfFace(faceId)[0]
    def getSecondNodeOfFace(self, faceId):
        return self.getNodesOfFace(faceId)[1]
    
    def getCellsOfNode(self, nodeId):
        i, j = self.__id2IndexNode(nodeId)
        cellsOfNode = []
        if i < self.__nbYQuads and j < self.__nbXQuads:
            cellsOfNode.append(self.__index2IdCell(i, j))
        if i < self.__nbYQuads and j > 0:
            cellsOfNode.append(self.__index2IdCell(i, j-1))
        if i > 0 and j < self.__nbXQuads:
            cellsOfNode.append(self.__index2IdCell(i-1, j))
        if i > 0 and j > 0:
            cellsOfNode.append(self.__index2IdCell(i-1, j-1))
        cellsOfNode.sort()
        return np.array(cellsOfNode)
    
    def getCellsOfFace(self, faceId):
        i_f = faceId // ((2 * self.__nbXQuads) + 1)
        k_f = faceId - (i_f * ((2 * self.__nbXQuads) + 1))
        cellsOfFace = []
        if i_f < self.__nbYQuads: # all except upper bound faces
            if k_f == (2 * self.__nbXQuads):
                cellsOfFace.append(self.__index2IdCell(i_f, self.__nbXQuads - 1))
            else:
                if k_f == 1: # left bound edge
                    cellsOfFace.append(self.__index2IdCell(i_f, 0))
                else:
                    if (k_f % 2) == 0: # horizontal edge
                        cellsOfFace.append(self.__index2IdCell(i_f, k_f // 2))
                        if (i_f > 0): # Not bottom bound edge
                            cellsOfFace.append(self.__index2IdCell(i_f - 1, k_f // 2))
                    else: # vertical edge (neither left bound nor right bound)
                        cellsOfFace.append(self.__index2IdCell(i_f, (((k_f - 1) // 2) - 1)))
                        cellsOfFace.append(self.__index2IdCell(i_f, ((k_f - 1) // 2)))
        else: # upper bound faces
            cellsOfFace.append(self.__index2IdCell(i_f - 1, k_f))
        return np.array(cellsOfFace)
    
    def getNeighbourCells(self, cellId):
        i, j = self.__id2IndexCell(cellId)
        neighbourCells = []
        if i >= 1:
            neighbourCells.append(self.__index2IdCell(i-1, j))
        if i < self.__nbYQuads - 1:
            neighbourCells.append(self.__index2IdCell(i+1, j))
        if j >= 1:
            neighbourCells.append(self.__index2IdCell(i, j-1))
        if j < self.__nbXQuads - 1:
            neighbourCells.append(self.__index2IdCell(i, j+1))
        neighbourCells.sort()
        return np.array(neighbourCells)
    
    def getFacesOfCell(self, cellId):
        i, j = self.__id2IndexCell(cellId)
        bottomFace = (2 * j + i * (2 * self.__nbXQuads + 1))
        leftFace = bottomFace + 1
        rightFace = bottomFace + (2 if j == self.__nbXQuads else 3)
        topFace = bottomFace + (2 *  self.__nbXQuads + 1 if i <  self.__nbYQuads - 1 else 2 *  self.__nbXQuads + 1 - j)
        return [bottomFace, leftFace, rightFace, topFace]

    def getCommonFace(self, cell1, cell2):
        cell1Faces = self.getFacesOfCell(cell1);
        cell2Faces = self.getFacesOfCell(cell2);
        commonFace = list(set(cell1Faces).intersection(cell2Faces))
        if commonFace:
            return commonFace[0]
        else:
            return -1;
        
    def getBackCell(self, faceId):
        cells = self.getCellsOfFace(faceId);
        if len(cells) < 2:
            raise Exception("Error in getBackCell(" + str(faceId) + "): please consider using this method with inner face only.");
        else:
            return cells[0]
    
    def getFrontCell(self, faceId):
        cells = self.getCellsOfFace(faceId);
        if len(cells) < 2:
            raise Exception("Error in getBackCell(" + str(faceId) + "): please consider using this method with inner face only.");
        else:
            return cells[1]
    
    def getTopFaceOfCell(self, cellId):
        i, j = self.__id2IndexCell(cellId)
        bottomFace = 2 * j + i * (2 * self.__nbXQuads + 1)
        topFace = bottomFace + (2 * self.__nbXQuads + 1 if i < self.__nbYQuads - 1 else 2 * self.__nbXQuads + 1 - j)
        return topFace
    
    def getBottomFaceOfCell(self, cellId):
        i, j = self.__id2IndexCell(cellId)
        bottomFace = 2 * j + i * (2 * self.__nbXQuads + 1)
        return bottomFace
    
    def getLeftFaceOfCell(self, cellId):
        bottomFace = self.getBottomFaceOfCell(cellId)
        leftFace = bottomFace + 1
        return leftFace
    
    def getRightFaceOfCell(self, cellId):
        i, j = self.__id2IndexCell(cellId)
        bottomFace = 2 * j + i * (2 * self.__nbXQuads + 1);
        rightFace = bottomFace + (2 if j == self.__nbXQuads - 1 else 3)
        return rightFace

    def getTopCell(self, cellId):
        i, j = self.__id2IndexCell(cellId)
        if (i == self.__nbYQuads - 1):
            return cellId
        return self.__index2IdCell(i+1, j)
    
    def getBottomCell(self, cellId):
        i, j = self.__id2IndexCell(cellId)
        if (i == 0):
            return cellId
        return self.__index2IdCell(i-1, j)
    
    def getLeftCell(self, cellId):
        i, j = self.__id2IndexCell(cellId)
        if (j == 0):
            return cellId
        return self.__index2IdCell(i, j-1)
    
    def getRightCell(self, cellId):
        i, j = self.__id2IndexCell(cellId)
        if (j == self.__nbXQuads-1):
            return cellId
        return self.__index2IdCell(i, j+1)
    
    def getBottomFaceNeighbour(self, faceId):
        return (faceId - (2 * self.__nbXQuads + 1))
    
    def getBottomLeftFaceNeighbour(self, faceId):
        edges = self.__geometry.edges
        if(self.__isVerticalEdge(edges[faceId])):
            return faceId - 3
        else:
            return (faceId + 1) - (2 * self.__nbXQuads + 1)
    
    def getBottomRightFaceNeighbour(self, faceId):
        edges = self.__geometry.edges
        if (self.__isVerticalEdge(edges[faceId])):
            return faceId - 1
        else: # horizontal
            return (faceId + 3) - (2 * self.__nbXQuads + 1)
    
    def getTopFaceNeighbour(self, faceId):
        return (faceId + (2 * self.__nbXQuads + 1))
    
    def getTopLeftFaceNeighbour(self, faceId):
        edges = self.__geometry.edges
        if (self.__isVerticalEdge(edges[faceId])):
            return (faceId - 3) + (2 * self.__nbXQuads + 1)
        else: # horizontal
            return faceId + 1
    
    def getTopRightFaceNeighbour(self, faceId):
        edges = self.__geometry.edges
        if (self.__isVerticalEdge(edges[faceId])):
            return (faceId - 1) + (2 * self.__nbXQuads + 1)
        else: # horizontal
            return faceId + 3
        
    def getRightFaceNeighbour(self, faceId):
        return faceId + 2
    
    def getLeftFaceNeighbour(self, faceId):
        return faceId - 2
    
    def create(self, nbXQuads, nbYQuads, xSize, ySize):
        if (nbXQuads == -1 or nbYQuads == -1 or xSize == -1 or ySize == -1):
            raise Exception("Mesh attributes uninitialized")
        
        self.__nbXQuads = nbXQuads
        self.__nbYQuads = nbYQuads
        
        nodes = np.empty(((nbXQuads + 1) * (nbYQuads + 1), 2), dtype=np.double)
        quads = np.empty((nbXQuads * nbYQuads, 4), dtype=np.int32)
        edges = np.empty((2 * len(quads) + nbXQuads + nbYQuads, 2), dtype=np.int32)

        outerNodesIds = np.empty(2 * (nbXQuads + nbYQuads), dtype=np.int32)
        self.__innerNodes = np.empty(len(nodes) - len(outerNodesIds), dtype=np.int32)
        self.__topNodes = np.empty(nbXQuads + 1, dtype=np.int32)
        self.__bottomNodes = np.empty(nbXQuads + 1, dtype=np.int32)
        self.__leftNodes = np.empty(nbYQuads + 1, dtype=np.int32)
        self.__rightNodes = np.empty(nbYQuads + 1, dtype=np.int32)

        self.__innerCells = np.empty((nbXQuads - 2)*(nbYQuads - 2), dtype=np.int32)
        self.__outerCells = np.empty(2 * nbXQuads + 2 * (nbYQuads - 2), dtype=np.int32)
        
        nodeId = innerNodeId = topNodeId = bottomNodeId = leftNodeId = rightNodeId = 0
        
        # node creation
        for j in range(nbYQuads + 1):
            for i in range(nbXQuads + 1):
                nodes[nodeId] = [xSize * i, ySize * j]
                if i!=0 and j!=0 and i!=nbXQuads and j!=nbYQuads:
                    self.__innerNodes[innerNodeId] = nodeId
                    innerNodeId +=1
                else:
                    if j==0:
                        self.__bottomNodes[bottomNodeId] = nodeId
                        bottomNodeId += 1
                    if j==nbYQuads:
                        self.__topNodes[topNodeId] = nodeId
                        topNodeId += 1
                    if i==0:
                        self.__leftNodes[leftNodeId] = nodeId
                        leftNodeId += 1
                    if i==nbXQuads:
                        self.__rightNodes[rightNodeId] = nodeId
                        rightNodeId += 1
                nodeId += 1
        
        # edge creation
        nbXNodes = nbXQuads+1
        edgeId = 0
        for i in range(len(nodes)):
            rightNodeIndex = i+1
            if rightNodeIndex%nbXNodes!=0:
                edges[edgeId] = [i, rightNodeIndex]
                edgeId += 1
            belowNodeIndex = i + nbXNodes
            if belowNodeIndex<len(nodes):
                edges[edgeId] = [i, belowNodeIndex]
                edgeId += 1
                
        # quad creation
        quadId = innerCellId = outerCellId = 0
        for j in range(nbYQuads):
            for i in range(nbXQuads):
                if i != 0 and i != nbXQuads - 1 and j != 0 and j != nbYQuads - 1:
                    self.__innerCells[innerCellId] = quadId
                    innerCellId += 1
                else:
                    self.__outerCells[outerCellId] = quadId
                    outerCellId += 1
                upperLeftNodeIndex = (j*nbXNodes)+i;
                lowerLeftNodeIndex = upperLeftNodeIndex + nbXNodes;
                quads[quadId] = [upperLeftNodeIndex, upperLeftNodeIndex+1, lowerLeftNodeIndex+1, lowerLeftNodeIndex]
                quadId += 1
                
        self.__geometry = MeshGeometry(nodes, edges, quads)
        self.__topLeftNode = (nbXQuads + 1) * nbYQuads
        self.__topRightNode = (nbXQuads + 1) * (nbYQuads +1) - 1
        self.__bottomLeftNode = 0
        self.__bottomRightNode = nbXQuads
        
        outFaces = []
        inFaces = []
        inVFaces = []
        inHFaces = []
        tFaces = []
        bFaces = []
        lFaces = []
        rFaces = []
        
        for edgeId in range(len(edges)):
            # Top boundary faces
            if edgeId >= 2 * nbXQuads * nbYQuads + nbYQuads:
                tFaces.append(edgeId)
            # Bottom boundary faces
            if (edgeId < 2 * nbXQuads) and (edgeId % 2 == 0):
                bFaces.append(edgeId)
            # Left boundary faces
            if (edgeId % (2 * nbXQuads + 1) == 1) and (edgeId < (2 * nbXQuads + 1) * nbYQuads):
                lFaces.append(edgeId)
            # Right boundary faces
            if edgeId % (2 * nbXQuads + 1) == 2 * nbXQuads:
                rFaces.append(edgeId)
                
            edge = edges[edgeId]
            if not self.__isInnerEdge(edge):
                outFaces.append(edgeId);
            else:
                inFaces.append(edgeId)
                if self.__isVerticalEdge(edge):
                    inVFaces.append(edgeId)
                elif self.__isHorizontalEdge(edge):
                    inHFaces.append(edgeId)
                else:
                    raise Exception("The inner edge " + str(edgeId) + " should be either vertical or horizontal")
        
        self.__outerFaces = np.array(outFaces)
        self.__innerFaces = np.array(inFaces)
        self.__innerVerticalFaces = np.array(inVFaces)
        self.__innerHorizontalFaces = np.array(inHFaces)
        
        self.__topFaces = np.array(tFaces)
        self.__bottomFaces = np.array(bFaces)
        self.__leftFaces = np.array(lFaces)
        self.__rightFaces = np.array(rFaces)
        
        # Construction of boundary cell sets
        self.__topCells = self.__cellsOfNodeCollection(self.__topNodes)
        self.__bottomCells = self.__cellsOfNodeCollection(self.__bottomNodes)
        self.__leftCells = self.__cellsOfNodeCollection(self.__leftNodes)
        self.__rightCells = self.__cellsOfNodeCollection(self.__rightNodes)
    
    def __isInnerEdge(self, edge):
        i1, j1 = self.__id2IndexNode(edge[0])
        i2, j2 = self.__id2IndexNode(edge[1])
        # If nodes are located on the same boundary, then the face is an outer one
        if (i1 == 0 and i2 == 0) or (i1 == self.__nbYQuads and i2 == self.__nbYQuads) or (j1 == 0 and j2 == 0) or (j1 == self.__nbXQuads and j2 == self.__nbXQuads):
            return False
        #else it's an inner one
        return True
    
    def __isVerticalEdge(self, edge):
        return edge[0] == edge[1] + self.__nbXQuads + 1 or edge[1] == edge[0] + self.__nbXQuads + 1
    
    def __isHorizontalEdge(self, edge):
        return edge[0] == edge[1] + 1 or edge[1] == edge[0] + 1
    
    def __index2IdCell(self, i, j):
        return (i * self.__nbXQuads) + j
    
    def __id2IndexNode(self, nodeId):
        i = nodeId // (self.__nbXQuads + 1)
        j = nodeId % (self.__nbXQuads + 1)
        return i, j
    
    def __id2IndexCell(self, cellId):
        i = cellId // self.__nbXQuads
        j = cellId % self.__nbXQuads
        return i, j
    
    def __cellsOfNodeCollection(self, nodeIds):
        cellsOfNode = []
        for nodeId in nodeIds:
            for cellId in self.getCellsOfNode(nodeId):
                if not cellId in cellsOfNode:
                    cellsOfNode.append(cellId)
        return np.array(cellsOfNode)
    
    def dump(self):
        self.__geometry.dump()
        print("MESH TOPOLOGY")
        print("Inner nodes ("+ str(len(self.__innerNodes))+"):")
        print(self.__innerNodes)
        print("Top nodes ("+ str(len(self.__topNodes))+"):")
        print(self.__topNodes)
        print("Bottom nodes ("+ str(len(self.__bottomNodes))+"):")
        print(self.__bottomNodes)
        print("Left nodes ("+ str(len(self.__leftNodes))+"):")
        print(self.__leftNodes)
        print("Right nodes ("+ str(len(self.__rightNodes))+"):")
        print(self.__rightNodes)
        print("Outer faces ("+ str(len(self.__outerFaces))+"):")
        print(self.__outerFaces)
        print("Inner faces ("+ str(len(self.__innerFaces))+"):")
        print(self.__innerFaces)