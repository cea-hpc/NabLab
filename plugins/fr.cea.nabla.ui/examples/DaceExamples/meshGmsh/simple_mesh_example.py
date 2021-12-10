'''
Created on 6 déc. 2021

@author: meynardr
'''
from fullgmsh_cartesian_mesh_2d import CartesianMesh2D
#from fullnp_cartesian_mesh_2d import CartesianMesh2D

class SimpleMeshExample:
    
    ''' Options and global variables '''
    _deltat = 0.001
    _t_n = 0
    _t_nplus1 = 0
    _cst = []
 
    ''' Mesh and mesh variables'''
    def __init__(self, mesh):
        self.__mesh = mesh
        self.__nbNodes = mesh.getNbNodes(self)
        print("Number of the noeuds : ", self.__nbNodes)
        self.__nbCells = mesh.getNbCells(self)
        print("Number of the cells : ", self.__nbCells)
        self.__maxNodesOfCell = mesh._maxNodesOfCell 
        print("maxNodesofCell : ", self.__maxNodesOfCell)
        
    '''
        Job computeCst called @1.0 in simulate method
        In variables :
        Out variables : cst
    '''
    def _computeCst(self):
        ''' Initialize _cst at 1.0 in all indexes. '''
        self._cst = [[1.0]]*(self.__nbNodes)
        
        ''' Add in each nodes the value 1.0'''
        tagViewConstantOnNodes = self.addValuesOnNodes("constantOnNodes", self._cst, 1)
        return  tagViewConstantOnNodes
    
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
    def _computeSum(self, tagViewOnNodes):
        
        ''' Get data on nodes '''
        _, tags, data, _, _ =  simpleMeshExample.getValuesData(tagViewOnNodes, 1)
        print("tags : ", tags)
        print("data : ", data)
    
        lineTags, _  = self.getTagsEdges()
        _, _  = self.getTagsQuadrangle()
        valuesOnCells = []
        for jcells in range(0, self.__nbCells):
            jId = jcells + 1
            nodesOfCellJ_typeString = self.getQuadrangleNodes(jId + len(lineTags))
            nodesOnCellJ_typeliste = nodesOfCellJ_typeString.strip('][').split(',')
            ''' Loop on the nodes of the cell '''
            nodes_sum = 0
            for rNodes in range(4):
                nodeNumber = int(nodesOnCellJ_typeliste[rNodes])
                nodes_sum = nodes_sum + int(data[nodeNumber-1])
            valuesOnCells.append([nodes_sum*jcells])
        print("valuesOnCells : ", valuesOnCells)
        ''' Add values on cells '''
        tagView = self.addValuesOnCells("nodesSumOnCells", valuesOnCells, 0)    
        return tagView
    
    '''
        Job assertSum called @3.0 in simulate method.
        In variables : nodes_sum
        Out variables :
    '''
    def _assertSum(self, tagView):
        ''' Get data on nodes '''
        _, tags, data, _, _ =  self.getValuesData(tagView, 0)
        print("tags : ", tags)
        print("data : ", data)
        for i in range(len(data)):
            assert([4*i] == data[i]), " Result is false for i = " + str(i)


if __name__ == '__main__':
    
    mesh = CartesianMesh2D("simple_mesh_example")
    ''' Generate the simpleMeshExample mesh'''
    mesh.jsonInit()
    simpleMeshExample = SimpleMeshExample(mesh)
    ''' Add constant values on nodes'''
    tagViewConstantOnNodes = simpleMeshExample._computeCst()
    ''' Add values on cell corresponding to the sum of the values of each nodes of this cell'''
    valuesOnCells  = simpleMeshExample._computeSum(tagViewConstantOnNodes)
    ''' Test if the values added on cells are correct'''
    simpleMeshExample._assertSum(valuesOnCells)
    ''' Launch graphic interface '''
    simpleMeshExample.launchVisualizationMesh()