package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.JobContainer
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
class JobContainerContentProvider
{
	protected val TraceContentProvider traceContentProvider

	def getCallsHeader(JobContainer it) ''''''

	def getCallsContent(JobContainer it)
	'''
		«FOR j : innerJobs.sortByAtAndName»
		«j.codeName»(); // @«j.at»
		«ENDFOR»

	'''
}

@Data
class KokkosTeamThreadJobContainerContentProvider extends JobContainerContentProvider
{
	override getCallsHeader(JobContainer it)
	{
		if (innerJobs.exists[x | x.hasIterable])
		'''
		auto team_policy(Kokkos::TeamPolicy<>(
			Kokkos::hwloc::get_available_numa_count(),
			Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));

		'''
		else ''''''
	}

	override getCallsContent(JobContainer it)
	'''
		«var nbTimes = 0»
		«val jobsByAt = innerJobs.groupBy[at]»
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