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

import fr.cea.nabla.ir.ir.Arg
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.SimpleVariable
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

@Data
abstract class ArgOrVarContentProvider
{
	val extension TypeContentProvider

	protected abstract def String getLinearAlgebraType(int dimension)

	def dispatch String getCppType(Arg it)
	{
		type.cppType
	}

	def dispatch String getCppType(SimpleVariable it)
	{
		type.cppType
	}

	def dispatch String getCppType(ConnectivityVariable it)
	{
		if (linearAlgebra)
			type.connectivities.size.linearAlgebraType
		else
			type.cppType
	}

	def boolean isMatrix(ArgOrVar it)
	{
		if (it instanceof ConnectivityVariable)
			(linearAlgebra && type.connectivities.size == 2)
		else
			false
	}
}

@Data
class StlArgOrVarContentProvider extends ArgOrVarContentProvider
{
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

@Data
class KokkosArgOrVarContentProvider extends ArgOrVarContentProvider
{
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
