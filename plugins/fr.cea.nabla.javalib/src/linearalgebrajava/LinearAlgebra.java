/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package linearalgebrajava;

import java.text.DecimalFormat;

import org.apache.commons.math3.linear.AbstractRealMatrix;
import org.apache.commons.math3.linear.ConjugateGradient;
import org.apache.commons.math3.linear.IterativeLinearSolver;
import org.apache.commons.math3.linear.RealVector;

public class LinearAlgebra implements ILinearAlgebra
{
	@Override
	public void jsonInit(final String jsonContent) {}

	@Override
	public Vector solveLinearSystem(Matrix a, Vector b)
	{
		final RealVector x = solveLinearSystem(a.getData(), b.getData());
		return new Vector(b.getName() + "_plus1", x);
	}

	public RealVector solveLinearSystem(AbstractRealMatrix a, RealVector b)
	{
		final int maxIterations = 100;
		final IterativeLinearSolver m_solver = new ConjugateGradient(maxIterations, 1E-10, true);
		return m_solver.solve(a, b);
	}

	public void print(double[] x, DecimalFormat df)
	{
		System.out.print("\t[ ");
		for (int i=0 ; i<x.length ; ++i) 
			System.out. print(df.format(x[i]) + " ");
		System.out.println("]");
	}

	public void print(double[][] x, DecimalFormat df)
	{
		for (int i=0 ; i<x.length ; ++i)
			print(x[i], df);
	}

	@Override
	public Vector solveLinearSystem(Matrix x0, Vector x1, Vector x2)
	{
		throw new RuntimeException("Not implemented exception");
	}

	@Override
	public Vector solveLinearSystem(Matrix x0, Vector x1, Matrix x2)
	{
		throw new RuntimeException("Not implemented exception");
	}

	@Override
	public Vector solveLinearSystem(Matrix x0, Vector x1, Vector x2, int x3)
	{
		throw new RuntimeException("Not implemented exception");
	}

	@Override
	public Vector solveLinearSystem(Matrix x0, Vector x1, Matrix x2, Vector x3)
	{
		throw new RuntimeException("Not implemented exception");
	}

	@Override
	public Vector solveLinearSystem(Matrix x0, Vector x1, Vector x2, int x3, double x4)
	{
		throw new RuntimeException("Not implemented exception");
	}

	@Override
	public Vector solveLinearSystem(Matrix x0, Vector x1, Matrix x2, Vector x3, int x4)
	{
		throw new RuntimeException("Not implemented exception");
	}

	@Override
	public Vector solveLinearSystem(Matrix x0, Vector x1, Matrix x2, Vector x3, int x4, double x5)
	{
		throw new RuntimeException("Not implemented exception");
	}
}
