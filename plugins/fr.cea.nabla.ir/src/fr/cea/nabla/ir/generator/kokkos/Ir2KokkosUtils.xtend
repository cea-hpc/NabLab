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
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.PrimitiveType

import static extension fr.cea.nabla.ir.generator.SizeTypeContentProvider.*

class Ir2KokkosUtils 
{
	static def dispatch String getCppType(BaseType it) 
	{
		if (it === null) 
			'null'
		else if (sizes.empty) 
			primitive.cppType
		else
			getCppArrayType(primitive, sizes.size) + '<' + sizes.map[content].join(',') + '>'
	}

	static def dispatch String getCppType(ConnectivityType it) 
	{ 
		'Kokkos::View<' + base.cppType + connectivities.map['*'].join + '>'
	}

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

	private static def getCppArrayType(PrimitiveType t, int dim)
	{
		switch t
		{
			case null, case BOOL : throw new RuntimeException('Not implemented')
			case INT: 'IntArray' + dim + 'D'
			case REAL: 'RealArray' + dim + 'D'
		}
 	}
}