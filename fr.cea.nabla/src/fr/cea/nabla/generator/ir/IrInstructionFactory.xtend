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
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.VarRef
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.ScalarVar
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.VarGroupDeclaration

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
	
	def dispatch Instruction toIrInstruction(ScalarVarDefinition v)
	{
		val irInstr = IrFactory::eINSTANCE.createScalarVarDefinition =>
		[
			annotations += v.toIrAnnotation
			variables += v.variable.toIrScalarVariable
		]

		return irInstr.transformReductions(v.defaultValue)
	}
	
	def dispatch create IrFactory::eINSTANCE.createScalarVarDefinition toIrInstruction(VarGroupDeclaration v)
	{
		// Il n'y a que des ScalarVar quand VarGroupDeclaration est une instruction.
		// Les ArrayVar ne sont que dans les variables du module (variables globales)
		for (scalarVar : v.variables.filter(ScalarVar))
		{
			annotations += v.toIrAnnotation
			variables += scalarVar.toIrScalarVariable
		}
	}

	def dispatch create IrFactory::eINSTANCE.createInstructionBlock toIrInstruction(InstructionBlock v)
	{
		annotations += v.toIrAnnotation
		v.instructions.forEach[x | instructions += x.toIrInstruction]
	}

	def dispatch Instruction toIrInstruction(Affectation v)
	{
		val irInstr = IrFactory::eINSTANCE.createAffectation =>
		[
			annotations += v.toIrAnnotation
			left = v.varRef.toIrExpression as VarRef
			operator = '='
			right = v.expression.toIrExpression
		]

		return irInstr.transformReductions(v.expression)
	}
	
	def dispatch create IrFactory::eINSTANCE.createLoop toIrInstruction(Loop v)
	{
		annotations += v.toIrAnnotation
		range = v.range.toIrIterator
		v.singletons.forEach[x | singletons += x.toIrIterator]
		body = v.body.toIrInstruction
	}
	
	def dispatch Instruction toIrInstruction(If v)
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
	
	private def Instruction transformReductions(Instruction i, Expression e)
	{
		val listOfReductionInstructions = e.toIrReductions
		if (listOfReductionInstructions.empty) i
		else IrFactory::eINSTANCE.createInstructionBlock =>
		[
			annotations += e.toIrAnnotation
			instructions += listOfReductionInstructions
			instructions += i
		]
	}
}