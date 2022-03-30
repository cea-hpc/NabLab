/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package test;

public class TestFunctions
{
	static int getOne()
	{
		return 1;
	}

	static int addOne(int a)
	{
		return a + 1;
	}

	static int add(int a, int b)
	{
		return a + b;
	}

	static double addOne(double a)
	{
		return a + 1;
	}

	static double add(double a, int b)
	{
		return a + b;
	}

	static double add(double a, double b)
	{
		return a + b;
	}

	static double[] add(double[] a, double[] b)
	{
		double[] sum = new double[a.length];
		for (int i=0 ; i < a.length ; i++)
			sum[i] = a[i] + b[i];
		return sum;
	}

	static double[][] add(double[][] a, double[][] b)
	{
		int rows = a.length, columns = a[0].length;
		double[][] sum = new double[rows][columns];
		for(int i = 0; i < rows; i++)
		{
			for (int j = 0; j < columns; j++)
				sum[i][j] = a[i][j] + b[i][j];
		}
		return sum;
	}
}