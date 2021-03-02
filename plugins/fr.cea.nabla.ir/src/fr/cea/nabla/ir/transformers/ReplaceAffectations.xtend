package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.Variable
import java.util.List
import org.eclipse.emf.ecore.util.EcoreUtil

import static fr.cea.nabla.ir.transformers.IrTransformationUtils.*

class ReplaceAffectations  extends IrTransformationStep
{

	new()
	{
		super('Replace arrays affectations by scalar affectations in loops')
	}

	override transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)
		var affectations = ir.eAllContents.filter(Affectation)

		for (affectation : affectations.toList)
		{
			// we know that left and right have same type and left cannot be ConnectivityType
			// For arrays (sizes  not empty), we generate loops
			if (affectation.left.type instanceof BaseType)
			{
				val baseType = affectation.left.type as BaseType
				if (!baseType.sizes.empty && affectation.right instanceof ArgOrVarRef)
				{
					val loop = createLoop(affectation.left, affectation.right as ArgOrVarRef, baseType.sizes, 1)
					replace(affectation, #[loop])
				}
			}
		}
		return true
	}

	private def create IrFactory::eINSTANCE.createLoop createLoop(ArgOrVarRef lhs, ArgOrVarRef rhs, List<Expression> dimensions, int depth)
	{
		val counter = createIterationCounter(depth)
		iterationBlock = createInterval(dimensions.get(0), counter)
		lhs.indices += createCounterRef(counter)
		rhs.indices += createCounterRef(counter)
		if (dimensions.size > 1)
			body = createLoop(lhs, rhs, dimensions.tail.toList, depth+1)
		else
			body = createAffectation(lhs, rhs)
		multithreadable = true
	}

	private	def createIterationCounter(int depth)
	{
		IrFactory::eINSTANCE.createVariable =>
		[
			name = "i" + depth
			type = IrFactory.eINSTANCE.createBaseType => [ primitive = PrimitiveType::INT ]
			const = false
			constExpr = false
			option = false
		]
	}

	private	def createInterval(Expression expr, Variable counter)
	{
		IrFactory::eINSTANCE.createInterval =>
		[
			index = counter
			nbElems = EcoreUtil::copy(expr)
		]
	}

	private def createAffectation(ArgOrVarRef lhs, ArgOrVarRef rhs)
	{
		IrFactory::eINSTANCE.createAffectation =>
		[
			left = lhs
			right = rhs
		]
	}

	private def createCounterRef(Variable counter)
	{
		IrFactory::eINSTANCE.createArgOrVarRef =>
		[
			type = EcoreUtil::copy(counter.type)
			target = counter
		]
	}
}