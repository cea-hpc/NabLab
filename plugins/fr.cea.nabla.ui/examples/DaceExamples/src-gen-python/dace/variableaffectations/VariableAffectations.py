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

valInput_test1 = 8
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

valOutput_test10 = [0.0, 0.0, 0.0, 0.0, 0.0 ]
valOutput_test10 = np.array(valOutput_test10)
valOutput_test10.astype(np.float64)

valInput_test10 = [1.0, 2.0, 3.0, 4.0, 5.0 ]
valInput_test10 = np.array(valInput_test10)
valInput_test10.astype(np.float64)

valOutput_test11 = np.full((5), 0)
valOutput_test11 = np.array(valOutput_test11)
valOutput_test11.astype(np.int64)

valInput_test11 = [4, 7, 3, 8, 5 ]
valInput_test11 = np.array(valInput_test11)
valInput_test11.astype(np.int64)

valOutput_test12 = [0, 0, 0, 0, 0 ]
valOutput_test12 = np.array(valOutput_test12)
valOutput_test12.astype(np.int64)

valInput_test12 = [4, 7, 3, 8, 5 ]
valInput_test12 = np.array(valInput_test12)
valInput_test12.astype(np.int64)

valOutput_test13 = np.full((6,5), 0.0)
valOutput_test13 = np.array(valOutput_test13)
valOutput_test13.astype(np.float64)

valInput_test13 = [[5.0] * 5 for _ in range(6)]
valInput_test13 = np.array(valInput_test13)
valInput_test13.astype(np.float64)

valOutput_test14 = [[0.0] * 5 for _ in range(6)]
valOutput_test14 = np.array(valOutput_test14)
valOutput_test14.astype(np.float64)

valInput_test14 = [[5.0] * 5 for _ in range(6)]
valInput_test14 = np.array(valInput_test14)
valInput_test14.astype(np.float64)

valOutput_test15 = np.full((6,5), 0)
valOutput_test15 = np.array(valOutput_test15)
valOutput_test15.astype(np.int64)

valInput_test15 = [[4] * 5 for _ in range(6)]
valInput_test15 = np.array(valInput_test15)
valInput_test15.astype(np.int64)

valOutput_test16 = [[0] * 5 for _ in range(6)]
valOutput_test16 = np.array(valOutput_test16)
valOutput_test16.astype(np.int64)

valInput_test16 = [[4] * 5 for _ in range(6)]
valInput_test16 = np.array(valInput_test16)
valInput_test16.astype(np.int64)

valOutput_test17 = np.full((2,2), 0.0)
valOutput_test17 = np.array(valOutput_test17)
valOutput_test17.astype(np.float64)

valInput_test17 = [[1.0, 2.0 ], [4.0, 5.0 ] ]
valInput_test17 = np.array(valInput_test17)
valInput_test17.astype(np.float64)

valOutput_test18 = [[0.0, 0.0 ], [0.0, 0.0 ] ]
valOutput_test18 = np.array(valOutput_test18)
valOutput_test18.astype(np.float64)

valInput_test18 = [[1.0, 2.0 ], [4.0, 5.0 ] ]
valInput_test18 = np.array(valInput_test18)
valInput_test18.astype(np.float64)

valOutput_test19 = np.full((2,2), 0)
valOutput_test19 = np.array(valOutput_test19)
valOutput_test19.astype(np.int64)

valInput_test19 = [[3, 4 ], [7, 5 ] ]
valInput_test19 = np.array(valInput_test19)
valInput_test19.astype(np.int64)

valOutput_test20 = [[0, 0 ], [0, 0 ] ]
valOutput_test20 = np.array(valOutput_test20)
valOutput_test20.astype(np.int64)

valInput_test20 = [[3, 4 ], [7, 5 ] ]
valInput_test20 = np.array(valInput_test20)
valInput_test20.astype(np.int64)

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

