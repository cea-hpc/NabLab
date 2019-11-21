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

import fr.cea.nabla.ir.ir.Arg
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.SimpleVariable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.java.Ir2JavaUtils.*

class ArgOrVarExtensions 
{
	static def dispatch getJavaType(Arg it) 
	{ 
		type.javaType
	}

	static def dispatch getJavaType(SimpleVariable it) 
	{ 
		type.javaType
	}

	static def dispatch getJavaType(ConnectivityVariable it)
	{
		if (linearAlgebra)
		{
			switch type.connectivities.size
			{
				case 1: return 'Vector'
				case 2: return 'Matrix'
				default: throw new RuntimeException("Not implemented exception")
			}
		}
		else
			type.javaType
	}

	static def getCodeName(ArgOrVar it)
	{
		if (option) 'options.' + name
		else name
	}
}