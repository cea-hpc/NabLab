/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.DefaultVarDependencies
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.Container
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.JobCallerExtensions.*

class Utils
{
	static val extension DefaultVarDependencies = new DefaultVarDependencies

	static def getCodeName(Job it)
	{
		name.toFirstLower
	}

	static def getCodeName(ArgOrVar it)
	{
		if (eContainingFeature === IrPackage.Literals.IR_MODULE__OPTIONS)
			'options.' + name
		else if (iteratorCounter)
			(eContainer as Iterator).index.name
		else
			name
	}

	static def getNbElemsVar(Connectivity it) { 'nb' + name.toFirstUpper }

	static def getNbElemsVar(Container it)
	{
		if (connectivity.indexEqualId)
			connectivity.nbElemsVar
		else
			'nb' + uniqueName.toFirstUpper
	}

	static def getComment(Job it)
	'''
		/**
		 * Job «name» called @«at» in «caller.name» method.
		 * In variables: «FOR v : inVars.sortBy[name] SEPARATOR ', '»«v.getName»«ENDFOR»
		 * Out variables: «FOR v : outVars.sortBy[name] SEPARATOR ', '»«v.getName»«ENDFOR»
		 */
	'''

	static def boolean isParallelLoop(Loop it)
	{
		isTopLevelLoop && multithreadable
	}

	static def getOperatorName(String op)
	{
		switch op
		{
			case '/': 'divide'
			case '-': 'minus'
			case '*': 'multiply'
			case '+': 'plus'
		}
	}

	private static def boolean isTopLevelLoop(EObject it)
	{
		if (eContainer === null) false
		else switch eContainer
		{
			Loop : false
			ReductionInstruction : false
			Job : true
			default : eContainer.topLevelLoop
		}
	}
}