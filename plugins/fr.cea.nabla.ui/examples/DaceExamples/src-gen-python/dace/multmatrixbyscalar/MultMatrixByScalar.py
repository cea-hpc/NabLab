import numpy as np
import dace as dp

from dace.sdfg import SDFG
from dace.memlet import Memlet
from dace.sdfg.validation import validate, validate_sdfg

# Importing these outside creates an import loop
from dace.codegen import codegen, compiler
from dace.codegen.compiled_sdfg import CompiledSDFG
import dace.config

b = [[0.0] * 2 for _ in range(6)]
b = np.array(b )
b.astype(np.float64)
a = [[5.0] * 2 for _ in range(6)]
a = np.array(a )
a.astype(np.float64)

mysdfg = SDFG('MultMatrixByScalar')


AddJob = mysdfg.add_state("AddJob", is_start_state=True)

AddJob_tasklet = AddJob.add_tasklet('AddJob', {'a'}, {'b'}, 'b=a*25.0+1.0')

AddJob_a = mysdfg.add_array('AddJob_a', [6,2], dp.float64)
AddJob_b = mysdfg.add_array('AddJob_b', [6,2], dp.float64)

map_entry, map_exit = AddJob.add_map('AddJob_map', dict(i0='0:6',i1='0:2'))
AddJob.add_memlet_path(AddJob.add_read('AddJob_a'),map_entry, AddJob_tasklet, dst_conn='a',memlet=dace.Memlet('AddJob_a[i0,i1]'))
AddJob.add_memlet_path(AddJob_tasklet, map_exit, AddJob.add_write('AddJob_b'), src_conn='b',memlet=dace.Memlet('AddJob_b[i0,i1]'))



mysdfg(AddJob_a=a,AddJob_b=b)
print('Valeur de b ', b)

mysdfg.view('MultMatrixByScalar')
