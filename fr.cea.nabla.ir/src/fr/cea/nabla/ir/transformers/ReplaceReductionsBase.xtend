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
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionCall
import fr.cea.nabla.ir.ir.Variable
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil

abstract class ReplaceReductionsBase 
{
	protected def createReductionLoop(Iterator iterator, Variable affectationLHS, Expression affectationRHS, String op)
	{
		val loop = IrFactory::eINSTANCE.createLoop
		loop.iterator = iterator
		loop.body = IrFactory::eINSTANCE.createAffectation => 
		[
			left = IrFactory::eINSTANCE.createVarRef => 
			[ 
				variable = affectationLHS
				type = EcoreUtil::copy(affectationRHS.type)
			]
			operator = op
			right = affectationRHS
		]
		return loop
	}	

	protected def boolean isExternal(EObject it)
	{
		if (eContainer === null) false
		else if (eContainer instanceof Loop) false
		else if (eContainer instanceof ReductionCall) false
		else if (eContainer instanceof Job) true
		else eContainer.external	
	}
}