'''
Created on 13 déc. 2021

@author: meynardr
'''
import gmsh
import json
import glob
import numpy as np

from edge import Edge
from quad import Quad

class FullNPCartesianMesh2D:
    
    ''' Protected  variables '''
    _maxNodesOfCell = 4
    _isfullnp = True
    
    def __init__(self, modelName):
        self.__nbXQuads = 0
        self.__nbYQuads = 0
        self.__xSize = 0.
        self.__ySize = 0.
        # List tags of the nodes
        self.nodesTags = []
        self.__modelName = modelName        
        self.__dimMesh = 2
    
    '''
        Get data from the json file
    '''      
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
        self._create()
        
    def _create(self):
        
        ''' 
        Initialize Gmsh API. This must be called before any call to the other
        functions in the API
        '''       
        gmsh.initialize()
        
        ''' 
        gmsh.model.add(name)
        Add a new model, with name 'name', and set it as the current model.
        '''    
        gmsh.model.add(self.__modelName)
        
        
        # Number of nodes
        self.__numberNodes = self.getNbNodes()
        # Array of nodes
        self.__nodes = np.zeros(self.__numberNodes)
        # List of nodes in all the mesh grid
        #self.__coordinateNodes = np.zeros((self.__numberNodes,2))
        self.__coordinateNodes = np.zeros((self.__numberNodes,3))
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
        self.__quads = np.zeros(self.__nbXQuads * self.__nbYQuads)
        # List of the nodes of each quad
        self.__quadNodes = np.zeros((self.__nbXQuads * self.__nbYQuads, 4))
        # List of the edges
        self.__edges = np.zeros(2 *len(self.__quadNodes) + self.__nbXQuads + self.__nbYQuads)
        # List of the nodes of each cells
        self.__edgeNode = np.zeros((2 *len(self.__quadNodes) + self.__nbXQuads + self.__nbYQuads, 2))
        
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
                self.__coordinateNodes[self.__nodeId][0] = round(self.__xSize*i,2)
                self.__coordinateNodes[self.__nodeId][1] = round(self.__ySize*j,2)
                self.__coordinateNodes[self.__nodeId][2] = 0.0
                #self.__coordinateNodes[self.__nodeId][2] = round(0.0,2)
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
        
        print("Coordinate nodes : ", self.__coordinateNodes)
        
        ''' edge creation'''
        nbXNodes = self.__nbXQuads + 1
        edgeId = 0
        for i in range(len(self.__coordinateNodes)):
            rightNodeIndex = i + 1
            if(rightNodeIndex%nbXNodes!=0):
                self.__edgeNode[edgeId] = Edge(i, rightNodeIndex).__str__()
                edgeId = edgeId + 1
            belowNodeIndex = i + nbXNodes
            if(belowNodeIndex<len(self.__coordinateNodes)):
                self.__edgeNode[edgeId] = Edge(i, belowNodeIndex).__str__()
                edgeId = edgeId + 1   
        print("List of the edges : ", self.__edgeNode)
        
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
                self.__quadNodes[quadId] = Quad(upperLeftNodeIndex, upperLeftNodeIndex + 1, lowerLeftNodeIndex + 1, lowerLeftNodeIndex).__str__()
                quadId = quadId + 1 
        print("List of the quads : ", self.__quadNodes) 
        
        
        ''' Add the tags of the different nodes'''
        for i in range(1, self.getNbNodes() + 1):
            self.nodesTags.append(i)
            
        '''
            To visualize results with Gmsh, it is required to :
                - add the tags of the different nodes
                - add discrete entity on surface
                - add nodes on surface
                - add discrete entity for lines
                - add lines and quads with addElementByType
        '''

        ''' Add discrete entity on surface '''
        self.tagSurface = gmsh.model.addDiscreteEntity(2)
        
        ''' Add all nodes on the surface '''
        coordinateNodes1D = np.hstack(self.__coordinateNodes)
        coordinateNodesList = coordinateNodes1D.tolist()
        gmsh.model.mesh.addNodes(2, self.tagSurface, self.nodesTags,  coordinateNodesList)
        
        ''' Add discrete entity for the lines '''
        self.tagDiscreteEntityLines = gmsh.model.addDiscreteEntity(1)
        
        ''' Add lines '''
        edgeNodes1D = np.hstack(self.__edgeNode)
        edgeNodesList = edgeNodes1D.tolist()
        for i in range(0, len(edgeNodesList)):
            edgeNodesList[i] = edgeNodesList[i] + 1 
        gmsh.model.mesh.addElementsByType(self.tagDiscreteEntityLines, 1, [], edgeNodesList)
        
        ''' Add cells '''
        quadNodes1D = np.hstack(self.__quadNodes)
        quadNodesList = quadNodes1D.tolist()
        for i in range(0, len(quadNodesList)):
            quadNodesList[i] = quadNodesList[i] + 1
        gmsh.model.mesh.addElementsByType(self.tagSurface, 3, [], quadNodesList)
        
        '''
        gmsh.model.mesh.generate(dim=3)
    
        Generate a mesh of the current model, up to dimension `dim' (0, 1, 2 or 3).
        '''
        gmsh.model.mesh.generate(self.__dimMesh)
        
        '''
        gmsh.write(fileName)
        Write a file. The export format is determined by the file extensimaxNodesOfCellon.
        '''
        gmsh.write(self.__modelName + ".msh")        
        
    ''' Get number of nodes '''
    def getNbNodes(self):
        return (self.__nbXQuads+1)*(self.__nbYQuads+1)
    
    ''' Number of the cells '''
    def getNbCells(self):
        return self.__nbXQuads * self.__nbYQuads
    ''' Tag of the quads '''
    def getTagsQuadrangle(self):
        for i in range(len(self.__quadNodes)):
            self.__quads[i] = len(self.__edgeNode) + i + 1
            
        return self.__quads
    ''' Get nodes of edges'''
    def getNodesOfEdges(self, edgeId):
        return self.__edgeNode[edgeId]
    
    ''' Get nodes of cell'''
    def getNodesOfCell(self, cellId):
        return self.__quadNodes[cellId]
    
    ''' Add values on all nodes '''
    def addValuesOnNodes(self, name, arrayDataInNodes, step):

        tagView = gmsh.view.add(name)
        # We add values of the volume in cells
        gmsh.view.addModelData(tagView, step, self.__modelName, 'NodeData', self.__nodes, arrayDataInNodes)
        return tagView
    
    ''' Add values on all cells '''
    def addValuesOnCells(self, name, arrayDataInCells, step):
        
        tagView = gmsh.view.add(name)
                
        # We add values of the temperature in nodes
        gmsh.view.addModelData(tagView, step, self.__modelName, 'ElementData', self.getTagsQuadrangle(), arrayDataInCells)
        return tagView
    
    ''' Run the event loop of the graphical user interface '''
    def launchVisualizationMesh(self):
        gmsh.fltk.run()
    '''
        Finalize the Gmsh API. This must be called when you are done using the Gmsh
        API.
    '''   
    gmsh.finalize()
    
if __name__ == '__main__':
    
    modelName = "generatingMesh2"
    testMesh = FullNPCartesianMesh2D(modelName)
    testMesh.jsonInit()
    nodesCellId = testMesh.getNodesOfCell(4)
    print(" nodesCellId : ", nodesCellId)
    
    