package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionCall
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.VarRef
import org.eclipse.emf.ecore.util.EcoreUtil

class ReplaceExternalReductions extends ReplaceReductionsBase implements IrTransformationStep
{
	override getDescription() 
	{
		'Replace external reductions by loops and affectations with nabla operator (the reduction variable becomes global)'
	}

	/**
	 * Transforme le module m pour qu'il n'est plus d'instance de ReductionInstruction.
	 * Les réductions sont remplacées par des 3 jobs... à détailler.
	 * Ex1: pour l'expression X = sum(j E cells)(Yj + 4) + Z
	 */
	override transform(IrModule m)
	{
		for (reductionInstr : m.eAllContents.filter(ReductionInstruction).filter[reduction.global].toIterable)
		{
			// création des fonctions correspondantes
			// 2 arguments IN : 1 du type de la collection, l'autre du type de retour (appel en chaine)
			val reduc = reductionInstr.reduction.reduction
			
			// Vérification du pattern attendu : une réduction et une affectation dans un bloc
			if (! (reductionInstr.eContainer instanceof InstructionBlock)
				|| ((reductionInstr.eContainer as InstructionBlock).instructions.length != 2)
				|| !((reductionInstr.eContainer as InstructionBlock).instructions.last instanceof Affectation))
				throw new Exception("Unexpected IR pattern for reduction")
				
			val reducBlock = reductionInstr.eContainer as InstructionBlock
			val reducFinalAffectation = reducBlock.instructions.last as Affectation
			val oldReducJob = reducBlock.eContainer as Job
			
			val reducOperatorRhs = handleReductionArg(m, oldReducJob.name, reductionInstr)
			val reducOperatorLhs = handleAffectation(m, oldReducJob.name, reductionInstr, reducFinalAffectation)
			m.jobs += IrFactory::eINSTANCE.createInstructionJob =>
			[
				name = oldReducJob.name + 'ReductionOperator'
				instruction = createReductionLoop(reductionInstr.reduction.iterator, reducOperatorLhs, reducOperatorRhs, reduc.operator)
			] 
			
			EcoreUtil::delete(oldReducJob, true)

			// si la réduction n'est pas référencée, on l'efface
			if (!m.eAllContents.filter(ReductionCall).exists[x | x.reduction == reduc])
				EcoreUtil::delete(reduc, true)
		}
	}
	
	/**
	 * Si l'argument de la réduction est une VarRef, retourne cette VarRef
	 * sinon crée un job pour calculer l'expression, une variable por stocker le
	 * résultat et retourne cette variable.
	 * Ex 1 : X = sum(j E cells)(Yj + 4) + Z, retourne une variable aux mailles avec valeur de Yj+4.
	 * Ex 2 : X = sum(j E cells)(Yj) + Z retourne Yj
	 */
	private def handleReductionArg(IrModule m, String jobBaseName, ReductionInstruction reductionInstr)
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
				dimensions += reductionInstr.reduction.iterator.range.connectivity
			]
			m.variables += argValue
			
			val argValueRef = IrFactory::eINSTANCE.createVarRef => 
			[ 
				variable = argValue
				type = reduc.arg.type.clone
			]
			
			val argJob = IrFactory::eINSTANCE.createInstructionJob =>
			[
				name = jobBaseName + 'ReductionArgValue'
				instruction = createReductionLoop(reduc.iterator, argValue, reduc.arg, '=')
			]
			m.jobs += argJob
			
			return argValueRef
		}
	}
	
	/**
	 * Si le rhs de l'affectation est une VarRef, retourne le lhs
	 * sinon crée un job avec l'affectation et retourne une la variable de reduction (qui doit devenir globale).
	 * Ex 1 : X = sum(j E cells)(Yj + 4) + Z, retourne Yj.
	 * Ex 2 : X = sum(j E cells)(Yj + 4) retourne X
	 */
	private def handleAffectation(IrModule m, String jobBaseName, ReductionInstruction reductionInstr, Affectation affectation)
	{
		// Attention, la variable doit devenir globale car la reduction disparait
		val globalVariable = reductionInstr.variable
		m.variables += globalVariable
		
		if (affectation.right instanceof VarRef) 
			return affectation.left.variable
		else
		{
			m.jobs += IrFactory::eINSTANCE.createInstructionJob =>
			[
				name = jobBaseName + 'FinalAffectation'
				instruction = affectation
			]
			return globalVariable
		}
	}

	private def getOperator(Reduction it)
	{
		switch name
		{
			case 'sum' : '+?='
			case 'reduceMin' : '<?='
			case 'reduceMax' : '>?='
			default : throw new Exception('Unsupported reduction function: ' + name)
		}
	}
}