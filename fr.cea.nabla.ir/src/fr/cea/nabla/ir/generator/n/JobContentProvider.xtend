/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator.n

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ScalarVariable
import fr.cea.nabla.ir.ir.TimeIterationCopyJob
import fr.cea.nabla.ir.transformers.ReplaceExternalReductions

class JobContentProvider 
{
	@Inject extension Ir2NUtils
	@Inject extension InstructionContentProvider
	
	def dispatch CharSequence getContent(InstructionJob it)
	{
		val i = instruction
		switch i
		{
			Loop: 
				if (i.reduction) '''«i.iterator.content» «(i.body as Affectation).reductionContent» @ «at»;'''
				else getInnerJobContent(i.body, '''«i.iterator.content» «header»@ «at» ''')
			default: getInnerJobContent(i, '''«header»@ «at» ''')
		}
	}

	def dispatch CharSequence getContent(TimeIterationCopyJob it)
	'''
		«left.loopHeader» «header»@ «at» { 
			«left.getName» = «right.getName»;
		}
	'''

	private def getHeader(Job it)
	'''«IF !name.nullOrEmpty»«name» «ENDIF»'''
	
	private def dispatch getInnerJobContent(Instruction i, CharSequence header)
	'''
		«header»{
			«i.content»
		}
	'''

	private def dispatch getInnerJobContent(InstructionBlock i, CharSequence header)
	'''
		«header»«i.content»
	'''
	
	private def dispatch getLoopHeader(ScalarVariable v) ''''''
	private def dispatch getLoopHeader(ArrayVariable v) { v.dimensions.map[d | '''∀ «d.returnType.type.literal»s'''].join(' ') }

	private def isReduction(Loop it) 
	{ 
		body instanceof Affectation && 
		ReplaceExternalReductions::ReductionOperators.values.contains((body as Affectation).operator)
	}
}