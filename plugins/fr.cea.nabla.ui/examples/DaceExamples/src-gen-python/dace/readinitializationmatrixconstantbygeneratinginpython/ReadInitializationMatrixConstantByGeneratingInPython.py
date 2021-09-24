import numpy as np
import dace as dp

from dace.sdfg import SDFG
from dace.memlet import Memlet
from dace.sdfg.validation import validate, validate_sdfg

# Importing these outside creates an import loop
from dace.codegen import codegen, compiler
from dace.codegen.compiled_sdfg import CompiledSDFG
import dace.config

matrix1 = [[1.0, 2.0 ], [4.0, 5.0 ] ]
matrix1 = np.array(matrix1 )
matrix1.astype(np.float64)
matrix2 = [[15.0, 12.0 ], [7.0, 8.0 ] ]
matrix2 = np.array(matrix2 )
matrix2.astype(np.float64)

mysdfg = SDFG('ReadInitializationMatrixConstantByGeneratingInPython')


AddJob = mysdfg.add_state("AddJob", is_start_state=True)

AddJob_tasklet = AddJob.add_tasklet('AddJob', {'matrix2'}, {'matrix1'}, 'matrix1=matrix2*3.0')

AddJob_matrix2 = mysdfg.add_array('AddJob_matrix2', [2,2], dp.float64)
AddJob_matrix1 = mysdfg.add_array('AddJob_matrix1', [2,2], dp.float64)

map_entry, map_exit = AddJob.add_map('AddJob_map', dict(i0='0:2',i1='0:2'))
AddJob.add_memlet_path(AddJob.add_read('AddJob_matrix2'),map_entry, AddJob_tasklet, dst_conn='matrix2',memlet=dace.Memlet('AddJob_matrix2[i0,i1]'))
AddJob.add_memlet_path(AddJob_tasklet, map_exit, AddJob.add_write('AddJob_matrix1'), src_conn='matrix1',memlet=dace.Memlet('AddJob_matrix1[i0,i1]'))



mysdfg(AddJob_matrix2=matrix2,AddJob_matrix1=matrix1)

print(matrix1)
mysdfg.view('ReadInitializationMatrixConstantByGeneratingInPython')
