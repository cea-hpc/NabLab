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
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.SizeType
import fr.cea.nabla.nabla.PrimitiveType

class BaseTypeTypeProvider
{
	@Inject extension PrimitiveTypeTypeProvider

	def NablaSimpleType getTypeFor(BaseType it)
	{ 
		switch sizes.size
		{
			case 0: primitive.typeFor
			case 1: getArray1DTypeFor(primitive, sizes.get(0))
			case 2: getArray2DTypeFor(primitive, sizes.get(0), sizes.get(1))
			default: throw new RuntimeException("Unmanaged type")
		}
	}

	private def NablaSimpleType getArray1DTypeFor(PrimitiveType primitive, SizeType size)
	{
		val s = NSTSizeType.create(size)
		switch primitive
		{
			case INT: new NSTIntArray1D(s)
			case REAL: new NSTRealArray1D(s)
			case BOOL: new NSTBoolArray1D(s)
		}
	}

	private def NablaSimpleType getArray2DTypeFor(PrimitiveType primitive, SizeType nbRows, SizeType nbCols)
	{
		val nbr = NSTSizeType.create(nbRows)
		val nbc = NSTSizeType.create(nbCols)
		switch primitive
		{
			case INT: new NSTIntArray2D(nbr, nbc)
			case REAL: new NSTRealArray2D(nbr, nbc)
			case BOOL: new NSTBoolArray2D(nbr, nbc)
		}
	}
}