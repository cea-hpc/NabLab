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
import fr.cea.nabla.ir.ir.SizeType
import fr.cea.nabla.nabla.SizeTypeInt
import fr.cea.nabla.nabla.SizeTypeOperation
import fr.cea.nabla.nabla.SizeTypeSymbol
import fr.cea.nabla.nabla.SizeTypeSymbolRef

/**
 * No create method for Dimension to ensure a new instance every time (for n+1 time variables)
 * but take care to keep a create method for DimensionSymbol (and to keep @Singleton)
 */
@Singleton
class IrSizeTypeFactory 
{
	@Inject extension IrAnnotationHelper

	def dispatch SizeType toIrSizeType(SizeTypeInt d)
	{
		IrFactory::eINSTANCE.createSizeTypeInt =>
		[
			annotations += d.toIrAnnotation
			value = d.value
		]
	}

	def dispatch SizeType toIrSizeType(SizeTypeOperation d)
	{
		IrFactory::eINSTANCE.createSizeTypeOperation =>
		[
			annotations += d.toIrAnnotation
			left = d.left.toIrSizeType
			right = d.right.toIrSizeType
			operator = d.op
		]
	}

	def dispatch SizeType toIrSizeType(SizeTypeSymbolRef d)
	{
		IrFactory::eINSTANCE.createSizeTypeSymbolRef =>
		[
			annotations += d.toIrAnnotation
			target = d.target.toIrSizeTypeSymbol
		]
	}

	def create IrFactory::eINSTANCE.createSizeTypeSymbol toIrSizeTypeSymbol(SizeTypeSymbol d)
	{
		annotations += d.toIrAnnotation
		name = d.name
	}
}