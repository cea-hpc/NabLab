/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos.defaultparallelism

import fr.cea.nabla.ir.generator.kokkos.JobContentProvider
import fr.cea.nabla.ir.ir.Job

import static extension fr.cea.nabla.ir.generator.Utils.*

class DefaultJobContentProvider extends JobContentProvider 
{
	new() { super(new DefaultInstructionContentProvider) }
	
	override getJobCallsContent(Iterable<Job> jobs)
	'''
		«FOR j : jobs.sortBy[at]»
		«j.codeName»(); // @«j.at»
		«ENDFOR»
	'''
	
	override getContent(Job it)
	'''
		«comment»
		KOKKOS_INLINE_FUNCTION
		void «codeName»() noexcept
		{
			«innerContent»
		}
	'''
}