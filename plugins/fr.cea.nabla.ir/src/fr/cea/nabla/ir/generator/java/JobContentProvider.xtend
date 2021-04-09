/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.TimeLoopJob

import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
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

	private static def dispatch CharSequence getInnerContent(InstructionJob it)
	'''
		«instruction.innerContent»
	'''

	private static def dispatch CharSequence getInnerContent(ExecuteTimeLoopJob it)
	'''
		«val itVar = iterationCounter.codeName»
		«itVar» = 0;
		boolean continueLoop = true;
		do
		{
			«itVar»++;
			System.out.printf("«caller.indentation»[%5d] t: %5.5f - deltat: %5.5f\n", «itVar», «irRoot.timeVariable.codeName», «irRoot.timeStepVariable.codeName»);
			«IF caller.main && irRoot.postProcessing !== null»
				«val ppInfo = irRoot.postProcessing»
				if («ppInfo.periodReference.codeName» >= «ppInfo.lastDumpVariable.codeName» + «ppInfo.periodValue.codeName»)
					dumpVariables(«itVar»);
			«ENDIF»
			«FOR j : calls»
				«j.callName»(); // @«j.at»
			«ENDFOR»

			// Evaluate loop condition with variables at time n
			continueLoop = («whileCondition.content»);

			if (continueLoop)
			{
				«instruction.innerContent»
			} 
		} while (continueLoop);
		«IF caller.main && irRoot.postProcessing !== null»
			// force a last output at the end
			dumpVariables(«itVar»);
		«ENDIF»
	'''

	private static def dispatch CharSequence getInnerContent(TimeLoopJob it)
	'''
		«instruction.innerContent»
	'''
}