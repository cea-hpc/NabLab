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
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IterationBlock
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.SpaceIterationBlock
import fr.cea.nabla.ir.ir.VarDefinition
import org.eclipse.xtend.lib.annotations.Data

import static fr.cea.nabla.ir.generator.cpp.IndexBuilder.*

import static extension fr.cea.nabla.ir.generator.IterationBlockExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.cpp.IterationBlockExtensions.*

@Data
abstract class InstructionContentProvider
{
	protected val extension ArgOrVarContentProvider
	protected val extension ExpressionContentProvider
	protected abstract def CharSequence getReductionContent(ReductionInstruction it)
	protected abstract def CharSequence getLoopContent(Loop it)

	def dispatch CharSequence getContent(VarDefinition it) 
	'''
		«FOR v : variables»
		«IF v.const»const «ENDIF»«v.cppType» «v.name»«v.defaultValueContent»;
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
		reductionContent
	} 

	def dispatch CharSequence getContent(Loop it) 
	{
		if (parallel)
			iterationBlock.defineInterval(loopContent)
		else
			iterationBlock.defineInterval(
			'''
				for (size_t «iterationBlock.indexName»=0; «iterationBlock.indexName»<«iterationBlock.nbElems»; «iterationBlock.indexName»++)
				{
					«IF iterationBlock instanceof SpaceIterationBlock»«defineIndices(iterationBlock as SpaceIterationBlock)»«ENDIF»
					«body.innerContent»
				}
			''')
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

	protected def boolean isParallel(Loop it) { topLevelLoop }

	protected def dispatch getDefaultValueContent(SimpleVariable it)
	'''«IF defaultValue !== null»(«defaultValue.content»)«ENDIF»'''
	
	protected def dispatch getDefaultValueContent(ConnectivityVariable it)
	'''«IF defaultValue !== null»(«defaultValue.content»)«ENDIF»'''
}

@Data
class SequentialInstructionContentProvider extends InstructionContentProvider
{
	override isParallel(Loop it) { false }

	override protected getReductionContent(ReductionInstruction it) 
	{
		throw new UnsupportedOperationException("ReductionInstruction must have been replaced before using this code generator")
	}
	
	override protected getLoopContent(Loop it) 
	{
		throw new UnsupportedOperationException("No parallel loop... bad path")
	}
}

@Data
class KokkosInstructionContentProvider extends InstructionContentProvider
{
	override getReductionContent(ReductionInstruction it)
	'''
		«result.cppType» «result.name»«result.defaultValueContent»;
		«iterationBlock.defineInterval('''
		Kokkos::parallel_reduce(«firstArgument», KOKKOS_LAMBDA(const int& «iterationBlock.indexName», «result.cppType»& accu)
		{
			«IF iterationBlock instanceof SpaceIterationBlock»«defineIndices(iterationBlock as SpaceIterationBlock)»«ENDIF»
			«FOR innerReduction : innerReductions»
			«innerReduction.content»
			«ENDFOR»
			accu = «binaryFunction.getCodeName('.')»(accu, «lambda.content»);
		}, Kokkos::«binaryFunction.kokkosName»<«result.cppType»>(«result.name»));''')»
	'''

	override getLoopContent(Loop it)
	'''
		Kokkos::parallel_for(«iterationBlock.nbElems», KOKKOS_LAMBDA(const int& «iterationBlock.indexName»)
		{
			«IF iterationBlock instanceof SpaceIterationBlock»«defineIndices(iterationBlock as SpaceIterationBlock)»«ENDIF»
			«body.innerContent»
		});
	'''

	protected def String getFirstArgument(ReductionInstruction it) 
	{
		iterationBlock.nbElems
	}

	private def getKokkosName(Function it)
	{
		if (name.startsWith("sum")) "Sum"
		else if (name.startsWith("prod")) "Prod"
		else if (name.startsWith("min")) "Min"
		else if (name.startsWith("max")) "Max"
		else throw new RuntimeException("Reduction not implemented in Kokkos: " + name)
	}
}

@Data
class KokkosTeamThreadInstructionContentProvider extends KokkosInstructionContentProvider
{
	override String getFirstArgument(ReductionInstruction it) 
	{
		"Kokkos::TeamThreadRange(teamMember, " + iterationBlock.nbElems + ")"
	}

	override getLoopContent(Loop it)
	'''
		{
			«iterationBlock.autoTeamWork»

			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& «iterationBlock.indexName»Team)
			{
				int «iterationBlock.indexName»(«iterationBlock.indexName»Team + teamWork.first);
				«IF iterationBlock instanceof SpaceIterationBlock»«defineIndices(iterationBlock as SpaceIterationBlock)»«ENDIF»
				«body.innerContent»
			});
		}
	'''

	private def getAutoTeamWork(IterationBlock it)
	'''
		const auto teamWork(computeTeamWorkRange(teamMember, «nbElems»));
		if (!teamWork.second)
			return;
	'''
}