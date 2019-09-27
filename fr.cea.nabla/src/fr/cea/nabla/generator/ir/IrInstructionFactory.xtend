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
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.VarRef
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InitializationExpression
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.VarGroupDeclaration
import java.util.ArrayList
import java.util.List

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class IrInstructionFactory
{
	@Inject extension IrVariableFactory
	@Inject extension IrIteratorFactory
	@Inject extension IrExpressionFactory
	@Inject extension IrAnnotationHelper
	@Inject extension IrReductionInstructionFactory
	
	def Instruction toIrInstruction(fr.cea.nabla.nabla.Instruction nablaInstruction)
	{
		val irInstructions = nablaInstruction.toIrInstructions
		if (irInstructions.size == 1) irInstructions.head
		else IrFactory::eINSTANCE.createInstructionBlock => [ instructions.addAll(irInstructions) ]
	}

	private def dispatch List<Instruction> toIrInstructions(SimpleVarDefinition v)
	{
		val irInstr = IrFactory::eINSTANCE.createVarDefinition =>
		[
			annotations += v.toIrAnnotation
			variables += v.variable.toIrSimpleVariable
		]

		return irInstr.transformReductions(v.defaultValue)
	}
	
	private def dispatch List<Instruction> toIrInstructions(VarGroupDeclaration v)
	{
		val irInstr = IrFactory::eINSTANCE.createVarDefinition =>
		[
			// Il n'y a que des ScalarVar quand VarGroupDeclaration est une instruction.
			// Les ArrayVar ne sont que dans les variables du module (variables globales)
			for (scalarVar : v.variables.filter(SimpleVar))
			{
				annotations += v.toIrAnnotation
				variables += scalarVar.toIrSimpleVariable
			}
		]
		#[irInstr]
	}
	
	private def dispatch List<Instruction> toIrInstructions(InstructionBlock v)
	{
		val irInstr = IrFactory::eINSTANCE.createInstructionBlock =>
		[
			annotations += v.toIrAnnotation
			v.instructions.forEach[x | instructions += x.toIrInstructions]
		]
		#[irInstr]
	}

	private def dispatch List<Instruction> toIrInstructions(Loop v)
	{
		val irInstr = IrFactory::eINSTANCE.createLoop =>
		[
			annotations += v.toIrAnnotation
			range = v.range.toIrIterator
			v.singletons.forEach[x | singletons += x.toIrIterator]
			body = v.body.toIrInstruction
		]
		#[irInstr]
	}

	private def dispatch List<Instruction> toIrInstructions(Affectation v)
	{
		val irInstr = IrFactory::eINSTANCE.createAffectation =>
		[
			annotations += v.toIrAnnotation
			left = v.varRef.toIrExpression as VarRef
			right = v.expression.toIrExpression
		]

		return irInstr.transformReductions(v.expression)
	}
	
	private def dispatch List<Instruction> toIrInstructions(If v)
	{
		val irInstr = IrFactory::eINSTANCE.createIf =>
		[
			annotations += v.toIrAnnotation
			condition = v.condition.toIrExpression
			thenInstruction = v.then.toIrInstruction
			if (v.^else !== null) elseInstruction = v.^else.toIrInstruction
		]		
		
		return irInstr.transformReductions(v.condition)
	}
	
	private def List<Instruction> transformReductions(Instruction i, InitializationExpression e)
	{
		val reductionInstructions = e.toIrReductions
		val instructions = new ArrayList<Instruction>
		instructions.addAll(reductionInstructions)
		instructions += i
		return instructions
	}
}