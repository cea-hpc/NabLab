package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionCall
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.ScalarVarDefinition
import java.util.List
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.ecore.util.FeatureMapUtil

class Ir2IrNoInternalReduction implements Ir2IrPass
{
	override getDescription() 
	{
		'Replacing internal reductions by loops'
	}

	/**
	 * Transforme le module m pour qu'il n'est plus de d'instance de ReductionInstruction.
	 * Les réductions sont remplacées par des fonctions traditionnelles.
	 */
	override transform(IrModule m)
	{
		for (reductionInstr : m.eAllContents.filter(ReductionInstruction).toIterable)
		{
			// création des fonctions correspondantes
			// 2 arguments IN : 1 du type de la collection, l'autre du type de retour (appel en chaine)
			val reduc = reductionInstr.reduction.reduction
			val function = findOrCreateFunction(m, reduc)
										
			// transformation de la reduction
			val loop = reductionInstr.createReductionLoop(function)
			val variableDefinition = IrFactory::eINSTANCE.createScalarVarDefinition => [ variables += reductionInstr.variable ]
			replace(reductionInstr, variableDefinition, loop)			

			// si la réduction n'est pas référencée, on l'efface
			if (!m.eAllContents.filter(ReductionCall).exists[x | x.reduction == reduc])
				EcoreUtil::delete(reduc, true)
		}
	}
	
	private def findOrCreateFunction(IrModule m, Reduction r)
	{
		var function = m.functions.findFirst
		[   
			name == r.name && 
			inTypes.length == 2 && 
			inTypes.get(0) == r.collectionType && 
			inTypes.get(1) == r.returnType && 
			returnType == r.returnType
		]
		
		if (function === null) 
		{ 
			function = IrFactory::eINSTANCE.createFunction =>
			[
				name = r.name
				inTypes += r.collectionType
				inTypes += r.returnType
				returnType = r.returnType
			]
			m.functions += function
		}
		
		return function
	}
	
	/**
	 * Création de la boucle de la réduction.
	 * L'itérateur de la boucle est celui de la réduction.
	 * La réduction est transformée en une fonction de même nom.
	 */
	private def createReductionLoop(ReductionInstruction reductionInstr, Function f)
	{
		val loop = IrFactory::eINSTANCE.createLoop
		loop.iterator = reductionInstr.reduction.iterator
		loop.body = IrFactory::eINSTANCE.createAffectation => 
		[
			left = IrFactory::eINSTANCE.createVarRef => [ variable = reductionInstr.variable ]
			operator = '='
			right = IrFactory::eINSTANCE.createFunctionCall =>
			[
				function = f
				args += IrFactory::eINSTANCE.createVarRef => [ variable = reductionInstr.variable ]
				args += reductionInstr.reduction.arg
			]
		]
		return loop
	}
	
	/**
	 * Extension de la méthode EcoreUtil::replace pour une liste d'objet.
	 * Si le eContainmentFeature est de cardinalité 1, un block est créé,
	 * sinon les instructions sont ajoutées une à une à l'emplacement de la réduction.
	 */
	private def replace(ReductionInstruction reduction, ScalarVarDefinition replacementI1, Loop replacementI2)
	{
    	val container = reduction.eContainer
    	if (container !== null)
		{
			val feature = reduction.eContainmentFeature
			if (FeatureMapUtil.isMany(container, feature))
			{
				val list = container.eGet(feature) as List<Object>
				val reductionIndex = list.indexOf(reduction)
				list.set(reductionIndex, replacementI1)
				list.add(reductionIndex+1, replacementI2)
      		}
			else
			{
				val replacementBlock = IrFactory::eINSTANCE.createInstructionBlock => 
				[ 
					instructions += replacementI1
					instructions += replacementI2
				]
				container.eSet(feature, replacementBlock)
			}
		}
	}
}