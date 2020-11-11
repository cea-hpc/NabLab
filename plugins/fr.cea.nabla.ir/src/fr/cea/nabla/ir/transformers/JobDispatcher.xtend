package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.JobDispatchVarDependencies
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import fr.cea.nabla.ir.ir.TearDownTimeLoopJob
import fr.cea.nabla.ir.ir.TimeLoopJob

import static extension fr.cea.nabla.ir.JobCallerExtensions.*

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
	def void dispatchJobsInTimeLoops(IrModule irModule)
	{
		for (j : irModule.jobs.filter[x | !(x instanceof TimeLoopJob) && x.previousJobs.empty])
			if (continueToDispatch(irModule.main, j, ''))
				dispatchJob(irModule.main, j, '')
	}

	private def void dispatchJob(JobCaller jc, Job job, String prefix)
	{
		//println(prefix + "dispatchJob(" + jc.name + ", " + job.name + ")")
		if (! (job instanceof TimeLoopJob))
		{
			//println(prefix + jc.name + " <-- " + job.name)
			jc.calls += job
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
		(job instanceof TimeLoopJob)
		|| (job.caller === null)
		|| (includes(job.caller, jc, prefix))
	}

	private def boolean includes(JobCaller a, JobCaller b, String prefix)
	{
		//println(prefix + "includes(" + a + ", " + b + ")")
		if (a === b || b.main) return false
		if (a.main) return true
		for (call : a.calls.filter(JobCaller))
			if (call === b || includes(call, b, prefix + '\t'))
				return true
		return false
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