valOutput_test9 = np.full((5), 0.0)
valOutput_test9 = np.array(valOutput_test9)
valOutput_test9.astype(np.float64)

valInput_test9 = [1.0, 2.0, 3.0, 4.0, 5.0 ]
valInput_test9 = np.array(valInput_test9)
valInput_test9.astype(np.float64)


mysdfg = SDFG('VariableAffectations')


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


MultiVectorByScalar_test10 = mysdfg.add_state("MultiVectorByScalar_test10", is_start_state=True)

MultiVectorByScalar_test10_tasklet = MultiVectorByScalar_test10.add_tasklet('MultiVectorByScalar_test10', {'valInput_test10'}, {'valOutput_test10'}, 'valOutput_test10=valInput_test10*2.0+3.0')

MultiVectorByScalar_test10_valInput_test10 = mysdfg.add_array('MultiVectorByScalar_test10_valInput_test10', [5], dp.float64)
MultiVectorByScalar_test10_valOutput_test10 = mysdfg.add_array('MultiVectorByScalar_test10_valOutput_test10', [5], dp.float64)

map_entry, map_exit = MultiVectorByScalar_test10.add_map('MultiVectorByScalar_test10_map', dict(i0='0:5'))
MultiVectorByScalar_test10.add_memlet_path(MultiVectorByScalar_test10.add_read('MultiVectorByScalar_test10_valInput_test10'),map_entry, MultiVectorByScalar_test10_tasklet, dst_conn='valInput_test10',memlet=dace.Memlet('MultiVectorByScalar_test10_valInput_test10[i0]'))
MultiVectorByScalar_test10.add_memlet_path(MultiVectorByScalar_test10_tasklet, map_exit, MultiVectorByScalar_test10.add_write('MultiVectorByScalar_test10_valOutput_test10'), src_conn='valOutput_test10',memlet=dace.Memlet('MultiVectorByScalar_test10_valOutput_test10[i0]'))


MultiVectorByScalar_test11 = mysdfg.add_state("MultiVectorByScalar_test11", is_start_state=True)

MultiVectorByScalar_test11_tasklet = MultiVectorByScalar_test11.add_tasklet('MultiVectorByScalar_test11', {'valInput_test11'}, {'valOutput_test11'}, 'valOutput_test11=valInput_test11*2+3')

MultiVectorByScalar_test11_valInput_test11 = mysdfg.add_array('MultiVectorByScalar_test11_valInput_test11', [5], dp.int64)
MultiVectorByScalar_test11_valOutput_test11 = mysdfg.add_array('MultiVectorByScalar_test11_valOutput_test11', [5], dp.int64)

map_entry, map_exit = MultiVectorByScalar_test11.add_map('MultiVectorByScalar_test11_map', dict(i0='0:5'))
MultiVectorByScalar_test11.add_memlet_path(MultiVectorByScalar_test11.add_read('MultiVectorByScalar_test11_valInput_test11'),map_entry, MultiVectorByScalar_test11_tasklet, dst_conn='valInput_test11',memlet=dace.Memlet('MultiVectorByScalar_test11_valInput_test11[i0]'))
MultiVectorByScalar_test11.add_memlet_path(MultiVectorByScalar_test11_tasklet, map_exit, MultiVectorByScalar_test11.add_write('MultiVectorByScalar_test11_valOutput_test11'), src_conn='valOutput_test11',memlet=dace.Memlet('MultiVectorByScalar_test11_valOutput_test11[i0]'))


MultiVectorByScalar_test12 = mysdfg.add_state("MultiVectorByScalar_test12", is_start_state=True)

MultiVectorByScalar_test12_tasklet = MultiVectorByScalar_test12.add_tasklet('MultiVectorByScalar_test12', {'valInput_test12'}, {'valOutput_test12'}, 'valOutput_test12=valInput_test12*3+7')

