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

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.TimeLoopCopyJob
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.ir.ir.Variable
import java.util.List
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
abstract class JobContentProvider
{
	protected val TraceContentProvider traceContentProvider
	protected val extension ExpressionContentProvider
	protected val extension InstructionContentProvider
	protected val extension JobContainerContentProvider
	protected abstract def CharSequence copy(Variable source, Variable destination)

	def getContent(Job it)
	'''
		«comment»
		void «codeName»() noexcept
		{
			«innerContent»
		}
	'''

	protected def dispatch CharSequence getInnerContent(InstructionJob it)
	'''
		«instruction.innerContent»
	'''

	protected def dispatch CharSequence getInnerContent(TimeLoopJob it)
	'''
		«callsHeader»
		«val itVar = timeLoop.iterationCounter.name»
		«itVar» = 0;
		bool continueLoop = true;
		do
		{
			«IF isTopLevel»
			global_timer.start();
			cpu_timer.start();
			«ENDIF»
			«itVar»++;
			«IF topLevel && irModule.postProcessingInfo !== null»dumpVariables(«itVar»);«ENDIF»
			«traceContentProvider.getBeginOfLoopTrace(itVar, timeVarName, isTopLevel)»

			«callsContent»

			// Evaluate loop condition with variables at time n
			continueLoop = «timeLoop.whileCondition.content»;

			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				«FOR copy : copies»
					std::swap(«copy.source.name», «copy.destination.name»);
				«ENDFOR»
			}
			«IF isTopLevel»

			cpu_timer.stop();
			global_timer.stop();
			«ENDIF»

			«traceContentProvider.getEndOfLoopTrace(itVar, timeVarName, deltatVarName, isTopLevel)»

			«IF isTopLevel»
			cpu_timer.reset();
			io_timer.reset();
			«ENDIF»
		} while (continueLoop);
	'''

	protected def dispatch CharSequence getInnerContent(TimeLoopCopyJob it)
	'''
		«FOR copy : copies»
			«copy(copy.source, copy.destination)»
		«ENDFOR»
	'''

	protected def CharSequence copy(String left, String right, int dimension)
	{
		if (dimension == 0)
			'''«left» = «right»;'''
		else
		{
			val indexName = 'i' + dimension
			val suffix = '[' + indexName + ']'
			'''
				for (int «indexName»=0 ; «indexName»<«left».size() ; «indexName»++)
					«copy(left + suffix, right + suffix, dimension-1)»
			'''
		}
	}

	private def getTimeVarName(TimeLoopJob it)
	{
		val irModule = eContainer as IrModule
		irModule.timeVariable.name
	}

	private def getDeltatVarName(TimeLoopJob it)
	{
		val irModule = eContainer as IrModule
		irModule.deltatVariable.name
	}
}

@Data
class SequentialJobContentProvider extends JobContentProvider
{
	override getContent(Job it)
	'''
		«comment»
		void «codeName»() noexcept
		{
			«innerContent»
		}
	'''

	override copy(Variable source, Variable destination)
	{
		copy(destination.name, source.name, destination.type.dimension)
	}
}

@Data
class KokkosJobContentProvider extends JobContentProvider
{
	override getContent(Job it)
	'''
		«comment»
		KOKKOS_INLINE_FUNCTION
		void «codeName»(«FOR a : arguments SEPARATOR ', '»«a»«ENDFOR») noexcept
		{
			«innerContent»
		}
	'''

	override copy(Variable source, Variable destination)
	{
		if (destination.type instanceof BaseType)
			copy(destination.name, source.name, (destination.type as BaseType).sizes.size)
		else
			'''deep_copy(«destination.name», «source.name»);'''
	}

	protected def List<String> getArguments(Job it) { #[] }
}

@Data
class KokkosTeamThreadJobContentProvider extends KokkosJobContentProvider
{
	override getArguments(Job it)
	{
		if (hasIterable) #["const member_type& team_member"]
		else #[]
	}
}