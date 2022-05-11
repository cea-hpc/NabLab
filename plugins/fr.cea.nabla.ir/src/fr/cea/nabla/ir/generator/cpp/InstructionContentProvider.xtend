/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.CppGeneratorUtils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.Exit
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.ItemIdDefinition
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.IterationBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SetDefinition
import fr.cea.nabla.ir.ir.VariableDeclaration
import fr.cea.nabla.ir.ir.While
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.cpp.ItemIndexAndIdValueContentProvider.*

@Data
abstract class InstructionContentProvider
{
	protected val extension TypeContentProvider
	protected val extension ExpressionContentProvider
	protected val AbstractPythonEmbeddingContentProvider pythonEmbeddingContentProvider
	protected abstract def CharSequence getReductionContent(ReductionInstruction it)
	protected abstract def CharSequence getParallelLoopContent(Loop it)


	def dispatch CharSequence getContent(VariableDeclaration it)
	'''
		«IF variable.type.baseTypeConstExpr»
			«pythonEmbeddingContentProvider.getBeforeWriteContent(it)»
			«IF variable.const»const «ENDIF»«variable.type.cppType» «variable.name»«IF variable.defaultValue !== null»(«variable.defaultValue.content»)«ENDIF»;
			«pythonEmbeddingContentProvider.getAfterWriteContent(it)»
		«ELSE»
			«pythonEmbeddingContentProvider.getBeforeWriteContent(it)»
			«IF variable.const»const «ENDIF»«variable.type.cppType» «variable.name»;
			«pythonEmbeddingContentProvider.getAfterWriteContent(it)»
		«ENDIF»
	'''

	def dispatch CharSequence getContent(InstructionBlock it)
	'''
		{
			«FOR i : instructions»
			«i.content»
			«ENDFOR»
		}'''

	def dispatch CharSequence getContent(Affectation it)
	{
		if (left.target.linearAlgebra && !(left.iterators.empty && left.indices.empty))
			'''
			«pythonEmbeddingContentProvider.getBeforeWriteContent(it)»
			«left.codeName».setValue(«formatIteratorsAndIndices(left.target.type, left.iterators, left.indices)», «right.content»);
			«pythonEmbeddingContentProvider.getAfterWriteContent(it)»
			'''
		else
			'''
			«pythonEmbeddingContentProvider.getBeforeWriteContent(it)»
			«left.content» = «right.content»;
			«pythonEmbeddingContentProvider.getAfterWriteContent(it)»
			'''
	}

	def dispatch CharSequence getContent(ReductionInstruction it)
	{
		reductionContent
	}

	def dispatch CharSequence getContent(Loop it)
	{
		if (multithreadable)
			iterationBlock.defineInterval(parallelLoopContent)
		else
			iterationBlock.defineInterval(sequentialLoopContent)
	}

	def dispatch CharSequence getContent(If it)
	'''
		if («condition.content») 
		«val thenContent = thenInstruction.content»
		«IF !(thenContent.charAt(0) == '{'.charAt(0))»
		{
			«thenContent»
		}
		«ELSE»
		«thenContent»
		«ENDIF»
		«IF (elseInstruction !== null)»
		«val elseContent = elseInstruction.content»
		else
		«IF !(elseContent.charAt(0) == '{'.charAt(0))»
		{
			«elseContent»
		}
		«ELSE»
		«elseContent»
		«ENDIF»
		«ENDIF»
	'''

	def dispatch CharSequence getContent(ItemIndexDefinition it)
	'''
		const size_t «index.name»(«value.content»);
	'''

	def dispatch CharSequence getContent(ItemIdDefinition it)
	'''
		const Id «id.name»(«value.content»);
	'''

	def dispatch CharSequence getContent(SetDefinition it)
	{
		getSetDefinitionContent(name, value)
	}