MultiVectorByScalar_test12_valInput_test12 = mysdfg.add_array('MultiVectorByScalar_test12_valInput_test12', [5], dp.int64)
MultiVectorByScalar_test12_valOutput_test12 = mysdfg.add_array('MultiVectorByScalar_test12_valOutput_test12', [5], dp.int64)

map_entry, map_exit = MultiVectorByScalar_test12.add_map('MultiVectorByScalar_test12_map', dict(i0='0:5'))
MultiVectorByScalar_test12.add_memlet_path(MultiVectorByScalar_test12.add_read('MultiVectorByScalar_test12_valInput_test12'),map_entry, MultiVectorByScalar_test12_tasklet, dst_conn='valInput_test12',memlet=dace.Memlet('MultiVectorByScalar_test12_valInput_test12[i0]'))
MultiVectorByScalar_test12.add_memlet_path(MultiVectorByScalar_test12_tasklet, map_exit, MultiVectorByScalar_test12.add_write('MultiVectorByScalar_test12_valOutput_test12'), src_conn='valOutput_test12',memlet=dace.Memlet('MultiVectorByScalar_test12_valOutput_test12[i0]'))


MultiVectorByScalar_test13 = mysdfg.add_state("MultiVectorByScalar_test13", is_start_state=True)

MultiVectorByScalar_test13_tasklet = MultiVectorByScalar_test13.add_tasklet('MultiVectorByScalar_test13', {'valInput_test13'}, {'valOutput_test13'}, 'valOutput_test13=valInput_test13*2+5')

MultiVectorByScalar_test13_valInput_test13 = mysdfg.add_array('MultiVectorByScalar_test13_valInput_test13', [6,5], dp.float64)
MultiVectorByScalar_test13_valOutput_test13 = mysdfg.add_array('MultiVectorByScalar_test13_valOutput_test13', [6,5], dp.float64)

map_entry, map_exit = MultiVectorByScalar_test13.add_map('MultiVectorByScalar_test13_map', dict(i0='0:6',i1='0:5'))
MultiVectorByScalar_test13.add_memlet_path(MultiVectorByScalar_test13.add_read('MultiVectorByScalar_test13_valInput_test13'),map_entry, MultiVectorByScalar_test13_tasklet, dst_conn='valInput_test13',memlet=dace.Memlet('MultiVectorByScalar_test13_valInput_test13[i0,i1]'))
MultiVectorByScalar_test13.add_memlet_path(MultiVectorByScalar_test13_tasklet, map_exit, MultiVectorByScalar_test13.add_write('MultiVectorByScalar_test13_valOutput_test13'), src_conn='valOutput_test13',memlet=dace.Memlet('MultiVectorByScalar_test13_valOutput_test13[i0,i1]'))


MultiVectorByScalar_test14 = mysdfg.add_state("MultiVectorByScalar_test14", is_start_state=True)

MultiVectorByScalar_test14_tasklet = MultiVectorByScalar_test14.add_tasklet('MultiVectorByScalar_test14', {'valInput_test14'}, {'valOutput_test14'}, 'valOutput_test14=valInput_test14*3+6')

MultiVectorByScalar_test14_valInput_test14 = mysdfg.add_array('MultiVectorByScalar_test14_valInput_test14', [6,5], dp.float64)
MultiVectorByScalar_test14_valOutput_test14 = mysdfg.add_array('MultiVectorByScalar_test14_valOutput_test14', [6,5], dp.float64)

map_entry, map_exit = MultiVectorByScalar_test14.add_map('MultiVectorByScalar_test14_map', dict(i0='0:6',i1='0:5'))
MultiVectorByScalar_test14.add_memlet_path(MultiVectorByScalar_test14.add_read('MultiVectorByScalar_test14_valInput_test14'),map_entry, MultiVectorByScalar_test14_tasklet, dst_conn='valInput_test14',memlet=dace.Memlet('MultiVectorByScalar_test14_valInput_test14[i0,i1]'))
MultiVectorByScalar_test14.add_memlet_path(MultiVectorByScalar_test14_tasklet, map_exit, MultiVectorByScalar_test14.add_write('MultiVectorByScalar_test14_valOutput_test14'), src_conn='valOutput_test14',memlet=dace.Memlet('MultiVectorByScalar_test14_valOutput_test14[i0,i1]'))


