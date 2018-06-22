package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrFactory
import org.eclipse.emf.ecore.EObject
import fr.cea.nabla.ir.ir.ExpressionType
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionCall
import fr.cea.nabla.ir.ir.Job

abstract class ReplaceReductionsBase 
{
	protected def createReductionLoop(Iterator iterator, Variable affectationLHS, Expression affectationRHS, String op)
	{
		val loop = IrFactory::eINSTANCE.createLoop
		loop.iterator = iterator
		loop.body = IrFactory::eINSTANCE.createAffectation => 
		[
			left = IrFactory::eINSTANCE.createVarRef => 
			[ 
				variable = affectationLHS
				type = affectationRHS.type.clone
			]
			operator = op
			right = affectationRHS
		]
		return loop
	}	
	
	protected def clone(ExpressionType t)
	{
		IrFactory::eINSTANCE.createExpressionType => 
		[
			basicType = t.basicType
			dimension = t.dimension
		]
	}

	protected def boolean isGlobal(EObject it)
	{
		if (eContainer === null) false
		else if (eContainer instanceof Loop) false
		else if (eContainer instanceof ReductionCall) false
		else if (eContainer instanceof Job) true
		else eContainer.global	
	}
}