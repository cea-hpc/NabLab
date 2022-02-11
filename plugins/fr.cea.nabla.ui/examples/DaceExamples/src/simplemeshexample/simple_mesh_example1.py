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
import dace as dp

from dace.sdfg import SDFG
from dace.memlet import Memlet

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
        
        ''' Add the different symbols'''
        nbNodes = dp.symbol('nbNodes')
        nbNodesCells = dp.symbol('nbNodesCells')
        #nbNodesCells.set(4)
        nbCells = dp.symbol('nbCells')
        
        '''Construct SDFG'''
        sdfg_cells = SDFG('cells')
        sdfg_cells.add_symbol("nbNodesCells", dp.int64)
        sdfg_cells.add_symbol("nbNodes", dp.int64)
        sdfg_cells.add_symbol("nbCells", dp.int64)
        
        sdfg_nodesCells = dp.SDFG("nodesCells")
        sdfg_nodesCells.add_symbol("nbNodes", dp.int64)
        sdfg_nodesCells.add_symbol("nbNodesCells", dp.int64)
        sdfg_nodesCells.add_symbol("nbCells", dp.int64)
        
        sdfg_tmp = dp.SDFG("sdfgTmp")
        sdfg_tmp.add_symbol("nbNodes", dp.int64)
        sdfg_tmp.add_symbol("nbNodesCells", dp.int64)
        sdfg_tmp.add_symbol("nbCells", dp.int64)
        
        sdfg_red = dp.SDFG("reductionSum")
        sdfg_red.add_symbol("nbNodes", dp.int64)
        sdfg_red.add_symbol("nbNodesCells", dp.int64)
        sdfg_red.add_symbol("nbCells", dp.int64)
        
        '''Create the different states'''
        state_cells = sdfg_cells.add_state("cells")
        state_nodesCells = sdfg_nodesCells.add_state("nodesCells")
        state_tmp = sdfg_tmp.add_state("stateTmp")
        state_red = sdfg_red.add_state("reductionSum")
        
        '''Create the map in the cell state'''
        map_entry_cells, map_exit_cells = state_cells.add_map("map_on_cells", dict(ii='0:nbCells'))
        
        '''Create a substate in the cell state'''
        nsdfg_nodesCells = state_cells.add_nested_sdfg(sdfg_nodesCells,
                                                       sdfg_cells, {"read_nodes_cells", "read_cst"},
                                                       {"write_nodes_sum"},
                                                       symbol_mapping=dict(ii='ii', nbCells='nbCells', nbNodes='nbNodes', nbNodesCells='nbNodesCells'),
                                                       name="nodesCells")
        
        '''Create a substate in the nodesCell state'''
        nsdfg_tmp = state_nodesCells.add_nested_sdfg(sdfg_tmp,
                                                     sdfg_nodesCells, {"read_nodes_tmp", "read_cst_tmp"},
                                                     {"write_sum_tmp"},
                                                     symbol_mapping=dict(ii='ii', nbCells='nbCells', nbNodes='nbNodes', nbNodesCells='nbNodesCells'),
                                                     name="nsdfgTmp")
        
        '''Create a substate in the tmp state'''
        nsdfg_red = state_tmp.add_nested_sdfg(sdfg_red,
                                              sdfg_tmp, {"read_tmp_red", },
                                              {"write_sum_red"},
                                              symbol_mapping=dict(ii='ii', nbCells='nbCells', nbNodes='nbNodes', nbNodesCells='nbNodesCells'),
                                              name="reductionSum")
        
        '''Create the map in the cell state for initialize values in the nodes'''
        map_entry_init_nodes, map_exit_init_nodes = state_cells.add_map("init_nodes", {"k": "0:nbNodes"})
        
        '''Create the map in the nodesCell state'''
        map_entry_nodesCells, map_exit_nodesCells = state_nodesCells.add_map("map_on_nodesCells", {"j": "0:nbNodesCells"})
        
        '''Create the map in the tmp state'''
        map_entry_tmp, map_exit_tmp = state_tmp.add_map("map_on_nodes", {"i": "0:nbNodesCells"})
        
        '''Create the different tasklets'''
        tasklet = state_cells.add_tasklet("un", {}, {"out"}, "out = 1")
        tasklet_nodesCells = state_nodesCells.add_tasklet("tasklet", {"a",}, {"b"}, "b=a")
        tasklet_indirection = state_tmp.add_tasklet("Indirection", {"_ind_tmp1", "index_nodesOfCellJ_0"}, {"lookup"}, "lookup = _ind_tmp1[index_nodesOfCellJ_0]")
        tasklet_assign = state_tmp.add_tasklet("Assign", {"_inp"}, {"_out"}, "_out = _inp*ii")
        
        '''Create the reduction sum in the reductionSum state'''
        red = state_red.add_reduce('lambda a,b: a+b', None, 0)
        
        '''Read the different arrays'''
        sdfg_cells.add_array("quads", [nbCells, nbNodesCells], dp.int64)
        quads = state_cells.add_read("quads")
        
        sdfg_cells.add_array("cst", [nbNodes], dp.int64)
        cst = state_cells.add_read("cst")
        
        sdfg_nodesCells.add_array("read_nodes_cells", [nbNodesCells], dp.int64)
        read_nodes_cells = state_nodesCells.add_read("read_nodes_cells")
        
        sdfg_nodesCells.add_array("read_cst", [nbNodes], dp.int64)
        read_cst = state_nodesCells.add_read("read_cst")
        
        sdfg_red.add_array("read_tmp_red", [nbNodesCells], dp.int64, storage=dp.dtypes.StorageType.Register)
        read_tmp_red = state_red.add_read("read_tmp_red")
        
        sdfg_tmp.add_array("read_cst_tmp", [nbNodes], dp.int64)
        read_cst_tmp = state_tmp.add_read("read_cst_tmp")
        
        sdfg_tmp.add_array("read_nodes_tmp", [nbNodesCells], dp.int64)
        read_nodes_tmp = state_tmp.add_read("read_nodes_tmp")
        
        '''Write the different arrays'''
        sdfg_cells.add_array("nodes_sum", [nbCells], dp.int64)
        nodes_sum = state_cells.add_write("nodes_sum")
        
        sdfg_nodesCells.add_array("write_nodes_sum", [nbCells], dp.int64)
        write_nodes_sum = state_nodesCells.add_write("write_nodes_sum")
        
        sdfg_nodesCells.add_stream('write_nodes_cells', dp.int64, transient=True)
        write_nodes_cells = state_nodesCells.add_access("write_nodes_cells")
        
        sdfg_tmp.add_array("write_sum_tmp", [1], dp.int64)
        write_sum_tmp= state_tmp.add_write("write_sum_tmp")
        
        sdfg_tmp.add_transient('tmp_1', [1], dp.int64, dp.dtypes.StorageType.Register)
        tmp_1 = state_tmp.add_write("tmp_1")
        
        sdfg_tmp.add_stream('tmp_red', dp.int64, transient=True)
        tmp_red = state_tmp.add_access("tmp_red")
        
        sdfg_red.add_array("write_sum_red", [1], dp.int64,storage=dp.dtypes.StorageType.Register)
        write_sum_red = state_red.add_write("write_sum_red")
        
        '''Initialize values on nodes'''
        state_cells.add_edge(map_entry_init_nodes, None, tasklet, None, dp.memlet.Memlet())
        state_cells.add_edge(tasklet, 'out', map_exit_init_nodes, None, Memlet.simple(cst, 'k'))
        state_cells.add_edge(map_exit_init_nodes, None, cst, None, Memlet.simple(cst, 'k'))
        
        '''Connections in the reductionSum state'''
        state_red.add_nedge(read_tmp_red, red, dp.Memlet.simple("read_tmp_red", '0:nbNodesCells'))
        state_red.add_nedge(red, write_sum_red, dp.Memlet.simple("write_sum_red", '0'))
        
        '''Connections in the tmp state'''
        state_tmp.add_memlet_path(read_cst_tmp,
                                  map_entry_tmp,
                                  tasklet_indirection,
                                  dst_conn='_ind_tmp1',
                                  memlet=dp.Memlet('read_cst_tmp[0:nbNodes]'))
        
        state_tmp.add_memlet_path(read_nodes_tmp,
                                  map_entry_tmp,
                                  tasklet_indirection,
                                  dst_conn='index_nodesOfCellJ_0',
                                  memlet=dp.Memlet('read_nodes_tmp[i]'))
        
        state_tmp.add_memlet_path(tasklet_indirection,
                                  tmp_1,
                                  src_conn='lookup',
                                  memlet=dp.Memlet('tmp_1[0]'))
        
        state_tmp.add_memlet_path(tmp_1,
                                  tasklet_assign,
                                  dst_conn='_inp',
                                  memlet=dp.Memlet('tmp_1[0]'))
        
        state_tmp.add_memlet_path(tasklet_assign,
                                  map_exit_tmp,
                                  tmp_red,
                                  src_conn='_out',
                                  memlet=dp.Memlet('tmp_red[i]'))
        
        '''Connections in the nodesCells state'''
        state_nodesCells.add_memlet_path(read_nodes_cells,
                                          map_entry_nodesCells,
                                          tasklet_nodesCells,
                                          dst_conn='a',
                                          memlet=dp.Memlet('read_nodes_cells[j]'))
        
        state_nodesCells.add_memlet_path(tasklet_nodesCells,
                                         map_exit_nodesCells,
                                         write_nodes_cells,
                                         src_conn="b",
                                         memlet=dp.Memlet("write_nodes_cells[j]"))
        
        '''Connection between the reductionSum state and the write_sum_tmp array'''
        state_tmp.add_memlet_path(nsdfg_red,
                                  write_sum_tmp,
                                  src_conn="write_sum_red",
                                  memlet=dp.Memlet("write_sum_tmp[0]"))
        
        '''Connection between the tmp_red and the reductionSum state'''
        state_tmp.add_memlet_path(tmp_red,
                                  nsdfg_red,
                                  dst_conn="read_tmp_red",
                                  memlet=dp.Memlet("tmp_red[0:nbNodesCells]"))
        
        '''Connection between the write_nodes_cells array and the stateTmp state'''
        state_nodesCells.add_memlet_path(write_nodes_cells,
                                         nsdfg_tmp,
                                         dst_conn="read_nodes_tmp",
                                         memlet=dp.Memlet("write_nodes_cells[0:nbNodesCells]"))
        
        '''Connection between the read_cst array and the stateTmp state'''
        state_nodesCells.add_memlet_path(read_cst,
                                         nsdfg_tmp,
                                         dst_conn="read_cst_tmp",
                                         memlet=dp.Memlet("read_cst[0:nbNodes]"))
        
        '''Connection between the stateTmp state and the write_nodes_sum'''
        state_nodesCells.add_memlet_path(nsdfg_tmp,
                                         write_nodes_sum,
                                         src_conn="write_sum_tmp",
                                         memlet=dp.Memlet("write_nodes_sum[0:nbCells]"))
        
        '''Connection between the cst array and the nodesCells state'''
        state_cells.add_memlet_path(cst,
                                    map_entry_cells,
                                    nsdfg_nodesCells,
                                    dst_conn="read_cst",
                                    memlet=dp.Memlet("cst[0:nbNodes]"))
        
        '''Connection between the nodesCellOfJ array and the nodesCells state'''
        state_cells.add_memlet_path(quads,
                                    map_entry_cells,
                                    nsdfg_nodesCells,
                                    dst_conn="read_nodes_cells",
                                    memlet=dp.Memlet("quads[ii,0:nbNodesCells]"))
        
        '''Connection between the nodesCells state and the nodes_sum array'''
        state_cells.add_memlet_path(nsdfg_nodesCells,
                                    map_exit_cells,
                                    nodes_sum,
                                    src_conn="write_nodes_sum",
                                    memlet=dp.Memlet("nodes_sum[ii]"))
        
        '''Initialize values of input data'''
        cst_array = np.full((self.__nbNodes),0)
        cst_array = np.array(cst_array)
        cst_array.astype(np.int64)
        
        quads_array = np.empty((0, 4), np.int64)
        for jCells in range(self.__nbCells):
            jId = jCells
            nodesOfCellJ = mesh.getNodesOfCell(jId)
            quads_array = np.append(quads_array, np.array([nodesOfCellJ]), axis=0)
            
        '''Initialize values of output data'''
        nodes_sum_array = np.full((self.__nbCells), 0)
        nodes_sum_array = np.array(nodes_sum_array)
        nodes_sum_array.astype(np.int64)
        
        print("quads_array", quads_array)
        
        
        sdfg_cells(cst=cst_array, quads=quads_array, nodes_sum=nodes_sum_array, nbCells=self.__nbCells, nbNodes=self.__nbNodes, nbNodesCells=self.__maxNodesOfCell)
    
        print("cst_array : ", cst_array)
        
        print("nodes_sum_array : ", nodes_sum_array)
        
        sdfg_cells.view("sdfgComputeCstComputeSum")
        
    def _generateGraphSDFGSolution2(self):
        
        ''' Add the different symbols'''
        nbNodes = dp.symbol('nbNodes')
        nbCells = dp.symbol('nbCells')
        nbNodesCells = dp.symbol('nbNodesCells')
        
        '''Construct SDFG'''
        sdfg_1 = SDFG('sdfg1')
        sdfg_2 = SDFG('sdfg2')
        sdfg_3 = SDFG('sdfg3')
        
        '''Create the different states'''
        state_1 = sdfg_1.add_state("state1")
        state_2 = sdfg_2.add_state("state2")
        state_3 = sdfg_3.add_state("state3")
        
        '''Read the different arrays'''
        sdfg_1.add_array("cst", [nbNodes], dp.int64, storage=dp.dtypes.StorageType.Register)
        cst = state_1.add_read("cst")
        
        sdfg_1.add_array("quads", [nbCells, nbNodesCells], dp.int64, storage=dp.dtypes.StorageType.Register)
        quads = state_1.add_read("quads")
        
        sdfg_1.add_array("nodes_sum", [nbCells], dp.int64, storage=dp.dtypes.StorageType.Register)
        nodes_sum = state_1.add_read("nodes_sum")
        
        sdfg_2.add_array("read_nodes_cells", [nbNodesCells], dp.int64, storage=dp.dtypes.StorageType.Register)
        read_nodes_cells = state_2.add_write("read_nodes_cells")
        
        sdfg_2.add_stream('tmp_red', dp.int64, transient=True)
        write_tmp_red = state_2.add_access("tmp_red")
        
        sdfg_2.add_array("write_sum", [1], dp.int64, storage=dp.dtypes.StorageType.Register)
        write_sum = state_2.add_read("write_sum")
        
        sdfg_3.add_array("read_tmp_red", [nbNodesCells], dp.int64, storage=dp.dtypes.StorageType.Register)
        read_tmp_red = state_3.add_read("read_tmp_red")
        
        '''Create the map in the state_1 state'''
        map_entry_quads, map_exit_quads = state_1.add_map("map_on_cells", {"ii": "0:nbCells"})
        
        '''Create the map in the state_2 state'''
        map_entry_nodes, map_exit_nodes = state_2.add_map("map_on_nodes", {"i": "0:nbNodesCells"})
        
        '''Create the map in the cell state for initialize values in the nodes'''
        map_entry_init_nodes, map_exit_init_nodes = state_1.add_map("init_nodes", {"k": "0:nbNodes"})
        
        '''Create a substate in the state_1 state'''
        nsdfg_state2 = state_1.add_nested_sdfg(sdfg_2,
                                               sdfg_1, {"read_nodes_cells", "read_cst"},
                                               {"write_sum"},
                                               symbol_mapping=dict(ii='ii',nbCells='nbCells', nbNodes='nbNodes', nbNodesCells='nbNodesCells'),
                                               name="nodesCells")
        
        '''Create a substate in the state_2 state'''
        nsdfg_state3 = state_2.add_nested_sdfg(sdfg_3,
                                               sdfg_2, {"read_tmp_red", },
                                               {"write_sum_red"},
                                               symbol_mapping=dict(ii='ii', nbCells='nbCells', nbNodes='nbNodes', nbNodesCells='nbNodesCells'),
                                               name="reductionSum")
        
        '''Read the read_cst array int the state_2 state'''
        sdfg_2.add_array("read_cst", [nbNodes], dp.int64,storage=dp.dtypes.StorageType.Register)
        read_cst = state_2.add_read("read_cst")
        
        '''Add the different tasklets'''
        tasklet = state_1.add_tasklet("un", {}, {"out"}, "out = 1")
        tasklet_indirection = state_2.add_tasklet("Indirection", {"_ind_tmp1", "index_nodesOfCellJ_0"}, {"lookup"}, "lookup = _ind_tmp1[index_nodesOfCellJ_0]")
        tasklet_assign = state_2.add_tasklet("Assign", {"_inp"}, {"_out"}, "_out = _inp*dace.int64(ii)")
        
        '''Write the tmp array int the state_2 state'''
        sdfg_2.add_transient("tmp", [1], dp.int64,storage=dp.dtypes.StorageType.Register)
        tmp = state_2.add_write("tmp")
        
        '''Initialize values on nodes'''
        state_1.add_edge(map_entry_init_nodes, None, tasklet, None, dp.memlet.Memlet())
        state_1.add_edge(tasklet, 'out', map_exit_init_nodes, None, Memlet.simple(cst, 'k'))
        state_1.add_edge(map_exit_init_nodes, None, cst, None, Memlet.simple(cst, 'k'))
        
        '''Connection in the state_2'''
        state_2.add_memlet_path(read_cst,
                                map_entry_nodes,
                                tasklet_indirection,
                                dst_conn='_ind_tmp1',
                                memlet=dp.Memlet('read_cst[0:nbNodes]'))
        
        state_2.add_memlet_path(read_nodes_cells,
                                map_entry_nodes,
                                tasklet_indirection,
                                dst_conn='index_nodesOfCellJ_0',
                                memlet=dp.Memlet('read_nodes_cells[i]'))
        
        state_2.add_memlet_path(tasklet_indirection,
                                tmp,
                                src_conn='lookup',
                                memlet=dp.Memlet('tmp[0]'))
        
        state_2.add_memlet_path(tmp,
                                tasklet_assign,
                                dst_conn='_inp',
                                memlet=dp.Memlet('tmp[0]'))
        
        state_2.add_memlet_path(tasklet_assign,
                                map_exit_nodes,
                                write_tmp_red,
                                src_conn='_out',
                                memlet=dp.Memlet('tmp_red[i]'))
        
        '''Connection in the state_3'''
        red = state_3.add_reduce('lambda a,b: a+b', None, 0)
        
        sdfg_3.add_array("write_sum_red", [1], dp.int64,storage=dp.dtypes.StorageType.Register)
        write_sum_red = state_3.add_write("write_sum_red")
        
        state_3.add_nedge(read_tmp_red, red, dp.Memlet.simple("read_tmp_red", '0:nbNodesCells'))
        state_3.add_nedge(red, write_sum_red, dp.Memlet.simple("write_sum_red", '0'))
        
        '''Connection between the tmp_red and the state_3'''
        state_2.add_memlet_path(write_tmp_red,
                                nsdfg_state3,
                                dst_conn="read_tmp_red",
                                memlet=dp.Memlet("tmp_red[0:nbNodesCells]"))
        
        '''Connection between the state_3 and the write_sum array'''
        state_2.add_memlet_path(nsdfg_state3,
                                write_sum,
                                src_conn="write_sum_red",
                                memlet=dp.Memlet("write_sum[0]"))
        
        state_1.add_memlet_path(cst,
                                map_entry_quads,
                                nsdfg_state2,
                                dst_conn="read_cst",
                                memlet=dp.Memlet("cst[0:nbNodes]"))
        
        state_1.add_memlet_path(quads,
                                map_entry_quads,
                                nsdfg_state2,
                                dst_conn="read_nodes_cells",
                                memlet=dp.Memlet("quads[ii, 0:nbNodesCells]"))
        
        state_1.add_memlet_path(nsdfg_state2,
                                map_exit_quads,
                                nodes_sum,
                                src_conn="write_sum",
                                memlet=dp.Memlet("nodes_sum[ii]"))
        
        '''Initialize values of input data'''
        cst_array = np.full((self.__nbNodes),0)
        cst_array = np.array(cst_array)
        cst_array.astype(np.int64)
        
        quads_array = np.empty((0, 4), np.int64)
        for jCells in range(self.__nbCells):
            jId = jCells
            nodesOfCellJ = mesh.getNodesOfCell(jId)
            quads_array = np.append(quads_array, np.array([nodesOfCellJ]), axis=0)
            
        '''Initialize values of output data'''
        nodes_sum_array = np.full((self.__nbCells), 0)
        nodes_sum_array = np.array(nodes_sum_array)
        nodes_sum_array.astype(np.int64)
        
        print("quads_array", quads_array)
        
        
        sdfg_1(cst=cst_array, quads=quads_array, nodes_sum=nodes_sum_array, nbCells=self.__nbCells, nbNodes=self.__nbNodes, nbNodesCells=self.__maxNodesOfCell)
    
        print("cst_array : ", cst_array)
        
        print("nodes_sum_array : ", nodes_sum_array)
        
        
        sdfg_1.view("sdfgComputeCstComputeSum_solution2")
        
    
    def simulate(self):
        print("Start execution of simpleMeshExample")
        self._computeCst() # @1.0
        self._initTime() # @1.0
        self._computeSum() # @2.0
        self._setUpTimeLoopN() # @2.0
        self._assertSum() # @3.0
        self._executeTimeLoopN() # @3.0
        self._generateGraphSDFG()
        #self._generateGraphSDFGSolution2()
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