MultiVectorByScalar_test15 = mysdfg.add_state("MultiVectorByScalar_test15", is_start_state=True)

MultiVectorByScalar_test15_tasklet = MultiVectorByScalar_test15.add_tasklet('MultiVectorByScalar_test15', {'valInput_test15'}, {'valOutput_test15'}, 'valOutput_test15=valInput_test15*5+1')

MultiVectorByScalar_test15_valInput_test15 = mysdfg.add_array('MultiVectorByScalar_test15_valInput_test15', [6,5], dp.int64)
MultiVectorByScalar_test15_valOutput_test15 = mysdfg.add_array('MultiVectorByScalar_test15_valOutput_test15', [6,5], dp.int64)

map_entry, map_exit = MultiVectorByScalar_test15.add_map('MultiVectorByScalar_test15_map', dict(i0='0:6',i1='0:5'))
MultiVectorByScalar_test15.add_memlet_path(MultiVectorByScalar_test15.add_read('MultiVectorByScalar_test15_valInput_test15'),map_entry, MultiVectorByScalar_test15_tasklet, dst_conn='valInput_test15',memlet=dace.Memlet('MultiVectorByScalar_test15_valInput_test15[i0,i1]'))
MultiVectorByScalar_test15.add_memlet_path(MultiVectorByScalar_test15_tasklet, map_exit, MultiVectorByScalar_test15.add_write('MultiVectorByScalar_test15_valOutput_test15'), src_conn='valOutput_test15',memlet=dace.Memlet('MultiVectorByScalar_test15_valOutput_test15[i0,i1]'))


MultiVectorByScalar_test16 = mysdfg.add_state("MultiVectorByScalar_test16", is_start_state=True)

MultiVectorByScalar_test16_tasklet = MultiVectorByScalar_test16.add_tasklet('MultiVectorByScalar_test16', {'valInput_test16'}, {'valOutput_test16'}, 'valOutput_test16=valInput_test16*2+3')

MultiVectorByScalar_test16_valInput_test16 = mysdfg.add_array('MultiVectorByScalar_test16_valInput_test16', [6,5], dp.int64)
MultiVectorByScalar_test16_valOutput_test16 = mysdfg.add_array('MultiVectorByScalar_test16_valOutput_test16', [6,5], dp.int64)

map_entry, map_exit = MultiVectorByScalar_test16.add_map('MultiVectorByScalar_test16_map', dict(i0='0:6',i1='0:5'))
MultiVectorByScalar_test16.add_memlet_path(MultiVectorByScalar_test16.add_read('MultiVectorByScalar_test16_valInput_test16'),map_entry, MultiVectorByScalar_test16_tasklet, dst_conn='valInput_test16',memlet=dace.Memlet('MultiVectorByScalar_test16_valInput_test16[i0,i1]'))
MultiVectorByScalar_test16.add_memlet_path(MultiVectorByScalar_test16_tasklet, map_exit, MultiVectorByScalar_test16.add_write('MultiVectorByScalar_test16_valOutput_test16'), src_conn='valOutput_test16',memlet=dace.Memlet('MultiVectorByScalar_test16_valOutput_test16[i0,i1]'))


MultiVectorByScalar_test17 = mysdfg.add_state("MultiVectorByScalar_test17", is_start_state=True)

MultiVectorByScalar_test17_tasklet = MultiVectorByScalar_test17.add_tasklet('MultiVectorByScalar_test17', {'valInput_test17'}, {'valOutput_test17'}, 'valOutput_test17=valInput_test17*2.0+3.0')

