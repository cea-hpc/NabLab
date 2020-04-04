/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.PrimitiveType
import org.eclipse.xtend.lib.annotations.Accessors

abstract class TypeContentProvider
{
	@Accessors extension ExpressionContentProvider expressionContentProvider

	protected abstract def String getCppType(BaseType baseType, Iterable<Connectivity> connectivities)
	protected abstract def String getLinearAlgebraType(int dimension)

	def dispatch String getCppType(BaseType it)
	{
		if (it === null)
			'null'
		else if (sizes.empty)
			primitive.cppType
		else
			getCppArrayType(primitive, sizes.size) + '<' + sizes.map[content].join(',') + '>'
	}

	def dispatch String getCppType(PrimitiveType it)
	{
		switch it
		{
			case null : 'void'
			case BOOL: 'bool'
			case INT: 'int'
			case REAL: 'double'
		}
 	}

	def dispatch String getCppType(ConnectivityType it)
	{
		getCppType(base, connectivities)
	}

	private def getCppArrayType(PrimitiveType t, int dim)
	{
		switch t
		{
			case null, case BOOL : throw new RuntimeException('Not implemented')
			case INT: 'IntArray' + dim + 'D'
			case REAL: 'RealArray' + dim + 'D'
		}
 	}
 }

class StlTypeContentProvider extends TypeContentProvider
{
	override getCppType(BaseType baseType, Iterable<Connectivity> connectivities) 
	{
		if (connectivities.empty) baseType.cppType
		else 'std::vector<' + getCppType(baseType, connectivities.tail) + '>'
	}

	override protected getLinearAlgebraType(int dimension) 
	{
		switch dimension
		{
			case 1: return 'VectorType'
			case 2: return 'NablaSparseMatrix'
			default: throw new RuntimeException("Unsupported dimension: " + dimension)
		}
	}
}

class KokkosTypeContentProvider extends TypeContentProvider
{
	override getCppType(BaseType baseType, Iterable<Connectivity> connectivities) 
	{
		'Kokkos::View<' + baseType.cppType + connectivities.map['*'].join + '>'
	}

	override protected getLinearAlgebraType(int dimension) 
	{
		switch dimension
		{
			case 1: return 'VectorType'
			case 2: return 'NablaSparseMatrix'
			default: throw new RuntimeException("Unsupported dimension: " + dimension)
		}
	}
}