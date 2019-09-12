/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.Scalar

class Ir2KokkosUtils 
{
	static def dispatch String getCppType(Scalar it) { primitive.cppType }
	static def dispatch String getCppType(Array1D it) { primitive.cppArrayType + 'Array1D<' + size + '>' }
	static def dispatch String getCppType(Array2D it) { primitive.cppArrayType + 'Array2D<' + nbRows + ', ' + nbCols + '>' }

	static def dispatch getCppType(PrimitiveType t)
	{
		switch t
		{
			case null : 'void'
			case BOOL: 'bool'
			case INT: 'int'
			case REAL: 'double'
		}
 	}	

	private static def getCppArrayType(PrimitiveType t)
	{
		switch t
		{
			case null, case BOOL : throw new RuntimeException('Not implemented')
			case INT: 'Int'
			case REAL: 'Real'
		}
 	}	
}