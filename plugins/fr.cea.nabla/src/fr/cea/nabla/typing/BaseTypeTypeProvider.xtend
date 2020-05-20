/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.ExpressionExtensions
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.PrimitiveType

class BaseTypeTypeProvider
{
	@Inject extension PrimitiveTypeTypeProvider
	@Inject extension ExpressionExtensions

	def NablaSimpleType getTypeFor(BaseType it)
	{
		switch sizes.size
		{
			case 0: primitive.typeFor
			case 1:
			{
				val size = sizes.get(0)
				// if the label is null, the expression is not consistent
				if (size === null || !size.reductionLess)
					null
				else
					getArray1DTypeFor(primitive, sizes.get(0))
			}
			case 2: 
			{
				val nbRows = sizes.get(0)
				val nbCols = sizes.get(1)
				if (nbRows === null || nbCols === null || !nbRows.reductionLess || !nbCols.reductionLess)
					null
				else 
					getArray2DTypeFor(primitive, nbRows, nbCols)
			}
			default: throw new RuntimeException("Unmanaged type")
		}
	}

	def NablaSimpleType getArray1DTypeFor(PrimitiveType primitive, Expression size)
	{
		if (size === null) null
		else switch primitive
		{
			case INT: new NSTIntArray1D(size)
			case REAL: new NSTRealArray1D(size)
			case BOOL: new NSTBoolArray1D(size)
		}
	}

	def NablaSimpleType getArray2DTypeFor(PrimitiveType primitive, Expression nbRows, Expression nbCols)
	{
		if (nbRows === null || nbCols === null) null
		else switch primitive
		{
			case INT: new NSTIntArray2D(nbRows, nbCols)
			case REAL: new NSTRealArray2D(nbRows, nbCols)
			case BOOL: new NSTBoolArray2D(nbRows, nbCols)
		}
	}
}