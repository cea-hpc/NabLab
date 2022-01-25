/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.BaseTypeSizeEvaluator
import fr.cea.nabla.InvalidBaseTypeSize
import fr.cea.nabla.LinearAlgebraUtils
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.PrimitiveType

class BaseTypeTypeProvider
{
	@Inject extension BaseTypeSizeEvaluator
	@Inject extension PrimitiveTypeTypeProvider
	@Inject extension LinearAlgebraUtils

	def NablaType getTypeFor(BaseType it)
	{
		switch sizes.size
		{
			case 0: primitive.typeFor
			case 1:
			{
				val size = sizes.get(0)
				if (size === null) return null

				var int intSize
				try 
				{
					intSize = getIntSizeFor(size)
				}
				catch (InvalidBaseTypeSize e)
				{
					return null
				}

				// if the label is null, the expression is not consistent
				val laExtension = linearAlgebraExtension
				if (laExtension === null)
					return getNSTArray1DFor(primitive, size, intSize)
				else
					return new NLATVector(laExtension, size, intSize)
			}
			case 2:
			{
				val nbRows = sizes.get(0)
				if (nbRows === null) return null

				val nbCols = sizes.get(1)
				if (nbCols === null) return null

				var int intNbRows
				var int intNbCols
				try 
				{
					intNbRows = getIntSizeFor(nbRows)
					intNbCols = getIntSizeFor(nbCols)
				}
				catch (InvalidBaseTypeSize e)
				{
					return null
				}

				val laExtension = linearAlgebraExtension
				if (laExtension === null)
					return getNSTArray2DFor(primitive, nbRows, nbCols, intNbRows, intNbCols)
				else
					return new NLATMatrix(laExtension, nbRows, nbCols, intNbRows, intNbCols)
			}
			default: null
		}
	}

	def NSTArray1D getNSTArray1DFor(PrimitiveType primitive, Expression size, int intSize)
	{
		if (size === null) null
		else switch primitive
		{
			case INT: new NSTIntArray1D(size, intSize)
			case REAL: new NSTRealArray1D(size, intSize)
			case BOOL: new NSTBoolArray1D(size, intSize)
		}
	}

	def NSTArray2D getNSTArray2DFor(PrimitiveType primitive, Expression nbRows, Expression nbCols, int intNbRows, int intNbCols)
	{
		if (nbRows === null || nbCols === null) null
		else switch primitive
		{
			case INT: new NSTIntArray2D(nbRows, nbCols, intNbRows, intNbCols)
			case REAL: new NSTRealArray2D(nbRows, nbCols, intNbRows, intNbCols)
			case BOOL: new NSTBoolArray2D(nbRows, nbCols, intNbRows, intNbCols)
		}
	}
}