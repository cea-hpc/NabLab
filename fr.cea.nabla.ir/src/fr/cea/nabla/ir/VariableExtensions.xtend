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
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.VarRef
import fr.cea.nabla.ir.ir.Variable
import java.util.HashSet
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.Utils.*

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

	static def getCodeName(Variable it)
	{
		if (scalarConst) 'options.' + name
		else name
	}
	
	static def isLinearAlgebra(Variable it)
	{
		val references = irModule.eAllContents.filter(VarRef).filter[x | x.variable == it]
		references.exists[x | x.eContainer.containsLinearAlgebra]
	}

	private static dispatch def boolean containsLinearAlgebra(EObject it)
	{
		false
	}

	private static dispatch def boolean containsLinearAlgebra(Affectation it)
	{
		right.containsLinearAlgebra
	}
	
	private static dispatch def boolean containsLinearAlgebra(FunctionCall it)
	{
		function.provider == 'LinearAlgebra'
	}
}