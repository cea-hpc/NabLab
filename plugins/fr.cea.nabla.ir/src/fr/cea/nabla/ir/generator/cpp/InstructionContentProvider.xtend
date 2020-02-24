/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IntervalIterationBlock
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.SpaceIterationBlock
import fr.cea.nabla.ir.ir.VarDefinition
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.SizeTypeContentProvider.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.cpp.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.cpp.IndexBuilder.*

@Data
abstract class InstructionContentProvider
{
	protected val extension ArgOrVarContentProvider
	protected abstract def CharSequence getHeader(ReductionInstruction ri, String nbElems, String indexName)
	protected abstract def CharSequence getParallelContent(Loop l)

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
				getParallelContent(it)
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
			if (a.left.target.matrix)
				return false
		return true
	}

	private def dispatch getDefaultValueContent(SimpleVariable it)
	'''«IF defaultValue !== null» = «defaultValue.content»«ENDIF»;'''
	
	private def dispatch getDefaultValueContent(ConnectivityVariable it)
	'''«IF defaultValue !== null» = «defaultValue.content»«ENDIF»;'''

	protected def String getJobName(EObject o)
	{
		if (o === null) null
		else if (o instanceof Job) o.name
		else o.eContainer.jobName
	}
}

@Data
class KokkosInstructionContentProvider extends InstructionContentProvider
{
	override protected getHeader(ReductionInstruction ri, String nbElems, String indexName)
	'''
		Kokkos::parallel_reduce("«ri.jobName»«ri.result.name.toFirstUpper»", «nbElems», KOKKOS_LAMBDA(const int& «indexName», «ri.result.cppType»& x)
	'''

	override protected getParallelContent(Loop l)
	{ 
		getParallelContent(l.iterationBlock, l)
	}

	private def dispatch getParallelContent(SpaceIterationBlock it, Loop l)
	'''
		«val kokkosName = l.jobName»
		«IF !range.container.connectivity.indexEqualId»
		{
			auto «range.containerName»(«range.accessor»);
			Kokkos::parallel_for(«IF kokkosName !== null»"«kokkosName»", «ENDIF»«range.container.connectivity.nbElems», KOKKOS_LAMBDA(const int& «range.indexName»)
			{
				«defineIndices»
				«l.body.innerContent»
			});
		}
		«ELSE»
			Kokkos::parallel_for(«IF kokkosName !== null»"«kokkosName»", «ENDIF»«range.container.connectivity.nbElems», KOKKOS_LAMBDA(const int& «range.indexName»)
			{
				«defineIndices»
				«l.body.innerContent»
			});
		«ENDIF»
	'''

	private def dispatch getParallelContent(IntervalIterationBlock it, Loop l)
	'''
		«val kokkosName = l.jobName»
		{
			const int from = «from.content»;
			const int to = «to.content»«IF toIncluded»+1«ENDIF»;
			const int nbElems = from-to;
			Kokkos::parallel_for(«IF kokkosName !== null»«kokkosName», «ENDIF»nbElems, KOKKOS_LAMBDA(const int& «index.name»)
			{
				«l.body.innerContent»
			});
		}
	'''
}

@Data
class KokkosTeamThreadInstructionContentProvider extends InstructionContentProvider
{
	override protected getHeader(ReductionInstruction ri, String nbElems, String indexName)
	'''
		Kokkos::parallel_reduce(Kokkos::TeamThreadRange(team_member, «nbElems»), KOKKOS_LAMBDA(const int& «indexName», «ri.result.cppType»& x)
	'''

	override protected getParallelContent(Loop l)
	{
		getParallelContent(l.iterationBlock, l)
	}

	private def dispatch getParallelContent(SpaceIterationBlock it, Loop l)
	'''
		{
			const auto team_work(computeTeamWorkRange(team_member, «range.container.connectivity.nbElems»));
			if (!team_work.second)
				return;

			«IF !range.container.connectivity.indexEqualId»auto «range.containerName»(«range.accessor»);«ENDIF»
			Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& «range.indexName»Team)
			{
				int «range.indexName»(«range.indexName»Team + team_work.first);
				«defineIndices»
				«l.body.innerContent»
			});
		}
	'''

	private def dispatch getParallelContent(IntervalIterationBlock it, Loop l)
	'''
		{
			const int from = «from.content»;
			const int to = «to.content»«IF toIncluded»+1«ENDIF»;
			const int nbElems = from-to;
			const auto team_work(computeTeamWorkRange(team_member, nbElems));
			if (!team_work.second)
				return;

			Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& «index.name»Team)
			{
				int «index.name»(«index.name»Team + team_work.first);
				«l.body.innerContent»
			});
		}
	'''
}