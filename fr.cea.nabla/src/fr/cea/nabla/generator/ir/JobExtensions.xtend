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
import fr.cea.nabla.VarRefExtensions
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.VarRef
import org.eclipse.emf.common.util.EList

class JobExtensions 
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrInstructionFactory
	@Inject extension IrVariableFactory
	@Inject extension VarRefExtensions
	
	def void populateIrJobs(Job j, EList<fr.cea.nabla.ir.ir.Job> irJobs)
	{
		irJobs += IrFactory::eINSTANCE.createInstructionJob =>
		[
			annotations += j.toIrAnnotation
			name = j.name
			onCycle = false
			instruction = j.instruction.toIrInstruction	
		]
	}
	
	def void populateIrVariablesAndJobs(Job j, EList<Variable> irVariables, EList<fr.cea.nabla.ir.ir.Job> irJobs)
	{
		for (r : j.eAllContents.filter(VarRef).toIterable)
			if (r.hasTimeIterator)
			{
				val vCurrent = r.variable.toIrVariable('')
				val vNext = r.variable.toIrVariable(r.timeSuffix)
				irVariables += vNext
				if (r.timeIteratorDiv == 0) irJobs += toIrCopyJob(vCurrent, vNext) 
			}
	}
	
	private def create IrFactory::eINSTANCE.createTimeIterationCopyJob toIrCopyJob(Variable current, Variable next)
	{
		name = 'Copy_' + next.name + '_to_' + current.name
		left = current
		right = next
		timeIteratorName = 'n'
	}
}