/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.JobCaller
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.JobCallerExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import fr.cea.nabla.ir.ir.Job

class JobCallerContentProvider
{
	
	def getCallsHeader(JobCaller it) ''''''

	def getCallsContent(JobCaller it)
	'''
		«FOR j : calls»
			«j.callName.replace('.', '->')»(); // @«j.at»
		«ENDFOR»

	'''
}

@Data
class KokkosTeamThreadJobCallerContentProvider extends JobCallerContentProvider
{
	protected val extension PythonEmbeddingContentProvider
	
	override getCallsHeader(JobCaller it)
	{
		if (calls.exists[x | x.hasIterable])
		'''
		auto team_policy(Kokkos::TeamPolicy<>(
			Kokkos::hwloc::get_available_numa_count(),
			Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));

		'''
		else ''''''
	}

	override getCallsContent(JobCaller it)
	'''
		«var nbTimes = 0»
		«val jobsByAt = calls.groupBy[at]»
		«FOR at : jobsByAt.keySet.sort»
			«val atJobs = jobsByAt.get(at)»
			// @«at»
			«IF (atJobs.forall[j | !j.hasIterable || j instanceof JobCaller])»
				«FOR j : atJobs.sortBy[name]»
				«j.callName.replace('.', '->')»();
				«ENDFOR»
			«ELSE»
			#ifdef NABLAB_DEBUG
			{
				const bool shouldReleaseGIL = !(«FOR event : atJobs.map[allExecutionEvents] SEPARATOR ' && '»!monilog.has_registered_moniloggers(«event»)«ENDFOR»);
				if (shouldReleaseGIL)
				{
					py::gil_scoped_release release;
					Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
					{
						py::gil_scoped_acquire acquire;
						«FOR j : atJobs.sortBy[name]»
							«IF nbTimes++==0 && main»
							if (thread.league_rank() == 0)
								Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){
									std::cout << "[" << __GREEN__ << "RUNTIME" << __RESET__ << "]   Using " << __BOLD__ << setw(3) << thread.league_size() << __RESET__ << " team(s) of "
										<< __BOLD__ << setw(3) << thread.team_size() << __RESET__<< " thread(s)" << std::endl;});
							«ENDIF»
							«IF (!j.hasIterable || j instanceof JobCaller) /* Only simple instruction jobs && ExecuteTimeLoopJobs */»
								if (thread.league_rank() == 0)
									Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){«j.callName.replace('.', '->')»();});
							«ELSE»
								«IF j.hasLoop»
									(this->*(«j.callName.replace('.', '->')»Ptr))(thread);
								«ELSE /* Only for jobs containing ReductionInstruction */»
									if (thread.league_rank() == 0)
									{
										(this->*(«j.callName.replace('.', '->')»Ptr))(thread);
									}
								«ENDIF»
							«ENDIF»
						«ENDFOR»
						py::gil_scoped_release release;
					});
					py::gil_scoped_acquire acquire;
				}
				else
				{
					Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
					{
						«FOR j : atJobs.sortBy[name]»
							«IF nbTimes++==0 && main»
							if (thread.league_rank() == 0)
								Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){
									std::cout << "[" << __GREEN__ << "RUNTIME" << __RESET__ << "]   Using " << __BOLD__ << setw(3) << thread.league_size() << __RESET__ << " team(s) of "
										<< __BOLD__ << setw(3) << thread.team_size() << __RESET__<< " thread(s)" << std::endl;});
							«ENDIF»
							«IF (!j.hasIterable || j instanceof JobCaller) /* Only simple instruction jobs && ExecuteTimeLoopJobs */»
								if (thread.league_rank() == 0)
									Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){«j.callName.replace('.', '->')»();});
							«ELSE»
								«IF j.hasLoop»
									(this->*(«j.callName.replace('.', '->')»Ptr))(thread);
								«ELSE /* Only for jobs containing ReductionInstruction */»
									if (thread.league_rank() == 0)
									{
										(this->*(«j.callName.replace('.', '->')»Ptr))(thread);
									}
								«ENDIF»
							«ENDIF»
						«ENDFOR»
					});
				}
			}
			#else
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				«FOR j : atJobs.sortBy[name]»
					«IF nbTimes++==0 && main»
					if (thread.league_rank() == 0)
						Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){
							std::cout << "[" << __GREEN__ << "RUNTIME" << __RESET__ << "]   Using " << __BOLD__ << setw(3) << thread.league_size() << __RESET__ << " team(s) of "
								<< __BOLD__ << setw(3) << thread.team_size() << __RESET__<< " thread(s)" << std::endl;});
					«ENDIF»
					«IF (!j.hasIterable || j instanceof JobCaller) /* Only simple instruction jobs && ExecuteTimeLoopJobs */»
						if (thread.league_rank() == 0)
							Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){«j.callName.replace('.', '->')»();});
					«ELSE»
						«IF j.hasLoop»
							«j.callName.replace('.', '->')»(thread);
						«ELSE /* Only for jobs containing ReductionInstruction */»
							if (thread.league_rank() == 0)
							{
								«j.callName.replace('.', '->')»(thread);
							}
						«ENDIF»
					«ENDIF»
				«ENDFOR»
			});
			#endif
			«ENDIF»

		«ENDFOR»
	'''
}