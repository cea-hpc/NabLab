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
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.typing.NSTArray1D
import fr.cea.nabla.typing.NSTArray2D
import fr.cea.nabla.typing.NSTScalar
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.typing.NablaSimpleType
import fr.cea.nabla.typing.NablaType

class NablaType2IrType 
{
	@Inject extension IrBasicFactory
	@Inject extension IrExpressionFactory

	def IrType toIrType(NablaType t)
	{
		switch t
		{
			case null: null // Undefined type
			NablaSimpleType: t.toIrBaseType
			NablaConnectivityType: t.toIrConnectivityType
		}
	}

	def dispatch BaseType toIrBaseType(NSTScalar t)
	{
		IrFactory.eINSTANCE.createBaseType =>
		[
			primitive = t.primitive.toIrPrimitiveType
		]
	}

	def dispatch BaseType toIrBaseType(NSTArray1D t)
	{
		IrFactory.eINSTANCE.createBaseType =>
		[
			primitive = t.primitive.toIrPrimitiveType
			sizes += t.size.toIrExpression
		]
	}

	def dispatch BaseType toIrBaseType(NSTArray2D t)
	{
		IrFactory.eINSTANCE.createBaseType =>
		[
			primitive = t.primitive.toIrPrimitiveType
			sizes += t.nbRows.toIrExpression
			sizes += t.nbCols.toIrExpression
		]
	}

	private def ConnectivityType toIrConnectivityType(NablaConnectivityType t)
	{
		IrFactory.eINSTANCE.createConnectivityType =>
		[
			base = t.simple.toIrBaseType
			t.supports.forEach[x | connectivities += x.toIrConnectivity]
		]
	}
}