MultiVectorByScalar_test17_valInput_test17 = mysdfg.add_array('MultiVectorByScalar_test17_valInput_test17', [2,2], dp.float64)
MultiVectorByScalar_test17_valOutput_test17 = mysdfg.add_array('MultiVectorByScalar_test17_valOutput_test17', [2,2], dp.float64)

map_entry, map_exit = MultiVectorByScalar_test17.add_map('MultiVectorByScalar_test17_map', dict(i0='0:2',i1='0:2'))
MultiVectorByScalar_test17.add_memlet_path(MultiVectorByScalar_test17.add_read('MultiVectorByScalar_test17_valInput_test17'),map_entry, MultiVectorByScalar_test17_tasklet, dst_conn='valInput_test17',memlet=dace.Memlet('MultiVectorByScalar_test17_valInput_test17[i0,i1]'))
MultiVectorByScalar_test17.add_memlet_path(MultiVectorByScalar_test17_tasklet, map_exit, MultiVectorByScalar_test17.add_write('MultiVectorByScalar_test17_valOutput_test17'), src_conn='valOutput_test17',memlet=dace.Memlet('MultiVectorByScalar_test17_valOutput_test17[i0,i1]'))


MultiVectorByScalar_test18 = mysdfg.add_state("MultiVectorByScalar_test18", is_start_state=True)

MultiVectorByScalar_test18_tasklet = MultiVectorByScalar_test18.add_tasklet('MultiVectorByScalar_test18', {'valInput_test18'}, {'valOutput_test18'}, 'valOutput_test18=valInput_test18*3.0+4.0')

MultiVectorByScalar_test18_valInput_test18 = mysdfg.add_array('MultiVectorByScalar_test18_valInput_test18', [2,2], dp.float64)
MultiVectorByScalar_test18_valOutput_test18 = mysdfg.add_array('MultiVectorByScalar_test18_valOutput_test18', [2,2], dp.float64)

map_entry, map_exit = MultiVectorByScalar_test18.add_map('MultiVectorByScalar_test18_map', dict(i0='0:2',i1='0:2'))
MultiVectorByScalar_test18.add_memlet_path(MultiVectorByScalar_test18.add_read('MultiVectorByScalar_test18_valInput_test18'),map_entry, MultiVectorByScalar_test18_tasklet, dst_conn='valInput_test18',memlet=dace.Memlet('MultiVectorByScalar_test18_valInput_test18[i0,i1]'))
MultiVectorByScalar_test18.add_memlet_path(MultiVectorByScalar_test18_tasklet, map_exit, MultiVectorByScalar_test18.add_write('MultiVectorByScalar_test18_valOutput_test18'), src_conn='valOutput_test18',memlet=dace.Memlet('MultiVectorByScalar_test18_valOutput_test18[i0,i1]'))


MultiVectorByScalar_test19 = mysdfg.add_state("MultiVectorByScalar_test19", is_start_state=True)

MultiVectorByScalar_test19_tasklet = MultiVectorByScalar_test19.add_tasklet('MultiVectorByScalar_test19', {'valInput_test19'}, {'valOutput_test19'}, 'valOutput_test19=valInput_test19*2+3')

MultiVectorByScalar_test19_valInput_test19 = mysdfg.add_array('MultiVectorByScalar_test19_valInput_test19', [2,2], dp.int64)
MultiVectorByScalar_test19_valOutput_test19 = mysdfg.add_array('MultiVectorByScalar_test19_valOutput_test19', [2,2], dp.int64)

map_entry, map_exit = MultiVectorByScalar_test19.add_map('MultiVectorByScalar_test19_map', dict(i0='0:2',i1='0:2'))
MultiVectorByScalar_test19.add_memlet_path(MultiVectorByScalar_test19.add_read('MultiVectorByScalar_test19_valInput_test19'),map_entry, MultiVectorByScalar_test19_tasklet, dst_conn='valInput_test19',memlet=dace.Memlet('MultiVectorByScalar_test19_valInput_test19[i0,i1]'))
MultiVectorByScalar_test19.add_memlet_path(MultiVectorByScalar_test19_tasklet, map_exit, MultiVectorByScalar_test19.add_write('MultiVectorByScalar_test19_valOutput_test19'), src_conn='valOutput_test19',memlet=dace.Memlet('MultiVectorByScalar_test19_valOutput_test19[i0,i1]'))


