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
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.TimeLoopCopy
import fr.cea.nabla.ir.ir.TimeLoopJob
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
abstract class JobContentProvider
{
	protected val TraceContentProvider traceContentProvider
	protected val extension ExpressionContentProvider
	protected val extension InstructionContentProvider
	protected val extension JobCallerContentProvider

	protected def abstract CharSequence copyConnectivityType(String leftName, String rightName, int dimension, List<CharSequence> indexNames)

	def getDeclarationContent(Job it)
	'''
		void «codeName»() noexcept;'''

	def getDefinitionContent(Job it)
	'''
		«comment»
		void «irModule.className»::«codeName»() noexcept
		{
			«innerContent»
		}
	'''

	protected def dispatch CharSequence getInnerContent(InstructionJob it)
	'''
		«instruction.innerContent»
	'''

	protected def dispatch CharSequence getInnerContent(ExecuteTimeLoopJob it)
	'''
		«callsHeader»
		«val itVar = iterationCounter.codeName»
		«itVar» = 0;
		bool continueLoop = true;
		do
		{
			«IF caller.main»
			globalTimer.start();
			cpuTimer.start();
			«ENDIF»
			«itVar»++;
			«val ppInfo = irRoot.postProcessing»
			«IF caller.main && ppInfo !== null»
				if (!writer.isDisabled() && «ppInfo.periodReference.codeName» >= «ppInfo.lastDumpVariable.codeName» + «ppInfo.periodValue.codeName»)
					dumpVariables(«itVar»);
			«ENDIF»
			«traceContentProvider.getBeginOfLoopTrace(irModule, itVar, caller.main)»

			«callsContent»

			// Evaluate loop condition with variables at time n
			continueLoop = («whileCondition.content»);

			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				«FOR copy : copies»
					std::swap(«copy.source.name», «copy.destination.name»);
				«ENDFOR»
			}
			«IF caller.main»

			cpuTimer.stop();
			globalTimer.stop();
			«ENDIF»

			«traceContentProvider.getEndOfLoopTrace(irModule, itVar, caller.main, (ppInfo !== null))»

			«IF caller.main»
			cpuTimer.reset();
			ioTimer.reset();
			«ENDIF»
		} while (continueLoop);
		«IF caller.main && irRoot.postProcessing !== null»
			// force a last output at the end
			dumpVariables(«itVar», false);
		«ENDIF»
	'''

	protected def dispatch CharSequence getInnerContent(TimeLoopJob it)
	'''
		«FOR c  : copies»
			«c.content»
		«ENDFOR»
	'''

	protected def getContent(TimeLoopCopy it)
	{
		// c.destination.type == c.source.type
		val t = source.type
		switch t
		{
			BaseType: copyBaseType(destination.name, source.name, t.sizes.size, new ArrayList<CharSequence>())
			ConnectivityType: copyConnectivityType(destination.name, source.name, t.connectivities.size + t.base.sizes.size, new ArrayList<CharSequence>())
			LinearAlgebraType: copyLinearAlgebraType(destination.name, source.name, t.sizes.size, new ArrayList<CharSequence>())
		}
	}

	protected def CharSequence copyBaseType(String leftName, String rightName, int dimension, List<CharSequence> indexNames)
	{
		if (dimension == 0)
			'''«leftName»«FOR i : indexNames»[«i»]«ENDFOR» = «rightName»«FOR i : indexNames»[«i»]«ENDFOR»;'''
		else
		{
			val length = '''«leftName»«FOR i : indexNames»[«i»]«ENDFOR».size()'''
			var indexName = '''i«indexNames.size + 1»'''
			indexNames += indexName
			'''
				for (size_t «indexName»(0) ; «indexName»<«length» ; «indexName»++)
					«copyBaseType(leftName, rightName, dimension-1, indexNames)»
			'''
		}
	}

	protected def CharSequence copyLinearAlgebraType(String leftName, String rightName, int dimension, List<CharSequence> indexNames)
	{
		if (dimension == 0)
			'''«leftName».setValue(«FOR i : indexNames SEPARATOR ', '»«i»«ENDFOR», «rightName».getValue(«FOR i : indexNames SEPARATOR ', '»«i»«ENDFOR»));'''
		else
		{
			val length = '''«leftName»«FOR i : indexNames BEFORE '.getValue(' SEPARATOR ', ' AFTER ')'»«i»«ENDFOR».getSize()'''
			var indexName = '''i«indexNames.size + 1»'''
			indexNames += indexName
			'''
				for (size_t «indexName»(0) ; «indexName»<«length» ; «indexName»++)
					«copyLinearAlgebraType(leftName, rightName, dimension-1, indexNames)»
			'''
		}
	}
}

@Data
class StlThreadJobContentProvider extends JobContentProvider
{
	override protected copyConnectivityType(String leftName, String rightName, int dimension, List<CharSequence> indexNames)
	{
		copyBaseType(leftName, rightName, dimension, indexNames)
	}
}

@Data
class KokkosJobContentProvider extends JobContentProvider
{
	override getDeclarationContent(Job it)
	'''
		KOKKOS_INLINE_FUNCTION
		void «codeName»(«FOR a : arguments SEPARATOR ', '»«a»«ENDFOR») noexcept;'''

	override getDefinitionContent(Job it)
	'''
		«comment»
		void «irModule.className»::«codeName»(«FOR a : arguments SEPARATOR ', '»«a»«ENDFOR») noexcept
		{
			«innerContent»
		}
	'''

	protected def List<String> getArguments(Job it) { #[] }

	override protected copyConnectivityType(String leftName, String rightName, int dimension, List<CharSequence> indexNames)
	'''deep_copy(«leftName», «rightName»);'''
}

@Data
class KokkosTeamThreadJobContentProvider extends KokkosJobContentProvider
{
	override getArguments(Job it)
	{
		if (hasIterable) #["const member_type& teamMember"]
		else #[]
	}
}