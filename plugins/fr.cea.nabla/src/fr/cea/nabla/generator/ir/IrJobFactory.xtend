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
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.TimeIterator

@Singleton
class IrJobFactory
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrInstructionFactory
	@Inject extension IrArgOrVarFactory
	@Inject extension IrExpressionFactory

	def create IrFactory::eINSTANCE.createInstructionJob toIrInstructionJob(Job j)
	{
		annotations += j.toIrAnnotation
		name = j.name
		onCycle = false
		instruction = j.instruction.toIrInstruction
	}

	def create IrFactory::eINSTANCE.createSetUpTimeLoopJob toIrSetUpTimeLoopJob(TimeIterator ti)
	{
		annotations += ti.toIrAnnotation
		name = ti.setUpTimeLoopJobName
	}

	def create IrFactory::eINSTANCE.createTearDownTimeLoopJob toIrTearDownTimeLoopJob(TimeIterator ti)
	{ 
		annotations += ti.toIrAnnotation
		name = ti.tearDownTimeLoopJobName
	}

	def create IrFactory::eINSTANCE.createExecuteTimeLoopJob toIrExecuteTimeLoopJob(TimeIterator ti)
	{
		annotations += ti.toIrAnnotation
		name = ti.executeTimeLoopJobName
		iterationCounter = ti.toIrIterationCounter
		whileCondition = ti.condition.toIrExpression
	}

	def getSetUpTimeLoopJobName(TimeIterator ti) { "SetUpTimeLoop" + ti.name.toFirstUpper }
	def getTearDownTimeLoopJobName(TimeIterator ti) { "TearDownTimeLoop" + ti.name.toFirstUpper }
	def getExecuteTimeLoopJobName(TimeIterator ti) { "ExecuteTimeLoop" + ti.name.toFirstUpper }
}