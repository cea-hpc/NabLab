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

import java.util.Arrays;

import org.apache.commons.math3.linear.ArrayRealVector;
import org.apache.commons.math3.linear.OpenMapRealVector;

public class Vector 
{
	private Object lock = new Object();
	private org.apache.commons.math3.linear.RealVector nativeVector;

	public final int length;

	public Vector(org.apache.commons.math3.linear.RealVector nativeVector)
	{
		this.nativeVector = nativeVector;
		this.length = nativeVector.getDimension();
	}

	public static Vector createDenseVector(int size)
	{
		return new Vector(new ArrayRealVector(size));
	}

	public static Vector createSparseVector(int size)
	{
		return new Vector(new OpenMapRealVector(size));
	}

	public org.apache.commons.math3.linear.RealVector getNativeVector()
	{
		return nativeVector;
	}

	public double get(int i)
	{
		return nativeVector.getEntry(i);
	}

	public void set(int i, double value)
	{
		synchronized(lock) { nativeVector.setEntry(i, value); }
	}

	public void add(int i, double increment) 
	{
		synchronized(lock) { nativeVector.addToEntry(i, increment); }
	}

	@Override
	public String toString()
	{
		return Arrays.toString(nativeVector.toArray());
	}
}
