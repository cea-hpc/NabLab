package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.JobCaller

class JobCallerExtensions
{
	static def boolean isMain(JobCaller jc)
	{
		!(jc instanceof ExecuteTimeLoopJob)
	}

	static def String getIndentation(JobCaller jc)
	{
		if (jc instanceof ExecuteTimeLoopJob) getIndentation(jc.caller) + '\t'
		else ''
	}

	static def getName(JobCaller jobCaller)
	{
		if (jobCaller instanceof ExecuteTimeLoopJob)
			jobCaller.name
		else
			"Simulate"
	}
}