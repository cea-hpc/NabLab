/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.TimeLoopCopyJob
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.ir.ir.Variable
import java.util.HashSet

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

class JobExtensions
{
	static def isTopLevel(Job it)
	{
		(jobContainer instanceof IrModule)
	}

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
		val irModule = from.eContainer as IrModule
		val fromOutVars = from.outVars
		for (to : irModule.jobs)
			for (outVar : fromOutVars)
				if (to.inVars.exists[x | x === outVar])
					fromTargetJobs += to

		return fromTargetJobs
	}

	static def dispatch Iterable<Variable> getOutVars(TimeLoopJob it)
	{
		val outVars = new HashSet<Variable>
		innerJobs.forEach[x | outVars += x.outVars]
		return outVars
	}

	static def dispatch Iterable<Variable> getOutVars(TimeLoopCopyJob it)
	{
		copies.map[destination]
	}

	static def dispatch Iterable<Variable> getOutVars(InstructionJob it)
	{
		eAllContents.filter(Affectation).map[left.target].filter(Variable).filter[global].toSet
	}

	/** For TimeLoopJob, copies are ignored to avoid cycles */
	static def dispatch Iterable<Variable> getInVars(TimeLoopJob it)
	{
		val inVars = new HashSet<Variable>
		innerJobs.forEach[x | inVars += x.inVars]
		return inVars
	}

	static def dispatch Iterable<Variable> getInVars(TimeLoopCopyJob it)
	{
		copies.map[source]
	}

	static def dispatch Iterable<Variable> getInVars(InstructionJob it)
	{
		val allVars = eAllContents.filter(ArgOrVarRef).filter[x|x.eContainingFeature != IrPackage::eINSTANCE.affectation_Left].map[target]
		val inVars = allVars.filter(Variable).filter[global].toSet
		return inVars
	}

	static def getIteratorByName(Job it, String itName)
	{
		var iterators = eAllContents.filter(Iterator).toList
		return iterators.findFirst[index.name == itName]
	}

	static def getVariableByName(Job it, String varName)
	{
		var variables = eAllContents.filter(Variable).toList
		return variables.findFirst[x | x.name == varName]
	}
}