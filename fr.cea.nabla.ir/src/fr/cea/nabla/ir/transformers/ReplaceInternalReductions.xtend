/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Variable
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil

import static fr.cea.nabla.ir.transformers.IrTransformationUtils.*

import static extension fr.cea.nabla.ir.VariableExtensions.*

class ReplaceInternalReductions implements IrTransformationStep
{
	override getDescription() 
	{
		'Replace internal reductions by loops'
	}

	/**
	 * Replace inner reductions by a Loop + a Variable.
	 */
	override transform(IrModule m)
	{
		val reductions = m.eAllContents.filter(ReductionInstruction).filter[!external].toList
		for (reductionInstr : reductions)
		{
			// création des fonctions correspondantes
			// 2 arguments IN : 1 du type de la collection, l'autre du type de retour (appel en chaine)
			val reduc = reductionInstr.reduction
			// transformation de la reduction
			val loopExpression = createAffectationRHS(m, reductionInstr)
			val loop = createReductionLoop(reductionInstr.range, reductionInstr.singletons, reductionInstr.result, loopExpression)
			val variableDefinition = IrFactory::eINSTANCE.createVarDefinition => [ variables += reductionInstr.result ]
			replace(reductionInstr, #[variableDefinition, loop])			

			// si la réduction n'est pas référencée, on l'efface
			if (!m.eAllContents.filter(ReductionInstruction).exists[x | x.reduction == reduc])
				EcoreUtil::delete(reduc, true)
		}
		return true
	}
	
	override getOutputTraces() 
	{
		#[]
	}

	private def Expression createAffectationRHS(IrModule m, ReductionInstruction reductionInstr)
	{
		val reduction = reductionInstr.reduction
		val varRef = IrFactory::eINSTANCE.createVarRef => 
		[ 
			variable = reductionInstr.result
			type = EcoreUtil::copy(variable.type)
		]

		if (reduction.isOperator)
		{
			return IrFactory::eINSTANCE.createBinaryExpression =>
			[
				type = EcoreUtil::copy(reductionInstr.result.type)
				operator = reduction.name
				left = varRef
				right = IrFactory::eINSTANCE.createParenthesis => 
				[ 
					expression = reductionInstr.arg
					type = EcoreUtil::copy(expression.type)
				]
			]
		}
		else
		{
			// creation de la fonction
			val f = findOrCreateFunction(m, reduction)										
			// transformation de la reduction
			return IrFactory::eINSTANCE.createFunctionCall =>
			[
				type = EcoreUtil::copy(reductionInstr.result.type)
				function = f
				args += varRef
				args += reductionInstr.arg
			] 
		}
	}
	
	private def findOrCreateFunction(IrModule m, Reduction r)
	{
		var function = m.functions.findFirst
		[   
			name == r.functionName && 
			inTypes.length == 2 && 
			inTypes.get(0) == r.collectionType && 
			inTypes.get(1) == r.returnType && 
			returnType == r.returnType
		]
		
		if (function === null) 
		{ 
			function = IrFactory::eINSTANCE.createFunction =>
			[
				name = r.functionName
				inTypes += EcoreUtil.copy(r.collectionType)
				inTypes += EcoreUtil.copy(r.returnType)
				returnType = EcoreUtil.copy(r.returnType)
				provider = r.provider
			]
			m.functions += function
		}
		
		return function
	}

	private def getFunctionName(Reduction r)
	{
		val prefix = 'reduce'
		if (r.name.startsWith(prefix)) r.name.replaceFirst(prefix, '')
		else r.name
	}
	
	private def createReductionLoop(Iterator range, List<Iterator> singletons, Variable affectationLHS, Expression affectationRHS)
	{
		val loop = IrFactory::eINSTANCE.createLoop
		loop.range = range
		loop.singletons.addAll(singletons)
		loop.body = IrFactory::eINSTANCE.createAffectation => 
		[
			left = IrFactory::eINSTANCE.createVarRef => 
			[ 
				variable = affectationLHS
				type = EcoreUtil::copy(affectationRHS.type)
			]
			right = affectationRHS
		]
		return loop
	}	

	private def boolean isExternal(EObject it)
	{
		if (eContainer === null) false
		else if (eContainer instanceof Loop) false
		else if (eContainer instanceof ReductionInstruction) false
		else if (eContainer instanceof Job) true
		else eContainer.external	
	}
}