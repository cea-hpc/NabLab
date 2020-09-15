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

	/**
	 * Dispacth IrModule jobs in their corresponding job containers.
	 * First, TimeLoopCopyJob instances are dispatched in the container
	 * associated to their TimeLoop.
	 * Then, other jobs will be dispatched during a graph traversal.
	 */
	def void dispatchJobsInTimeLoops(IrModule it)
	{
		// Dispatch TimeLoopCopyJob instances
		if (mainTimeLoop !== null)
			dispatchTimeLoopCopyJobs(jobs.filter(TimeLoopCopyJob), it, mainTimeLoop)

		for (j : jobs.filter[x | !(x instanceof TimeLoopCopyJob) && x.previousJobs.empty])
			if (shouldCrossJob(it, j, ''))
				ditl(it, j, '')
	}

	private def void dispatchTimeLoopCopyJobs(Iterable<TimeLoopCopyJob> jobs, JobContainer c, TimeLoop timeLoopAssociatedToC)
	{
		println("distributeTimeLoopJobs " + timeLoopAssociatedToC.name)
		println("   inner jobs before : " + c.innerJobs.map[name].join(', '))
		c.innerJobs += jobs.filter[timeLoop === timeLoopAssociatedToC]
		println("   inner jobs after : " + c.innerJobs.map[name].join(', '))

		if (timeLoopAssociatedToC.innerTimeLoop !== null)
			dispatchTimeLoopCopyJobs(jobs.filter[timeLoop !== timeLoopAssociatedToC], timeLoopAssociatedToC.associatedJob, timeLoopAssociatedToC.innerTimeLoop)
		println
	}

	private def void ditl(JobContainer jc, Job job, String prefix)
	{
		println(prefix + "ditl(" + jc.name + ", " + job.name + ")")
		if (! (job instanceof TimeLoopCopyJob))
		{
			println(prefix + jc.name + " <-- " + job.name)
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
							if (shouldCrossJob(job, j, prefix))
								ditl(job, j, prefix + '\t')
			}
			AfterTimeLoopJob:
			{
				for (next : job.nextJobs)
					if (shouldCrossJob(job.jobContainer, next, prefix))
						ditl(job.jobContainer, next, prefix + '\t')
			}
			default:
			{
				println(prefix + "next de " + job.name + " : " + job.nextJobs.map[name].join(', '))
				for (next : job.nextJobs)
					if (shouldCrossJob(jc, next, prefix))
						ditl(jc, next, prefix + '\t')
			}
		}
	}

	private def boolean shouldCrossJob(JobContainer container, Job job, String prefix)
	{
		println(prefix + "shouldCross(" + container.name  + ", " + job.name + ")")
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