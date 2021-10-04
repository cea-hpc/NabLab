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

valOutput_test2 = np.full((1), 0.0)
valOutput_test2 = np.array(valOutput_test2)
valOutput_test2.astype(np.float64)

valInput_test2 = 4.0
valInput_test2 = [valInput_test2]
valInput_test2 = np.array(valInput_test2)
valInput_test2.astype(np.float64)

valOutput_test3 = 0
valOutput_test3 = [valOutput_test3]
valOutput_test3 = np.array(valOutput_test3)
valOutput_test3.astype(np.int64)

valInput_test3 = 4
valInput_test3 = [valInput_test3]
valInput_test3 = np.array(valInput_test3)
valInput_test3.astype(np.int64)


mysdfg = SDFG('VariableDefinition')


MultiScalarByScalar_test1 = mysdfg.add_state("MultiScalarByScalar_test1", is_start_state=True)

MultiScalarByScalar_test1_tasklet = MultiScalarByScalar_test1.add_tasklet('MultiScalarByScalar_test1', {'valInput_test1'}, {'valOutput_test1'}, 'valOutput_test1=valInput_test1*3')

MultiScalarByScalar_test1_valInput_test1 = mysdfg.add_array('MultiScalarByScalar_test1_valInput_test1', [1], dp.int64)
MultiScalarByScalar_test1_valOutput_test1 = mysdfg.add_array('MultiScalarByScalar_test1_valOutput_test1', [1], dp.int64)

map_entry, map_exit = MultiScalarByScalar_test1.add_map('MultiScalarByScalar_test1_map', dict(i='0:1'))
MultiScalarByScalar_test1.add_memlet_path(MultiScalarByScalar_test1.add_read('MultiScalarByScalar_test1_valInput_test1'),map_entry, MultiScalarByScalar_test1_tasklet, dst_conn='valInput_test1',memlet=dace.Memlet.simple('MultiScalarByScalar_test1_valInput_test1','i'))
MultiScalarByScalar_test1.add_memlet_path(MultiScalarByScalar_test1_tasklet, map_exit, MultiScalarByScalar_test1.add_write('MultiScalarByScalar_test1_valOutput_test1'), src_conn='valOutput_test1',memlet=dace.Memlet.simple('MultiScalarByScalar_test1_valOutput_test1','i'))


MultiScalarByScalar_test2 = mysdfg.add_state("MultiScalarByScalar_test2", is_start_state=True)

MultiScalarByScalar_test2_tasklet = MultiScalarByScalar_test2.add_tasklet('MultiScalarByScalar_test2', {'valInput_test2'}, {'valOutput_test2'}, 'valOutput_test2=valInput_test2*3.0')

MultiScalarByScalar_test2_valInput_test2 = mysdfg.add_array('MultiScalarByScalar_test2_valInput_test2', [1], dp.float64)
MultiScalarByScalar_test2_valOutput_test2 = mysdfg.add_array('MultiScalarByScalar_test2_valOutput_test2', [1], dp.float64)

map_entry, map_exit = MultiScalarByScalar_test2.add_map('MultiScalarByScalar_test2_map', dict(i='0:1'))
MultiScalarByScalar_test2.add_memlet_path(MultiScalarByScalar_test2.add_read('MultiScalarByScalar_test2_valInput_test2'),map_entry, MultiScalarByScalar_test2_tasklet, dst_conn='valInput_test2',memlet=dace.Memlet.simple('MultiScalarByScalar_test2_valInput_test2','i'))
MultiScalarByScalar_test2.add_memlet_path(MultiScalarByScalar_test2_tasklet, map_exit, MultiScalarByScalar_test2.add_write('MultiScalarByScalar_test2_valOutput_test2'), src_conn='valOutput_test2',memlet=dace.Memlet.simple('MultiScalarByScalar_test2_valOutput_test2','i'))


MultiScalarByScalar_test3 = mysdfg.add_state("MultiScalarByScalar_test3", is_start_state=True)

MultiScalarByScalar_test3_tasklet = MultiScalarByScalar_test3.add_tasklet('MultiScalarByScalar_test3', {'valInput_test3'}, {'valOutput_test3'}, 'valOutput_test3=valInput_test3*5')

MultiScalarByScalar_test3_valInput_test3 = mysdfg.add_array('MultiScalarByScalar_test3_valInput_test3', [1], dp.int64)
MultiScalarByScalar_test3_valOutput_test3 = mysdfg.add_array('MultiScalarByScalar_test3_valOutput_test3', [1], dp.int64)

map_entry, map_exit = MultiScalarByScalar_test3.add_map('MultiScalarByScalar_test3_map', dict(i='0:1'))
MultiScalarByScalar_test3.add_memlet_path(MultiScalarByScalar_test3.add_read('MultiScalarByScalar_test3_valInput_test3'),map_entry, MultiScalarByScalar_test3_tasklet, dst_conn='valInput_test3',memlet=dace.Memlet.simple('MultiScalarByScalar_test3_valInput_test3','i'))
MultiScalarByScalar_test3.add_memlet_path(MultiScalarByScalar_test3_tasklet, map_exit, MultiScalarByScalar_test3.add_write('MultiScalarByScalar_test3_valOutput_test3'), src_conn='valOutput_test3',memlet=dace.Memlet.simple('MultiScalarByScalar_test3_valOutput_test3','i'))


mysdfg.add_edge(MultiScalarByScalar_test1, MultiScalarByScalar_test2,dace.InterstateEdge())
mysdfg.add_edge(MultiScalarByScalar_test2, MultiScalarByScalar_test3,dace.InterstateEdge())


mysdfg(MultiScalarByScalar_test1_valOutput_test1=valOutput_test1,MultiScalarByScalar_test1_valInput_test1=valInput_test1,MultiScalarByScalar_test2_valOutput_test2=valOutput_test2,MultiScalarByScalar_test2_valInput_test2=valInput_test2,MultiScalarByScalar_test3_valOutput_test3=valOutput_test3,MultiScalarByScalar_test3_valInput_test3=valInput_test3)

mysdfg.view('VariableDefinition')
