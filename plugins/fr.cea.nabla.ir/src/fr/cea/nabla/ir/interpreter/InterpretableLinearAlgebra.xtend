/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.javalib.linearalgebra.LinearAlgebra
import fr.cea.nabla.javalib.linearalgebra.Matrix
import fr.cea.nabla.javalib.linearalgebra.Vector

interface InterpretableLinearAlgebra
{
	def Class<?> getVectorType()
	def Object createVector(int size)
	def double getValue(Object nativeVector, int i)
	def void setValue(Object nativeVector, int i, double value)

	def Class<?> getMatrixType()
	def Object createMatrix(int nbRows, int nbCols)
	def double getValue(Object nativeMatrix, int i, int j)
	def void setValue(Object nativeMatrix, int i, int j, double value)

	static def createInstance(Class<?> providerClass)
	{
		switch providerClass
		{
			case LinearAlgebra: new JavalibILA
			default: throw new RuntimeException("Unmanaged linear algebra provider: " + providerClass.name)
		}
	}
}

class JavalibILA implements InterpretableLinearAlgebra
{
	override getVectorType() { typeof(Vector) }
	override createVector(int size) { Vector.createDenseVector(size) }
	override getValue(Object nativeVector, int i) { (nativeVector as Vector).get(i) }
	override setValue(Object nativeVector, int i, double value) { (nativeVector as Vector).set(i, value) }
	
	override getMatrixType() { typeof(Matrix) }
	override createMatrix(int nbRows, int nbCols) { Matrix.createDenseMatrix(nbRows, nbCols) }
	override getValue(Object nativeMatrix, int i, int j) { (nativeMatrix as Matrix).get(i, j) }
	override setValue(Object nativeMatrix, int i, int j, double value) { (nativeMatrix as Matrix).set(i, j, value) }
}