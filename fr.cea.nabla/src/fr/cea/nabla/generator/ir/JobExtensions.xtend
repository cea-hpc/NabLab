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
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.InstructionJob
import fr.cea.nabla.nabla.TimeLoopJob
import fr.cea.nabla.nabla.VarRef
import org.eclipse.emf.common.util.EList

class JobExtensions 
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrInstructionFactory
	@Inject extension IrVariableFactory
	
	def dispatch void populateIrJobs(InstructionJob j, EList<Job> irJobs)
	{
		irJobs += IrFactory::eINSTANCE.createInstructionJob =>
		[
			annotations += j.toIrAnnotation
			name = j.name
			onCycle = false
			instruction = j.instruction.toIrInstruction	
		]
	}
	
	def dispatch void populateIrJobs(TimeLoopJob j, EList<Job> irJobs)
	{
		irJobs += IrFactory::eINSTANCE.createInstructionJob =>
		[
			annotations += j.toIrAnnotation
			name = 'Init_' + j.name
			onCycle = false
			instruction = j.initialization.toIrInstruction
		]
		
		irJobs += IrFactory::eINSTANCE.createInstructionJob =>
		[
			annotations += j.toIrAnnotation
			name = 'Compute_' + j.name
			onCycle = false
			instruction = j.body.toIrInstruction	
		]
	}

	def void populateIrVariablesAndJobs(TimeLoopJob j, EList<Variable> irVariables, EList<Job> irJobs)
	{
		for (r : j.body.eAllContents.filter(VarRef).toIterable)
			if (r.timeIterator!==null && r.timeIterator.next)
			{
				val vCurrent = r.variable.toIrVariable(null)
				val vNext = r.variable.toIrVariable(r.timeIterator)
				irVariables += vNext
				irJobs += toIrCopyJob(vCurrent, vNext, r.timeIterator.iterator.name) 
			}
	}
	
	private def create IrFactory::eINSTANCE.createTimeIterationCopyJob toIrCopyJob(Variable current, Variable next, String tiName)
	{
		name = 'Copy_' + next.name + '_to_' + current.name
		left = current
		right = next
		timeIteratorName = tiName
	}
}