/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.nabla.ArgOrVarType
import fr.cea.nabla.nabla.Dimension
import fr.cea.nabla.nabla.PrimitiveType

class ArgOrVarTypeTypeProvider
{
	@Inject extension PrimitiveTypeTypeProvider

	def NablaSimpleType getTypeFor(ArgOrVarType it)
	{ 
		switch sizes.size
		{
			case 0: primitive.typeFor
			case 1: getArray1DTypeFor(primitive, sizes.get(0))
			case 2: getArray2DTypeFor(primitive, sizes.get(0), sizes.get(1))
			default: throw new RuntimeException("Unmanaged type")
		}
	}

	private def NablaSimpleType getArray1DTypeFor(PrimitiveType primitive, Dimension size)
	{
		val s = NSTDimension.create(size)
		switch primitive
		{
			case INT: new NSTIntArray1D(s)
			case REAL: new NSTRealArray1D(s)
			case BOOL: new NSTBoolArray1D(s)
		}
	}

	private def NablaSimpleType getArray2DTypeFor(PrimitiveType primitive, Dimension nbRows, Dimension nbCols)
	{
		val nbr = NSTDimension.create(nbRows)
		val nbc = NSTDimension.create(nbCols)
		switch primitive
		{
			case INT: new NSTIntArray2D(nbr, nbc)
			case REAL: new NSTRealArray2D(nbr, nbc)
			case BOOL: new NSTBoolArray2D(nbr, nbc)
		}
	}
}