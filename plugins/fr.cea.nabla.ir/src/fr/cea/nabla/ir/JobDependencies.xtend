/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller

import static extension fr.cea.nabla.ir.JobCallerExtensions.*

class JobDependencies
{
	static def void computeAndSetNextJobs(Job it)
	{
		outVars.forEach[x | nextJobs += x.consumerJobs]
	}

	/**
	 * Set in and out variables collection of each job.
	 * In/out variables of time loop jobs (SetUp/TearDown/Execute) are set during IR building (NabLab -> IR) to avoid cycle.
	 * For other jobs they are computed through ArgOrVarRef instances.
	 * For ExecuteTimeLoop jobs, two groups of in variables have to be added:
	 *   - variables used in the time loop condition
	 *   - variables used in post processing (only for root loop)
	 * For InitVariablesJob with no default value, there is no Affectation instruction,
	 * consequently, outVars must be set with the target variable (variable initialized with the job).
	 */
	static def void computeAndSetInOutVars(Job it)
	{
		switch it
		{
			ExecuteTimeLoopJob:
			{
				inVars += IrUtils.getInVars(whileCondition)
				// main loop ?
				if (caller.main)
				{
					val irRoot = IrUtils.getContainerOfType(it, IrRoot)
					if (irRoot.postProcessing !== null)
					{
						inVars += irRoot.postProcessing.lastDumpVariable
						inVars += irRoot.postProcessing.periodValue
					}
				}
			}
			case !timeLoopJob:
			{
				outVars += IrUtils.getOutVars(it)
				inVars += IrUtils.getInVars(it)
			}
		}
	}

	static def void computeAndSetNextJobsWithSameCaller(Job it)
	{
		for (j : nextJobs)
		{
			if (j.caller === caller)
				nextJobsWithSameCaller += j
			else
			{
				val parent = getExecuteTimeLoopJobWithSameCaller(j, caller)
				if (parent !== null)
					nextJobsWithSameCaller += parent
			}
		}
	}

	private static def ExecuteTimeLoopJob getExecuteTimeLoopJobWithSameCaller(Job j, JobCaller parentCaller)
	{
		if (j.caller !== null && j.caller instanceof ExecuteTimeLoopJob)
		{
			val c = j.caller as ExecuteTimeLoopJob
			if (c.caller === parentCaller) c
			else getExecuteTimeLoopJobWithSameCaller(c, parentCaller)
		}
		else
			null
	}
}
