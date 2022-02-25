"""
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
"""
from cartesianmesh2d import CartesianMesh2D
import numpy as np
import json
import sys
from pvdfilewriter2d import PvdFileWriter2D

import numpy as np
import dace 

from dace.sdfg import SDFG
from dace.memlet import Memlet

from dace.sdfg.nodes import MapEntry, Tasklet
from dace.sdfg.graph import NodeNotFoundError, SubgraphView
from dace.transformation.helpers import nest_state_subgraph
from dace.transformation.dataflow import tiling

from IPython.display import Code

import pytest
from dace.sdfg.scope import ScopeSubgraphView

class SimpleMeshExample:
    stopTime = 1.0
    maxIterations = 1
    deltat = 0.001
 
    ''' Mesh and mesh variables'''
    def __init__(self, mesh):
        self.__mesh = mesh
        self.__nbNodes = mesh.nbNodes
        self.__nbCells = mesh.nbCells
        self.__maxNodesOfCell = mesh.MaxNbNodesOfCell

    def jsonInit(self, jsonContent):
        self.__outputPath = jsonContent["outputPath"]
        self.__writer = PvdFileWriter2D("SimpleMeshExample", self.__outputPath)
        self.outputPeriod = jsonContent["outputPeriod"]
        self.lastDump = -sys.maxsize - 1 # Integer.MIN_VALUE
        self.X = np.empty((self.__nbNodes, 2), dtype=np.double)
        self.nodes_sum = np.empty(self.__nbCells, dtype=np.double)
        self.cst = np.empty(self.__nbNodes, dtype=np.double)

        # Copy node coordinates
        gNodes = mesh.geometry.nodes
        for rNodes in range(self.__nbNodes):
            self.X[rNodes] = gNodes[rNodes]

    def _computeCst(self):
        for rNodes in range(self.__nbNodes): 
            self.cst[rNodes] = 1.0
    
    def _computeTn(self):
        self.t_nplus1 = self.t_n + self.deltat

    def _initTime(self):
        self.t_n0 = 0.0
    
    def _computeSum(self):
        for jCells in range(self.__nbCells):
            jId = jCells
            reduction0 = 0.0
            nodesOfCellJ = mesh.getNodesOfCell(jId)
            nbNodesOfCellJ = len(nodesOfCellJ)
            for rNodesOfCellJ in range(nbNodesOfCellJ):
                rId = nodesOfCellJ[rNodesOfCellJ]
                rNodes = rId
                reduction0 = self.__sumR0(reduction0, self.cst[rNodes] * jCells)
            self.nodes_sum[jCells] = reduction0
            
    def _setUpTimeLoopN(self):
        self.t_n = self.t_n0;

    def _assertSum(self):
        for jCells in range(self.__nbCells):
            b = self.__assertEquals(4.0 * jCells, self.nodes_sum[jCells])

    def _executeTimeLoopN(self):
        self.n = 0
        continueLoop = True
        while continueLoop:
            self.n += 1
            print("START ITERATION n: %5d - t: %5.5f - deltat: %5.5f\n" % (self.n, self.t_n, self.deltat))
        
            if (self.n >= self.lastDump + self.outputPeriod):
                self.__dumpVariables(self.n)

            self._computeTn() # @1.0
        
            # Evaluate loop condition with variables at time n
            continueLoop = (self.n < self.maxIterations)
        
            self.t_n = self.t_nplus1
        
        print("FINAL TIME: %5.5f - deltat: %5.5f\n" % (self.t_n, self.deltat))
        self.__dumpVariables(self.n+1)

    def __assertEquals(self, expected, actual):
        assert (expected == actual)

    def __sumR0(self, a, b):
        return a + b

    def __dumpVariables(self, iteration):
        if not self.__writer.disabled:
            quads = mesh.geometry.quads
            self.__writer.startVtpFile(iteration, self.t_n, self.X, quads)
            self.__writer.openNodeData()
            self.__writer.closeNodeData()
            self.__writer.openCellData()
            self.__writer.openCellArray("sum", 0)
            for i in range(self.__nbCells):
                self.__writer.write(self.nodes_sum[i])
            self.__writer.closeCellArray()
            self.__writer.closeCellData()
            self.__writer.closeVtpFile()
            self.lastDump = self.n
            
        
    def _generateGraphSDFG(self):
        
        nbCells = dace.symbol('nbCells')
        nbNodes = dace.symbol('nbNodes')
        maxNodesOfCell = dace.symbol('maxNodesOfCell')
        
        @dace.program
        def _computeCstComputeSum(nodesOfCells: dace.int64[nbCells, maxNodesOfCell], cst: dace.float64[nbNodes], nodes_sum: dace.float64[nbCells]):
            for rNodes in dace.map[0:nbNodes]:
                with dace.tasklet:
                        valuesOnNodes >> cst[rNodes]
                        valuesOnNodes = 1
            for jCells in dace.map[0:nbCells]:
                tmp = np.empty((maxNodesOfCell), dtype=np.float64)
                nodesOfCellJ = np.empty((maxNodesOfCell), dtype=np.int64)
                for rNodes in dace.map[0:maxNodesOfCell]:
                    with dace.tasklet:
                        idNodes << nodesOfCells[jCells,rNodes]
                        nodesCell >> nodesOfCellJ[rNodes]
                        nodesCell = idNodes
                for rNodes in dace.map[0:maxNodesOfCell]:
                    with dace.tasklet:
                        read_values_nodes << cst[nodesOfCellJ[rNodes]]
                        values_on_nodes >> tmp[rNodes]
                        values_on_nodes = read_values_nodes
                nodes_sum[jCells] = np.sum(tmp*jCells, axis=0)
        
        '''Initialize values of input data'''        
        nodesOfCells_array = np.empty((0, 4), np.int64)
        for jCells in range(self.__nbCells):
            jId = jCells
            nodesOfCellJ = mesh.getNodesOfCell(jId)
            nodesOfCells_array = np.append(nodesOfCells_array, np.array([nodesOfCellJ]), axis=0)
            
        '''Initialize values of output data'''
        nodes_sum_array = np.full((self.__nbCells), 0.0)
        nodes_sum_array = np.array(nodes_sum_array)
        nodes_sum_array.astype(np.float64)
        
        print("nodesOfCells_array", nodesOfCells_array)
        
        
        _computeCstComputeSum(cst=self.cst, nodesOfCells=nodesOfCells_array, nodes_sum=nodes_sum_array, nbCells=self.__nbCells, nbNodes=self.__nbNodes, maxNodesOfCell=self.__maxNodesOfCell)
    
        print("cst : ", self.cst)
        
        print("nodes_sum_array : ", nodes_sum_array)
        
        
        sdfg: dace.SDFG = _computeCstComputeSum.to_sdfg()
        state: dace.SDFGState
        
        '''List of the nodes :
            node :  _computeCstComputeSum_3[i=0:nbNodes]
            node :  _computeCstComputeSum_3[i=0:nbNodes]
            node :  cst
            node :  _computeCstComputeSum_7[ii=0:nbCells]
            node :  _computeCstComputeSum_7[ii=0:nbCells]
            node :  quads
            node :  nodes_sum
            node :  _computeCstComputeSum_4
            node :  _computeCstComputeSum_7_4_10[j=0:nbNodesCells]
            node :  _computeCstComputeSum_7_4_10[j=0:nbNodesCells]
            node :  nodesCellOfJ
            node :  _computeCstComputeSum_7_4_15[k=0:nbNodesCells]
            node :  _computeCstComputeSum_7_4_15[k=0:nbNodesCells]
            node :  tmp
            node :  _Mult__map[__i0=0:nbNodesCells]
            node :  _Mult_
            node :  _Mult__map[__i0=0:nbNodesCells]
            node :  __tmp3
            node :  Reduce (Sum), Axes: [0]
            node :  __tmp4
            node :  assign_20_8
            node :  _computeCstComputeSum_7_4_11
            node :  _computeCstComputeSum_7_4_16
            node :  Indirection
        
        '''
        
        '''List of the states : 
            state : MapState
        '''
        # Nest outer region
        '''Creation of a state representing the computation of computeCst'''
        for node, state in sdfg.all_nodes_recursive():
            if isinstance(node, dace.nodes.MapEntry):
                #if len(node.map.params) == 1:
                    '''_scope_subgraph(graph, entry_node, include_entry, include_exit). Detect each subgraph after :'''
                    '''Traverse children map nodes'''
                    '''Get child map subgraph (1 level)'''
                    subgraph = state.scope_subgraph(node)
                    '''Create the subgraph''' 
                    nest_state_subgraph(sdfg, state, subgraph)
                    break
        # Nest inner scope
        for node, state in sdfg.all_nodes_recursive():
            if isinstance(node, dace.nodes.MapEntry):
                if len(node.map.params) == 1:
                    subgraph = state.scope_subgraph(node, include_entry=False, include_exit=False)
                    nest_state_subgraph(sdfg, state, subgraph)
                    break
                
        """ Iterate over this and all nested SDFGs. """
        for csdfg in sdfg.all_sdfgs_recursive():
                pass
                
        sdfg.view("sdfgGraphWith3States")
        
        
    def _generateGraphSDFGSolution2(self):
        
        nbCells = dace.symbol('nbCells')
        nbNodes = dace.symbol('nbNodes')
        maxNodesOfCell = dace.symbol('maxNodesOfCell')
        
        @dace.program
        def _computeCstComputeSum(nodesOfCells: dace.int64[nbCells, maxNodesOfCell], cst: dace.float64[nbNodes], nodes_sum: dace.float64[nbCells]):
            for rNodes in dace.map[0:nbNodes]:
                with dace.tasklet:
                        valuesOnNodes >> cst[rNodes]
                        valuesOnNodes = 1
            for jCells in dace.map[0:nbCells]:
                tmp = np.empty((maxNodesOfCell), dtype=np.float64)
                nodesOfCellJ = np.empty((maxNodesOfCell), dtype=np.int64)
                for rNodes in dace.map[0:maxNodesOfCell]:
                    with dace.tasklet:
                        idNodes << nodesOfCells[jCells,rNodes]
                        nodesCell >> nodesOfCellJ[rNodes]
                        nodesCell = idNodes
                for rNodes in dace.map[0:maxNodesOfCell]:
                    with dace.tasklet:
                        read_values_nodes << cst[nodesOfCellJ[rNodes]]
                        values_on_nodes >> tmp[rNodes]
                        values_on_nodes = read_values_nodes
                nodes_sum[jCells] = np.sum(tmp*jCells, axis=0)
        
        '''Initialize values of input data'''        
        nodesOfCells_array = np.empty((0, 4), np.int64)
        for jCells in range(self.__nbCells):
            jId = jCells
            nodesOfCellJ = mesh.getNodesOfCell(jId)
            nodesOfCells_array = np.append(nodesOfCells_array, np.array([nodesOfCellJ]), axis=0)
            
        '''Initialize values of output data'''
        nodes_sum_array = np.full((self.__nbCells), 0.0)
        nodes_sum_array = np.array(nodes_sum_array)
        nodes_sum_array.astype(np.float64)
        
        print("nodesOfCells_array", nodesOfCells_array)
        
        
        _computeCstComputeSum(cst=self.cst, nodesOfCells=nodesOfCells_array, nodes_sum=nodes_sum_array, nbCells=self.__nbCells, nbNodes=self.__nbNodes, maxNodesOfCell=self.__maxNodesOfCell)
    
        print("cst : ", self.cst)
        
        print("nodes_sum_array : ", nodes_sum_array)
        
        
        sdfg = _computeCstComputeSum.to_sdfg()
        for state in sdfg.nodes():
            if any(isinstance(node, Tasklet) for node in state.nodes()):
                break
        
        
        tasklet_nodes = [n for n in state.nodes() if isinstance(n, Tasklet)]
        
        for i in range(len(tasklet_nodes)):
            if (i!=2):
                nest_state_subgraph(sdfg, state, SubgraphView(state, [tasklet_nodes[i]]))      
        
        sdfg.view("sdfgGraphWithStatesForEachTasklet")
        
    def _generateGraphSDFGSolution3(self):
        
        nbCells = dace.symbol('nbCells')
        nbNodes = dace.symbol('nbNodes')
        maxNodesOfCell = dace.symbol('maxNodesOfCell')
        
        @dace.program
        def _computeCstComputeSum(nodesOfCells: dace.int64[nbCells, maxNodesOfCell], cst: dace.float64[nbNodes], nodes_sum: dace.float64[nbCells]):
            for rNodes in dace.map[0:nbNodes]:
                with dace.tasklet:
                        valuesOnNodes >> cst[rNodes]
                        valuesOnNodes = 1
            for jCells in dace.map[0:nbCells]:
                tmp = np.empty((maxNodesOfCell), dtype=np.int64)
                nodesOfCellJ = np.empty((maxNodesOfCell), dtype=np.int64)
                for rNodes in dace.map[0:maxNodesOfCell]:
                    with dace.tasklet:
                        idNodes << nodesOfCells[jCells,rNodes]
                        nodesCell >> nodesOfCellJ[rNodes]
                        nodesCell = idNodes
                for rNodes in dace.map[0:maxNodesOfCell]:
                    with dace.tasklet:
                        read_values_nodes << cst[nodesOfCellJ[rNodes]]
                        values_on_nodes >> tmp[rNodes]
                        values_on_nodes = read_values_nodes
                nodes_sum[jCells] = np.sum(tmp*jCells, axis=0)
        
        '''Initialize values of input data'''
        
        nodesOfCells_array = np.empty((0, 4), np.int64)
        for jCells in range(self.__nbCells):
            jId = jCells
            nodesOfCellJ = mesh.getNodesOfCell(jId)
            nodesOfCells_array = np.append(nodesOfCells_array, np.array([nodesOfCellJ]), axis=0)
            
        '''Initialize values of output data'''
        nodes_sum_array = np.full((self.__nbCells), 0.0)
        nodes_sum_array = np.array(nodes_sum_array)
        nodes_sum_array.astype(np.float64)
        
        print("nodesOfCells_array", nodesOfCells_array)
        
        
        _computeCstComputeSum(cst=self.cst, nodesOfCells=nodesOfCells_array, nodes_sum=nodes_sum_array, nbCells=self.__nbCells, nbNodes=self.__nbNodes, maxNodesOfCell=self.__maxNodesOfCell)
        
        print("cst : ", self.cst)
        print("nodes_sum_array : ", nodes_sum_array)
        
        sdfg: dace.SDFG = _computeCstComputeSum.to_sdfg()
        state: dace.SDFGState
        
        # Nest inner scope
        for node, state in sdfg.all_nodes_recursive():
            if isinstance(node, dace.nodes.MapEntry):
                if len(node.map.params) == 1 and node.map.params[0] == 'jCells':
                    subgraph = state.scope_subgraph(node, include_entry=False, include_exit=False)
                    nest_state_subgraph(state.parent, state, subgraph)
                    break
        
        sdfg.view("sdfgGraphWith2States")
        
    
    def simulate(self):
        print("Start execution of simpleMeshExample")
        self._computeCst() # @1.0
        self._initTime() # @1.0
        self._computeSum() # @2.0
        self._setUpTimeLoopN() # @2.0
        self._assertSum() # @3.0
        #self._executeTimeLoopN() # @3.0
        #self._generateGraphSDFG()
        #self._generateGraphSDFGSolution2()
        self._generateGraphSDFGSolution3()
        print("End of execution of simpleMeshExample")

if __name__ == '__main__':
    args = sys.argv[1:]
    
    if len(args) == 1:
        f = open(args[0])
        data = json.load(f)
        f.close()

        # Mesh instanciation    
        mesh = CartesianMesh2D()
        mesh.jsonInit(data["mesh"])
    
        # Module instanciation
        simpleMeshExample = SimpleMeshExample(mesh)
        simpleMeshExampleData = data["simpleMeshExample"]
        if simpleMeshExampleData:
            simpleMeshExample.jsonInit(simpleMeshExampleData) 

        # Start simulation
        simpleMeshExample.simulate()
    else:
        print("[ERROR] Wrong number of arguments: expected 1, actual " + str(len(args)), file=sys.stderr)
        print("        Expecting user data file name, for example SimpleMeshExample.json", file=sys.stderr)
        exit(1)