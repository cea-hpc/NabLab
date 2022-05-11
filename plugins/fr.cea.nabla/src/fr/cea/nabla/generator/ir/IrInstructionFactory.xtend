/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.SpaceIteratorExtensions
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Exit
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.ItemSet
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.While
import java.util.ArrayList
import java.util.List

@Singleton
class IrInstructionFactory
{
	@Inject extension SpaceIteratorExtensions
	@Inject extension IrArgOrVarFactory
	@Inject extension IrExpressionFactory
	@Inject extension NabLabFileAnnotationFactory
	@Inject extension IrReductionInstructionFactory
	@Inject extension IrIterationBlockFactory
	@Inject extension IrSetDefinitionFactory

	def Instruction toIrInstruction(fr.cea.nabla.nabla.Instruction nablaInstruction)
	{
		val irInstructions = nablaInstruction.toIrInstructions
		if (irInstructions.size == 1) irInstructions.head
		else IrFactory::eINSTANCE.createInstructionBlock => [ instructions.addAll(irInstructions) ]
	}

	private def dispatch List<Instruction> toIrInstructions(SimpleVarDeclaration v)
	{
		val irInstr = IrFactory::eINSTANCE.createVariableDeclaration =>
		[
			annotations += v.toNabLabFileAnnotation
			variable = v.variable.toIrVariable
		]

		return irInstr.transformReductions(v.value)
	}

	private def dispatch List<Instruction> toIrInstructions(VarGroupDeclaration v)
	{
		val instructions = new ArrayList<Instruction>
		for (nablaVar : v.variables.filter(SimpleVar))
		{
			instructions += IrFactory::eINSTANCE.createVariableDeclaration =>
			[
				annotations += nablaVar.toNabLabFileAnnotation
				variable = nablaVar.toIrVariable
			]
		}
		return instructions
	}

	private def dispatch List<Instruction> toIrInstructions(InstructionBlock v)
	{
		val irInstr = IrFactory::eINSTANCE.createInstructionBlock =>
		[
			annotations += v.toNabLabFileAnnotation
			v.instructions.forEach[x | instructions += x.toIrInstructions]
		]
		#[irInstr]
	}

	private def dispatch List<Instruction> toIrInstructions(Loop v)
	{
		if (v.iterationBlock instanceof SpaceIterator && !(v.iterationBlock as SpaceIterator).multiple)
		{
			val irInstr = flatten(v.body.toIrInstruction, v.iterationBlock.neededIndexAndIdDefinitions)
			irInstr.annotations += v.toNabLabFileAnnotation
			#[irInstr]
		}
		else
		{
			val irInstr = IrFactory::eINSTANCE.createLoop =>
			[
				annotations += v.toNabLabFileAnnotation
				iterationBlock = v.iterationBlock.toIrIterationBlock
				body = flatten(v.body.toIrInstruction, v.iterationBlock.neededIndexAndIdDefinitions)
			]
			#[irInstr]
		}
	}

	private def dispatch List<Instruction> toIrInstructions(Affectation v)
	{
		val irInstr = IrFactory::eINSTANCE.createAffectation =>
		[
			annotations += v.toNabLabFileAnnotation
			left = v.left.toIrExpression as ArgOrVarRef
			right = v.right.toIrExpression
		]

		return irInstr.transformReductions(v.right)
	}

	private def dispatch List<Instruction> toIrInstructions(If v)
	{
		val irInstr = IrFactory::eINSTANCE.createIf =>
		[
			annotations += v.toNabLabFileAnnotation
			condition = v.condition.toIrExpression
			thenInstruction = v.then.toIrInstruction
			if (v.^else !== null) elseInstruction = v.^else.toIrInstruction
		]
		return irInstr.transformReductions(v.condition)
	}

	private def dispatch List<Instruction> toIrInstructions(ItemSet v)
	{
		#[v.toIrSetDefinition]
	}

	private def dispatch List<Instruction> toIrInstructions(While v)
	{
		val irInstr = IrFactory::eINSTANCE.createWhile =>
		[
			annotations += v.toNabLabFileAnnotation
			condition = v.condition.toIrExpression
			instruction = v.instruction.toIrInstruction
		]
		return irInstr.transformReductions(v.condition)
	}

	private def dispatch List<Instruction> toIrInstructions(Return v)
	{
		val irInstr = IrFactory::eINSTANCE.createReturn =>
		[
			annotations += v.toNabLabFileAnnotation
			expression = v.expression.toIrExpression
		]
		return irInstr.transformReductions(v.expression)
	}

	private def dispatch List<Instruction> toIrInstructions(Exit v)
	{
		val irInstr = IrFactory::eINSTANCE.createExit =>
		[
			annotations += v.toNabLabFileAnnotation
			message = v.message
		]
		#[irInstr]
	}

	private def List<Instruction> transformReductions(Instruction i, Expression e)
	{
		val reductionInstructions = e.toIrReductions
		val instructions = new ArrayList<Instruction>
		instructions.addAll(reductionInstructions)
		instructions += i
		return instructions
	}

	private def flatten(Instruction instruction, List<Instruction> definitions)
	{
		if (definitions.empty) 
			return instruction
		else if (instruction instanceof fr.cea.nabla.ir.ir.InstructionBlock)
		{
			instruction.instructions.addAll(0, definitions)
			return instruction
		}
		else return IrFactory::eINSTANCE.createInstructionBlock =>
		[
			instructions.addAll(0, definitions)
			instructions.add(instruction)
		]
	}
}