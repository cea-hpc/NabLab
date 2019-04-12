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

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.EndOfInitJob
import fr.cea.nabla.ir.ir.EndOfTimeLoopJob
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.Job

class JobContentProvider 
{
	@Inject extension Utils
	@Inject extension InstructionContentProvider
	
	def getContent(Job it)
	'''
		«comment»
		void «name.toFirstLower»()
		{
			«innerContent»
		}
	'''
	
	private def dispatch CharSequence getInnerContent(InstructionJob it)
	'''
		«instruction.innerContent»
	'''
	
	private def dispatch CharSequence getInnerContent(EndOfTimeLoopJob it)
	'''
		auto tmpSwitch = «left.name»;
		«left.name» = «right.name»;
		«right.name» = tmpSwitch;
	'''

	private def dispatch CharSequence getInnerContent(EndOfInitJob it)
	'''
		Kokkos::parallel_for(«left.name».dimension_0(), KOKKOS_LAMBDA(const int i)
		{
			«left.name»(i) = «right.name»(i);
		});
	'''
}