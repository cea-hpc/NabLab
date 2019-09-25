/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.JobExtensions.*

class Utils 
{
	static def getNbElems(Connectivity it) { 'nb' + name.toFirstUpper}

	static def getComment(Job it)
	'''
		/**
		 * Job «name» @«at»
		 * In variables: «FOR v : inVars SEPARATOR ', '»«v.getName»«ENDFOR»
		 * Out variables: «FOR v : outVars SEPARATOR ', '»«v.getName»«ENDFOR»
		 */
	'''	

	/**
	 * Retourne la liste des connectivités utilisées par le module,
	 * lors de la déclaration des variables ou des itérateurs.
	 */
	static def getUsedConnectivities(IrModule it)
	{
		// connectivités nécessaires pour les variables
		val connectivities = variables.filter(ConnectivityVariable).map[type.connectivities].flatten.toSet
		// connectivités utilisées dans le code
		jobs.forEach[j | connectivities += j.eAllContents.filter(ConnectivityCall).map[connectivity].toSet]

		return connectivities.filter[c | c.returnType.multiple]
	}
	
	static def boolean isTopLevelLoop(EObject it)
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

	static def initConstant(Array1D it, CharSequence value)
	'''«FOR i : 0..<size BEFORE '{' SEPARATOR ', ' AFTER '}'»«value»«ENDFOR»'''

	static def initConstant(Array2D it, CharSequence value)
	'''«FOR i : 0..<nbRows BEFORE '{' SEPARATOR ', ' AFTER '}'»«FOR j : 0..<nbCols BEFORE '{' SEPARATOR ', ' AFTER '}'»«value»«ENDFOR»«ENDFOR»'''
	
	static def getPersistentVariables(IrModule it) 
	{ 
		variables.filter(ConnectivityVariable).filter[x|x.persistenceName !== null && x.type.connectivities.size==1]
	}
}