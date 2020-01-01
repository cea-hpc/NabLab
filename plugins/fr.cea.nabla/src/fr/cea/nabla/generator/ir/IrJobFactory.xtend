/*******************************************************************************
 * Copyright (c) 2018 CEA
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
		name = "setUpTimeLoop" + tl.name.toFirstUpper
		timeLoop = tl
		for (v : tl.variables.filter[v | v.init !== null])
			copies += toIrCopy(v.init, v.current)
	}

	def create IrFactory::eINSTANCE.createAfterTimeLoopJob toIrAfterTimeLoopJob(TimeLoop tl)
	{ 
		name = "tearDownTimeLoop" + tl.name.toFirstUpper
		timeLoop = tl
		if (tl.outerTimeLoop !== null)
			for (v : tl.variables)
			{
				val outerV = tl.outerTimeLoop.variables.findFirst[name == v.name]
				if (outerV !== null) copies += toIrCopy(v.next, outerV.next)
			}
	}

	def create IrFactory::eINSTANCE.createNextTimeLoopIterationJob toIrNextTimeLoopIterationJob(TimeLoop tl)
	{ 
		name = "prepareNextIterationOfTimeLoop" + tl.name.toFirstUpper
		timeLoop = tl
		for (v : tl.variables)
			copies += toIrCopy(v.next, v.current)
	}

	def create IrFactory::eINSTANCE.createTimeLoopJob toIrTimeLoopJob(TimeLoop tl)
	{
		name = "executeTimeLoop" + tl.name.toFirstUpper
		timeLoop= tl
	}

	private def create IrFactory::eINSTANCE.createTimeLoopCopy toIrCopy(Variable from, Variable to)
	{
		source = from
		destination = to
	}
}