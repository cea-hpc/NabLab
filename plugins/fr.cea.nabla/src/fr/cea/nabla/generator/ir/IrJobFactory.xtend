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

	def create IrFactory::eINSTANCE.createBeginOfTimeLoopJob toIrBeginOfTimeLoopJob(TimeIterator ti)
	{
		name = "Begin of " + ti.name + " time loop"
	}

	def create IrFactory::eINSTANCE.createEndOfTimeLoopJob toIrEndOfTimeLoopJob(TimeIterator ti)
	{ 
		name = "End of " + ti.name + " time loop"
		whileCondition = ti.cond.toIrExpression
	}
}