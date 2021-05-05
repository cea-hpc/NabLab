/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.SpaceIteratorExtensions
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.overloading.DeclarationProvider
import java.util.ArrayList

class IrReductionInstructionFactory
{
	@Inject extension SpaceIteratorExtensions
	@Inject extension ReductionCallExtensions
	@Inject extension IrAnnotationHelper
	@Inject extension IrFunctionFactory
	@Inject extension DeclarationProvider
	@Inject extension IrIterationBlockFactory
	@Inject extension IrExpressionFactory

	def dispatch Iterable<Instruction> toIrReductions(Expression it) { #[] }  // by default...
	def dispatch Iterable<Instruction> toIrReductions(ContractedIf it) { then.toIrReductions + ^else.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(Or it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(And it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(Equality it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(Comparison it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(Plus it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(Minus it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(Mul it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(Div it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(Modulo it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(Parenthesis it) { expression.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(UnaryMinus it) { expression.toIrReductions }
	def dispatch Iterable<Instruction> toIrReductions(Not it) { expression.toIrReductions }

	def dispatch Iterable<Instruction> toIrReductions(FunctionCall it)
	{
		args.map[a | a.toIrReductions].flatten
	}

	def dispatch Iterable<Instruction> toIrReductions(ReductionCall it)
	{
		if (iterationBlock instanceof SpaceIterator && !(iterationBlock as SpaceIterator).multiple)
		{
			val irInstructions = new ArrayList<Instruction>
			irInstructions += iterationBlock.neededIndexAndIdDefinitions
			irInstructions += arg.toIrReductions
			val definition = IrFactory::eINSTANCE.createVariableDeclaration
			definition.variable = toIrLocalVariable
			definition.variable.defaultValue = arg.toIrExpression
			irInstructions += definition
			irInstructions
		}
		else
		{
			val irInstruction = IrFactory::eINSTANCE.createReductionInstruction
			irInstruction.annotations += toIrAnnotation
			irInstruction.innerInstructions += iterationBlock.neededIndexAndIdDefinitions
			irInstruction.innerInstructions += arg.toIrReductions
			irInstruction.binaryFunction = declaration.model.toIrFunction
			irInstruction.iterationBlock = iterationBlock.toIrIterationBlock
			irInstruction.lambda = arg.toIrExpression
			irInstruction.result = toIrLocalVariable
			#[irInstruction]
		}
	}

	def dispatch Iterable<Instruction> toIrReductions(BaseTypeConstant it)
	{
		value.toIrReductions
	}
}