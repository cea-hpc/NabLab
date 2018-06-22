package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.BasicType
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.ExpressionType
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionCall
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.ScalarVarDefinition
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.ecore.util.FeatureMapUtil

class ReplaceInternalReductions implements IrTransformationStep
{
	static val Operators = #{ 'sum'->'+', 'prod'->'*' }
	
	override getDescription() 
	{
		'Replace internal reductions by loops'
	}

	/**
	 * Transforme le module m pour qu'il n'est plus d'instance de ReductionInstruction.
	 * Les réductions sont remplacées par des opérateurs ou des fonctions traditionnelles.
	 * Le choix se fait en fonction de la liste Operators.
	 */
	override transform(IrModule m)
	{
		for (reductionInstr : m.eAllContents.filter(ReductionInstruction).filter[!reduction.global].toIterable)
		{
			// création des fonctions correspondantes
			// 2 arguments IN : 1 du type de la collection, l'autre du type de retour (appel en chaine)
			val reduc = reductionInstr.reduction.reduction
						
			// transformation de la reduction
			val loopExpression = createAffectationRHS(m, reductionInstr)
			val loop = reductionInstr.createReductionLoop(loopExpression)
			val variableDefinition = IrFactory::eINSTANCE.createScalarVarDefinition => [ variables += reductionInstr.variable ]
			replace(reductionInstr, variableDefinition, loop)			

			// si la réduction n'est pas référencée, on l'efface
			if (!m.eAllContents.filter(ReductionCall).exists[x | x.reduction == reduc])
				EcoreUtil::delete(reduc, true)
		}
	}
	
	private def Expression createAffectationRHS(IrModule m, ReductionInstruction reductionInstr)
	{
		val reduction = reductionInstr.reduction.reduction
		val varRef = IrFactory::eINSTANCE.createVarRef => 
		[ 
			variable = reductionInstr.variable
			type = createExpressionType(variable.type)
		]
		
		if (Operators.keySet.contains(reduction.name))
		{
			return IrFactory::eINSTANCE.createBinaryExpression =>
			[
				type = createExpressionType(reduction.returnType)
				operator = Operators.get(reduction.name)
				left = varRef
				right = IrFactory::eINSTANCE.createParenthesis => 
				[ 
					expression = reductionInstr.reduction.arg
					type = expression.type.clone
				]
			]
		}
		else
		{
			// creation de la fonction
			val f = findOrCreateFunction(m, reduction)										
			// transformation de la reduction
			return IrFactory::eINSTANCE.createFunctionCall =>
			[
				type = createExpressionType(f.returnType)
				function = f
				args += varRef
				args += reductionInstr.reduction.arg
			] 
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
				provider = r.provider
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
	private def createReductionLoop(ReductionInstruction reductionInstr, Expression affectationRHS)
	{
		val loop = IrFactory::eINSTANCE.createLoop
		loop.iterator = reductionInstr.reduction.iterator
		loop.body = IrFactory::eINSTANCE.createAffectation => 
		[
			left = IrFactory::eINSTANCE.createVarRef => 
			[ 
				variable = reductionInstr.variable
				type = affectationRHS.type.clone
			]
			operator = '='
			right = affectationRHS
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

	private def createExpressionType(BasicType t)
	{
		IrFactory::eINSTANCE.createExpressionType => 
		[
			basicType = t
			dimension = 0
		]
	}

	private def clone(ExpressionType t)
	{
		IrFactory::eINSTANCE.createExpressionType => 
		[
			basicType = t.basicType
			dimension = t.dimension
		]
	}

	def boolean isGlobal(EObject it)
	{
		if (eContainer === null) false
		else if (eContainer instanceof Loop) false
		else if (eContainer instanceof ReductionCall) false
		else if (eContainer instanceof Job) true
		else eContainer.global	
	}
}