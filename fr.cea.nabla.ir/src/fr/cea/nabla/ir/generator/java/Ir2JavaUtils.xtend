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
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.PrimitiveType

class Ir2JavaUtils 
{
	static def getJavaType(BaseType t)
	{
		val rootType = t.root.javaType
		return rootType + t.dimSizes.map['[]'].join('')
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
	
	static def getOperatorName(String op)
	{
		switch op
		{
			case '/': 'divide'
			case '-': 'minus'
			case '*': 'multiply'
			case '+': 'plus'
		}
	}
}