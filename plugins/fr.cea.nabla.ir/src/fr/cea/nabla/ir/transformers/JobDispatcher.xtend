package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.JobDispatchVarDependencies
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobContainer
import fr.cea.nabla.ir.ir.TearDownTimeLoopJob
import fr.cea.nabla.ir.ir.TimeLoop
import fr.cea.nabla.ir.ir.TimeLoopContainer
import fr.cea.nabla.ir.ir.TimeLoopJob

/**
 * Dispatch jobs in their corresponding time loops
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
		// Dispatch TimeLoopJob instances
		dispatchTimeLoopJobs(jobs.filter(TimeLoopJob), it, '')

		for (j : jobs.filter[x | !(x instanceof TimeLoopJob) && x.previousJobs.empty])
			if (continueToDispatch(it, j, ''))
				dispatchJob(it, j, '')
	}

	private def void dispatchTimeLoopJobs(Iterable<TimeLoopJob> jobs, TimeLoopContainer timeLoopContainer, String prefix)
	{
		//println(prefix + "distributeTimeLoopJobs " + timeLoopContainer.name)
		val innerJobs = timeLoopContainer.jobContainer.innerJobs
		//println(prefix + "   inner jobs before : " + innerJobs.map[name].join(', '))
		for (containerTimeLoop : timeLoopContainer.innerTimeLoops)
		{
			//println("      containerTimeLoop : " + containerTimeLoop)
			innerJobs += jobs.filter[timeLoop === containerTimeLoop]
			dispatchTimeLoopJobs(jobs.filter[timeLoop !== containerTimeLoop], containerTimeLoop, prefix + '\t')
		}
		//println(prefix + "   inner jobs after : " + innerJobs.map[name].join(', '))
	}

	private def void dispatchJob(JobContainer jc, Job job, String prefix)
	{
		//println(prefix + "dispatchJob(" + jc.name + ", " + job.name + ")")
		if (! (job instanceof TimeLoopJob))
		{
			//println(prefix + jc.name + " <-- " + job.name)
			jc.innerJobs += job
		}
		switch job
		{
			ExecuteTimeLoopJob:
			{
				val irModule = job.eContainer as IrModule
				for (j : irModule.jobs.filter[x | x !== job])
					for (startLoopVar : job.inVars)
						if (j.inVars.exists[x | x === startLoopVar])
							if (continueToDispatch(job, j, prefix))
								dispatchJob(job, j, prefix + '\t')
			}
			TearDownTimeLoopJob:
			{
				for (next : job.nextJobs)
					if (continueToDispatch(job.jobContainer, next, prefix))
						dispatchJob(job.jobContainer, next, prefix + '\t')
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

	private def boolean continueToDispatch(JobContainer container, Job job, String prefix)
	{
		//println(prefix + "continueToDispatch(" + container.name  + ", " + job.name + ")")
		(job instanceof TimeLoopJob)
		|| (job.jobContainer === null)
		|| (includes(job.jobContainer.timeLoop, container.timeLoop, prefix))
	}

	private def boolean includes(TimeLoop a, TimeLoop b, String prefix)
	{
		//println(prefix + "includes(" + a + ", " + b + ")")
		if (a === b || b === null) return false
		if (a === null) return true
		for (tl : a.innerTimeLoops)
			if (tl === b || includes(tl, b, prefix + '\t'))
				return true
		return false
	}

	private def TimeLoop getTimeLoop(JobContainer jc)
	{
		if (jc === null) null
		else switch jc
		{
			ExecuteTimeLoopJob: jc.timeLoop
			IrModule: null
		}
	}

	private def JobContainer getJobContainer(TimeLoopContainer elt)
	{
		if (elt === null) null
		else switch elt
		{
			TimeLoop: elt.associatedJob
			IrModule: elt
		}
	}

//	private def String getName(JobContainer elt)
//	{
//		if (elt === null) "null"
//		else switch elt
//		{
//			TimeLoopJob: elt.name
//			IrModule: elt.name
//		}
//	}
//
//	private def String getName(TimeLoopContainer elt)
//	{
//		if (elt === null) "null"
//		else switch elt
//		{
//			TimeLoop: elt.name
//			IrModule: elt.name
//		}
//	}
}