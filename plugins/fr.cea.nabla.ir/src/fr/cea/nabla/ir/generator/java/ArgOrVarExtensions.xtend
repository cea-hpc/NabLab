/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.Arg
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.SimpleVariable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.Ir2JavaUtils.*

class ArgOrVarExtensions
{
	static def dispatch getJavaAllocation(SimpleVariable it)
	{
		if (type.scalar) ''''''
		else ''' = new «type.primitive.javaType»«type.dimContent»'''
	}

	static def dispatch getJavaAllocation(ConnectivityVariable it)
	''' = new «type.primitive.javaType»«type.dimContent»'''

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

	private def static dispatch String getDimContent(BaseType it)
	'''«FOR s : sizes BEFORE '[' SEPARATOR '][' AFTER ']'»«s.content»«ENDFOR»'''

	private def static dispatch String getDimContent(ConnectivityType it)
	'''«FOR c : connectivities»[«c.nbElems»]«ENDFOR»«base.dimContent»'''
}