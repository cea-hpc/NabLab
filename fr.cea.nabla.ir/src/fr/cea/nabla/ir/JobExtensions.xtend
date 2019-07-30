/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.TimeIterationCopyJob
import fr.cea.nabla.ir.ir.VarRef
import fr.cea.nabla.ir.ir.Variable
import java.util.HashSet

import static extension fr.cea.nabla.ir.VariableExtensions.*

class JobExtensions 
{
	static def hasIterable(Job it)
	{
		!eAllContents.filter(IterableInstruction).empty
	}
	
	static def hasLoop(Job it)
	{
		!eAllContents.filter(Loop).empty
	}

	static def getNextJobs(Job from)
	{
		val fromTargetJobs = new HashSet<Job>
		val irFile = from.eContainer as IrModule
		val fromOutVars = from.outVars
		//for (to : irFile.jobs.filter[x|x != from])
		for (to : irFile.jobs)
			for (outVar : fromOutVars)
				if (to.inVars.exists[x|x === outVar])
					fromTargetJobs += to
					
		return fromTargetJobs
	}
	
	static def dispatch Iterable<Variable> getOutVars(TimeIterationCopyJob it)
	{
		#[left].toSet
	}

	static def dispatch Iterable<Variable> getOutVars(InstructionJob it)
	{
		eAllContents.filter(Affectation).map[left.variable].filter[global].toSet
	}
	
	static def dispatch Iterable<Variable> getInVars(TimeIterationCopyJob it)
	{
		#[right].toSet
	}

	static def dispatch Iterable<Variable> getInVars(InstructionJob it)
	{
		val allVars = eAllContents.filter(VarRef).filter[x|x.eContainingFeature != IrPackage::eINSTANCE.affectation_Left].map[variable].filter[global].toSet
		return allVars
	}
}