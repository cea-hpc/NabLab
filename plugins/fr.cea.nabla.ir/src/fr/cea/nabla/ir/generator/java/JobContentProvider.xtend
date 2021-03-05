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
		«FOR c  : copies»
			«c.content»
		«ENDFOR»
	'''

	private static def getContent(TimeLoopCopy it)
	{
		// c.destination.type == c.source.type
		val t = source.type
		switch t
		{
			BaseType: copyBaseType(destination.name, source.name, t.sizes.size, new ArrayList<CharSequence>())
			ConnectivityType: copyBaseType(destination.name, source.name, t.connectivities.size + t.base.sizes.size, new ArrayList<CharSequence>())
			LinearAlgebraType: copyLinearAlgebraType(destination.name, source.name, t.sizes.size, new ArrayList<CharSequence>())
		}
	}

	private static def CharSequence copyBaseType(String leftName, String rightName, int dimension, List<CharSequence> indexNames)
	{
		if (dimension == 0)
			'''«leftName»«FOR i : indexNames»[«i»]«ENDFOR» = «rightName»«FOR i : indexNames»[«i»]«ENDFOR»;'''
		else
		{
			val length = '''«leftName»«FOR i : indexNames»[«i»]«ENDFOR».length'''
			var indexName = '''i«indexNames.size + 1»'''
			indexNames += indexName
			// first loop
			if (indexNames.size == 1)
			'''
				IntStream.range(0, «length»).parallel().forEach(«indexName» ->
				{
					«copyBaseType(leftName, rightName, dimension-1, indexNames)»
				});
			'''
			else
			'''
				for (int «indexName»=0 ; «indexName»<«length» ; «indexName»++)
					«copyBaseType(leftName, rightName, dimension-1, indexNames)»
			'''
		}
	}

	private static def CharSequence copyLinearAlgebraType(String leftName, String rightName, int dimension, List<CharSequence> indexNames)
	{
		if (dimension == 0)
			'''«leftName».setValue(«FOR i : indexNames SEPARATOR ', '»«i»«ENDFOR», «rightName».getValue(«FOR i : indexNames SEPARATOR ', '»«i»«ENDFOR»));'''
		else
		{
			val length = '''«leftName»«FOR i : indexNames BEFORE '.getValue(' SEPARATOR ', ' AFTER ')'»«i»«ENDFOR».getSize()'''
			var indexName = '''i«indexNames.size + 1»'''
			indexNames += indexName
			// first loop
			if (indexNames.size == 1)
			'''
				IntStream.range(0, «length»).parallel().forEach(«indexName» ->
				{
					«copyLinearAlgebraType(leftName, rightName, dimension-1, indexNames)»
				});
			'''
			else
			'''
				for (int «indexName»=0 ; «indexName»<«length» ; «indexName»++)
					«copyLinearAlgebraType(leftName, rightName, dimension-1, indexNames)»
			'''
		}
	}

//	private static def CharSequence copy(Variable left, Variable right, int dimension, List<CharSequence> indexNames)
//	{
//		if (dimension == 0)
//			if (left.linearAlgebra)
//				'''«left.name».setValue(«formatIteratorsAndIndices(left.type, indexNames)», «right.name».getValue(«formatIteratorsAndIndices(right.type, indexNames)»));'''
//			else
//				'''«left.name»«formatIteratorsAndIndices(left.type, indexNames)» = «right.name»«formatIteratorsAndIndices(right.type, indexNames)»;'''
//		else
//		{
//			var indexName = '''i«dimension»'''
//			indexNames += indexName
//			// first loop
//			if (indexNames.size == 1)
//			'''
//				IntStream.range(0, «length(left, indexNames)»).parallel().forEach(«indexName» ->
//				{
//					«copy(left, right, dimension-1, indexNames)»
//				});
//			'''
//			else
//			'''
//				for (int «indexName»=0 ; «indexName»<«length(left, indexNames)» ; «indexName»++)
//					«copy(left, right, dimension-1, indexNames)»
//			'''
//		}
//	}
//
//	private static def CharSequence length(Variable v, Iterable<CharSequence> indexNames)
//	{
//		val lengthCall = (v.linearAlgebra ? ".getSize()" : ".length")
//		if (indexNames.size === 0)
//			return v.name + lengthCall
//		else
//			if (v.linearAlgebra)
//				'''«v.name».getValue(«formatIteratorsAndIndices(v.type, indexNames)»)'''
//			else
//				'''«v.name»«formatIteratorsAndIndices(v.type, indexNames)»'''
//	}
}