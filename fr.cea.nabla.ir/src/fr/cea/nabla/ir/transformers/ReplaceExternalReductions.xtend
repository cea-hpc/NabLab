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
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionCall
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.VarRef
import java.util.ArrayList
import org.eclipse.emf.ecore.util.EcoreUtil

class ReplaceExternalReductions extends ReplaceReductionsBase implements IrTransformationStep
{
	public static val ReductionOperators = #{'sum'->'+?=', 'reduceMin'->'<?=', 'reduceMax'->'>?='}
	
	override getDescription() 
	{
		'Replace external reductions by loops and affectations with nabla operator (the reduction variable becomes global)'
	}

	/**
	 * Transforme le module m pour qu'il n'est plus d'instance de ReductionInstruction 'externes',
	 * c'est à dire non intégrées à une boucle. Chaque ReductionInstruction est remplacée par
	 * 2 jobs. 
	 * Pour X = sum(j E cells)(Yj + 4) + Z, on a :
	 *   - un job avec une boucle cells qui calcule l'argument de la réduction tmpSumXXX = Yj+4
	 *   - un job avec une boucle cells qui fait la réduction sumXXX +?= tmpSumXXX
	 * Si l'argument est une VarRef, le premier job est inutile (=> remplacer tmpSumXXX par Y dans le 2e).
	 * Si l'expression finale est une VarRef, le dernier job est inutile mais aucune optimisation
	 * n'a été faite pour le moment.
	 */
	override transform(IrModule m)
	{
		for (reductionInstr : m.eAllContents.filter(ReductionInstruction).filter[reduction.external].toList)
		{
			// création des fonctions correspondantes
			// 2 arguments IN : 1 du type de la collection, l'autre du type de retour (appel en chaine)
			val reduc = reductionInstr.reduction.reduction

			// Vérification du pattern attendu : une réduction et une affectation dans un bloc
			if (! (reductionInstr.eContainer instanceof InstructionBlock)
				|| !((reductionInstr.eContainer as InstructionBlock).instructions.last instanceof Affectation))
				throw new Exception("Unexpected IR pattern for reduction")
				
			// creation du job de reduction avec l'operateur nabla
			val reducOperatorRhs = handleReductionArg(m, reductionInstr)
			val reducOperatorLhs = reductionInstr.variable
			m.jobs += IrFactory::eINSTANCE.createInstructionJob =>
			[
				name = 'Reduce_' + reductionInstr.variable.name
				instruction = createReductionLoop(reductionInstr.reduction.iterator, reductionInstr.reduction.dependantIterators, reducOperatorLhs, reducOperatorRhs, reduc.operator)
			] 

			// la variable de reduction doit devenir globale pour etre utilisée dans le job final
			m.variables += reductionInstr.variable
			
			// nettoyage
			EcoreUtil::delete(reductionInstr)			
			if (!m.eAllContents.filter(ReductionCall).exists[x | x.reduction == reduc])
					EcoreUtil::delete(reduc, true)
		}
		return true
	}
	
	/**
	 * Si l'argument de la réduction est une VarRef, retourne cette VarRef
	 * sinon crée un job pour calculer l'expression, une variable por stocker le
	 * résultat et retourne cette variable.
	 * Ex 1 : X = sum(j E cells)(Yj + 4) + Z, retourne une variable aux mailles avec valeur de Yj+4.
	 * Ex 2 : X = sum(j E cells)(Yj) + Z retourne Yj
	 */
	private def handleReductionArg(IrModule m, ReductionInstruction reductionInstr)
	{
		if (reductionInstr.reduction.arg instanceof VarRef) 
			return reductionInstr.reduction.arg as VarRef
		else
		{
			val reduc = reductionInstr.reduction
			
			val argValue = IrFactory::eINSTANCE.createArrayVariable =>
			[
				name = reductionInstr.variable.name + 'ArgValue'
				type = reductionInstr.variable.type
				dimensions += reductionInstr.reduction.iterator.call.connectivity
			]
			m.variables += argValue
			
			val argValueRef = IrFactory::eINSTANCE.createVarRef => 
			[ 
				variable = argValue
				type = EcoreUtil::copy(reduc.arg.type)
			]
			
			val argJob = IrFactory::eINSTANCE.createInstructionJob =>
			[
				name = 'Compute_' + reductionInstr.variable.name + '_arg'
				val dependantIterators = new ArrayList<Iterator>
				reduc.dependantIterators.forEach[x | dependantIterators += EcoreUtil::copy(x)]
				instruction = createReductionLoop(EcoreUtil::copy(reduc.iterator), dependantIterators, argValue, reduc.arg, '=')
			]
			m.jobs += argJob
			
			return argValueRef
		}
	}

	private def getOperator(Reduction it)
	{
		val op = ReductionOperators.get(name)
		if (op === null) throw new Exception('Unsupported reduction function: ' + name)
		else op
	}
}