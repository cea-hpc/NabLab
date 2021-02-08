/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib.linearalgebra;

import org.apache.commons.math3.linear.AbstractRealMatrix;
import org.apache.commons.math3.linear.Array2DRowRealMatrix;
import org.apache.commons.math3.linear.OpenMapRealMatrix;

public class Matrix
{
	private Object lock = new Object();
	private AbstractRealMatrix nativeMatrix;

	public Matrix(AbstractRealMatrix nativeMatrix)
	{
		this.nativeMatrix = nativeMatrix;
	}

	public static Matrix createDenseMatrix(int nbRows, int nbCols)
	{
		return new Matrix(new Array2DRowRealMatrix(nbRows, nbCols));
	}

	public static Matrix createSparseMatrix(int nbRows, int nbCols)
	{
		return new Matrix(new OpenMapRealMatrix(nbRows, nbCols));
	}

	public AbstractRealMatrix getNativeMatrix()
	{
		return nativeMatrix; 
	}

	public double get(int i, int j)
	{
		return nativeMatrix.getEntry(i, j); 
	}

	public void set(int i, int j, double value)
	{
		synchronized(lock) { nativeMatrix.setEntry(i, j, value); }
	}

	public void add(int i, int j, double increment)
	{
		synchronized(lock) { nativeMatrix.addToEntry(i, j, increment); }
	}

	@Override
	public String toString()
	{
		StringBuilder sb = new StringBuilder("");
		for (int i = 0; i < nativeMatrix.getColumnDimension(); i++)
			for (int j = 0; j < nativeMatrix.getRowDimension(); j ++)
			{
				sb.append(nativeMatrix.getEntry(i, j));
				sb.append(" ");
			}
		return sb.toString();
	}
}
