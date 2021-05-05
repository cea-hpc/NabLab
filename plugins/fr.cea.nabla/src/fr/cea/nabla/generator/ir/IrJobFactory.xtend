/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.TimeIterator

import static fr.cea.nabla.ir.JobExtensions.*

@Singleton
class IrJobFactory
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrInstructionFactory
	@Inject extension IrArgOrVarFactory
	@Inject extension IrExpressionFactory

	def create IrFactory::eINSTANCE.createJob toIrInstructionJob(Job j)
	{
		annotations += j.toIrAnnotation
		name = j.name
		onCycle = false
		instruction = j.instruction.toIrInstruction
		JobDependencies.computeAndSetInOutVars(it)
	}

	/** SetUpTimeLoopJob in/out vars are set in ArgOrVarFactory during time variable creation */
	def create IrFactory::eINSTANCE.createJob toIrSetUpTimeLoopJob(TimeIterator ti)
	{
		annotations += ti.toIrAnnotation
		name = ti.setUpTimeLoopJobName
		onCycle = false
		timeLoopJob = true
	}

	/** TearDownTimeLoopJob in/out vars are set in ArgOrVarFactory during time variable creation */
	def create IrFactory::eINSTANCE.createJob toIrTearDownTimeLoopJob(TimeIterator ti)
	{ 
		annotations += ti.toIrAnnotation
		name = ti.tearDownTimeLoopJobName
		onCycle = false
		timeLoopJob = true
	}

	/** ExecuteTimeLoopJob in/out vars are set in ArgOrVarFactory during time variable creation */
	def create IrFactory::eINSTANCE.createExecuteTimeLoopJob toIrExecuteTimeLoopJob(TimeIterator ti)
	{
		annotations += ti.toIrAnnotation
		name = ti.executeTimeLoopJobName
		onCycle = false
		iterationCounter = ti.toIrIterationCounter
		whileCondition = ti.condition.toIrExpression
		timeLoopJob = true
	}

	def getSetUpTimeLoopJobName(TimeIterator ti) { SETUP_TIMELOOP_PREFIX + ti.name.toFirstUpper }
	def getTearDownTimeLoopJobName(TimeIterator ti) { TEARDOWN_TIMELOOP_PREFIX + ti.name.toFirstUpper }
	def getExecuteTimeLoopJobName(TimeIterator ti) { EXECUTE_TIMELOOP_PREFIX + ti.name.toFirstUpper }
}