MultiVectorByScalar_test20 = mysdfg.add_state("MultiVectorByScalar_test20", is_start_state=True)

MultiVectorByScalar_test20_tasklet = MultiVectorByScalar_test20.add_tasklet('MultiVectorByScalar_test20', {'valInput_test20'}, {'valOutput_test20'}, 'valOutput_test20=valInput_test20*3+4')

MultiVectorByScalar_test20_valInput_test20 = mysdfg.add_array('MultiVectorByScalar_test20_valInput_test20', [2,2], dp.int64)
MultiVectorByScalar_test20_valOutput_test20 = mysdfg.add_array('MultiVectorByScalar_test20_valOutput_test20', [2,2], dp.int64)

map_entry, map_exit = MultiVectorByScalar_test20.add_map('MultiVectorByScalar_test20_map', dict(i0='0:2',i1='0:2'))
MultiVectorByScalar_test20.add_memlet_path(MultiVectorByScalar_test20.add_read('MultiVectorByScalar_test20_valInput_test20'),map_entry, MultiVectorByScalar_test20_tasklet, dst_conn='valInput_test20',memlet=dace.Memlet('MultiVectorByScalar_test20_valInput_test20[i0,i1]'))
MultiVectorByScalar_test20.add_memlet_path(MultiVectorByScalar_test20_tasklet, map_exit, MultiVectorByScalar_test20.add_write('MultiVectorByScalar_test20_valOutput_test20'), src_conn='valOutput_test20',memlet=dace.Memlet('MultiVectorByScalar_test20_valOutput_test20[i0,i1]'))


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


MultiVectorByScalar_test9 = mysdfg.add_state("MultiVectorByScalar_test9", is_start_state=True)

MultiVectorByScalar_test9_tasklet = MultiVectorByScalar_test9.add_tasklet('MultiVectorByScalar_test9', {'valInput_test9'}, {'valOutput_test9'}, 'valOutput_test9=valInput_test9*2.0+3.0')

MultiVectorByScalar_test9_valInput_test9 = mysdfg.add_array('MultiVectorByScalar_test9_valInput_test9', [5], dp.float64)
MultiVectorByScalar_test9_valOutput_test9 = mysdfg.add_array('MultiVectorByScalar_test9_valOutput_test9', [5], dp.float64)

map_entry, map_exit = MultiVectorByScalar_test9.add_map('MultiVectorByScalar_test9_map', dict(i0='0:5'))
MultiVectorByScalar_test9.add_memlet_path(MultiVectorByScalar_test9.add_read('MultiVectorByScalar_test9_valInput_test9'),map_entry, MultiVectorByScalar_test9_tasklet, dst_conn='valInput_test9',memlet=dace.Memlet('MultiVectorByScalar_test9_valInput_test9[i0]'))
MultiVectorByScalar_test9.add_memlet_path(MultiVectorByScalar_test9_tasklet, map_exit, MultiVectorByScalar_test9.add_write('MultiVectorByScalar_test9_valOutput_test9'), src_conn='valOutput_test9',memlet=dace.Memlet('MultiVectorByScalar_test9_valOutput_test9[i0]'))


