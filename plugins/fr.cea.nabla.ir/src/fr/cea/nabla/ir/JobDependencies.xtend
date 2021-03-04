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

import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Variable
import java.util.HashSet

import static extension fr.cea.nabla.ir.Utils.*

class JobDependencies
{
	val extension VarDependencies varDependencies

	new()
	{
		varDependencies = new DefaultVarDependencies
	}

	new(VarDependencies varDependencies)
	{
		this.varDependencies = varDependencies
	}

	def getPreviousJobs(Job to)
	{
		val toSourceJobs = new HashSet<Job>
		for (inVar : to.inVars)
			toSourceJobs += inVar.previousJobs
		return toSourceJobs
	}

	def getNextJobs(Job from)
	{
		val fromTargetJobs = new HashSet<Job>
		for (outVar : from.outVars)
			fromTargetJobs += outVar.nextJobs
		//println("###   module " + from.name + " : " + fromTargetJobs.map[name].join(', '))
		return fromTargetJobs
	}

	def getNextJobs(Variable it)
	{
		val nextJobs = new HashSet<Job>
		for (j : irRoot.jobs)
			if (j.inVars.exists[x | x === it])
				nextJobs += j
		return nextJobs
	}

	def getPreviousJobs(Variable it)
	{
		val previousJobs = new HashSet<Job>
		for (j : irRoot.jobs)
			if (j.outVars.exists[x | x === it])
				previousJobs += j
		return previousJobs
	}

}
