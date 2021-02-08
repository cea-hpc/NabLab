/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib;

public class ArrayOperations 
{
	// INT
	public static int[] plus(int a, int[] b)
	{
		return plus(b, a);
	}

	public static int[] multiply(int a, int[] b)
	{
		return multiply(b, a);
	}

	public static double[] multiply(int a, double[] b)
	{
		return multiply(b, a);
	}

	public static double[][] multiply(int a, double[][] b)
	{
		return multiply(b, a);
	}

	// REAL
	public static double[] plus(double a, double[] b)
	{
		return plus(b, a);
	}

	public static double[] multiply(double a, double[] b)
	{
		return multiply(b, a);
	}
	
	public static double[][] multiply(double a, double[][] b)
	{
		return multiply(b, a);
	}

	// INT ARRAY1D
	public static int[] plus(int[] a, int b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] + b;
		return result;
	}

	public static int[] minus(int[] a, int b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] - b;
		return result;
	}

	public static int[] multiply(int[] a, int b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] * b;
		return result;
	}

	public static int[] divide(int[] a, int b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] / b;
		return result;
	}

	public static double[] plus(int[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] + b;
		return result;
	}

	public static double[] minus(int[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] - b;
		return result;
	}

	public static double[] multiply(int[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] * b;
		return result;
	}

	public static double[] divide(int[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] / b;
		return result;
	}
	
	public static int[] plus(int[] a, int[] b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] + b[i];
		return result;
	}

	public static int[] minus(int[] a, int[] b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] - b[i];
		return result;
	}

	public static int[] multiply(int[] a, int[] b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] * b[i];
		return result;
	}

	public static int[] divide(int[] a, int[] b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] / b[i];
		return result;
	}

	public static int[] minus(int[] a)
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = -a[i];
		return result;
	}

	// REAL ARRAY1D
	public static double[] plus(double[] a, int b) 
	{
		return plus(a, (double)b);
	}

	public static double[] minus(double[] a, int b) 
	{
		return minus(a, (double)b);
	}

	public static double[] multiply(double[] a, int b) 
	{
		return multiply(a, (double)b);
	}

	public static double[] divide(double[] a, int b) 
	{
		return divide(a, (double)b);
	}
	
	public static double[] plus(double[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] + b;
		return result;
	}

	public static double[] minus(double[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] - b;
		return result;
	}

	public static double[] multiply(double[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] * b;
		return result;
	}

	public static double[] divide(double[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] / b;
		return result;
	}

	public static double[] plus(double[] a, double[] b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] + b[i];
		return result;
	}

	public static double[] minus(double[] a, double[] b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] - b[i];
		return result;
	}

	public static double[] multiply(double[] a, double[] b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] * b[i];
		return result;
	}

	public static double[] divide(double[] a, double[] b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] / b[i];
		return result;
	}

	public static double[] minus(double[] a)
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = -a[i];
		return result;
	}

	// REAL ARAY2D
	public static double[][] multiply(double[][] a, int b) 
	{ 
		return multiply(a, (double)b);
	}
	
	public static double[][] multiply(double[][] a, double b) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = a[i][j] * b;
		return result;
	}
	
	public static double[][] multiply(double[][] a, double[][] b) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = a[i][j] * b[i][j];
		return result;
	}
	
	public static double[][] divide(double[][] a, int v) 
	{ 
		return divide(a, (double)v);
	}
	
	public static double[][] divide(double[][] a, double v) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = a[i][j] / v;
		return result;
	}

	public static double[][] plus(double[][] a, double[][] b) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = a[i][j] + b[i][j];
		return result;
	}

	public static double[][] minus(double[][] a, double[][] b) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = a[i][j] - b[i][j];
		return result;
	}
	
	public static double[][] minus(double[][] a) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = -a[i][j];
		return result;
	}	
}
