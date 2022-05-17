/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.ItemId
import fr.cea.nabla.ir.ir.ItemIndex
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.util.EcoreUtil

import static extension fr.cea.nabla.ir.IrTypeExtensions.*

/**
 * Replace affectations to avoid aliasing.
 * Affectations on connectivity and array variables at left and ArgOrVarRef instance at right
 * are replaced by a loop to avoid aliasing.
 * Note that an affectation on a connectivity variable is an error in the NabLab language but it 
 * can be created during IR transformation (for example Un = Un+1 at the end of time loop).
 */
class ReplaceAffectations extends IrTransformationStep
{
	override getDescription()
	{
		"Replace arrays affectations by scalar affectations in loops"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		for (affectation : ir.eAllContents.filter(Affectation).toList.filter(a | a.left.type instanceof ConnectivityType))
		{
			// we know that left and right have same type
			// For connectivityTypes, we generate loops on connectivities
			val loop = createLoopWithIterator(affectation.left, affectation.right as ArgOrVarRef, (affectation.left.type as ConnectivityType).connectivities, 1, new ArrayList<ItemId>)
			EcoreUtil.replace(affectation, loop)
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
				IrTransformationUtils.replace(affectation, #[loop])
			}
		}
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		// nothing to do
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
	}

	/*
	 * createLoopWithIterator
	 * Creates a loop on connectivityType dimensions to call affectation only on baseTypes
	 */
	private def create IrFactory::eINSTANCE.createLoop createLoopWithIterator(ArgOrVarRef lhs, ArgOrVarRef rhs, List<Connectivity> connectivities, int depth, List<ItemId> idArgs)
	{
		val connectivity = connectivities.get(0)
		val itemIndex = createItemIndex(connectivity, depth)
		val iter = createIterator(connectivity, itemIndex, idArgs)
		iterationBlock = iter
		lhs.iterators += itemIndex
		rhs.iterators += itemIndex
		val instructionBlock = IrFactory::eINSTANCE.createInstructionBlock
		if (connectivities.size > 1 && !connectivities.get(1).inTypes.empty)
		{
			// SubConnectivity will need Id on ItemIndex
			val itemId = IrFactory.eINSTANCE.createItemId =>
			[
				name = itemIndex.name + 'Id'
				itemName = itemIndex.name
			]
			val itemIdDefinition = IrFactory.eINSTANCE.createItemIdDefinition =>
			[
				id = itemId
				value = IrFactory::eINSTANCE.createItemIdValueIterator =>
				[
					iterator = iter
					shift = 0
				]
			]
			instructionBlock.instructions += itemIdDefinition
			idArgs += itemIdDefinition.id
		}
		if (connectivities.size > 1)
			instructionBlock.instructions += createLoopWithIterator(lhs, rhs, connectivities.tail.toList, depth+1, idArgs)
		else
			instructionBlock.instructions += createAffectation(lhs, rhs)
		body = instructionBlock
	}

	private def createIterationCounter(int depth)
	{
		IrFactory::eINSTANCE.createVariable =>
		[
			name = "i" + depth
			type = IrFactory.eINSTANCE.createBaseType =>
			[
				primitive = PrimitiveType::INT
				isStatic = true
			]
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

	private def createIterator(Connectivity c, ItemIndex id, List<ItemId> argsIds)
	{
		IrFactory::eINSTANCE.createIterator =>
		[
			index = id
			container = IrFactory::eINSTANCE.createConnectivityCall =>
			[
				connectivity = c
				args += argsIds
			]
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
