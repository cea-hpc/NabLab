/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp.arcane

import fr.cea.nabla.ir.ir.Job

import static extension fr.cea.nabla.ir.generator.Utils.*

class JobContentProvider
{
	static def getDeclarationContent(Job it)
	'''void «codeName»();'''

//	def getDefinitionContent(Job it)
//	'''
//		«comment»
//		void «IrUtils.getContainerOfType(it, IrModule).className»::«codeName»() noexcept
//		{
//			«innerContent»
//		}
//	'''

//	protected def dispatch CharSequence getInnerContent(Job it)
//	'''
//		«instruction.innerContent»
//	'''
//
//	protected def dispatch CharSequence getInnerContent(ExecuteTimeLoopJob it)
//	'''
//		«callsHeader»
//		«val itVar = iterationCounter.codeName»
//		«val irRoot = IrUtils.getContainerOfType(it, IrRoot)»
//		«val irModule = IrUtils.getContainerOfType(it, IrModule)»
//		«val ppInfo = irRoot.postProcessing»
//		«itVar» = 0;
//		bool continueLoop = true;
//		do
//		{
//			«IF caller.main»
//			globalTimer.start();
//			cpuTimer.start();
//			«ENDIF»
//			«itVar»++;
//			«IF caller.main»
//				«IF ppInfo !== null»
//				if (!writer.isDisabled() && «ppInfo.periodReference.codeName» >= «ppInfo.lastDumpVariable.codeName» + «ppInfo.periodValue.codeName»)
//					dumpVariables(«itVar»);
//				«ENDIF»
//				«traceContentProvider.getBeginOfLoopTrace(irModule, itVar)»
//
//			«ENDIF»
//			«callsContent»
//
//			// Evaluate loop condition with variables at time n
//			continueLoop = («whileCondition.content»);
//
//			«instruction.innerContent»
//			«IF caller.main»
//
//			cpuTimer.stop();
//			globalTimer.stop();
//
//			«traceContentProvider.getEndOfLoopTrace(irModule, itVar, (ppInfo !== null))»
//
//			cpuTimer.reset();
//			ioTimer.reset();
//			«ENDIF»
//		} while (continueLoop);
//		«IF caller.main»
//			«IF ppInfo !== null»
//			if (!writer.isDisabled())
//				dumpVariables(«itVar»+1, false);
//			«ENDIF»
//		«ENDIF»
//	'''
}
