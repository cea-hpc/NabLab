import numpy as np
import dace as dp

from dace.sdfg import SDFG
from dace.memlet import Memlet
from dace.sdfg.validation import validate, validate_sdfg

# Importing these outside creates an import loop
from dace.codegen import codegen, compiler
from dace.codegen.compiled_sdfg import CompiledSDFG
import dace.config

valOutput_test1 = np.full((1), 0)
valOutput_test1 = np.array(valOutput_test1)
valOutput_test1.astype(np.int64)

valInput_test1 = 4
valInput_test1 = [valInput_test1]
valInput_test1 = np.array(valInput_test1)
valInput_test1.astype(np.int64)

valOutput_test2 = 0
valOutput_test2 = [valOutput_test2]
valOutput_test2 = np.array(valOutput_test2)
valOutput_test2.astype(np.int64)

valInput_test2 = 9
valInput_test2 = [valInput_test2]
valInput_test2 = np.array(valInput_test2)
valInput_test2.astype(np.int64)

valOutput_test3 = np.full((1), 0.0)
valOutput_test3 = np.array(valOutput_test3)
valOutput_test3.astype(np.float64)

valInput_test3 = 4.0
valInput_test3 = [valInput_test3]
valInput_test3 = np.array(valInput_test3)
valInput_test3.astype(np.float64)

valOutput_test4 = 0.0
valOutput_test4 = [valOutput_test4]
valOutput_test4 = np.array(valOutput_test4)
valOutput_test4.astype(np.float64)

valInput_test4 = 7.0
valInput_test4 = [valInput_test4]
valInput_test4 = np.array(valInput_test4)
valInput_test4.astype(np.float64)

valOutput_test5 = np.full((5), 0.0)
valOutput_test5 = np.array(valOutput_test5)
valOutput_test5.astype(np.float64)

valInput_test5 = [5.0] * 5
valInput_test5 = np.array(valInput_test5)
valInput_test5.astype(np.float64)

valOutput_test6 = [0.0] * 5
valOutput_test6 = np.array(valOutput_test6)
valOutput_test6.astype(np.float64)

valInput_test6 = [2.0] * 5
valInput_test6 = np.array(valInput_test6)
valInput_test6.astype(np.float64)

valOutput_test7 = np.full((5), 0)
valOutput_test7 = np.array(valOutput_test7)
valOutput_test7.astype(np.int64)

valInput_test7 = [5] * 5
valInput_test7 = np.array(valInput_test7)
valInput_test7.astype(np.int64)

valOutput_test8 = [0] * 5
valOutput_test8 = np.array(valOutput_test8)
valOutput_test8.astype(np.int64)

valInput_test8 = [5] * 5
valInput_test8 = np.array(valInput_test8)
valInput_test8.astype(np.int64)


mysdfg = SDFG('VariableDefinition')


MultiScalarByScalar_test1 = mysdfg.add_state("MultiScalarByScalar_test1", is_start_state=True)

MultiScalarByScalar_test1_tasklet = MultiScalarByScalar_test1.add_tasklet('MultiScalarByScalar_test1', {'valInput_test1'}, {'valOutput_test1'}, 'valOutput_test1=valInput_test1*3')

MultiScalarByScalar_test1_valInput_test1 = mysdfg.add_array('MultiScalarByScalar_test1_valInput_test1', [1], dp.int64)
MultiScalarByScalar_test1_valOutput_test1 = mysdfg.add_array('MultiScalarByScalar_test1_valOutput_test1', [1], dp.int64)

map_entry, map_exit = MultiScalarByScalar_test1.add_map('MultiScalarByScalar_test1_map', dict(i='0:1'))
MultiScalarByScalar_test1.add_memlet_path(MultiScalarByScalar_test1.add_read('MultiScalarByScalar_test1_valInput_test1'),map_entry, MultiScalarByScalar_test1_tasklet, dst_conn='valInput_test1',memlet=dace.Memlet.simple('MultiScalarByScalar_test1_valInput_test1','i'))
MultiScalarByScalar_test1.add_memlet_path(MultiScalarByScalar_test1_tasklet, map_exit, MultiScalarByScalar_test1.add_write('MultiScalarByScalar_test1_valOutput_test1'), src_conn='valOutput_test1',memlet=dace.Memlet.simple('MultiScalarByScalar_test1_valOutput_test1','i'))


