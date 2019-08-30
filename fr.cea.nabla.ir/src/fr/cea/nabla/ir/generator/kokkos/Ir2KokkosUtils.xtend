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

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.PrimitiveType

class Ir2KokkosUtils 
{
	static def getCppType(BaseType t)
	{
		val rootType = t.root.cppType
		if (t.sizes.empty) 
			rootType
		else
			t.root.arrayPrimitiveType + 'Array' + t.sizes.size + 'D<' + t.sizes.join(',') + '>'
	}

	static def getCppType(PrimitiveType t)
	{
		switch t
		{
			case VOID : 'void'
			case BOOL: 'bool'
			case INT: 'int'
			case REAL: 'double'
		}
 	}	

	private static def getArrayPrimitiveType(PrimitiveType t)
	{
		switch t
		{
			case VOID : throw new RuntimeException('Not implemented')
			case BOOL: throw new RuntimeException('Not implemented')
			case INT: 'Int'
			case REAL: 'Real'
		}
 	}	
}