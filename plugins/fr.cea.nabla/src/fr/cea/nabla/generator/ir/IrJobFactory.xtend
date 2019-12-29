/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.TimeIterator

class IrJobFactory 
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrInstructionFactory
	@Inject extension IrExpressionFactory

	def create IrFactory::eINSTANCE.createInstructionJob toIrInstructionJob(Job j)
	{
		annotations += j.toIrAnnotation
		name = j.name
		onCycle = false
		instruction = j.instruction.toIrInstruction
	}

	def create IrFactory::eINSTANCE.createBeforeTimeLoopJob toIrBeforeTimeLoopJob(TimeIterator ti)
	{
		name = "setUpTimeLoop" + ti.name.toFirstUpper
		associatedTimeLoop = ti.toIrTimeLoopJob
	}

	def create IrFactory::eINSTANCE.createAfterTimeLoopJob toIrAfterTimeLoopJob(TimeIterator ti)
	{ 
		name = "tearDownTimeLoop" + ti.name.toFirstUpper
		associatedTimeLoop = ti.toIrTimeLoopJob
	}

	def create IrFactory::eINSTANCE.createNextTimeLoopIterationJob toIrNextTimeLoopIterationJob(TimeIterator ti)
	{ 
		name = "prepareNextIterationOfTimeLoop" + ti.name.toFirstUpper
	}

	def create IrFactory::eINSTANCE.createTimeLoopJob toIrTimeLoopJob(TimeIterator ti)
	{
		timeLoopName = ti.name
		name = "executeTimeLoop" + ti.name.toFirstUpper
		whileCondition = ti.cond.toIrExpression
	}
}