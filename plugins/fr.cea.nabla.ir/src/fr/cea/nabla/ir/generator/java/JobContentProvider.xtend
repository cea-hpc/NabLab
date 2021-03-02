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
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList
import java.util.List

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.InstructionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.TypeContentProvider.*

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
				// Switch variables to prepare next iteration
				«FOR copy : copies»
					«copy.destination.type.javaType» tmp_«copy.destination.name» = «copy.destination.name»;
					«copy.destination.name» = «copy.source.name»;
					«copy.source.name» = tmp_«copy.destination.name»;
				«ENDFOR»
			} 
		} while (continueLoop);
		«IF caller.main && irRoot.postProcessing !== null»
			// force a last output at the end
			dumpVariables(«itVar»);
		«ENDIF»
	'''

	private static def dispatch CharSequence getInnerContent(TimeLoopJob it)
	'''
		«FOR copy : copies»
			«copy(copy.destination, copy.source, copy.destination.type.dimension, true, new ArrayList<String>(), null)»
		«ENDFOR»
	'''

	private static def CharSequence copy(Variable left, Variable right, int dimension, boolean firstLoop, List<String> indexNames, String newIndexName)
	{
		if (newIndexName !== null)
			indexNames += newIndexName
		if (dimension == 0)
			if (left.linearAlgebra && indexNames.size === 1)
				left.name + ".set(" + indexNames.get(0) + ", " + right.name + "[" + indexNames.get(0) + "]);"
			else if (left.linearAlgebra && indexNames.size === 2)
				left.name + " .set(" + indexNames.get(0) + ", " + indexNames.get(1) + ", " + right.name + "[" + indexNames.get(0) + "][" + indexNames.get(1) + "]);"
			else
				left.name + indexNames.map[s|"["+s+"]"].join + " = " + right.name + indexNames.map[s|"["+s+"]"].join + ";"
		else
		{
			var indexName = 'i' + dimension
			if (firstLoop)
			'''
				IntStream.range(0, «length(left, indexNames)»).parallel().forEach(«indexName» -> 
				{
					«copy(left, right, dimension-1, false, indexNames, indexName)»
				});
			'''
			else
			'''
				for (int «indexName»=0 ; «indexName»<«length(left, indexNames)» ; «indexName»++)
					«copy(left, right, dimension-1, false, indexNames, indexName)»
			'''
		}
	}

	private static def CharSequence length(Variable v, List<String> indexNames)
	{
		val lengthCall = (v.linearAlgebra ? ".getSize()" : ".length")
		if (indexNames.size === 0)
			return v.name + lengthCall
		else
			if (v.linearAlgebra)
				return v.name + indexNames.map[s | ".get(" + s + ")"].join + lengthCall
			else
				return v.name + indexNames.map[s | "[" + s + "]"].join + lengthCall
	}
}