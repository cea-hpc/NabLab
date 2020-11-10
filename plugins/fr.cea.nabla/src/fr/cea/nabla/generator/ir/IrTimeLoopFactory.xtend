/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.TimeLoopContainer
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorBlock
import java.util.ArrayList

@Singleton
class IrTimeLoopFactory 
{
	@Inject extension IrExpressionFactory
	@Inject extension IrArgOrVarFactory
	@Inject extension IrAnnotationHelper

	def dispatch ArrayList<SimpleVariable> createTimeLoopsAndIterationCounters(TimeLoopContainer tlContainer, TimeIteratorBlock nablaTimeIterator)
	{
		val timeLoopVariables = new ArrayList<SimpleVariable>
		for (ti : nablaTimeIterator.iterators)
			timeLoopVariables += createTimeLoopsAndIterationCounters(tlContainer, ti)
		return timeLoopVariables
	}

	def dispatch ArrayList<SimpleVariable> createTimeLoopsAndIterationCounters(TimeLoopContainer tlContainer, TimeIterator nablaTimeIterator)
	{
		val timeLoopVariables = new ArrayList<SimpleVariable>
		val ic = nablaTimeIterator.toIrIterationCounter
		timeLoopVariables += ic
		val timeLoop = nablaTimeIterator.toIrTimeLoop => [ iterationCounter = ic ]
		tlContainer.innerTimeLoops += timeLoop
		if (nablaTimeIterator.innerIterator !== null)
		{
			timeLoopVariables += createTimeLoopsAndIterationCounters(timeLoop, nablaTimeIterator.innerIterator)
		}
		return timeLoopVariables
	}

	def create IrFactory::eINSTANCE.createTimeLoop toIrTimeLoop(TimeIterator ti)
	{
		annotations += ti.toIrAnnotation
		name = ti.name
		whileCondition = ti.condition.toIrExpression
	}
}