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

import java.util.Arrays;

import org.apache.commons.math3.linear.ArrayRealVector;
import org.apache.commons.math3.linear.RealVector;
//import org.apache.commons.math3.linear.OpenMapRealVector;

public class Vector
{
	private final Object lock = new Object();
	private final RealVector data;
	private final String name;

	public Vector(final String name, final int size)
	{
		this.name = name;
		// Dense
		this.data = new ArrayRealVector(size);
		// Sparse
		// this.data = new OpenMapRealVector(size);
	}

	public Vector(final String name, final RealVector data)
	{
		this.name = name;
		this.data = data;
	}

	public String getName()
	{
		return name;
	}

	public RealVector getData()
	{
		return data;
	}

	public int getSize()
	{
		return data.getDimension();
	}

	public double getValue(int i)
	{
		return data.getEntry(i);
	}

	public void setValue(int i, double value)
	{
		synchronized(lock) { data.setEntry(i, value); }
	}

	@Override
	public String toString()
	{
		return Arrays.toString(data.toArray());
	}
}
