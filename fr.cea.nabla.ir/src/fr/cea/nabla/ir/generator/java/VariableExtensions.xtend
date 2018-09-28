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

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.ScalarVariable

class VariableExtensions 
{
	@Inject extension Ir2JavaUtils
	
	def dispatch getJavaType(ScalarVariable it) 
	{ 
		type.javaType
	}
	
	def dispatch getJavaType(ArrayVariable it)
	{
		var t = getType.javaType 
		for (d : dimensions) t += '[]'
		return t
	}

	def getJavaAllocation(ArrayVariable it)
	{
		throw new Exception("Not yet implemented")
//		var alloc = 'new ' + getType.javaType + '[nb' + support.literal.toFirstUpper + 's]'
//		if (innerSupport != ItemType::NONE) alloc = alloc + '[' + getInnerMaxAccessor(support, innerSupport) + ']'
//		return alloc
	}
}