/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType

import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.dace.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.dace.DaceGeneratorUtils.*
import fr.cea.nabla.ir.ContainerExtensions

class TypeContentProvider
{
	static def getDaceType(IrType it)
	{
		switch it
		{
			BaseType case scalar: '''dace.scalar(«getDaceType(primitive)»)'''
			BaseType: '''«getDaceType(primitive)»[«FOR s : intSizes SEPARATOR ', '»«s»«ENDFOR»]'''
			ConnectivityType: '''«getDaceType(primitive)»[«FOR s : connectivities.map[x | ContainerExtensions.getNbElemsVar(x)] + base.intSizes SEPARATOR ', '»«s»«ENDFOR»]'''
			LinearAlgebraType: throw new RuntimeException("Not yet implemented")
		}
	}

	static def getDaceType(PrimitiveType t)
	{
		switch t
		{
			case BOOL: "dace.bool"
			case INT: "dace.int64"
			case REAL: "dace.float64"
		}
	}

	static def CharSequence getPythonAllocation(IrType it, String name)
	{
		switch it
		{
			BaseType case scalar: ''''''
			BaseType: getNumpyAllocation(sizes.map[content], primitive)
			ConnectivityType: getNumpyAllocation(connectivities.map[nbElems] + base.sizes.map[content], primitive)
			LinearAlgebraType: ''' = «IrTypeExtensions.getLinearAlgebraClass(it)».empty("«name»", «FOR s : sizes SEPARATOR ', '»«s.content»«ENDFOR»)'''
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
