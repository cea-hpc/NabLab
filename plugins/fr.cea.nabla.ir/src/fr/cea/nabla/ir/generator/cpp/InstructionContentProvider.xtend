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
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.ItemIdDefinition
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.IterationBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.JobCaller
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SetDefinition
import fr.cea.nabla.ir.ir.VariableDeclaration
import fr.cea.nabla.ir.ir.While
import org.eclipse.xtend.lib.annotations.Data

import static fr.cea.nabla.ir.IrUtils.*
import static fr.cea.nabla.ir.generator.cpp.PythonEmbeddingContentProvider.*

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.cpp.ItemIndexAndIdValueContentProvider.*
import fr.cea.nabla.ir.annotations.NabLabFileAnnotation

@Data
abstract class InstructionContentProvider
{
	protected val extension TypeContentProvider
	protected val extension ExpressionContentProvider
	protected val extension PythonEmbeddingContentProvider
	protected abstract def CharSequence getReductionContent(ReductionInstruction it)
	protected abstract def CharSequence getParallelLoopContent(Loop it)

	protected def getScopeUpdateContent(String variableName)
	'''
		scope->«variableName» = &«variableName»;'''
	
	protected def getScopeParameter()
	'''
		«LOCAL_SCOPE»'''

	def dispatch CharSequence getContent(VariableDeclaration it)
	'''
		«IF variable.type.baseTypeConstExpr»
«««			FIXME add support for internal functions
			«IF getContainerOfType(it, InternFunction) === null && isUserDefined(variable)»
			#ifdef NABLAB_DEBUG
			«getInstrumentation(getExecutionEvent(true))»
			#endif
			«ENDIF»
			«IF variable.const»const «ENDIF»«variable.type.cppType» «variable.name»«IF variable.defaultValue !== null»(«variable.defaultValue.content»)«ENDIF»;
«««			FIXME add support for internal functions
			«IF getContainerOfType(it, InternFunction) === null && isUserDefined(variable)»
			#ifdef NABLAB_DEBUG
			«variable.name.scopeUpdateContent»
			«getInstrumentation(getExecutionEvent(false))»
			#endif
			«ENDIF»
		«ELSE»
«««			FIXME add support for internal functions
			«IF getContainerOfType(it, InternFunction) === null && isUserDefined(variable)»
			#ifdef NABLAB_DEBUG
			«getInstrumentation(getExecutionEvent(true))»
			#endif
			«ENDIF»
			«IF variable.const»const «ENDIF»«variable.type.cppType» «variable.name»;
«««			FIXME add support for internal functions
			«IF getContainerOfType(it, InternFunction) === null && isUserDefined(variable)»
			«initCppTypeContent(variable.name, variable.type)»
			#ifdef NABLAB_DEBUG
			«variable.name.scopeUpdateContent»
			«getInstrumentation(getExecutionEvent(false))»
			#endif
			«ENDIF»
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
«««			FIXME add support for internal functions
			«IF getContainerOfType(it, InternFunction) === null && isUserDefined(left.target)»
			#ifdef NABLAB_DEBUG
			«getInstrumentation(getExecutionEvent(true))»
			#endif
			«ENDIF»
			«left.codeName».setValue(«formatIteratorsAndIndices(left.target.type, left.iterators, left.indices)», «right.content»);
«««			FIXME add support for internal functions
			«IF getContainerOfType(it, InternFunction) === null && isUserDefined(left.target)»
			#ifdef NABLAB_DEBUG
			«IF !left.target.global»
			«left.codeName.toString.scopeUpdateContent»
			«ENDIF»
			«getInstrumentation(getExecutionEvent(false))»
			#endif
			«ENDIF»
			'''
		else
			'''
«««			FIXME add support for internal functions
			«IF getContainerOfType(it, InternFunction) === null && isUserDefined(left.target)»
			#ifdef NABLAB_DEBUG
			«getInstrumentation(getExecutionEvent(true))»
			#endif
			«ENDIF»
			«left.content» = «right.content»;
«««			FIXME add support for internal functions
			«IF getContainerOfType(it, InternFunction) === null && isUserDefined(left.target)»
			#ifdef NABLAB_DEBUG
			«IF !left.target.global»
			«left.codeName.toString.scopeUpdateContent»
			«ENDIF»
			«getInstrumentation(getExecutionEvent(false))»
			#endif
			«ENDIF»
			'''
	}

	def dispatch CharSequence getContent(ReductionInstruction it)
	{
		reductionContent
	}

	def dispatch CharSequence getContent(Loop it)
	{
		if (parallel)
			iterationBlock.defineInterval(parallelLoopContent)
		else
			iterationBlock.defineInterval(sequentialLoopContent)
	}

	def dispatch CharSequence getContent(If it)
	'''
		if («condition.content»)
		{
			«thenInstruction.content»
		}
		«IF (elseInstruction !== null)»
		else
		{
			«elseInstruction.content»
		}
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

	protected def boolean isParallel(Loop it) { parallelLoop }

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
	override isParallel(Loop it) { false }

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
		«wrapWithGILGuard(
		'''
			parallel_exec(«iterationBlock.nbElems», [&](const size_t& «iterationBlock.indexName»)
			{
				py::gil_scoped_acquire acquire;
				«body.innerContent»
				py::gil_scoped_release release;
			});
		''',
		'''
			parallel_exec(«iterationBlock.nbElems», [&](const size_t& «iterationBlock.indexName»)
			{
				«body.innerContent»
			});
		''')»
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

	override getScopeUpdateContent(String variableName)
	'''
		scopeRef->«variableName» = &«variableName»;'''

	override getScopeParameter()
	'''
		py::cast(*scopeRef)'''

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
		val jobCaller = IrUtils.getContainerOfType(it, JobCaller)

		// A jobCaller instance is a graph, never in a team
		if (jobCaller === null)
			parallelLoopBlock
		else
			super.getParallelLoopContent(it)
	}

	private def getParallelLoopBlock(Loop it)
	'''
		{
			«iterationBlock.autoTeamWork»

			«wrapWithGILGuard(
			'''
				Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& «iterationBlock.indexName»Team)
				{
					py::gil_scoped_acquire acquire;
					int «iterationBlock.indexName»(«iterationBlock.indexName»Team + teamWork.first);
					«body.innerContent»
					py::gil_scoped_release release;
				});
			''',
			'''
				Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& «iterationBlock.indexName»Team)
				{
					int «iterationBlock.indexName»(«iterationBlock.indexName»Team + teamWork.first);
					«body.innerContent»
				});
			''')»
		}
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
		«wrapWithGILGuard(
		'''
			#pragma omp parallel for
			for (size_t «iterationBlock.indexName»=0; «iterationBlock.indexName»<«iterationBlock.nbElems»; «iterationBlock.indexName»++)
			{
				py::gil_scoped_acquire acquire;
				«body.innerContent»
				py::gil_scoped_release release;
			}
		''',
		'''
			#pragma omp parallel for
			«sequentialLoopContent»
		''')»
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