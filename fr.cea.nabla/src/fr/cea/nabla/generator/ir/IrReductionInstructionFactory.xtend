/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.typing.DeclarationProvider
import org.eclipse.xtext.EcoreUtil2

class IrReductionInstructionFactory 
{
	@Inject extension ReductionCallExtensions
	@Inject extension IrAnnotationHelper
	@Inject extension IrFunctionFactory
	@Inject extension DeclarationProvider
	@Inject extension IrIterationBlockFactory
	@Inject extension IrExpressionFactory

	def dispatch Iterable<ReductionInstruction> toIrReductions(Expression it) { #[] }  // by default...
	def dispatch Iterable<ReductionInstruction> toIrReductions(ContractedIf it) { then.toIrReductions + ^else.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Or it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(And it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Equality it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Comparison it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Plus it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Minus it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(MulOrDiv it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Modulo it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Parenthesis it) { expression.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(UnaryMinus it) { expression.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Not it) { expression.toIrReductions }

	def dispatch Iterable<ReductionInstruction> toIrReductions(FunctionCall it) 
	{ 
		args.map[a | a.toIrReductions].flatten
	}

	def dispatch Iterable<ReductionInstruction> toIrReductions(ReductionCall it) 
	{
		val m = EcoreUtil2.getContainerOfType(reduction, NablaModule)
		val irInstruction = IrFactory::eINSTANCE.createReductionInstruction
		irInstruction.annotations += toIrAnnotation
		irInstruction.innerReductions += arg.toIrReductions
		irInstruction.reduction = declaration.model.toIrReduction(m.name)
		irInstruction.iterationBlock = iterationBlock.toIrIterationBlock
		irInstruction.arg = arg.toIrExpression		
		irInstruction.result = toIrLocalVariable
		return #[irInstruction]
	}

	def dispatch Iterable<ReductionInstruction> toIrReductions(BaseTypeConstant it)
	{
		value.toIrReductions
	}
}