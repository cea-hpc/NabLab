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
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorBlock
import java.util.LinkedHashSet
import org.eclipse.xtext.EcoreUtil2

class IrJobFactory
{
	@Inject extension IrAnnotationHelper
	@Inject extension TimeIteratorExtensions
	@Inject extension IrInstructionFactory
	@Inject extension IrArgOrVarFactory
	@Inject extension IrExpressionFactory
	@Inject extension IrTimeLoopFactory

	def dispatch Iterable<TimeLoopJob> createIrJobs(TimeIteratorBlock ti)
	{
		val jobs = new LinkedHashSet<TimeLoopJob>
		ti.iterators.forEach[x | jobs += createIrJobs(x)]
		return jobs
	}

	def dispatch Iterable<TimeLoopJob> createIrJobs(TimeIterator ti)
	{
		val jobs = new LinkedHashSet<TimeLoopJob>
		val nablaModule = EcoreUtil2.getContainerOfType(ti, NablaModule)
		val tiArgOrVarRefs = nablaModule.eAllContents.filter(ArgOrVarRef).filter[x | !x.timeIterators.empty && x.timeIterators.last.target === ti]
		val tiInitArgOrVarRefs = tiArgOrVarRefs.filter[x | x.timeIterators.last instanceof InitTimeIteratorRef]
		val parentTi = ti.parentTimeIterator

		// Time loop job creation
		jobs += ti.toIrExecuteTimeLoopJob
		// TearDown job not created if ti represents the top level loop
		if (parentTi !== null)
			jobs += ti.toIrTearDownTimeLoopJob
		// SetUp job not created if no init variable like "X_n0" and ti represents the top level loop
		if (parentTi !== null || !tiInitArgOrVarRefs.empty)
			jobs += ti.toIrSetUpTimeLoopJob

		// Idem for inner time iterator if exists
		if (ti.innerIterator !== null) jobs += createIrJobs(ti.innerIterator)

		return jobs
	}

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
		timeLoop = ti.toIrTimeLoop
	}

	def create IrFactory::eINSTANCE.createTearDownTimeLoopJob toIrTearDownTimeLoopJob(TimeIterator ti)
	{ 
		annotations += ti.toIrAnnotation
		name = ti.tearDownTimeLoopJobName
		timeLoop = ti.toIrTimeLoop
	}

	def create IrFactory::eINSTANCE.createExecuteTimeLoopJob toIrExecuteTimeLoopJob(TimeIterator ti)
	{
		annotations += ti.toIrAnnotation
		name = ti.executeTimeLoopJobName
		iterationCounter = ti.toIrIterationCounter
		whileCondition = ti.condition.toIrExpression
		timeLoop = ti.toIrTimeLoop
		timeLoop.associatedJob = it
	}

	def getSetUpTimeLoopJobName(TimeIterator ti) { "SetUpTimeLoop" + ti.name.toFirstUpper }
	def getTearDownTimeLoopJobName(TimeIterator ti) { "TearDownTimeLoop" + ti.name.toFirstUpper }
	def getExecuteTimeLoopJobName(TimeIterator ti) { "ExecuteTimeLoop" + ti.name.toFirstUpper }
}