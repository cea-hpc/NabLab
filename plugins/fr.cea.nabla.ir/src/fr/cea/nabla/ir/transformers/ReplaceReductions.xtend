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
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.IterationBlock
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil

import static fr.cea.nabla.ir.transformers.IrTransformationUtils.*

class ReplaceReductions extends IrTransformationStep
{
	val boolean replaceAllReductions

	new(boolean replaceAllReductions)
	{
		super('Replace reductions by loops')
		this.replaceAllReductions = replaceAllReductions
	}

	/**
	 * Replace inner reductions by a variable definition (accumulator) and a Loop.
	 * The loop contains an affectation with a call to the binary function of the reduction.
	 */
	override transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)
		var reductions = ir.eAllContents.filter(ReductionInstruction)
		if (!replaceAllReductions) reductions = reductions.filter[!external]

		for (reduction : reductions.toList)
		{
			val functionCall = createFunctionCall(reduction)
			val affectation = createAffectation(reduction.result, functionCall)
			val innerInstructions = new ArrayList<Instruction>
			innerInstructions += reduction.innerInstructions.filter[x | !(x instanceof ReductionInstruction)]
			innerInstructions += affectation
			val loop = createLoop(reduction.iterationBlock, innerInstructions)

			// instantiate the VarDefinition at the end to prevent reduction.result from becoming null
			val variableDefinition = IrFactory::eINSTANCE.createVariableDeclaration => [ variable = reduction.result ]
			replace(reduction, #[variableDefinition, loop])
		}
		return true
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

	private def create IrFactory::eINSTANCE.createLoop createLoop(IterationBlock itBlock, List<Instruction> _instructions)
	{
		iterationBlock = itBlock
		switch _instructions.size
		{
			case 0: body = null
			case 1: body = _instructions.head
			default: body = IrFactory::eINSTANCE.createInstructionBlock =>
			[
				instructions += _instructions
			]
		}
		// A reduction cannot be executed in // (because of +=)
		multithreadable = false
	}

	private def boolean isExternal(EObject it)
	{
		if (eContainer === null) false
		else if (eContainer instanceof IterableInstruction) false
		else if (eContainer instanceof Job) true
		else eContainer.external
	}
}