MultiScalarByScalar_test2 = mysdfg.add_state("MultiScalarByScalar_test2", is_start_state=True)

MultiScalarByScalar_test2_tasklet = MultiScalarByScalar_test2.add_tasklet('MultiScalarByScalar_test2', {'valInput_test2'}, {'valOutput_test2'}, 'valOutput_test2=valInput_test2*3')

MultiScalarByScalar_test2_valInput_test2 = mysdfg.add_array('MultiScalarByScalar_test2_valInput_test2', [1], dp.int64)
MultiScalarByScalar_test2_valOutput_test2 = mysdfg.add_array('MultiScalarByScalar_test2_valOutput_test2', [1], dp.int64)

map_entry, map_exit = MultiScalarByScalar_test2.add_map('MultiScalarByScalar_test2_map', dict(i='0:1'))
MultiScalarByScalar_test2.add_memlet_path(MultiScalarByScalar_test2.add_read('MultiScalarByScalar_test2_valInput_test2'),map_entry, MultiScalarByScalar_test2_tasklet, dst_conn='valInput_test2',memlet=dace.Memlet.simple('MultiScalarByScalar_test2_valInput_test2','i'))
MultiScalarByScalar_test2.add_memlet_path(MultiScalarByScalar_test2_tasklet, map_exit, MultiScalarByScalar_test2.add_write('MultiScalarByScalar_test2_valOutput_test2'), src_conn='valOutput_test2',memlet=dace.Memlet.simple('MultiScalarByScalar_test2_valOutput_test2','i'))


MultiScalarByScalar_test3 = mysdfg.add_state("MultiScalarByScalar_test3", is_start_state=True)

MultiScalarByScalar_test3_tasklet = MultiScalarByScalar_test3.add_tasklet('MultiScalarByScalar_test3', {'valInput_test3'}, {'valOutput_test3'}, 'valOutput_test3=valInput_test3*5.0')

MultiScalarByScalar_test3_valInput_test3 = mysdfg.add_array('MultiScalarByScalar_test3_valInput_test3', [1], dp.float64)
MultiScalarByScalar_test3_valOutput_test3 = mysdfg.add_array('MultiScalarByScalar_test3_valOutput_test3', [1], dp.float64)

map_entry, map_exit = MultiScalarByScalar_test3.add_map('MultiScalarByScalar_test3_map', dict(i='0:1'))
MultiScalarByScalar_test3.add_memlet_path(MultiScalarByScalar_test3.add_read('MultiScalarByScalar_test3_valInput_test3'),map_entry, MultiScalarByScalar_test3_tasklet, dst_conn='valInput_test3',memlet=dace.Memlet.simple('MultiScalarByScalar_test3_valInput_test3','i'))
MultiScalarByScalar_test3.add_memlet_path(MultiScalarByScalar_test3_tasklet, map_exit, MultiScalarByScalar_test3.add_write('MultiScalarByScalar_test3_valOutput_test3'), src_conn='valOutput_test3',memlet=dace.Memlet.simple('MultiScalarByScalar_test3_valOutput_test3','i'))


MultiScalarByScalar_test4 = mysdfg.add_state("MultiScalarByScalar_test4", is_start_state=True)

MultiScalarByScalar_test4_tasklet = MultiScalarByScalar_test4.add_tasklet('MultiScalarByScalar_test4', {'valInput_test4'}, {'valOutput_test4'}, 'valOutput_test4=valInput_test4*12')

MultiScalarByScalar_test4_valInput_test4 = mysdfg.add_array('MultiScalarByScalar_test4_valInput_test4', [1], dp.float64)
MultiScalarByScalar_test4_valOutput_test4 = mysdfg.add_array('MultiScalarByScalar_test4_valOutput_test4', [1], dp.float64)

