/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IntervalIterationBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.SpaceIterationBlock
import fr.cea.nabla.ir.ir.VarDefinition
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.SizeTypeContentProvider.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.kokkos.ExpressionContentProvider.*

abstract class InstructionContentProvider 
{
	def dispatch CharSequence getContent(VarDefinition it) 
	'''
		«FOR v : variables»
		«IF v.const»const «ENDIF»«v.cppType» «v.name»«v.defaultValueContent»
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
	'''«left.content» = «right.content»;'''

	def dispatch CharSequence getContent(ReductionInstruction it)
	{
		getContent(it, iterationBlock)
	} 

	def dispatch CharSequence getContent(Loop it) 
	{
		if (topLevelLoop) 
			if (multithreadable)
				getParallelContent(it, jobName)
			else
				getTopLevelSequentialContent(iterationBlock, it)
		else 
			getSequentialContent(iterationBlock, it)
	}

	def dispatch CharSequence getContent(If it) 
	'''
		if («condition.content») 
		«val thenContent = thenInstruction.content»
		«IF !(thenContent.charAt(0) == '{'.charAt(0))»	«ENDIF»«thenContent»
		«IF (elseInstruction !== null)»
			«val elseContent = elseInstruction.content»
			else
			«IF !(elseContent.charAt(0) == '{'.charAt(0))»	«ENDIF»«elseContent»
		«ENDIF»
	'''

	def dispatch CharSequence getContent(Return it) 
	'''
		return «expression.content»;
	'''

	def dispatch getInnerContent(Instruction it) 
	{ 
		content
	}

	def dispatch getInnerContent(InstructionBlock it)
	'''
		«FOR i : instructions»
		«i.content»
		«ENDFOR»
	'''

	protected abstract def CharSequence getParallelContent(Loop l, String kokkosName)
	protected abstract def CharSequence getHeader(ReductionInstruction it, String nbElems, String indexName)

	private def dispatch CharSequence getContent(ReductionInstruction it, SpaceIterationBlock b) 
	'''
		«IF !b.range.container.connectivity.indexEqualId»int[] «b.range.containerName»(«b.range.accessor»);«ENDIF»
		«result.cppType» «result.name»(«result.defaultValue.content»);
		{
			Kokkos::«reduction.kokkosName»<«result.cppType»> reducer(«result.name»);
			«getHeader(it, b.range.container.connectivity.nbElems, b.range.indexName)»
			{
				«b.defineIndices»
				«FOR innerReduction : innerReductions»
				«innerReduction.content»
				«ENDFOR»
				reducer.join(x, «arg.content»);
			}, reducer);
		}
	'''

	private def dispatch CharSequence getContent(ReductionInstruction it, IntervalIterationBlock b) 
	'''
		{
			const int from = «b.from.content»;
			const int to = «b.to.content»«IF b.toIncluded»+1«ENDIF»;
			const int nbElems = from-to;
			«result.cppType» «result.name»(«result.defaultValue.content»);
			{
				Kokkos::«reduction.kokkosName»<«result.cppType»> reducer(«result.name»);
				«getHeader(it, "nbElems", b.index.name)»
				{
					«FOR innerReduction : innerReductions»
					«innerReduction.content»
					«ENDFOR»
					reducer.join(x, «arg.content»);
				}, reducer);
			}
		}
	'''

	private def dispatch getTopLevelSequentialContent(SpaceIterationBlock it, Loop l)
	'''
		for (size_t «range.indexName»=0; «range.indexName»<«range.container.connectivity.nbElems»; «range.indexName»++)
		{
			«defineIndices»
			«l.body.innerContent»
		}
	'''

	private def dispatch getTopLevelSequentialContent(IntervalIterationBlock it, Loop l)
	'''
		for (size_t «index.name»=«from.content»; «index.name»<«IF toIncluded»=«ENDIF»«to.content»; «index.name»++)
			«l.body.innerContent»
	'''

	private def dispatch getSequentialContent(SpaceIterationBlock it, Loop l)
	'''
		{
			auto «range.containerName»(«range.accessor»);
			for (size_t «range.indexName»=0; «range.indexName»<«range.containerName».size(); «range.indexName»++)
			{
				«defineIndices»
				«l.body.innerContent»
			}
		}
	'''

	private def dispatch getSequentialContent(IntervalIterationBlock it, Loop l)
	{
		getTopLevelSequentialContent(it, l)
	}

	/** Define all needed ids and indexes at the beginning of an iteration, ie Loop or ReductionInstruction  */
	protected def defineIndices(SpaceIterationBlock it)
	'''
		«range.defineIndices»
		«FOR s : singletons»
			int «s.indexName»(«s.accessor»);
			«s.defineIndices»
		«ENDFOR»
	'''

	private def defineIndices(Iterator it)
	'''
		«FOR neededId : neededIds»
			int «neededId.idName»(«neededId.indexToId»);
		«ENDFOR»
		«FOR neededIndex : neededIndices»
			int «neededIndex.indexName»(«neededIndex.idToIndex»);
		«ENDFOR»
	'''

	private def getKokkosName(Reduction it)
	{
		switch name
		{
			case '+' : 'Sum'
			case '*' : 'Prod'
			default : name.toFirstUpper
		}
	}
	
	/**
	 * No multithread loop if there is a SparseMatrix affectation because it is not thread safe.
	 * No std::mutex use when threads are Kokkos threads.
	 */
	private def isMultithreadable(Loop it)
	{
		val affectations = eAllContents.filter(Affectation)
		for (a : affectations.toIterable)
			if (a.left.target.cppType == MatrixType)
				return false
		return true
	}

	private	def getIndexToId(IteratorRef it)
	{
		if (target.container.connectivity.indexEqualId || target.singleton) indexValue
		else target.containerName + '[' + indexValue + ']'		
	}
	
	private def getIdToIndex(ArgOrVarRefIteratorRef it)
	{
		if (varContainer.indexEqualId) idName
		else 'utils::indexOf(' + accessor + ',' + idName + ')'
	}

	private def dispatch getDefaultValueContent(SimpleVariable it)
	'''«IF defaultValue !== null» = «defaultValue.content»«ENDIF»;'''
	
	private def dispatch getDefaultValueContent(ConnectivityVariable it)
	'''«IF defaultValue !== null» = «defaultValue.content»«ENDIF»;'''

	protected def getAccessor(ArgOrVarRefIteratorRef it) { getAccessor(varContainer, varArgs) }
	protected def getAccessor(Iterator it)  { getAccessor(container.connectivity, container.args) }
	private def getAccessor(Connectivity c, Iterable<? extends IteratorRef> args)  
	'''mesh->get«c.name.toFirstUpper»(«args.map[idName].join(', ')»)'''

	private def String getJobName(EObject o)
	{
		if (o === null) null
		else if (o instanceof Job) o.name
		else o.eContainer.jobName
	}
}