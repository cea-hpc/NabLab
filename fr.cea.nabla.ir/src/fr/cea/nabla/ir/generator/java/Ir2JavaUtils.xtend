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

import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.Scalar

class Ir2JavaUtils 
{
	static def dispatch String getJavaType(Scalar it) { primitive.javaType }
	static def dispatch String getJavaType(Array1D it) { primitive.javaType + '[]' }
	static def dispatch String getJavaType(Array2D it) { primitive.javaType + '[][]' }

	static def dispatch String getJavaType(PrimitiveType t)
	{
		switch t
		{
			case null: 'void'
			case BOOL: 'boolean'
			case INT: 'int'
			case REAL: 'double'
		}
	}
}