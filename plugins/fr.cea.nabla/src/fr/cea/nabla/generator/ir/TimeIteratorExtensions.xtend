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
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.nabla.AbstractTimeIterator
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorBlock
import fr.cea.nabla.nabla.TimeIteratorDefinition
import java.util.ArrayList
import org.eclipse.xtext.EcoreUtil2

class TimeIteratorExtensions
{
	@Inject extension IrJobFactory
	@Inject extension IrArgOrVarFactory

	/**
	 * Dispatch method that creates TimeLoopJob instances and iteration counter Variable instances.
	 * Other variables (X_n, X_nplus1...) are not created here. They are created
	 * in their Nabla order to keep the consistency of default values.
	 */
	def dispatch void addJobsAndCountersToModule(TimeIteratorBlock ti, IrModule irModule)
	{
		ti.iterators.forEach[x | addJobsAndCountersToModule(x, irModule)]
	}

	def dispatch void addJobsAndCountersToModule(TimeIterator ti, IrModule irModule)
	{
		val nablaModule = EcoreUtil2.getContainerOfType(ti, NablaModule)
		val tiArgOrVarRefs = nablaModule.eAllContents.filter(ArgOrVarRef).filter[x | !x.timeIterators.empty && x.timeIterators.last.target === ti]
		val tiInitArgOrVarRefs = tiArgOrVarRefs.filter[x | x.timeIterators.last instanceof InitTimeIteratorRef]
		val parentTi = ti.parentTimeIterator
		val caller = (parentTi === null ? null : parentTi.toIrExecuteTimeLoopJob)
		val ic = ti.toIrIterationCounter

		// Time loop job creation
		val createdJobs = new ArrayList<TimeLoopJob>
		createdJobs += ti.toIrExecuteTimeLoopJob => [iterationCounter = ic]
		// TearDown job not created if ti represents the top level loop
		if (parentTi !== null)
			createdJobs += ti.toIrTearDownTimeLoopJob
		// SetUp job not created if no init variable like "X_n0" and ti represents the top level loop
		if (parentTi !== null || !tiInitArgOrVarRefs.empty)
			createdJobs += ti.toIrSetUpTimeLoopJob

		// Add created jobs to the module and in their caller
		irModule.jobs += createdJobs
		if (caller !== null) caller.calls += createdJobs
		irModule.variables += ic

		// Idem for inner time iterator if exists
		if (ti.innerIterator !== null) 
			addJobsAndCountersToModule(ti.innerIterator, irModule)
	}

	def TimeIterator getParentTimeIterator(AbstractTimeIterator it)
	{
		switch eContainer
		{
			TimeIteratorDefinition: null
			TimeIterator: eContainer as TimeIterator
			TimeIteratorBlock: (eContainer as TimeIteratorBlock).parentTimeIterator
		}
	}

	def String getIrVarTimeSuffix(AbstractTimeIterator ti, String type)
	{
		val suffix = switch ti
		{
			TimeIterator: '_' + ti.name + type
			TimeIteratorBlock: ''
		}

		if (ti.eContainer !== null && ti.eContainer instanceof AbstractTimeIterator)
			getIrVarTimeSuffix(ti.eContainer as AbstractTimeIterator, nextTimeIteratorName) + suffix
		else
			suffix
	}

	def getCurrentTimeIteratorName() { '' }
	def getInitTimeIteratorName() { '0' }
	def getNextTimeIteratorName() { 'plus1' }
}