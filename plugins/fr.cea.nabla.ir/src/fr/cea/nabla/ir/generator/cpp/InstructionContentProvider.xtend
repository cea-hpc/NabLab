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
import fr.cea.nabla.ir.ir.IterationBlock
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
import static extension fr.cea.nabla.ir.generator.cpp.IndexBuilder.*

@Data
abstract class InstructionContentProvider
{
	protected val extension ArgOrVarContentProvider
	protected val extension ExpressionContentProvider
	protected abstract def CharSequence getContent(String indexName, String nbElems, CharSequence innerContent)
	protected abstract def CharSequence getContent(Loop l, IterationBlock b)
	protected abstract def CharSequence getContent(ReductionInstruction r, IterationBlock b)

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
		if (topLevelLoop && multithreadable)
			getContent(it, iterationBlock)
		else 
			getSequentialContent(it, iterationBlock)
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

	protected def getSequentialContent(Loop l, IterationBlock b)
	{
		switch b
		{
			SpaceIterationBlock:
			'''
				{
					«IF !b.range.container.connectivity.indexEqualId »
					auto «b.range.containerName»(«b.range.accessor»);
					«ENDIF»
					«IF !l.topLevelLoop»
					int nb«b.range.containerName.toFirstUpper» = «b.range.containerName».size();
					«ENDIF»
					for (size_t «b.range.indexName»=0; «b.range.indexName»<nb«b.range.containerName.toFirstUpper»; «b.range.indexName»++)
					{
						«b.defineIndices»
						«l.body.innerContent»
					}
				}
			'''
			IntervalIterationBlock:
			'''
				for (size_t «b.index.name»=«b.from.content»; «b.index.name»<«IF b.toIncluded»=«ENDIF»«b.to.content»; «b.index.name»++)
					«l.body.innerContent»
			'''
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
class SequentialInstructionContentProvider extends InstructionContentProvider
{
	override protected getContent(Loop l, IterationBlock b) 
	{
		getSequentialContent(l, b)
	}

	override protected getContent(ReductionInstruction r, IterationBlock b) 
	{
		throw new UnsupportedOperationException("ReductionInstruction must have been replaced before using this code generator")
	}

	override protected getContent(String indexName, String nbElems, CharSequence innerContent) 
	'''
		for (size_t «indexName»=0; «indexName»<«nbElems»; «indexName»++)
			«innerContent»
	'''
}

@Data
class KokkosInstructionContentProvider extends InstructionContentProvider
{
	override protected getContent(String indexName, String nbElems, CharSequence innerContent)
	'''
		Kokkos::parallel_for(«nbElems», KOKKOS_LAMBDA(const int& «indexName»)
		{
			«innerContent»
		});
	'''

	override getContent(Loop l, IterationBlock b)
	{
		switch b
		{
			SpaceIterationBlock:
			'''
				{
					«val kokkosName = l.jobName»
					«IF !b.range.container.connectivity.indexEqualId»auto «b.range.containerName»(«b.range.accessor»);«ENDIF»
					Kokkos::parallel_for(«IF kokkosName !== null»"«kokkosName»", «ENDIF»«b.range.container.connectivity.nbElems», KOKKOS_LAMBDA(const int& «b.range.indexName»)
					{
						«b.defineIndices»
						«l.body.innerContent»
					});
				}
			'''
			IntervalIterationBlock:
			'''
				{
					«val kokkosName = l.jobName»
					«b.fromAndTo»
					Kokkos::parallel_for(«IF kokkosName !== null»«kokkosName», «ENDIF»nbElems, KOKKOS_LAMBDA(const int& «b.index.name»)
					{
						«l.body.innerContent»
					});
				}
			'''
		}
	}

	override getContent(ReductionInstruction r, IterationBlock b)
	{
		switch b
		{
			SpaceIterationBlock:
			'''
				«IF !b.range.container.connectivity.indexEqualId»int[] «b.range.containerName»(«b.range.accessor»);«ENDIF»
				«r.result.cppType» «r.result.name»(«r.result.defaultValue.content»);
				{
					Kokkos::«r.reduction.kokkosName»<«r.result.cppType»> reducer(«r.result.name»);
					«getHeader(r, b.range.container.connectivity.nbElems, b.range.indexName)»
					{
						«b.defineIndices»
						«FOR innerReduction : r.innerReductions»
						«innerReduction.content»
						«ENDFOR»
						reducer.join(x, «r.arg.content»);
					}, reducer);
				}
			'''
			IntervalIterationBlock:
			'''
				{
					«b.fromAndTo»
					«r.result.cppType» «r.result.name»(«r.result.defaultValue.content»);
					{
						Kokkos::«r.reduction.kokkosName»<«r.result.cppType»> reducer(«r.result.name»);
						«getHeader(r, "nbElems", b.index.name)»
						{
							«FOR innerReduction : r.innerReductions»
							«innerReduction.content»
							«ENDFOR»
							reducer.join(x, «r.arg.content»);
						}, reducer);
					}
				}
			'''
		}
	}

	protected def getHeader(ReductionInstruction ri, String nbElems, String indexName)
	'''
		Kokkos::parallel_reduce("«ri.jobName»«ri.result.name.toFirstUpper»", «nbElems», KOKKOS_LAMBDA(const int& «indexName», «ri.result.cppType»& x)
	'''

	protected def getFromAndTo(IntervalIterationBlock it)
	'''
		const int from = «from.content»;
		const int to = «to.content»«IF toIncluded»+1«ENDIF»;
		const int nbElems = from-to;
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
}

@Data
class KokkosTeamThreadInstructionContentProvider extends KokkosInstructionContentProvider
{
	override getHeader(ReductionInstruction ri, String nbElems, String indexName)
	'''
		Kokkos::parallel_reduce(Kokkos::TeamThreadRange(team_member, «nbElems»), KOKKOS_LAMBDA(const int& «indexName», «ri.result.cppType»& x)
	'''

	override getContent(Loop l, IterationBlock b)
	{
		switch b
		{
			SpaceIterationBlock:
			'''
				{
					const auto team_work(computeTeamWorkRange(team_member, «b.range.container.connectivity.nbElems»));
					if (!team_work.second)
						return;

					«IF !b.range.container.connectivity.indexEqualId»auto «b.range.containerName»(«b.range.accessor»);«ENDIF»
					Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& «b.range.indexName»Team)
					{
						int «b.range.indexName»(«b.range.indexName»Team + team_work.first);
						«b.defineIndices»
						«l.body.innerContent»
					});
				}
			'''
			IntervalIterationBlock:
			'''
				{
					«b.fromAndTo»
					const auto team_work(computeTeamWorkRange(team_member, nbElems));
					if (!team_work.second)
						return;

					Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& «b.index.name»Team)
					{
						int «b.index.name»(«b.index.name»Team + team_work.first);
						«l.body.innerContent»
					});
				}
			'''
		}
	}
}