/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.PrimitiveType

class Ir2JavaUtils 
{
	static def getJavaType(BaseType t)
	{
		val rootType = t.root.javaType
		return rootType + t.sizes.map['[]'].join('')
	}
	
	static def getJavaType(PrimitiveType t)
	{
		switch t
		{
			case VOID : 'void'
			case BOOL: 'boolean'
			case INT: 'int'
			case REAL: 'double'
		}
	}
}