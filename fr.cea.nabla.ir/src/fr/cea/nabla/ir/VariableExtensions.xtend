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

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable
import java.util.HashSet
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.JobExtensions.*

class VariableExtensions 
{
	static def isScalarConst(Variable it)
	{
		(it instanceof SimpleVariable) && (it as SimpleVariable).const
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

	/**
	 * Returns true if the variable has at least 2 connectivities which takes no argument, false otherwise.
	 * For example, X{cells, nodesOfCell} returns false but X{cells, cells} or X{cells, nodes} returns true.
	 */
	static def isConnectivityMatrix(ConnectivityVariable it)
	{
		val fullConnectivities = dimensions.filter[x | x.inTypes.empty]
		return (fullConnectivities.size > 1)
	}

	private static def IrModule getIrModule(EObject it)
	{
		if (eContainer === null) null
		else if (eContainer instanceof IrModule) eContainer as IrModule
		else eContainer.irModule
	}
}