package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.JobDispatchVarDependencies
import fr.cea.nabla.ir.ir.AfterTimeLoopJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobContainer
import fr.cea.nabla.ir.ir.TimeLoop
import fr.cea.nabla.ir.ir.TimeLoopCopyJob
import fr.cea.nabla.ir.ir.TimeLoopJob

/** 
 * Split jobs in their corresponding time loops 
 * i.e. add them to 'jobs' of TimeLoopJob instance.
 * Warning: the module must not contain job cycles.
 */
class JobDispatcher
{
	val extension JobDispatchVarDependencies jdvd = new JobDispatchVarDependencies
	val extension JobDependencies  = new JobDependencies(jdvd)

	def void dispatchJobsInTimeLoops(IrModule it)
	{
		if (mainTimeLoop !== null)
			distributeTimeLoopJobs(jobs.filter(TimeLoopCopyJob), it, mainTimeLoop)

		for (j : jobs.filter[x | !(x instanceof TimeLoopCopyJob) && x.previousJobs.empty])
			if (shouldCrossJob(j, it, ''))
				ditl(it, j, '')
	}

	private def void distributeTimeLoopJobs(Iterable<TimeLoopCopyJob> jobs, JobContainer container, TimeLoop tl)
	{
		//println("distributeTimeLoopJobs " + tl.name)
		//println("   inner jobs before : " + container.innerJobs.map[name].join(', '))
		container.innerJobs += jobs.filter[timeLoop === tl]
		//println("   inner jobs after : " + container.innerJobs.map[name].join(', '))

		if (tl.innerTimeLoop !== null)
			distributeTimeLoopJobs(jobs, tl.associatedJob, tl.innerTimeLoop)
		//println
	}

	private def void ditl(JobContainer jc, Job job, String prefix)
	{
		//println(prefix + "ditl(" + jc.name + ", " + job.name + ")")
		if (! (job instanceof TimeLoopCopyJob))
		{
			//println(prefix + jc.name + " <-- " + job.name)
			jc.innerJobs += job
		}
		switch job
		{
			TimeLoopJob:
			{
				val irModule = job.eContainer as IrModule
				for (j : irModule.jobs.filter[x | x !== job])
					for (startLoopVar : job.inVars)
						if (j.inVars.exists[x | x === startLoopVar])
							if (shouldCrossJob(j, job, prefix))
								ditl(job, j, prefix + '\t')
			}
			AfterTimeLoopJob:
			{
				for (next : job.nextJobs)
					if (shouldCrossJob(next, job.jobContainer, prefix))
						ditl(job.jobContainer, next, prefix + '\t')
			}
			default:
			{
				for (next : job.nextJobs)
					if (shouldCrossJob(next, jc, prefix))
						ditl(jc, next, prefix + '\t')
			}
		}
	}

	private def boolean shouldCrossJob(Job job, JobContainer container, String prefix)
	{
		//println(prefix + "shouldCross(" + job.name + ", " + container.name + ")")
		(job instanceof TimeLoopCopyJob)
		|| (job.jobContainer === null)
		|| (job.jobContainer.timeLoop.includes(container.timeLoop, prefix))
	}

	private def boolean includes(TimeLoop a, TimeLoop b, String prefix)
	{
		//println(prefix + "includes(" + a + ", " + b + ")")
		if (a === b || b === null) return false
		if (a === null) return true
		var itl = a.innerTimeLoop
		while (itl !== null)
			if (itl === b) return true
			else itl = itl.innerTimeLoop
		return false
	}

	private def TimeLoop getTimeLoop(JobContainer jc)
	{
		if (jc === null) null
		else switch jc
		{
			TimeLoopJob: jc.timeLoop
			IrModule: null
		}
	}

	private def String getName(JobContainer jc)
	{
		if (jc === null) "null"
		else switch jc
		{
			TimeLoopJob: jc.name
			IrModule: jc.name
		}
	}
}