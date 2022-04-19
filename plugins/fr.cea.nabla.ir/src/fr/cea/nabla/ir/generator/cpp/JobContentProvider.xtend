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
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import java.util.List
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
abstract class JobContentProvider
{
	protected val TraceContentProvider traceContentProvider
	protected val extension ExpressionContentProvider
	protected val extension InstructionContentProvider
	protected val extension JobCallerContentProvider
	protected val extension JsonContentProvider
	protected val extension TypeContentProvider
	protected val AbstractPythonEmbeddingContentProvider pythonEmbeddingContentProvider

	def getDeclarationContent(Job it)
	'''
		void «codeName»() noexcept;'''

	def getDefinitionContent(Job it)
	'''
		«comment»
		void «IrUtils.getContainerOfType(it, IrModule).className»::«codeName»() noexcept
		{
			«pythonEmbeddingContentProvider.getBeforeCallContent(it)»
			«innerContent»
			«pythonEmbeddingContentProvider.getAfterCallContent(it)»
		}
	'''

	protected def dispatch CharSequence getInnerContent(Job it)
	'''
		«instruction.innerContent»
	'''

	protected def dispatch CharSequence getInnerContent(ExecuteTimeLoopJob it)
	'''
		«callsHeader»
		«val itVar = iterationCounter.codeName»
		«val irRoot = IrUtils.getContainerOfType(it, IrRoot)»
		«val irModule = IrUtils.getContainerOfType(it, IrModule)»
		«val ppInfo = irRoot.postProcessing»
		«itVar» = 0;
		bool continueLoop = true;
		do
		{
			«IF caller.main»
			globalTimer.start();
			cpuTimer.start();
			«ENDIF»
			«itVar»++;
			«IF caller.main»
				«IF ppInfo !== null»
				if (writer != NULL && !writer->isDisabled() && «ppInfo.periodReference.codeName» >= «ppInfo.lastDumpVariable.codeName» + «ppInfo.periodValue.codeName»)
					dumpVariables(«itVar»);
				«ENDIF»
				«traceContentProvider.getBeginOfLoopTrace(irModule, itVar)»

			«ENDIF»
			«callsContent»

			// Evaluate loop condition with variables at time n
			continueLoop = («whileCondition.content»);

			«instruction.innerContent»
			«IF caller.main»

			cpuTimer.stop();
			globalTimer.stop();

			«traceContentProvider.getEndOfLoopTrace(irModule, itVar, (ppInfo !== null))»

			cpuTimer.reset();
			ioTimer.reset();
			«ENDIF»
		} while (continueLoop);
		«IF caller.main»
			«IF ppInfo !== null»
			if (writer != NULL && !writer->isDisabled())
				dumpVariables(«itVar»+1, false);
			«ENDIF»
		«ENDIF»
	'''
}

@Data
class StlThreadJobContentProvider extends JobContentProvider
{
}

@Data
class KokkosJobContentProvider extends JobContentProvider
{
	override getDeclarationContent(Job it)
	'''
		void «codeName»(«FOR a : arguments SEPARATOR ', '»«a»«ENDFOR») noexcept;'''

	override getDefinitionContent(Job it)
	'''
		«comment»
		void «IrUtils.getContainerOfType(it, IrModule).className»::«codeName»(«FOR a : arguments SEPARATOR ', '»«a»«ENDFOR») noexcept
		{
			«innerContent»
		}
	'''

	protected def List<String> getArguments(Job it) { #[] }
}

@Data
class KokkosTeamThreadJobContentProvider extends KokkosJobContentProvider
{
	override getArguments(Job it)
	{
		// JobCaller never in a team
		if (!hasIterable || it instanceof JobCaller) #[]
		else #["const member_type& teamMember"]
	}
}