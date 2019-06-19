/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.BaseType

class Ir2KokkosUtils 
{
	static def getKokkosType(BaseType t)
	{
		val rootType = switch t.root
		{
			case VOID : 'void'
			case BOOL: 'bool'
			case INT: 'int'
			case REAL: 'double'
		}
		return rootType + t.dimSizes.map[x | '[' + x + ']'].join
 	}	
}