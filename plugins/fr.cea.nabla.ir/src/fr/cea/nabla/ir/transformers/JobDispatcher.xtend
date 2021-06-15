/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller

import static fr.cea.nabla.ir.JobExtensions.*

import static extension fr.cea.nabla.ir.JobCallerExtensions.*

/**
 * Dispatch jobs in their corresponding time loops
 * i.e. add them to 'jobs' of TimeLoopJob instance.
 * Warning: the module must not contain job cycles.
 */
class JobDispatcher
{
	/** Dispatch IrModule jobs in their corresponding job containers during a graph traversal. */
	def void dispatchJobsInTimeLoops(IrRoot ir)
	{
		for (j : ir.jobs.filter[x | !x.timeLoopJob && x.previousJobs.empty])
			if (continueToDispatch(ir.main, j, ''))
				dispatchJob(ir.main, j, '')
	}

	private def void dispatchJob(JobCaller jc, Job job, String prefix)
	{
		//println(prefix + "dispatchJob(" + jc.name + ", " + job.name + ")")
		if (!job.timeLoopJob)
		{
			//println(prefix + jc.name + " <-- " + job.name)
			jc.calls += job
		}
		switch job
		{
			ExecuteTimeLoopJob:
			{
				val jobRoot = IrUtils.getContainerOfType(job, IrRoot)
				for (j : jobRoot.jobs.filter[x | x !== job])
					for (startLoopVar : job.inVars)
						if (j.inVars.exists[x | x === startLoopVar])
							if (continueToDispatch(job, j, prefix))
								dispatchJob(job, j, prefix + '\t')
			}
			//TearDownTimeLoopJob:
			case (job.timeLoopJob && job.name.startsWith(TEARDOWN_TIMELOOP_PREFIX)):
			{
				for (next : job.nextJobs)
					if (continueToDispatch(job.caller, next, prefix))
						dispatchJob(job.caller, next, prefix + '\t')
			}
			default:
			{
				//println(prefix + "next de " + job.name + " : " + job.nextJobs.map[name].join(', '))
				for (next : job.nextJobs)
					if (continueToDispatch(jc, next, prefix))
						dispatchJob(jc, next, prefix + '\t')
			}
		}
	}

	private def boolean continueToDispatch(JobCaller jc, Job job, String prefix)
	{
		//println(prefix + "continueToDispatch(" + container.name  + ", " + job.name + ")")
		(job.timeLoopJob)
		|| (job.caller === null)
		|| (includes(job.caller, jc, prefix))
	}

	private def boolean includes(JobCaller a, JobCaller b, String prefix)
	{
		//println(prefix + "includes(" + a + ", " + b + ")")
		if (a === b || b.init) return false
		if (a.init) return true
		for (call : a.calls.filter(JobCaller))
			if (call === b || includes(call, b, prefix + '\t'))
				return true
		return false
	}
}