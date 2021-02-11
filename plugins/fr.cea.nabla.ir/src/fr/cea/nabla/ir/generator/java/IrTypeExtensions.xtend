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

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.LinearAlgebraType

import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.JavaGeneratorUtils.*

class IrTypeExtensions
{
	static def dispatch String getJavaType(BaseType it)
	{
		if (it === null) return 'null'
		var ret = primitive.javaType
		for (s : sizes) ret += '[]'
		return ret
	}

	static def dispatch String getJavaType(ConnectivityType it)
	{
		if (it === null) return 'null'
		base.javaType + connectivities.map['[]'].join
	}

	static def dispatch String getJavaType(LinearAlgebraType t)
	{
		switch t.sizes.size
		{
			case 1: return 'Vector'
			case 2: return 'Matrix'
			default: throw new RuntimeException("Not implemented exception")
		}
	}
	
	static def dispatch getJavaAllocation(BaseType it)
	{
		if (scalar) ''
		else ' = new ' + primitive.javaType + dimContent
	}

	static def dispatch getJavaAllocation(ConnectivityType it)
	{
		' = new ' + primitive.javaType + dimContent
	}
	
	static def dispatch getJavaAllocation(LinearAlgebraType it)
	{
		if (sizes.size == 1) ' = Vector.createDenseVector(' + sizes.head.content + ')'
		else if (sizes.size == 2) ' = Matrix.createDenseMatrix(' + sizes.map[content].join(', ') + ')'
		else throw new RuntimeException("Not implemented exception")
	}
	
	private def static dispatch String getDimContent(BaseType it)
	'''«FOR s : sizes BEFORE '[' SEPARATOR '][' AFTER ']'»«s.content»«ENDFOR»'''

	private def static dispatch String getDimContent(ConnectivityType it)
	'''«FOR c : connectivities»[«c.nbElemsVar»]«ENDFOR»«base.dimContent»'''
	
	private def static dispatch String getDimContent(LinearAlgebraType it)
	'''«FOR s : sizes BEFORE '[' SEPARATOR '][' AFTER ']'»«s.content»«ENDFOR»'''	
}