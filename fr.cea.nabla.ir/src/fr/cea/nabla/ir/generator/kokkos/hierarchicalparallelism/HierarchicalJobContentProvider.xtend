/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.kokkos.JobContentProvider
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction

class HierarchicalJobContentProvider extends JobContentProvider 
{
	@Inject extension Utils
	
	override getJobCallsContent(Iterable<Job> jobs) 
	'''
		«FOR j : jobs.sortBy[at]»
			«j.name.toFirstLower»(); // @«j.at»
		«ENDFOR»
	'''
	
	override getContent(Job it)
	{
		if (eAllContents.exists[i | i instanceof Loop || i instanceof ReductionInstruction])
			parallelHeader
		else
			sequentialHeader
	}
	
	private def getParallelHeader(Job it)
	'''
		«comment»
		KOKKOS_INLINE_FUNCTION
		void «name.toFirstLower»(const member_type& team_member) noexcept
		{
			«innerContent»
		}
	'''

	private def getSequentialHeader(Job it)
	'''
		«comment»
		KOKKOS_INLINE_FUNCTION
		void «name.toFirstLower»(const member_type& team_member) noexcept
		{
			«innerContent»
		}
	'''
}