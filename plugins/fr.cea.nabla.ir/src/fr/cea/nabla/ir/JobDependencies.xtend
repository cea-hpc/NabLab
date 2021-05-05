/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

class JobDependencies
{
	static def void computeAndSetNextJobs(Job it)
	{
		outVars.forEach[x | nextJobs += x.nextJobs]
	}

	static def void computeAndSetInOutVars(Job it)
	{
		outVars += eAllContents.filter(Affectation).map[left.target].filter(Variable).filter[global].toSet
		val allReferencedVars = eAllContents.filter(ArgOrVarRef).filter[x|x.eContainingFeature != IrPackage::eINSTANCE.affectation_Left].map[target]
		inVars += allReferencedVars.filter(Variable).filter[global].toSet
	}

	static def void computeAndSetNextJobsWithSameCaller(Job it)
	{
		for (j : nextJobs)
			if (j.caller === caller)
				nextJobsWithSameCaller += j
			else
			{
				val parent = getExecuteTimeLoopJobWithSameCaller(j, caller)
				if (parent !== null)
					nextJobsWithSameCaller += parent
			}
	}

	private static def ExecuteTimeLoopJob getExecuteTimeLoopJobWithSameCaller(Job j, JobCaller parentCaller)
	{
		if (j.caller !== null && j.caller instanceof ExecuteTimeLoopJob)
		{
			val c = j.caller as ExecuteTimeLoopJob
			if (c.caller === parentCaller) c
			else getExecuteTimeLoopJobWithSameCaller(c, parentCaller)
		}
		else
			null
	}
}
