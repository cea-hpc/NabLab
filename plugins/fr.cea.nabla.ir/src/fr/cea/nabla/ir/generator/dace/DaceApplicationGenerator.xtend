package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.generator.ApplicationGenerator
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.Variable

import fr.cea.nabla.ir.ir.Instruction

class DaceApplicationGenerator implements ApplicationGenerator
{
	override getName() { 'DaCe' }

	override getIrTransformationStep() { null }
	// Only one file generated corresponding to the application
	override getGenerationContents(IrRoot ir)
	{
		#[new GenerationContent(ir.name + '.py', ir.fileContent, false)]
	}

	private def getFileContent(IrRoot ir)
	'''
		import numpy as np
		import dace as dp

		from dace.sdfg import SDFG
		from dace.memlet import Memlet
		from dace.sdfg.validation import validate, validate_sdfg

		# Importing these outside creates an import loop
		from dace.codegen import codegen, compiler
		from dace.codegen.compiled_sdfg import CompiledSDFG
		import dace.config

		«FOR v : getUsedVariables(ir)»
			«DefinitionContentProvider.getDefinitionContent(v, v.name)»
			
		«ENDFOR»

		mysdfg = SDFG('«ir.name»')

		«FOR j : ir.main.calls»

			«StateContentProvider.getContent(j.instruction, j.name)»
		«ENDFOR»

		mysdfg.add_edge(«FOR j : ir.main.calls SEPARATOR ','»«j.name»«ENDFOR», dace.InterstateEdge())

		
		mysdfg(«FOR j : ir.main.calls  SEPARATOR ','»«FOR v : getUsedVariablesJobs(j.instruction) SEPARATOR ','»«j.name»_«v.name»=«v.name»«ENDFOR»«ENDFOR»)
		
		mysdfg.view('«ir.name»')
	'''

		private def getUsedVariables(IrRoot ir)
		{
			ir.eAllContents.filter(ArgOrVarRef).map[target].filter(Variable).toIterable
		}
		
		private def getUsedVariablesJobs(Instruction i)
		{
			i.eAllContents.filter(ArgOrVarRef).map[target].filter(Variable).toIterable
		}
}