'''
Created on 6 déc. 2021

@author: meynardr
'''
from fullnp_cartesian_mesh_2d import FullNPCartesianMesh2D
from fullgmsh_cartesian_mesh_2d import FullGmshCartesianMesh2D
import numpy as np

class SimpleMeshExample:
    
    ''' Options and global variables '''
    _deltat = 0.001
    _t_n = 0
    _t_nplus1 = 0
 
    ''' Mesh and mesh variables'''
    def __init__(self, mesh):
        self.__mesh = mesh
        self.__nbNodes = mesh.getNbNodes()
        print("Number of the noeuds : ", self.__nbNodes)
        self.__nbCells = mesh.getNbCells()
        print("Number of the cells : ", self.__nbCells)
        self.__maxNodesOfCell = mesh._maxNodesOfCell 
        print("maxNodesofCell : ", self.__maxNodesOfCell)
        ''' Array with the values on nodes'''
        self.__cst = np.zeros(self.__nbNodes)
        ''' Array with the values on cells'''
        self.__nodes_sum = np.zeros(self.__nbCells)
        ''' Tag of the view of data added on nodes'''
        self.__tagViewOnNodes = 0
        ''' Tag of the view of data added on cells'''
        self.__tagViewOnCells = 0
        
    '''
        Job computeCst called @1.0 in simulate method
        In variables :
        Out variables : cst
    '''
    def _computeCst(self):
        ''' Initialize _cst at 1.0 in all indexes. '''
        ''' Case fullnp_cartesian_mesh_2d : data are stored in an array'''
        for i in range(self.__nbNodes):
            self.__cst[i] = 1.0 
            
        ''' Require to store data on nodes in a list to display results with Gmsh'''
        self.valuesOnNodes = []
        for i in range(len(self.__cst)):
            self.valuesOnNodes.append([self.__cst[i]])
            
        ''' Add in each nodes the value 1.0 with Gmsh'''
        self.__tagViewOnNodes = self.__mesh.addValuesOnNodes("constantOnNodes", self.valuesOnNodes, 1)
    
    '''
        Job computeTn called @1.0 in executeTimeLoopN method.
        In variables : deltat, t_n
        Out variables : t_nplus1
    '''
    def _computeTn(self):
        self._t_nplus1 = self._t_n + self._deltat
        return self._t_nplus1
    
    '''
        Job initTime called @1.0 in simulate method.
        In variables : 
        Out variables : t_n0 
    '''
    def _initTime(self):
        self._t_n0 = 0.0
        
    '''
        Job setUpTimeLoopN called @2.0 in simulate method.
        In variables : t_n0
        Out variables : t_n
    '''
    def _setUpTimeLoopN(self):
        self._t_n = self._t_n0
        
    '''
        Job computeSum called @2.0 in simulate method.
        In variables : _cst
        Out variables : nodes_sum        
    '''
    def _computeSum(self):
        
        ''' Determine if the test is with the fullgmsh_cartesian_mesh_2d or with the full_np_cartesian_mesh_2d'''
        if(self.__mesh._isfullnp==True):
            ''' Case fullnp_cartesian_mesh_2d'''
            for jcells in range(0, self.__nbCells):
                jId = jcells
                nodesOfCellJ = self.__mesh.getNodesOfCell(jId)
                nbNodesOfCellJ = len(nodesOfCellJ)
                sumOnNodes = 0
                print(" Nodes of the " + str(jId) + " cell " + "have the following values : ") 
                for rNodesOfCellJ in range(nbNodesOfCellJ):
                    rId = nodesOfCellJ[rNodesOfCellJ]
                    print(" Nodes " + str(rId)+", value of cst["+str(rId)+"] = " + str(self.__cst[int(rId)]))
                    sumOnNodes = sumOnNodes + self.__cst[int(rId)]
                ''' Add values of the cells in the __nodes_sum array '''
                print("")
                self.__nodes_sum[jcells] = sumOnNodes*jcells
            print("nodes_sum = ", self.__nodes_sum)
            
            ''' Convert __nodes_sum array in list to add data in the method addValuesOnCells which calls the method addModelData of Gmsh '''
            self.valuesOnCells = []
            for i in range(len(self.__nodes_sum)):
                self.valuesOnCells.append([self.__nodes_sum[i]])
            ''' Add data on cells to visualize results with Gmsh'''
            self.__tagViewOnCells = self.__mesh.addValuesOnCells("nodesSumOnCells", self.valuesOnCells, 0) # Calling a method gmsh to put values in cells in order to visualize the result
            
        else:
            ''' Case fullgmsh_cartesian_mesh_2d'''
            ''' Get data on nodes '''
            _, _, data, _, _ =  self.__mesh.getValuesData(self.__tagViewOnNodes, 1)
            print("dataOnNodes : ", data)
    
            lineTags, _  = self.__mesh.getTagsEdges()
            _, _  = self.__mesh.getTagsQuadrangle()
            
            valuesOnCells = []
            for jcells in range(0, self.__nbCells):
                jId = jcells + 1
                nodesOfCellJ_typeString = self.__mesh.getQuadrangleNodes(jId + len(lineTags))
                nodesOnCellJ_typeliste = nodesOfCellJ_typeString.strip('][').split(',')
                ''' Loop on the nodes of the cell '''
                nodes_sum = 0
                for rNodes in range(4):
                    nodeNumber = int(nodesOnCellJ_typeliste[rNodes])
                    nodes_sum = nodes_sum + int(data[nodeNumber-1])
                valuesOnCells.append([nodes_sum*jcells])
            print("valuesOnCells : ", valuesOnCells)
            ''' Add values on cells '''
            self.__tagViewOnCells  = self.__mesh.addValuesOnCells("nodesSumOnCells", valuesOnCells, 0)       
            
    '''
        Job assertSum called @3.0 in simulate method.
        In variables : nodes_sum
        Out variables :
    '''
    def _assertSum(self):
        ''' Determine if the test is with the fullgmsh_cartesian_mesh_2d or with the full_np_cartesian_mesh_2d'''
        if(self.__mesh._isfullnp==True):
            for i in range(0, self.__nbCells):
                assert(4*i == self.__nodes_sum[i]), " Result is false for i = " + str(i)                
        else:
            ''' Get data on cells '''
            _, _, data, _, _ =  self.__mesh.getValuesData(self.__tagViewOnCells , 0)
            print("data : ", data)
            for i in range(0, self.__nbCells):
                assert([4*i] == data[i]), " Result is false for i = " + str(i)
            
    
    def simulate(self):
        self._computeCst()
        self._computeSum()
        self._assertSum()
        self.__mesh.launchVisualizationMesh()

if __name__ == '__main__':
    
    print(" ------------------------Test with FullNPCartesianMesh2D-------------------")
    modelName = "generatingMesh1"
    mesh = FullNPCartesianMesh2D(modelName)
    mesh.jsonInit()
    simpleMeshExample = SimpleMeshExample(mesh)
    ''' Gmsh displays only one interface graphic not several. To see results with Gmsh, run the simulate() method with FullNPCartesianMesh2D or with FullGmshCartesianMesh2D '''
    simpleMeshExample.simulate()
    
    print("")
    print(" ------------------------Test with FullGmshCartesianMesh2D-------------------")
    modelName = "generatingMesh2"
    testMesh = FullGmshCartesianMesh2D(modelName)
    testMesh.jsonInit()
    simpleMeshExample2 = SimpleMeshExample(testMesh)
    ''' Gmsh displays only one interface graphic not several in the same time. To see results with Gmsh, run the simulate() method with FullNPCartesianMesh2D or with FullGmshCartesianMesh2D '''
    #simpleMeshExample2.simulate()
    