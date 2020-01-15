/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib.types;

public class MathFunctions 
{
	public static double fabs(double v) { return Math.abs(v); }
	public static double sqrt(double v) { return Math.sqrt(v); }
	public static double min(double a, double b) { return Math.min(a, b); }
	public static double max(double a, double b) { return Math.max(a, b); }
	public static double sin(double v) { return Math.sin(v); }
	public static double cos(double v) { return Math.cos(v); }
	public static double asin(double v) { return Math.asin(v); }
	public static double acos(double v) { return  Math.acos(v); }

	/** Scalar product */
	public static double dot(double[] a, double[] b)
	{
		double result = 0.0;
		for (int i=0 ; i<a.length ; ++i)
			result += a[i]*b[i];
		return result;
	}

	public static double[] matVectProduct(double[][] a, double[] b)
	{
		double[] result = new double[a.length];
		for (int ia=0 ; ia<a.length ; ++ia)
			result[ia] = dot(a[ia], b);
		return result;
	}

	/** Determinant 2D */
	public static double det(double[] a, double[] b)
	{
		return (a[0]*b[1] - a[1]*b[0]);
	}

	/** Determinant 2D */
	public static double det(double[][] a)
	{
		return a[0][0] * a[1][1] - a[0][1] * a[1][0];
	}

	public static double norm(double[] a) 
	{
		return Math.sqrt(dot(a,a));
	}
}
