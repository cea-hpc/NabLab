/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.ir.ir.IterationBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.SpaceIterator
import java.util.ArrayList
import java.util.List

@Singleton
class IrIterationBlockFactory 
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrConnectivityCallFactory
	@Inject extension IrItemIndexDefinitionFactory
	@Inject extension IrItemIdDefinitionFactory
	@Inject extension IrItemIndexFactory
	@Inject extension IrArgOrVarFactory
	@Inject extension IrExpressionFactory

	def toIrIterator(SpaceIterator b)
	{
		b.toIrIterationBlock as Iterator
	}

	def dispatch IterationBlock create IrFactory::eINSTANCE.createIterator toIrIterationBlock(SpaceIterator b)
	{
		annotations += b.toIrAnnotation
		index = b.toIrIndex
		container = toIrConnectivityCall(b.container.connectivity, b.container.args)
	}

	def dispatch IterationBlock create IrFactory::eINSTANCE.createInterval toIrIterationBlock(Interval b)
	{
		annotations += b.toIrAnnotation
		index = toIrSimpleVariable(b.index, b.index.name)
		nbElems = b.nbElems.toIrExpression
	}

	def dispatch List<Instruction> getNeededIndexAndIdDefinitions(SpaceIterator b)
	{
		val instructions = new ArrayList<Instruction>
		instructions += b.neededIdDefinitions
		instructions += b.neededIndexDefinitions
		for (s : b.singletons)
		{
			instructions += s.toIrIdDefinition
			instructions += s.item.neededIndexDefinitions
		}
		return instructions
	}

	def dispatch List<Instruction> getNeededIndexAndIdDefinitions(Interval b)
	{
		#[]
	}
}