map_entry, map_exit = MultiScalarByScalar_test4.add_map('MultiScalarByScalar_test4_map', dict(i='0:1'))
MultiScalarByScalar_test4.add_memlet_path(MultiScalarByScalar_test4.add_read('MultiScalarByScalar_test4_valInput_test4'),map_entry, MultiScalarByScalar_test4_tasklet, dst_conn='valInput_test4',memlet=dace.Memlet.simple('MultiScalarByScalar_test4_valInput_test4','i'))
MultiScalarByScalar_test4.add_memlet_path(MultiScalarByScalar_test4_tasklet, map_exit, MultiScalarByScalar_test4.add_write('MultiScalarByScalar_test4_valOutput_test4'), src_conn='valOutput_test4',memlet=dace.Memlet.simple('MultiScalarByScalar_test4_valOutput_test4','i'))


MultiVectorByScalar_test5 = mysdfg.add_state("MultiVectorByScalar_test5", is_start_state=True)

MultiVectorByScalar_test5_tasklet = MultiVectorByScalar_test5.add_tasklet('MultiVectorByScalar_test5', {'valInput_test5'}, {'valOutput_test5'}, 'valOutput_test5=valInput_test5*6.0+2')

MultiVectorByScalar_test5_valInput_test5 = mysdfg.add_array('MultiVectorByScalar_test5_valInput_test5', [5], dp.float64)
MultiVectorByScalar_test5_valOutput_test5 = mysdfg.add_array('MultiVectorByScalar_test5_valOutput_test5', [5], dp.float64)

map_entry, map_exit = MultiVectorByScalar_test5.add_map('MultiVectorByScalar_test5_map', dict(i0='0:5'))
MultiVectorByScalar_test5.add_memlet_path(MultiVectorByScalar_test5.add_read('MultiVectorByScalar_test5_valInput_test5'),map_entry, MultiVectorByScalar_test5_tasklet, dst_conn='valInput_test5',memlet=dace.Memlet('MultiVectorByScalar_test5_valInput_test5[i0]'))
MultiVectorByScalar_test5.add_memlet_path(MultiVectorByScalar_test5_tasklet, map_exit, MultiVectorByScalar_test5.add_write('MultiVectorByScalar_test5_valOutput_test5'), src_conn='valOutput_test5',memlet=dace.Memlet('MultiVectorByScalar_test5_valOutput_test5[i0]'))


MultiVectorByScalar_test6 = mysdfg.add_state("MultiVectorByScalar_test6", is_start_state=True)

MultiVectorByScalar_test6_tasklet = MultiVectorByScalar_test6.add_tasklet('MultiVectorByScalar_test6', {'valInput_test6'}, {'valOutput_test6'}, 'valOutput_test6=valInput_test6*6.0+2')

MultiVectorByScalar_test6_valInput_test6 = mysdfg.add_array('MultiVectorByScalar_test6_valInput_test6', [5], dp.float64)
MultiVectorByScalar_test6_valOutput_test6 = mysdfg.add_array('MultiVectorByScalar_test6_valOutput_test6', [5], dp.float64)

map_entry, map_exit = MultiVectorByScalar_test6.add_map('MultiVectorByScalar_test6_map', dict(i0='0:5'))
MultiVectorByScalar_test6.add_memlet_path(MultiVectorByScalar_test6.add_read('MultiVectorByScalar_test6_valInput_test6'),map_entry, MultiVectorByScalar_test6_tasklet, dst_conn='valInput_test6',memlet=dace.Memlet('MultiVectorByScalar_test6_valInput_test6[i0]'))
MultiVectorByScalar_test6.add_memlet_path(MultiVectorByScalar_test6_tasklet, map_exit, MultiVectorByScalar_test6.add_write('MultiVectorByScalar_test6_valOutput_test6'), src_conn='valOutput_test6',memlet=dace.Memlet('MultiVectorByScalar_test6_valOutput_test6[i0]'))


MultiVectorByScalar_test7 = mysdfg.add_state("MultiVectorByScalar_test7", is_start_state=True)

MultiVectorByScalar_test7_tasklet = MultiVectorByScalar_test7.add_tasklet('MultiVectorByScalar_test7', {'valInput_test7'}, {'valOutput_test7'}, 'valOutput_test7=valInput_test7*4+2')

MultiVectorByScalar_test7_valInput_test7 = mysdfg.add_array('MultiVectorByScalar_test7_valInput_test7', [5], dp.int64)
MultiVectorByScalar_test7_valOutput_test7 = mysdfg.add_array('MultiVectorByScalar_test7_valOutput_test7', [5], dp.int64)

