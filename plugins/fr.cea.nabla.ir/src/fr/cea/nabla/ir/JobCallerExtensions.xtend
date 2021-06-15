/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller

import static extension fr.cea.nabla.ir.JobExtensions.getDisplayName

class JobCallerExtensions
{
	static def boolean isInit(JobCaller jc)
	{
		!(jc instanceof ExecuteTimeLoopJob)
	}

	static def boolean isMainTimeLoop(JobCaller jc)
	{
		jc instanceof ExecuteTimeLoopJob && (jc as ExecuteTimeLoopJob).caller.init
	}

	static def getName(JobCaller jobCaller)
	{
		if (jobCaller instanceof ExecuteTimeLoopJob)
			jobCaller.name
		else
			"Simulate"
	}

	static def getDisplayName(JobCaller jc)
	{
		if (jc instanceof Job)
			(jc as Job).displayName
		else
			jc.name
	}
}
