/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.VariableExtensions.*
import static extension fr.cea.nabla.ir.generator.kokkos.Ir2KokkosUtils.*

class VariableExtensions 
{
	public static val MatrixType = 'NablaSparseMatrix'
	
	static def dispatch getCppType(SimpleVariable it) 
	'''«type.cppType»'''
	
	static def dispatch getCppType(ConnectivityVariable it)
	{
		if (linearAlgebra)
			switch dimensions.size
			{
				case 1: return 'VectorType'
				case 2: return MatrixType
				default: throw new RuntimeException("Not implemented exception")
			}
		else
			'''Kokkos::View<«type.cppType»«FOR d : dimensions»*«ENDFOR»>'''
	}

	static def getCodeName(Variable it)
	{
		if (scalarConst && global) 'options->' + name
		else name
	}
}