package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.ItemIndex
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.Variable
import java.util.List
import org.eclipse.emf.ecore.util.EcoreUtil

import static fr.cea.nabla.ir.transformers.IrTransformationUtils.*

import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import fr.cea.nabla.ir.ir.ConnectivityType

class ReplaceAffectations  extends IrTransformationStep
{
	new()
	{
		super('Replace arrays affectations by scalar affectations in loops')
	}

	override transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)

		for (affectation : ir.eAllContents.filter(Affectation).toList.filter(a | a.left.type instanceof ConnectivityType))
		{
			// we know that left and right have same type
			// For connectivityTypes, we generate loops on connectivities
			val loop = createLoopWithIterator(affectation.left, affectation.right as ArgOrVarRef, (affectation.left.type as ConnectivityType).connectivities, 1)
			replace(affectation, #[loop])
		}

		for (affectation : ir.eAllContents.filter(Affectation).toList)
		{
			// we know that left and right have same type
			// For arrays (sizes  not empty), we generate loops
			if (!(affectation.left.type instanceof LinearAlgebraType)
				&& !affectation.left.type.baseSizes.empty
				&& affectation.right instanceof ArgOrVarRef)
			{
				val loop = createLoopWithInterval(affectation.left, affectation.right as ArgOrVarRef, affectation.left.type.baseSizes, 1)
				replace(affectation, #[loop])
			}
		}
		return true
	}

	/*
	 * createLoopWithInterval
	 * Creates a loop on baseType dimensions to call affectation only on scalars
	 */
	private def create IrFactory::eINSTANCE.createLoop createLoopWithInterval(ArgOrVarRef lhs, ArgOrVarRef rhs, List<Expression> dimensions, int depth)
	{
		val counter = createIterationCounter(depth)
		iterationBlock = createInterval(dimensions.get(0), counter)
		lhs.indices += createCounterRef(counter)
		rhs.indices += createCounterRef(counter)
		if (dimensions.size > 1)
			body = createLoopWithInterval(lhs, rhs, dimensions.tail.toList, depth+1)
		else
			body = createAffectation(lhs, rhs)
		multithreadable = true
	}

	/*
	 * createLoopWithIterator
	 * Creates a loop on connectivityType dimensions to call affectation only on baseTypes
	 */
	private def create IrFactory::eINSTANCE.createLoop createLoopWithIterator(ArgOrVarRef lhs, ArgOrVarRef rhs, List<Connectivity> connectivities, int depth)
	{
		val itemIndex = createItemIndex(connectivities.get(0), depth)
		iterationBlock = createIterator(connectivities.get(0), itemIndex)
		lhs.iterators += itemIndex
		rhs.iterators += itemIndex
		if (connectivities.size > 1)
			body = createLoopWithIterator(lhs, rhs, connectivities.tail.toList, depth+1)
		else
			body = createAffectation(lhs, rhs)
		multithreadable = true
	}

	private def createIterationCounter(int depth)
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

	private def createInterval(Expression expr, Variable counter)
	{
		IrFactory::eINSTANCE.createInterval =>
		[
			index = counter
			nbElems = EcoreUtil::copy(expr)
		]
	}

	private def createItemIndex(Connectivity c, int depth)
	{
		IrFactory::eINSTANCE.createItemIndex =>
		[
			name = "i"+depth+c.name.toFirstUpper
			itemName = "i"
		]
	}

	private def createIterator(Connectivity c, ItemIndex id)
	{
		IrFactory::eINSTANCE.createIterator =>
		[
			index = id
			container = IrFactory::eINSTANCE.createConnectivityCall => [ connectivity = c ]
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
