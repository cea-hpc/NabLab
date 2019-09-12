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
import fr.cea.nabla.nabla.Array1D
import fr.cea.nabla.nabla.Array2D
import fr.cea.nabla.nabla.Scalar

class BaseTypeTypeProvider 
{
	@Inject extension PrimitiveTypeTypeProvider
	
	def dispatch NTSimpleType getTypeFor(Scalar it) 
	{ 
		primitive.typeFor
	}
	
	def dispatch NTSimpleType getTypeFor(Array1D it) 
	{ 
		switch primitive
		{
			case INT: new NTIntArray1D(size)
			case REAL: new NTRealArray1D(size)
			case BOOL: new NTBoolArray1D(size)
		}
	}
	
	def dispatch NTSimpleType getTypeFor(Array2D it) 
	{ 
		switch primitive
		{
			case INT: new NTIntArray2D(nbRows, nbCols)
			case REAL: new NTRealArray2D(nbRows, nbCols)
			case BOOL: new NTBoolArray2D(nbRows, nbCols)
		}
	}
}