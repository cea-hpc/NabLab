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
import fr.cea.nabla.ir.ir.Arg
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable
import java.util.HashSet
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import fr.cea.nabla.ir.ir.Function

class ArgOrVarExtensions
{
	static def IrType getType(ArgOrVar it)
	{
		switch it
		{
			Arg: type
			SimpleVariable: type
			ConnectivityVariable: type
		}
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

	static def isOption(ArgOrVar it)
	{
		(it instanceof SimpleVariable) && (it as SimpleVariable).const && (it as SimpleVariable).global
	}

	static def isGlobal(Variable it)
	{
		(eContainer instanceof IrModule)
	}

	static def isLinearAlgebra(Function it)
	{
		containsLinearAlgebra
	}

	static def isLinearAlgebra(ArgOrVar it)
	{
		if (it instanceof ConnectivityVariable)
		{
			val references = irModule.eAllContents.filter(ArgOrVarRef).filter[x | x.target == it]
			references.exists[x | x.eContainer.containsLinearAlgebra]
		}
		else
			false
	}

	private static def dispatch boolean containsLinearAlgebra(EObject it)
	{
		false
	}

	private static def dispatch boolean containsLinearAlgebra(Affectation it)
	{
		right.containsLinearAlgebra
	}

	private static def dispatch boolean containsLinearAlgebra(FunctionCall it)
	{
		function.containsLinearAlgebra
	}

	private static def dispatch boolean containsLinearAlgebra(Function it)
	{
		provider == 'LinearAlgebra'
	}
}