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
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ItemType
import fr.cea.nabla.nabla.PrimitiveType

@Singleton
class IrBasicFactory
{
	@Inject extension IrAnnotationHelper

	def create IrFactory::eINSTANCE.createConnectivity toIrConnectivity(Connectivity c)
	{
		annotations += c.toIrAnnotation
		name = c.name
		returnType = c.returnType.toIrItemType
		inTypes += c.inTypes.map[toIrItemType]
		multiple = c.multiple
	}

	def toIrPrimitiveType(PrimitiveType t)
	{
		val type = fr.cea.nabla.ir.ir.PrimitiveType::get(t.value + 1) // First literal is VOID in the IR model
		if (type === null) throw new RuntimeException('Conversion Nabla --> IR impossible : type inconnu ' + t.literal)
		return type
	}

	def create IrFactory::eINSTANCE.createItemType toIrItemType(ItemType i)
	{
		annotations += i.toIrAnnotation
		name = i.name
	}
}