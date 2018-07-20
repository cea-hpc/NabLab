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
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Variable
import java.util.HashSet
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.JobExtensions.*
import fr.cea.nabla.ir.ir.ScalarVariable

class VariableExtensions 
{
	static def isScalarConst(Variable it)
	{
		(it instanceof ScalarVariable) && (it as ScalarVariable).const
	}
	
	static def getNextJobs(Variable it)
	{
		val nextJobs = new HashSet<Job>
		for (j : irModule.jobs)
			if (j.inVars.exists[x | x === it])
				nextJobs += j		
		return nextJobs
	}

	static def getPreviousJobs(Variable it)
	{
		val previousJobs = new HashSet<Job>
		for (j : irModule.jobs)
			if (j.outVars.exists[x | x === it])
				previousJobs += j
		return previousJobs
	}

	static def isGlobal(Variable it) 
	{ 
		eContainer instanceof IrModule
	}

	private static def IrModule getIrModule(EObject it)
	{
		if (eContainer === null) null
		else if (eContainer instanceof IrModule) eContainer as IrModule
		else eContainer.irModule
	}
}