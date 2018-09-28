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
package fr.cea.nabla.ir.generator.kokkos

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.IndexHelper
import fr.cea.nabla.ir.generator.IndexHelper.IndexFactory
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.ScalarVarDefinition

class InstructionContentProvider 
{
	@Inject extension Utils
	@Inject extension Ir2KokkosUtils
	@Inject extension ExpressionContentProvider
	@Inject extension VariableExtensions
	@Inject extension IndexHelper

	def dispatch getInnerContent(Instruction it) { content }
	def dispatch getInnerContent(InstructionBlock it)
	'''
		«FOR i : instructions»
		«i.content»
		«ENDFOR»
	'''

	def dispatch CharSequence getContent(ReductionInstruction it) 
	{
		throw new Exception('Les instances de ReductionInstruction doivent être supprimées avant de générer le C++ Kokkos')
	}

	def dispatch CharSequence getContent(ScalarVarDefinition it) 
	'''
		«FOR v : variables»
		«v.kokkosType» «v.name»«IF v.defaultValue !== null» = «v.defaultValue.content»«ENDIF»;
		«ENDFOR»
	'''
	
	def dispatch CharSequence getContent(InstructionBlock it) 
	'''
		{
			«FOR i : instructions»
			«i.content»
			«ENDFOR»
		}'''
	
	def dispatch CharSequence getContent(Affectation it) 
	'''«left.content» «operator» «right.content»;'''

	def dispatch CharSequence getContent(Loop it) 
	{
		if (isTopLevelLoop(it)) 
			iterator.addParallelLoop(it)
		else
			iterator.addSequentialLoop(it)
	}
	
	def dispatch CharSequence getContent(If it) 
	'''
		if («condition.content») 
		«IF !(thenInstruction instanceof InstructionBlock)»	«ENDIF»«thenInstruction.content»
		«IF (elseInstruction !== null)»
		else 
		«IF !(elseInstruction instanceof InstructionBlock)»	«ENDIF»«elseInstruction.content»
		«ENDIF»
	'''
	
	private def addParallelLoop(Iterator it, Loop l)
	'''
		«val itIndex = IndexFactory::createIndex(it)»
		«IF !range.connectivity.indexEqualId»int[] «itIndex.containerName» = «range.accessor»;«ENDIF»
		Kokkos::parallel_for(«range.connectivity.nbElems», KOKKOS_LAMBDA(const int «itIndex.label»)
		{
			«IF needIdFor(l)»int «name»Id = «indexToId(itIndex)»;«ENDIF»
			«FOR index : getRequiredIndexes(l)»
			int «index.label» = «idToIndex(index, name+'Id')»;
			«ENDFOR»
			«l.body.innerContent»
		});
	'''

	private def addSequentialLoop(Iterator it, Loop l)
	'''
		«val itIndex = IndexFactory::createIndex(it)»
		auto «itIndex.containerName» = «range.accessor»;
		for (int «itIndex.label»=0; «itIndex.label»<«itIndex.containerName».size(); «itIndex.label»++)
		{
			«IF needPrev(l)»int «prev(itIndex.label)» = («itIndex.label»-1+«itIndex.containerName».size())%«itIndex.containerName».size();«ENDIF»
			«IF needNext(l)»int «next(itIndex.label)» = («itIndex.label»+1+«itIndex.containerName».size())%«itIndex.containerName».size();«ENDIF»
			«IF needIdFor(l)»
				«val idName = name + 'Id'»
				int «idName» = «indexToId(itIndex)»;
				«IF needPrev(l)»int «prev(idName)» = «indexToId(itIndex, 'prev')»;«ENDIF»
				«IF needNext(l)»int «next(idName)» = «indexToId(itIndex, 'next')»;«ENDIF»
				«FOR index : getRequiredIndexes(l)»
					«val cIdName = index.iterator.name + 'Id'»
					«IF !(index.connectivity.indexEqualId)»«index.idToIndexArray»«ENDIF»
					int «index.label» = «idToIndex(index, cIdName)»;
					«IF needPrev(l)»int «prev(index.label)» = «idToIndex(index, prev(cIdName))»;«ENDIF»
					«IF needNext(l)»int «next(index.label)» = «idToIndex(index, next(cIdName))»;«ENDIF»
				«ENDFOR»
			«ENDIF»
			«l.body.innerContent»
		}
	'''
}