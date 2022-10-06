/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job

import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.InstructionContentProvider.*

class JobContentProvider
{
	static def getContent(Job it)
	'''
		«comment»
		protected void «codeName»()
		{
			«innerContent»
		}
	'''

	private static def dispatch CharSequence getInnerContent(Job it)
	'''
		«instruction.innerContent»
	'''

	private static def dispatch CharSequence getInnerContent(ExecuteTimeLoopJob it)
	'''
		«val itVar = iterationCounter.codeName»
		«val irRoot = IrUtils.getContainerOfType(it, IrRoot)»
		«val tn = irRoot.currentTimeVariable.codeName»
		«val delta_t = irRoot.timeStepVariable.codeName»
		«val ppInfo = irRoot.postProcessing»
		«itVar» = 0;
		boolean continueLoop = true;
		do
		{
			«itVar»++;
			«IF caller.main»
				System.out.printf("START ITERATION «iterationCounter.name»: %5d - t: %5.5f - delta_t: %5.5f\n", «itVar», «tn», «delta_t»);
				«IF ppInfo !== null»
					if («ppInfo.periodReference.codeName» >= «ppInfo.lastDumpVariable.codeName» + «ppInfo.periodValue.codeName»)
						dumpVariables(«itVar»);
				«ENDIF»
			«ELSE»
				System.out.printf("Start iteration «iterationCounter.name»: %5d\n", «itVar»);
			«ENDIF»

			«FOR j : calls»
				«j.callName»(); // @«j.at»
			«ENDFOR»

			// Evaluate loop condition with variables at time n
			continueLoop = («whileCondition.content»);

			«instruction.innerContent»
		} while (continueLoop);
		«IF caller.main»

			System.out.printf("FINAL TIME: %5.5f - delta_t: %5.5f\n", «tn», «delta_t»);
			«IF ppInfo !== null»dumpVariables(«itVar»+1);«ENDIF»
		«ENDIF»
	'''
}