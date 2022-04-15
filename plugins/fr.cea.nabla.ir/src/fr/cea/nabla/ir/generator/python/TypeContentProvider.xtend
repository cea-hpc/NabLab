/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.python

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType

import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.python.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.python.PythonGeneratorUtils.*

class TypeContentProvider
{
	static def CharSequence getPythonAllocation(IrType it, String name)
	{
		switch it
		{
			BaseType case scalar: ''''''
			BaseType: getNumpyAllocation(sizes.map[content], primitive)
			ConnectivityType: getNumpyAllocation(connectivities.map[nbElems] + base.sizes.map[content], primitive)
			LinearAlgebraType: ''' = «IrTypeExtensions.getLinearAlgebraClass(it)».zeros("«name»", «FOR s : sizes SEPARATOR ', '»«s.content»«ENDFOR»)'''
		}
	}

	static def String getNumpyType(PrimitiveType t)
	{
		switch t
		{
			case BOOL: 'bool_'
			case INT: 'int_'
			case REAL: 'double'
		}
	}

	private static def getNumpyAllocation(Iterable<CharSequence> iteratorsAndIndices, PrimitiveType primitive)
	''' = np.empty((«FOR i : iteratorsAndIndices SEPARATOR ", "»«i»«ENDFOR»), dtype=np.«primitive.numpyType»)'''
}
