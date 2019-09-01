/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.VarDefinition
import fr.cea.nabla.ir.ir.VarRefIteratorRef

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.kokkos.VariableExtensions.*

abstract class InstructionContentProvider 
{
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
		«IF !range.container.connectivity.indexEqualId»int[] «range.containerName»(«range.accessor»);«ENDIF»
		«result.cppType» «result.name»(«result.defaultValue.content»);
		{
			Kokkos::«reduction.kokkosName»<«result.cppType»> reducer(«result.name»);
			«header»
			{
				«defineIndices»
				«FOR innerReduction : innerReductions»
				«innerReduction.content»
				«ENDFOR»
				reducer.join(x, «arg.content»);
			}, reducer);
		}
	'''

	protected abstract def CharSequence getHeader(ReductionInstruction it)

	def dispatch CharSequence getContent(VarDefinition it) 
	'''
		«FOR v : variables»
		«IF v.const»const «ENDIF»«v.varContent»
		«ENDFOR»
	'''
	
	private def dispatch getVarContent(SimpleVariable it)
	'''«cppType» «name»«IF defaultValue !== null» = «defaultValue.content»«ENDIF»;'''
	
	private def dispatch getVarContent(ConnectivityVariable it)
	'''«cppType» «name»«IF defaultValue !== null» = «defaultValue.content»«ENDIF»;'''

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
		if (topLevelLoop) 
			if (multithreadable)
				parallelContent
			else
				topLevelSequentialContent
		else 
			sequentialContent
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
	
	protected abstract def CharSequence getParallelContent(Loop it)

	private def getTopLevelSequentialContent(Loop it)
	'''
		for (int «range.indexName»=0; «range.indexName»<«range.container.connectivity.nbElems»; «range.indexName»++)
		{
			«defineIndices»
			«body.innerContent»
		}
	'''

	private def getSequentialContent(Loop it)
	'''
		{
			auto «range.containerName»(«range.accessor»);
			for (int «range.indexName»=0; «range.indexName»<«range.containerName».size(); «range.indexName»++)
			{
				«defineIndices»
				«body.innerContent»
			}
		}
	'''
	
	/** Define all needed ids and indexes at the beginning of an iteration, ie Loop or ReductionInstruction  */
	protected def defineIndices(IterableInstruction it)
	'''
		«FOR neededId : range.neededIds»
			int «neededId.id»(«neededId.indexToId»);
		«ENDFOR»
		«FOR neededIndex : range.indicesToDefined»
			int «neededIndex.indexName»(«neededIndex.idToIndex»);
		«ENDFOR»
		«FOR singleton : singletons»
			int «singleton.id»(«singleton.accessor»);
			«FOR neededIndex : singleton.indicesToDefined»
				int «neededIndex.indexName»(«neededIndex.idToIndex»);
			«ENDFOR»
		«ENDFOR»
	'''
	
	private	def getIndexToId(IteratorRef it)
	{
		if (target.container.connectivity.indexEqualId || target.singleton) indexValue
		else target.containerName + '[' + indexValue + ']'		
	}
	
	private def getIdToIndex(VarRefIteratorRef it)
	{
		if (indexEqualId) id
		else 'utils::indexOf(' + accessor + ',' + id + ')'
	}

	def getAccessor(VarRefIteratorRef it) '''mesh->get«connectivity.name.toFirstUpper»(«connectivityArgs.map[id].join(', ')»)'''
	def getAccessor(Iterator it)  '''mesh->get«container.connectivity.name.toFirstUpper»(«container.args.map[id].join(', ')»)'''

	private def getKokkosName(Reduction it) '''«name.replaceFirst("reduce", "")»'''
	
	/**
	 * No multithread loop if there is a SparseMatrix affectation because it is not thread safe.
	 * No std::mutex use when threads are Kokkos threads.
	 */
	private def isMultithreadable(Loop it)
	{
		val affectations = eAllContents.filter(Affectation)
		for (a : affectations.toIterable)
			if (a.left.variable.cppType == MatrixType)
				return false
		return true
	}
}