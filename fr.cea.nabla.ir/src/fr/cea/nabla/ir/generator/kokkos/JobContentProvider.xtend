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
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.EndOfInitJob
import fr.cea.nabla.ir.ir.EndOfTimeLoopJob
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.Job

abstract class JobContentProvider 
{
	extension InstructionContentProvider icp
	
	new(InstructionContentProvider icp) { this.icp = icp }
	
	abstract def CharSequence getJobCallsContent(Iterable<Job> jobs)
	abstract def CharSequence getContent(Job it)
	
	protected def dispatch CharSequence getInnerContent(InstructionJob it)
	'''
		«instruction.innerContent»
	'''
	
	protected def dispatch CharSequence getInnerContent(EndOfTimeLoopJob it)
	'''
		std::swap(«right.name», «left.name»);
	'''

	protected def dispatch CharSequence getInnerContent(EndOfInitJob it)
	'''
		deep_copy(«left.name», «right.name»);
	'''
}