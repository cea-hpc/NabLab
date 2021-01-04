/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
 package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller

class ComputePreviousAndNextJobs extends IrTransformationStep
{
	val JobDependencies jobDependencies

	new()
	{
		super('Compute previous and next jobs of each job')
		jobDependencies = new JobDependencies
	}

	override protected boolean transform(IrRoot ir)
	{
		trace('IR -> IR: ' + description)
		if (ir.main !== null)
		{
			computePreviousAndNextJobsWithSameCaller(ir.main)
		}
		
		return true
	}

	protected def void computePreviousAndNextJobsWithSameCaller(JobCaller jobCaller) {
		for (job : jobCaller.calls)
		{
			computePreviousAndNextJobsWithSameCaller(job)
			if (job instanceof JobCaller)
			{
				(job as JobCaller).computePreviousAndNextJobsWithSameCaller
			}
		}
	}

	protected def void computePreviousAndNextJobsWithSameCaller(Job job) {
		val previousJobs = jobDependencies.getPreviousJobs(job)
		val previousJobsWithSameCaller = previousJobs.filter[x | x.caller === job.caller]
		job.previousJobsWithSameCaller.addAll(previousJobsWithSameCaller)
		if (!previousJobsWithSameCaller.isEmpty)
		{
			val nextJobs = jobDependencies.getNextJobs(job)
			val nextJobsWithSameCaller = nextJobs.filter[x | x.caller === job.caller]
			job.nextJobsWithSameCaller.addAll(nextJobsWithSameCaller)
		}
	}
}
