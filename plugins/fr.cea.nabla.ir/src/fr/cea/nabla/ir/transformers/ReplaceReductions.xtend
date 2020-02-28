/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.IterationBlock
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Variable
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil

import static fr.cea.nabla.ir.transformers.IrTransformationUtils.*

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

class ReplaceReductions implements IrTransformationStep
{
	val boolean replaceAllReductions

	new(boolean replaceAllReductions)
	{
		this.replaceAllReductions = replaceAllReductions
	}

	override getDescription()
	{
		'Replace reductions by loops'
	}

	/**
	 * Replace inner reductions by a variable definition (accumulator) and a Loop.
	 * The loop contains an affectation with a call to the binary function of the reduction.
	 */
	override transform(IrModule m)
	{
		var reductions = m.eAllContents.filter(ReductionInstruction)
		if (!replaceAllReductions) reductions = reductions.filter[!external]

		for (reduction : reductions.toList)
		{
			val functionCall = createFunctionCall(reduction)
			val affectation = createAffectation(reduction.result, functionCall)
			val loop = createLoop(reduction.iterationBlock, affectation)

			// instantiate the VarDefinition at the end to prevent reduction.result from becoming null
			val variableDefinition = IrFactory::eINSTANCE.createVarDefinition => [ variables += reduction.result ]
			replace(reduction, #[variableDefinition, loop])
		}
		return true
	}

	override getOutputTraces()
	{
		#[]
	}

	private def Expression createFunctionCall(ReductionInstruction reduction)
	{
		IrFactory::eINSTANCE.createFunctionCall =>
		[
			type = EcoreUtil::copy(reduction.result.type)
			function = reduction.binaryFunction
			args += IrFactory::eINSTANCE.createArgOrVarRef =>
			[
				target = reduction.result
				type = EcoreUtil::copy(target.type)
			]
			args += reduction.lambda
		]
	}

	private def create IrFactory::eINSTANCE.createAffectation createAffectation(Variable lhs, Expression rhs)
	{
		left = IrFactory::eINSTANCE.createArgOrVarRef =>
		[
			target = lhs
			type = EcoreUtil::copy(rhs.type)
		]
		right = rhs
	}

	private def create IrFactory::eINSTANCE.createLoop createLoop(IterationBlock itBlock, Instruction b)
	{
		iterationBlock = itBlock
		body = b
	}

	private def boolean isExternal(EObject it)
	{
		if (eContainer === null) false
		else if (eContainer instanceof IterableInstruction) false
		else if (eContainer instanceof Job) true
		else eContainer.external
	}
}