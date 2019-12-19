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
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BeginOfTimeLoopJob
import fr.cea.nabla.ir.ir.EndOfTimeLoopJob
import fr.cea.nabla.ir.ir.InSituJob
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Variable
import java.util.HashSet

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

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

	static def dispatch Iterable<Variable> getOutVars(BeginOfTimeLoopJob it)
	{
		initializations.map[destination]
	}

	static def dispatch Iterable<Variable> getOutVars(EndOfTimeLoopJob it)
	{
		nextLoopCopies.map[destination] + exitLoopCopies.map[destination]
	}

	static def dispatch Iterable<Variable> getOutVars(InstructionJob it)
	{
		eAllContents.filter(Affectation).map[left.target].filter(Variable).filter[global].toSet
	}

	static def dispatch Iterable<Variable> getOutVars(InSituJob it)
	{
		#[]
	}

	static def dispatch Iterable<Variable> getInVars(BeginOfTimeLoopJob it)
	{
		initializations.map[source]
	}

	static def dispatch Iterable<Variable> getInVars(EndOfTimeLoopJob it)
	{
		nextLoopCopies.map[source] + exitLoopCopies.map[source]
	}

	static def dispatch Iterable<Variable> getInVars(InstructionJob it)
	{
		val allVars = eAllContents.filter(ArgOrVarRef).filter[x|x.eContainingFeature != IrPackage::eINSTANCE.affectation_Left].map[target]
		val inVars = allVars.filter(Variable).filter[global].toSet
		return inVars
	}

	static def dispatch Iterable<Variable> getInVars(InSituJob it)
	{
		return dumpedVariables + #[periodVariable]
	}

	static def getIteratorByName(Job it, String name)
	{
		var iterators = eAllContents.filter(Iterator).toList
		return iterators.findFirst[i | i.name == name]
	}

	static def getVariableByName(Job it, String name)
	{
		var variables = eAllContents.filter(Variable).toList
		return variables.findFirst[i | i.name == name]
	}
}