	def dispatch CharSequence getContent(While it)
	'''
		while («condition.content»)
		«val iContent = instruction.content»
		«IF !(iContent.charAt(0) == '{'.charAt(0))»	«ENDIF»«iContent»
	'''

	def dispatch CharSequence getContent(Return it)
	'''
		return «expression.content»;
	'''

	def dispatch CharSequence getContent(Exit it)
	'''
		throw std::runtime_error("«message»");
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

	protected def CharSequence getSequentialLoopContent(Loop it)
	'''
		for (size_t «iterationBlock.indexName»=0; «iterationBlock.indexName»<«iterationBlock.nbElems»; «iterationBlock.indexName»++)
		{
			«body.innerContent»
		}
	'''

	// ### IterationBlock Extensions ###
	protected def dispatch defineInterval(Iterator it, CharSequence innerContent)
	{
		if (container.connectivityCall.indexEqualId)
			innerContent
		else
		'''
		{
			«IF container instanceof ConnectivityCall»«getSetDefinitionContent(container.uniqueName, container as ConnectivityCall)»«ENDIF»
			«IF !container.connectivityCall.args.empty»const size_t «nbElems»(«container.uniqueName».size());«ENDIF»
			«innerContent»
		}
		'''
	}

	protected def dispatch defineInterval(Interval it, CharSequence innerContent)
	{
		innerContent
	}

	protected def dispatch getIndexName(Iterator it) { index.name }
	protected def dispatch getIndexName(Interval it) { index.name }
	protected def dispatch getNbElems(Iterator it) { container.nbElemsVar }
	protected def dispatch getNbElems(Interval it) { nbElems.content }

	protected def instanciateTemplate(IrType it)
	{
		switch it
		{
			case null: ''
			BaseType case !sizes.empty: '<' + sizes.map[e | (e.constExpr?e.content:'0')].join(',') + '>'
			default: ''
		}
	}

	private def getSetDefinitionContent(String setName, ConnectivityCall call)
	'''
		const auto «setName»(mesh.«call.accessor»);
	'''
}

@Data
class SequentialInstructionContentProvider extends InstructionContentProvider
{
	override protected getReductionContent(ReductionInstruction it)
	{
		throw new RuntimeException("ReductionInstruction must have been replaced before using this code generator")
	}

	override protected getParallelLoopContent(Loop it)
	{
		sequentialLoopContent
	}
}

@Data
class StlThreadInstructionContentProvider extends InstructionContentProvider
{
	override getReductionContent(ReductionInstruction it)
	'''
		«result.type.cppType» «result.name»;
		«iterationBlock.defineInterval('''
		«result.name» = parallel_reduce(«iterationBlock.nbElems», «result.type.cppType»(«result.defaultValue.content»), [&](«result.type.cppType»& accu, const size_t& «iterationBlock.indexName»)
			{
				«FOR innerInstruction : innerInstructions»
				«innerInstruction.content»
				«ENDFOR»
				return (accu = «CppGeneratorUtils.getCodeName(binaryFunction)»(accu, «lambda.content»));
			},
			&«CppGeneratorUtils.getCodeName(binaryFunction)»«result.type.instanciateTemplate»);''')»
	'''

	override getParallelLoopContent(Loop it)
	'''
		{
			«pythonEmbeddingContentProvider.wrapLambdaWithGILGuard(it,
				"void(const size_t&)",
				"loopLambda",
				'''const size_t& «iterationBlock.indexName»''',
				'''«body.innerContent»''')»
			«pythonEmbeddingContentProvider.wrapLambdaCallWithGILGuard('''parallel_exec(«iterationBlock.nbElems», loopLambda);''')»
		}
	'''
}

@Data
class KokkosInstructionContentProvider extends InstructionContentProvider
{
	override getReductionContent(ReductionInstruction it)
	'''
		«result.type.cppType» «result.name»;
		«iterationBlock.defineInterval('''
		Kokkos::parallel_reduce(«firstArgument», KOKKOS_LAMBDA(const size_t& «iterationBlock.indexName», «result.type.cppType»& accu)
		{
			«FOR innerInstruction : innerInstructions»
			«innerInstruction.content»
			«ENDFOR»
			accu = «CppGeneratorUtils.getCodeName(binaryFunction)»(accu, «lambda.content»);
		}, KokkosJoiner<«result.type.cppType»>(«result.name», «result.type.cppType»(«result.defaultValue.content»), &«CppGeneratorUtils.getCodeName(binaryFunction)»«result.type.instanciateTemplate»));''')»
	'''

	override getParallelLoopContent(Loop it)
	'''
		Kokkos::parallel_for(«iterationBlock.nbElems», KOKKOS_LAMBDA(const size_t& «iterationBlock.indexName»)
		{
			«body.innerContent»
		});
	'''

	protected def getFirstArgument(ReductionInstruction it)
	{
		iterationBlock.nbElems
	}
}

@Data
class KokkosTeamThreadInstructionContentProvider extends KokkosInstructionContentProvider
{
	override String getFirstArgument(ReductionInstruction it) 
	{
		"Kokkos::TeamThreadRange(teamMember, " + iterationBlock.nbElems + ")"
	}

	override getParallelLoopContent(Loop it)
	{
		val isLoopInFunction = IrUtils.getContainerOfType(it, Function) !== null
		// a JobCaller is a graph => simulate and eexecuteTimeLoop jobs
		val isLoopInJobCaller = IrUtils.getContainerOfType(it, JobCaller) !== null

		// no team of thread in a JobCaller or a Function
		if (!isLoopInFunction && !isLoopInJobCaller)
			parallelLoopBlock
		else
			super.getParallelLoopContent(it)
	}

	private def getParallelLoopBlock(Loop it)
	'''
		{
			«iterationBlock.autoTeamWork»

			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& «iterationBlock.indexName»Team)
			{
				int «iterationBlock.indexName»(«iterationBlock.indexName»Team + teamWork.first);
				«body.innerContent»
			});
		}
		«val j = IrUtils.getContainerOfType(it, Job)»
		«IF (j.eAllContents.filter(Loop).filter[multithreadable].size > 1)»
		teamMember.team_barrier();
		«ENDIF»
	'''

	private def getAutoTeamWork(IterationBlock it)
	'''
		const auto teamWork(computeTeamWorkRange(teamMember, «nbElems»));
		if (!teamWork.second)
			return;
	'''
}

@Data
class OpenMpInstructionContentProvider extends InstructionContentProvider
{
	override getReductionContent(ReductionInstruction it)
	'''
		«result.type.cppType» «result.name»(«result.defaultValue.content»);
		#pragma omp parallel for reduction(«reductionIdentifier»:«result.name»)
		«iterationBlock.defineInterval('''
		for (size_t «iterationBlock.indexName»=0; «iterationBlock.indexName»<«iterationBlock.nbElems»; «iterationBlock.indexName»++)
		{
			«result.name» = «CppGeneratorUtils.getCodeName(binaryFunction)»(«result.name», «lambda.content»);
		}''')»
	'''


	override getParallelLoopContent(Loop it)
	'''
		«pythonEmbeddingContentProvider.wrapLoopWithGILGuard(it,
			'''
				#pragma omp parallel for
				for (size_t «iterationBlock.indexName»=0; «iterationBlock.indexName»<«iterationBlock.nbElems»; «iterationBlock.indexName»++)
			''',
			'''«body.innerContent»''')»
	'''

	private def String getReductionIdentifier(ReductionInstruction it)
	{
		val n = binaryFunction.name
		if (n.startsWith("sum")) "+"
		else if (n.startsWith("prod")) "*"
		else if (n.startsWith("min")) "min"
		else if (n.startsWith("max")) "max"
		else throw new RuntimeException("Open MP reduction not yet implemented: " + n)
	}
}