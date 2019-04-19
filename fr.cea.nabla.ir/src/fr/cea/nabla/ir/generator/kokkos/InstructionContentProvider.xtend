/*******************************************************************************
	private def getJavaName(ReductionCall it) '''«reduction.provider»Functions.«reduction.name»'''
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
import fr.cea.nabla.ir.generator.IndexHelper.Index
import fr.cea.nabla.ir.generator.IndexHelper.IndexFactory
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionCall
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.ScalarVarDefinition
import java.util.List

abstract class InstructionContentProvider 
{
	@Inject extension Utils
	@Inject extension Ir2KokkosUtils
	@Inject extension ExpressionContentProvider
	@Inject extension VariableExtensions
	@Inject extension IndexHelper

	protected def idToIndex(Index i, String idName) { idToIndex(i, idName, '::') }	
	protected abstract def CharSequence addParallelLoop(Iterator it, Loop l)

	def dispatch getInnerContent(Instruction it) { content }
	def dispatch getInnerContent(InstructionBlock it)
	'''
		«FOR i : instructions»
		«i.content»
		«ENDFOR»
	'''

	/**
	 * Les réductions à l'intérieur des boucles ont été remplacées dans l'IR par des boucles.
	 * Ne restent que les réductions au niveau des jobs => reduction //
	 */
	def dispatch CharSequence getContent(ReductionInstruction it) 
	'''
		«val iter = reduction.iterator»
		«val itIndex = IndexFactory::createIndex(iter)»
		«IF !iter.call.connectivity.indexEqualId»int[] «itIndex.containerName» = «iter.call.accessor»;«ENDIF»
		«variable.kokkosType» «variable.name» = «variable.defaultValue.content»;
		Kokkos::«reduction.kokkosName»<«variable.kokkosType»> reducer(«variable.name»);
		Kokkos::parallel_reduce("Reduction«variable.name»", «iter.call.connectivity.nbElems», KOKKOS_LAMBDA(const int& «itIndex.label», «variable.kokkosType»& x)
		{
			reducer.join(x, «reduction.arg.content»);
		}, reducer);
	'''

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
	
	private def addSequentialLoop(Iterator it, Loop l)
	'''
		«val itIndex = IndexFactory::createIndex(it)»
		const auto& «itIndex.containerName»(«call.accessor»);
		for (int «itIndex.label»=0; «itIndex.label»<«itIndex.containerName».size(); «itIndex.label»++)
		{
			«IF needPrev(l)»int «prev(itIndex.label)» = («itIndex.label»-1+«itIndex.containerName».size())%«itIndex.containerName».size();«ENDIF»
			«IF needNext(l)»int «next(itIndex.label)» = («itIndex.label»+1+«itIndex.containerName».size())%«itIndex.containerName».size();«ENDIF»
			«IF needIdFor(l)»
				«val idName = name + 'Id'»
				int «idName» = «indexToId(itIndex)»;
				«l.dependantIterators.dependantIteratorsContent»
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
	
	def idToIndexArray(Index it)
	'''auto «containerName» = mesh->get«connectivity.name.toFirstUpper()»(«connectivityArgIterator»Id);'''
	
	private def getKokkosName(ReductionCall it) '''«reduction.name.replaceFirst("reduce", "")»'''

	private def getDependantIteratorsContent(List<Iterator> iterators)
	'''
	«FOR i : iterators»
	int «i.name»Id = «i.call.accessor»;
	«ENDFOR»
	'''
}