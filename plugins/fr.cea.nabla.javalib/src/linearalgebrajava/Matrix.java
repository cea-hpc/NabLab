/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package linearalgebrajava;

import org.apache.commons.math3.linear.AbstractRealMatrix;
import org.apache.commons.math3.linear.Array2DRowRealMatrix;
//import org.apache.commons.math3.linear.OpenMapRealMatrix;

public class Matrix
{
	private final Object lock = new Object();
	private final AbstractRealMatrix data;
	private final String name;

	public Matrix(final String name, final int nbRows, final int nbCols)
	{
		this.name = name;
		// Dense
		this.data = new Array2DRowRealMatrix(nbRows, nbCols);
		// Sparse
		// this.data = new OpenMapRealMatrix(nbRows, nbCols)
	}

	public String getName()
	{
		return name;
	}

	public AbstractRealMatrix getData()
	{
		return data; 
	}

	int getNbRows()
	{
		return data.getRowDimension();
	}

	int getNbCols()
	{
		return data.getColumnDimension();
	}

	public double getValue(int i, int j)
	{
		return data.getEntry(i, j); 
	}

	public void setValue(int i, int j, double value)
	{
		synchronized(lock) { data.setEntry(i, j, value); }
	}

	@Override
	public String toString()
	{
		StringBuilder sb = new StringBuilder("");
		for (int i = 0; i < data.getColumnDimension(); i++)
			for (int j = 0; j < data.getRowDimension(); j ++)
			{
				sb.append(data.getEntry(i, j));
				sb.append(" ");
			}
		return sb.toString();
	}
}
