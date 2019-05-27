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
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.TimeIterationCopyJob
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.Job

class JobFactory 
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrInstructionFactory
	
	def create IrFactory::eINSTANCE.createInstructionJob toIrInstructionJob(Job j)
	{
		annotations += j.toIrAnnotation
		name = j.name
		onCycle = false
		instruction = j.instruction.toIrInstruction
	}
	
	def create IrFactory::eINSTANCE.createEndOfInitJob toEndOfInitJob(Variable vAtN0, Variable vAtN)  { init(vAtN, vAtN0) }
	def create IrFactory::eINSTANCE.createEndOfTimeLoopJob toEndOfLoopJob(Variable vAtN, Variable vAtNplus1) { init(vAtN, vAtNplus1) }

	private def init(TimeIterationCopyJob it, Variable vLeft, Variable vRight)
	{
		name = 'Copy_' + vRight.name + '_to_' + vLeft.name
		left = vLeft
		right = vRight
		timeIteratorName = 'n'
	}
}