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

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.VariableExtensions.*
import static extension fr.cea.nabla.ir.generator.java.Ir2JavaUtils.*

class VariableExtensions 
{
	static def dispatch getJavaType(SimpleVariable it) 
	{ 
		type.javaType
	}
	
	static def dispatch getJavaType(ConnectivityVariable it)
	{
		if (linearAlgebra)
		{
			switch supports.size
			{
				case 1: return 'Vector'
				case 2: return 'Matrix'
				default: throw new RuntimeException("Not implemented exception")
			}
		}
		else
		{
			var t = getType.javaType 
			for (d : supports) t += '[]'
			return t	
		}
	}
	
	static def getCodeName(Variable it)
	{
		if (scalarConst && global) 'options.' + name
		else name
	}	
}