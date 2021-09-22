import numpy as np
import dace as dp

from dace.sdfg import SDFG
from dace.memlet import Memlet
from dace.sdfg.validation import validate, validate_sdfg

# Importing these outside creates an import loop
from dace.codegen import codegen, compiler
from dace.codegen.compiled_sdfg import CompiledSDFG
import dace.config

valOutput = dp.np.(dp.int64)
valInput = dp.np.(dp.int64)
valInput = 4

mysdfg = SDFG('MultScalarByScalar')


AddJob = mysdfg.add_state("AddJob", is_start_state=True)

AddJob_tasklet = AddJob.add_tasklet('AddJob', {'valInput'}, {'valOutput'}, 'valOutput=valInput*25+1')

AddJob_valInput = mysdfg.add_array('AddJob_valInput', dp.int64)
AddJob_valOutput = mysdfg.add_array('AddJob_valOutput', dp.int64)

map_entry, map_exit = AddJob.add_map('AddJob_map', dict())
AddJob.add_memlet_path(AddJob.add_read('AddJob_valInput'),map_entry, AddJob_tasklet, dst_conn='valInput',memlet=dace.Memlet('AddJob_valInput[]'))
AddJob.add_memlet_path(AddJob_tasklet, map_exit, AddJob.add_write('AddJob_valOutput'), src_conn='valOutput',memlet=dace.Memlet('AddJob_valOutput[]'))



mysdfg(AddJob_valInput=valInput,AddJob_valOutput=valOutput)


mysdfg.view('MultScalarByScalar.html')
