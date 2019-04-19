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
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.Real2Constant
import fr.cea.nabla.nabla.Real2x2Constant
import fr.cea.nabla.nabla.Real3Constant
import fr.cea.nabla.nabla.Real3x3Constant
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.RealXCompactConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarRef

class IrReductionInstructionFactory 
{
	@Inject extension ReductionCallExtensions
	@Inject extension IrAnnotationHelper
	
	def dispatch Iterable<ReductionInstruction> toIrReductions(Or it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(And it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Equality it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Comparison it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Plus it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Minus it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(MulOrDiv it) { left.toIrReductions + right.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Parenthesis it) { expression.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(UnaryMinus it) { expression.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Not it) { expression.toIrReductions }
	def dispatch Iterable<ReductionInstruction> toIrReductions(IntConstant it) { #[] }
	def dispatch Iterable<ReductionInstruction> toIrReductions(RealConstant it) { #[] }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Real2Constant it) { #[] }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Real3Constant it) { #[] }
	def dispatch Iterable<ReductionInstruction> toIrReductions(BoolConstant it) { #[] }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Real2x2Constant it) { #[] }
	def dispatch Iterable<ReductionInstruction> toIrReductions(Real3x3Constant it) { #[] }
	def dispatch Iterable<ReductionInstruction> toIrReductions(RealXCompactConstant it) { #[] }
	def dispatch Iterable<ReductionInstruction> toIrReductions(MinConstant it) { #[] }
	def dispatch Iterable<ReductionInstruction> toIrReductions(MaxConstant it) { #[] }

	def dispatch Iterable<ReductionInstruction> toIrReductions(FunctionCall it) 
	{ 
		args.map[a | a.toIrReductions].flatten
	}
	
	def dispatch Iterable<ReductionInstruction> toIrReductions(ReductionCall it) 
	{
		val irInstruction = IrFactory::eINSTANCE.createReductionInstruction
		irInstruction.annotations += toIrAnnotation
		irInstruction.variable = toIrLocalVariable
		irInstruction.reduction = toIrReductionCall
		irInstruction.innerReductions += arg.toIrReductions
		return #[irInstruction]
	}
	
	def dispatch Iterable<ReductionInstruction> toIrReductions(VarRef e)  { #[] }
}