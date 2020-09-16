/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.TimeLoop
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.Job
import org.eclipse.emf.ecore.util.EcoreUtil

class IrJobFactory
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

	def create IrFactory::eINSTANCE.createBeforeTimeLoopJob toIrBeforeTimeLoopJob(TimeLoop tl)
	{
		annotations += EcoreUtil::copyAll(tl.annotations)
		name = "SetUpTimeLoop" + tl.name.toFirstUpper
		timeLoop = tl

		// if x^{n+1, k=0} exists, x^{n+1, k} = x^{n+1, k=0}
		// else x^{n+1, k} = x^{n}
		for (v : tl.variables)
		{
			if (v.init !== null)
				copies += toIrCopy(v.init, v.current)
			else if (tl.container instanceof TimeLoop) // inner loop
			{
				val outerV = (tl.container as TimeLoop).variables.findFirst[name == v.name]
				copies += toIrCopy(outerV.current, v.current)
			}
		}
	}

	def create IrFactory::eINSTANCE.createAfterTimeLoopJob toIrAfterTimeLoopJob(TimeLoop tl)
	{ 
		annotations += EcoreUtil::copyAll(tl.annotations)
		name = "TearDownTimeLoop" + tl.name.toFirstUpper
		timeLoop = tl

		// x^{n+1} = x^{n+1, k+1}
		if (tl.container instanceof TimeLoop) // inner loop
			for (v : tl.variables)
			{
				val outerV = (tl.container as TimeLoop).variables.findFirst[name == v.name]
				if (outerV !== null) copies += toIrCopy(v.next, outerV.next)
			}
	}

	def create IrFactory::eINSTANCE.createTimeLoopJob toIrTimeLoopJob(TimeLoop tl)
	{
		annotations += EcoreUtil::copyAll(tl.annotations)
		name = "ExecuteTimeLoop" + tl.name.toFirstUpper
		timeLoop= tl
		tl.associatedJob = it

		// variables copy for next iteration
		// x^{n+1, k} <---> x^{n+1, k+1}
		for (v : tl.variables)
			copies += toIrCopy(v.next, v.current)
	}

	private def create IrFactory::eINSTANCE.createTimeLoopCopy toIrCopy(Variable from, Variable to)
	{
		source = from
		destination = to
	}
}