mysdfg.add_edge(MultiScalarByScalar_test1, MultiScalarByScalar_test2,dace.InterstateEdge())
mysdfg.add_edge(MultiScalarByScalar_test2, MultiScalarByScalar_test3,dace.InterstateEdge())
mysdfg.add_edge(MultiScalarByScalar_test3, MultiScalarByScalar_test4,dace.InterstateEdge())
mysdfg.add_edge(MultiScalarByScalar_test4, MultiVectorByScalar_test10,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test10, MultiVectorByScalar_test11,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test11, MultiVectorByScalar_test12,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test12, MultiVectorByScalar_test13,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test13, MultiVectorByScalar_test14,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test14, MultiVectorByScalar_test15,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test15, MultiVectorByScalar_test16,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test16, MultiVectorByScalar_test17,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test17, MultiVectorByScalar_test18,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test18, MultiVectorByScalar_test19,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test19, MultiVectorByScalar_test20,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test20, MultiVectorByScalar_test5,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test5, MultiVectorByScalar_test6,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test6, MultiVectorByScalar_test7,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test7, MultiVectorByScalar_test8,dace.InterstateEdge())
mysdfg.add_edge(MultiVectorByScalar_test8, MultiVectorByScalar_test9,dace.InterstateEdge())


mysdfg(MultiScalarByScalar_test1_valOutput_test1=valOutput_test1, MultiScalarByScalar_test1_valInput_test1=valInput_test1, 
MultiScalarByScalar_test2_valOutput_test2=valOutput_test2, MultiScalarByScalar_test2_valInput_test2=valInput_test2, 
MultiScalarByScalar_test3_valOutput_test3=valOutput_test3, MultiScalarByScalar_test3_valInput_test3=valInput_test3, 
MultiScalarByScalar_test4_valOutput_test4=valOutput_test4, MultiScalarByScalar_test4_valInput_test4=valInput_test4, 
MultiVectorByScalar_test10_valOutput_test10=valOutput_test10, MultiVectorByScalar_test10_valInput_test10=valInput_test10, 
MultiVectorByScalar_test11_valOutput_test11=valOutput_test11, MultiVectorByScalar_test11_valInput_test11=valInput_test11, 
MultiVectorByScalar_test12_valOutput_test12=valOutput_test12, MultiVectorByScalar_test12_valInput_test12=valInput_test12, 
MultiVectorByScalar_test13_valOutput_test13=valOutput_test13, MultiVectorByScalar_test13_valInput_test13=valInput_test13, 
MultiVectorByScalar_test14_valOutput_test14=valOutput_test14, MultiVectorByScalar_test14_valInput_test14=valInput_test14, 
MultiVectorByScalar_test15_valOutput_test15=valOutput_test15, MultiVectorByScalar_test15_valInput_test15=valInput_test15, 
MultiVectorByScalar_test16_valOutput_test16=valOutput_test16, MultiVectorByScalar_test16_valInput_test16=valInput_test16, 
MultiVectorByScalar_test17_valOutput_test17=valOutput_test17, MultiVectorByScalar_test17_valInput_test17=valInput_test17, 
MultiVectorByScalar_test18_valOutput_test18=valOutput_test18, MultiVectorByScalar_test18_valInput_test18=valInput_test18, 
MultiVectorByScalar_test19_valOutput_test19=valOutput_test19, MultiVectorByScalar_test19_valInput_test19=valInput_test19, 
MultiVectorByScalar_test20_valOutput_test20=valOutput_test20, MultiVectorByScalar_test20_valInput_test20=valInput_test20, 
MultiVectorByScalar_test5_valOutput_test5=valOutput_test5, MultiVectorByScalar_test5_valInput_test5=valInput_test5, 
MultiVectorByScalar_test6_valOutput_test6=valOutput_test6, MultiVectorByScalar_test6_valInput_test6=valInput_test6, 
MultiVectorByScalar_test7_valOutput_test7=valOutput_test7, MultiVectorByScalar_test7_valInput_test7=valInput_test7, 
MultiVectorByScalar_test8_valOutput_test8=valOutput_test8, MultiVectorByScalar_test8_valInput_test8=valInput_test8, 
MultiVectorByScalar_test9_valOutput_test9=valOutput_test9, MultiVectorByScalar_test9_valInput_test9=valInput_test9)

mysdfg.view('VariableAffectations')
