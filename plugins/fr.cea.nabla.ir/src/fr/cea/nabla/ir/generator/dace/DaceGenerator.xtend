/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.UnzipHelper
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.IrCodeGenerator
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Variable

class DaceGenerator implements IrCodeGenerator
{
	new(String wsPath)
	{
		// unzip NRepository if necessary
		UnzipHelper::unzipNRepository(wsPath)
	}

	override getName() { "DaCe" }

	override getIrTransformationSteps() { #[] }

	// Only one file generated corresponding to the application
	override getGenerationContents(IrRoot ir)
	{
		#[new GenerationContent(ir.name + '.py', ir.fileContent, false)]
	}

	override getGenerationContents(DefaultExtensionProvider provider)
	{
		throw new RuntimeException("Not yet implemented")
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

		«FOR i : 0..<ir.main.calls.sortBy[j | j.at].length - 1»
			mysdfg.add_edge(«ir.main.calls.get(i).name», «ir.main.calls.get(i+1).name»,dace.InterstateEdge())
		«ENDFOR»

«««		mysdfg.add_edge(«FOR j : ir.main.calls SEPARATOR ','»«j.name»«ENDFOR», dace.InterstateEdge())

		mysdfg(«FOR j : ir.main.calls  SEPARATOR ', \n'»«FOR v : getUsedVariablesJobs(j.instruction) SEPARATOR ', '»«j.name»_«v.name»=«v.name»«ENDFOR»«ENDFOR»)

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