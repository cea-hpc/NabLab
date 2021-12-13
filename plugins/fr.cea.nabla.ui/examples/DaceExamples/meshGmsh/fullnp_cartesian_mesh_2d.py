'''
Created on 13 déc. 2021

@author: meynardr
'''
import json
import glob
import numpy as np

from edge import Edge
from quad import Quad

'''
    Get data from the json file
'''    
class CartesianMesh2D:
    
    ''' Protected  variables '''
    _maxNodesOfCell = 4
    
    def __init__(self, modelName):
        self.__nbXQuads = 0
        self.__nbYQuads = 0
        self.__xSize = 0.
        self.__ySize = 0.
        self.__modelName = modelName
        
    def jsonInit(self):
        # Looking at a file with the .json as extension
        jsonFileFound = glob.glob('*.json')
        if len(jsonFileFound) !=1:
            raise ValueError('should be only one json file in the current directory')
        
        jsonFilename = jsonFileFound[0]
        
        # Open the json file and get data in this file
        with open(jsonFilename) as f:
            data = json.load(f)
            
        self.__nbXQuads = data['mesh']['nbXQuads']
        self.__nbYQuads = data['mesh']['nbYQuads']
        self.__xSize = data['mesh']['xSize']
        self.__ySize = data['mesh']['ySize']
        
    def _create(self):
        
        # Number of nodes
        self.__numberNodes = self._getNumberNodes()
        # List of nodes in all the mesh grid
        self.__nodes = np.zeros((self.__numberNodes,2))
        # List of the outer nodes
        self.__outerNodesIds = np.zeros(2*(self.__nbXQuads + self.__nbYQuads)) 
        # List of the top nodes
        self.__topNodes = np.zeros(self.__nbXQuads + 1)
        # List of the inner nodes
        self.__innerNodes = np.zeros(self.__numberNodes - len(self.__outerNodesIds))
        # List of the bottom nodes
        self.__bottomNodes = np.zeros(self.__nbXQuads + 1)
        # List of the left nodes
        self.__leftNodes = np.zeros(self.__nbYQuads + 1)
        # LIst of the right nodes
        self.__rightNodes = np.zeros(self.__nbYQuads + 1)
        
        # List of the quads
        self.__quads = np.zeros((self.__nbXQuads * self.__nbYQuads, 4))
        # List of the edges
        self.__edges = np.zeros((2 *len(self.__quads) + self.__nbXQuads + self.__nbYQuads, 2))
        
        # List of the inner cells
        self.__innerCells = np.zeros((self.__nbXQuads - 2)*(self.__nbYQuads - 2))
        self.__outerCells = np.zeros(2*self.__nbXQuads + 2 *(self.__nbYQuads - 2))
        
        
        self.__nodeId = 0
        self.__innerNodeId = 0
        self.__topNodeId = 0
        self.__bottomNodeId = 0
        self.__leftNodeId = 0
        self.__rightNodeId = 0
        # Nodes creation
        for j in range(self.__nbYQuads+1):
            for i in range(self.__nbXQuads+1):                
                self.__nodes[self.__nodeId][0] = round(self.__xSize*i,2)
                self.__nodes[self.__nodeId][1] = round(self.__xSize*j,2)
                if(i!=0 and j!=0 and i!=self.__nbXQuads and j!=self.__nbYQuads):
                    self.__innerNodes[self.__innerNodeId] = self.__nodeId
                    self.__innerNodeId = self.__innerNodeId + 1
                else:
                    if(j==0): 
                            self.__bottomNodes[self.__bottomNodeId] = self.__nodeId
                            self.__bottomNodeId = self.__bottomNodeId + 1
                    if(j==self.__nbYQuads): 
                        self.__topNodes[self.__topNodeId] = self.__nodeId 
                        self.__topNodeId = self.__topNodeId + 1
                    if(i==0):
                        self.__leftNodes[self.__leftNodeId] = self.__nodeId
                        self.__leftNodeId = self.__leftNodeId + 1
                    if(i==self.__nbXQuads): 
                        self.__rightNodes[self.__rightNodeId] = self.__nodeId
                        self.__rightNodeId = self.__rightNodeId + 1
                self.__nodeId = self.__nodeId + 1 
        
        print("Coordinate nodes : ", self.__nodes)
        
        ''' edge creation'''
        nbXNodes = self.__nbXQuads + 1
        edgeId = 0
        for i in range(len(self.__nodes)):
            rightNodeIndex = i + 1
            if(rightNodeIndex%nbXNodes!=0):
                self.__edges[edgeId] = Edge(i, rightNodeIndex).__str__()
                edgeId = edgeId + 1
            belowNodeIndex = i + nbXNodes
            if(belowNodeIndex<len(self.__nodes)):
                self.__edges[edgeId] = Edge(i, belowNodeIndex).__str__()
                edgeId = edgeId + 1   
        print("List of the edges : ", self.__edges)
        
        # quad creation
        quadId = 0
        innerCellId = 0
        outerCellId = 0
        for j in range(self.__nbYQuads):
            for i in range(self.__nbXQuads):
                if((i!=0) and (i != self.__nbXQuads - 1) and (j!=0) and (j!= self.__nbYQuads - 1)):
                    if(len(self.__innerCells)!=0):
                        self.__innerCells[innerCellId] = quadId
                        innerCellId = innerCellId + 1
                else:
                    self.__outerCells[outerCellId] = quadId
                    outerCellId = outerCellId + 1
                
                upperLeftNodeIndex = (j*nbXNodes)+i
                lowerLeftNodeIndex = upperLeftNodeIndex + nbXNodes
                self.__quads[quadId] = Quad(upperLeftNodeIndex, upperLeftNodeIndex + 1, lowerLeftNodeIndex + 1, lowerLeftNodeIndex).__str__()
                quadId = quadId + 1 
        print("List of the quads : ", self.__quads) 
        
    ''' Get number of nodes '''
    def _getNumberNodes(self):
        return (self.__nbXQuads+1)*(self.__nbYQuads+1)
    
if __name__ == '__main__':
    
    modelName = "generatingMesh2"
    testMesh = CartesianMesh2D(modelName)
    testMesh.jsonInit()
    testMesh._create()