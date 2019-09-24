/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.Scalar

class BaseTypeValueProvider 
{
	static def dispatch NablaSimpleValue getValueOf(Scalar it) 
	{ 
		switch primitive
		{
			case INT: new NSVIntScalar(0)
			case REAL: new NSVRealScalar(0.0)
			case BOOL: new NSVBoolScalar(false)
		}
	}
	
	static def dispatch NablaSimpleValue getValueOf(Array1D it) 
	{ 
		switch primitive
		{
			case INT: new NSVIntArray1D(newIntArrayOfSize(size))
			case REAL: new NSVRealArray1D(newDoubleArrayOfSize(size))
			case BOOL: new NSVBoolArray1D(newBooleanArrayOfSize(size))
		}
	}
	
	static def dispatch NablaSimpleValue getValueOf(Array2D it) 
	{ 
		switch primitive
		{
			case INT:  new NSVIntArray2D(newArrayOfSize(nbRows).map[x | newIntArrayOfSize(nbCols)])
			case REAL: new NSVRealArray2D(newArrayOfSize(nbRows).map[x | newDoubleArrayOfSize(nbCols)])
			case BOOL: new NSVBoolArray2D(newArrayOfSize(nbRows).map[x | newBooleanArrayOfSize(nbCols)])
		}
	}
}