map_entry, map_exit = MultiVectorByScalar_test7.add_map('MultiVectorByScalar_test7_map', dict(i0='0:5'))
MultiVectorByScalar_test7.add_memlet_path(MultiVectorByScalar_test7.add_read('MultiVectorByScalar_test7_valInput_test7'),map_entry, MultiVectorByScalar_test7_tasklet, dst_conn='valInput_test7',memlet=dace.Memlet('MultiVectorByScalar_test7_valInput_test7[i0]'))
MultiVectorByScalar_test7.add_memlet_path(MultiVectorByScalar_test7_tasklet, map_exit, MultiVectorByScalar_test7.add_write('MultiVectorByScalar_test7_valOutput_test7'), src_conn='valOutput_test7',memlet=dace.Memlet('MultiVectorByScalar_test7_valOutput_test7[i0]'))


MultiVectorByScalar_test8 = mysdfg.add_state("MultiVectorByScalar_test8", is_start_state=True)

MultiVectorByScalar_test8_tasklet = MultiVectorByScalar_test8.add_tasklet('MultiVectorByScalar_test8', {'valInput_test8'}, {'valOutput_test8'}, 'valOutput_test8=valInput_test8*4+2')

MultiVectorByScalar_test8_valInput_test8 = mysdfg.add_array('MultiVectorByScalar_test8_valInput_test8', [5], dp.int64)
MultiVectorByScalar_test8_valOutput_test8 = mysdfg.add_array('MultiVectorByScalar_test8_valOutput_test8', [5], dp.int64)

map_entry, map_exit = MultiVectorByScalar_test8.add_map('MultiVectorByScalar_test8_map', dict(i0='0:5'))
MultiVectorByScalar_test8.add_memlet_path(MultiVectorByScalar_test8.add_read('MultiVectorByScalar_test8_valInput_test8'),map_entry, MultiVectorByScalar_test8_tasklet, dst_conn='valInput_test8',memlet=dace.Memlet('MultiVectorByScalar_test8_valInput_test8[i0]'))
MultiVectorByScalar_test8.add_memlet_path(MultiVectorByScalar_test8_tasklet, map_exit, MultiVectorByScalar_test8.add_write('MultiVectorByScalar_test8_valOutput_test8'), src_conn='valOutput_test8',memlet=dace.Memlet('MultiVectorByScalar_test8_valOutput_test8[i0]'))


mysdfg.add_edge(MultiScalarByScalar_test1, MultiScalarByScalar_test2,dace.InterstateEdge())
mysdfg.add_edge(MultiScalarByScalar_test2, MultiScalarByScalar_test3,dace.InterstateEdge())
mysdfg.add_edge(MultiScalarByScalar_test3, MultiScalarByScalar_test4,dace.InterstateEdge())
mysdfg.add_edge(MultiScalarByScalar_test4, MultiVectorByScalar_test5,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test5, MultiVectorByScalar_test6,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test6, MultiVectorByScalar_test7,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test7, MultiVectorByScalar_test8,dace.InterstateEdge())


mysdfg(MultiScalarByScalar_test1_valOutput_test1=valOutput_test1, MultiScalarByScalar_test1_valInput_test1=valInput_test1, 
MultiScalarByScalar_test2_valOutput_test2=valOutput_test2, MultiScalarByScalar_test2_valInput_test2=valInput_test2, 
MultiScalarByScalar_test3_valOutput_test3=valOutput_test3, MultiScalarByScalar_test3_valInput_test3=valInput_test3, 
MultiScalarByScalar_test4_valOutput_test4=valOutput_test4, MultiScalarByScalar_test4_valInput_test4=valInput_test4, 
MultiVectorByScalar_test5_valOutput_test5=valOutput_test5, MultiVectorByScalar_test5_valInput_test5=valInput_test5, 
MultiVectorByScalar_test6_valOutput_test6=valOutput_test6, MultiVectorByScalar_test6_valInput_test6=valInput_test6, 
MultiVectorByScalar_test7_valOutput_test7=valOutput_test7, MultiVectorByScalar_test7_valInput_test7=valInput_test7, 
MultiVectorByScalar_test8_valOutput_test8=valOutput_test8, MultiVectorByScalar_test8_valInput_test8=valInput_test8)

mysdfg.view('VariableDefinition')
