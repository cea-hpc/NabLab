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

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.InstructionContentProvider.*

class JobContentProvider 
{
	static def getContent(Job it)
	'''
		«comment»
		private void «codeName»()
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
			System.out.printf("«caller.indentation»[%5d] t: %5.5f - deltat: %5.5f\n", «itVar», «irModule.timeVariable.codeName», «irModule.timeStepVariable.codeName»);
			«IF caller.main && irModule.postProcessing !== null»
				«val ppInfo = irModule.postProcessing»
				if («ppInfo.periodReference.codeName» >= «ppInfo.lastDumpVariable.codeName» + «ppInfo.periodValue.codeName»)
					dumpVariables(«itVar»);
			«ENDIF»
			«FOR j : calls»
				«j.codeName»(); // @«j.at»
			«ENDFOR»

			// Evaluate loop condition with variables at time n
			continueLoop = («whileCondition.content»);

			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				«FOR copy : copies»
					«copy.destination.javaType» tmp_«copy.destination.name» = «copy.destination.name»;
					«copy.destination.name» = «copy.source.name»;
					«copy.source.name» = tmp_«copy.destination.name»;
				«ENDFOR»
			} 
		} while (continueLoop);
		«IF caller.main && irModule.postProcessing !== null»
			// force a last output at the end
			dumpVariables(«itVar»);
		«ENDIF»
	'''

	private static def dispatch CharSequence getInnerContent(TimeLoopJob it)
	'''
		«FOR copy : copies»
			«copy(copy.destination.name, copy.source.name, copy.destination.type.dimension, true)»
		«ENDFOR»
	'''

	private static def CharSequence copy(String left, String right, int dimension, boolean firstLoop)
	{
		if (dimension == 0)
			'''«left» = «right»;'''
		else
		{
			val indexName = 'i' + dimension
			val suffix = '[' + indexName + ']'
			'''
				«IF firstLoop»
				IntStream.range(0, «left».length).parallel().forEach(«indexName» -> 
				{
					«copy(left + suffix, right + suffix, dimension-1, false)»
				});
				«ELSE»
				for (int «indexName»=0 ; «indexName»<«left».length ; «indexName»++)
					«copy(left + suffix, right + suffix, dimension-1, false)»
				«ENDIF»
			'''
		}
	}
}