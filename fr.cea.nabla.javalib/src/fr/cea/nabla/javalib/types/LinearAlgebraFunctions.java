package fr.cea.nabla.javalib.types;

import java.text.DecimalFormat;

import org.apache.commons.math3.linear.Array2DRowRealMatrix;
import org.apache.commons.math3.linear.ArrayRealVector;
import org.apache.commons.math3.linear.ConjugateGradient;
import org.apache.commons.math3.linear.IterativeLinearSolver;
import org.apache.commons.math3.linear.RealLinearOperator;
import org.apache.commons.math3.linear.RealVector;

public class LinearAlgebraFunctions 
{
	public static double[] solveLinearSystem(double[][] a, double[] b)
	{
		final int maxIterations = 100;
		final RealLinearOperator m_a = new Array2DRowRealMatrix(a);
		final IterativeLinearSolver m_solver = new ConjugateGradient(maxIterations, 1E-10, true);
	    final RealVector m_b = new ArrayRealVector(b);
	    final RealVector m_x = m_solver.solve(m_a, m_b);
	    return m_x.toArray();
	}
	
	public static double[] solveLinearSystem(double[][] a, double[] x, double[] b)
	{
		final int maxIterations = 100;
		final RealLinearOperator m_a = new Array2DRowRealMatrix(a);
		final IterativeLinearSolver m_solver = new ConjugateGradient(maxIterations, 1E-10, true);
	    final RealVector m_b = new ArrayRealVector(b);
	    final RealVector m_x = new ArrayRealVector(x);
	    m_solver.solveInPlace(m_a, m_b, m_x);
	    return m_x.toArray();
	}

	public static void print(double[] x, DecimalFormat df)
	{
		System.out.print("\t[ ");
		for (int i=0 ; i<x.length ; ++i) 
			System.out. print(df.format(x[i]) + " ");
		System.out.println("]");
	}
	
	public static void print(double[][] x, DecimalFormat df)
	{
		for (int i=0 ; i<x.length ; ++i)
			print(x[i], df);
	}
}
