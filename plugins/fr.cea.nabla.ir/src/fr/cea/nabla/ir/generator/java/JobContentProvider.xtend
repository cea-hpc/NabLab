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

import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.TimeLoop
import fr.cea.nabla.ir.ir.TimeLoopCopyJob
import fr.cea.nabla.ir.ir.TimeLoopJob

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
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

	private static def dispatch CharSequence getInnerContent(TimeLoopJob it)
	'''
		«val itVar = timeLoop.iterationCounter.name»
		«itVar» = 0;
		boolean continueLoop = true;
		do
		{
			«itVar»++;
			System.out.printf("«timeLoop.indentation»[%5d] t: %5.5f - deltat: %5.5f\n", «itVar», «irModule.timeVariable.name», «irModule.deltatVariable.name»);
			«IF topLevel && irModule.postProcessingInfo !== null»
				«val ppInfo = irModule.postProcessingInfo»
				if («ppInfo.periodReference.codeName» >= «ppInfo.lastDumpVariable.codeName» + «ppInfo.periodValue.codeName»)
					dumpVariables(«itVar»);
			«ENDIF»
			«FOR j : innerJobs»
				«j.codeName»(); // @«j.at»
			«ENDFOR»

			// Evaluate loop condition with variables at time n
			continueLoop = «timeLoop.whileCondition.content»;

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
		«IF topLevel && irModule.postProcessingInfo !== null»
			// force a last output at the end
			dumpVariables(«itVar»);
		«ENDIF»
	'''

	private static def dispatch CharSequence getInnerContent(TimeLoopCopyJob it)
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

	private static def String getIndentation(TimeLoop it)
	{
		if (outerTimeLoop === null) ''
		else getIndentation(outerTimeLoop) + '\t'
	}
}