package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.Job
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
class JobCallsContentProvider
{
	protected val TraceContentProvider traceContentProvider

	def getContent(Iterable<Job> jobs)
	'''
		«FOR j : jobs.sortByAtAndName»
		«j.codeName»(); // @«j.at»
		«ENDFOR»
	'''
}

@Data
class KokkosTeamThreadJobCallsContentProvider extends JobCallsContentProvider
{
	override getContent(Iterable<Job> jobs)
	'''
		«var nbTimes = 0»
		«val jobsByAt = jobs.groupBy[at]»
		«FOR at : jobsByAt.keySet.sort»
			«val atJobs = jobsByAt.get(at)»
			// @«at»
			«IF (atJobs.forall[!hasIterable])»
				«FOR j : atJobs.sortBy[name]»
				«j.codeName»();
				«ENDFOR»
			«ELSE»
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				«FOR j : atJobs.sortBy[name]»
					«IF nbTimes++==0»
						«traceContentProvider.getTeamOfThreadsInfo(j.topLevel)»
					«ENDIF»
					«IF !j.hasLoop»
					if (thread.league_rank() == 0)
						«IF !j.hasIterable /* Only simple instruction jobs */»
							Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){«j.codeName»();});
						«ELSE /* Only for jobs containing ReductionInstruction */»
							«j.codeName»(thread);
						«ENDIF»
					«ELSE»
						«j.codeName»(thread);
					«ENDIF»
				«ENDFOR»
			});
			«ENDIF»

		«ENDFOR»
	'''
}