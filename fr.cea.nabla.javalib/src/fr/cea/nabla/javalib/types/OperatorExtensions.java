package fr.cea.nabla.javalib.types;

public class OperatorExtensions 
{
	// INT
	public static int[] operator_plus(int a, int[] b)
	{
		return operator_plus(b, a);
	}

	public static int[] operator_multiply(int a, int[] b)
	{
		return operator_multiply(b, a);
	}

	public static double[] operator_multiply(int a, double[] b)
	{
		return operator_multiply(b, a);
	}

	public static double[][] operator_multiply(int a, double[][] b)
	{
		return operator_multiply(b, a);
	}

	// REAL
	public static double[] operator_plus(double a, double[] b)
	{
		return operator_plus(b, a);
	}

	public static double[] operator_multiply(double a, double[] b)
	{
		return operator_multiply(b, a);
	}
	
	public static double[][] operator_multiply(double a, double[][] b)
	{
		return operator_multiply(b, a);
	}

	// INT ARRAY
	public static int[] operator_plus(int[] a, int b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] + b;
		return result;
	}

	public static int[] operator_minus(int[] a, int b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] - b;
		return result;
	}

	public static int[] operator_multiply(int[] a, int b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] * b;
		return result;
	}

	public static int[] operator_divide(int[] a, int b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] / b;
		return result;
	}

	public static double[] operator_plus(int[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] + b;
		return result;
	}

	public static double[] operator_minus(int[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] - b;
		return result;
	}

	public static double[] operator_multiply(int[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] * b;
		return result;
	}

	public static double[] operator_divide(int[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] / b;
		return result;
	}
	
	public static int[] operator_plus(int[] a, int[] b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] + b[i];
		return result;
	}

	public static int[] operator_minus(int[] a, int[] b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] - b[i];
		return result;
	}

	public static int[] operator_multiply(int[] a, int[] b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] * b[i];
		return result;
	}

	public static int[] operator_divide(int[] a, int[] b) 
	{
		int[] result = new int[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] / b[i];
		return result;
	}
	
	// REAL ARRAY
	public static double[] operator_plus(double[] a, int b) 
	{
		return operator_plus(a, (double)b);
	}

	public static double[] operator_minus(double[] a, int b) 
	{
		return operator_minus(a, (double)b);
	}

	public static double[] operator_multiply(double[] a, int b) 
	{
		return operator_multiply(a, (double)b);
	}

	public static double[] operator_divide(double[] a, int b) 
	{
		return operator_divide(a, (double)b);
	}
	
	public static double[] operator_plus(double[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] + b;
		return result;
	}

	public static double[] operator_minus(double[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] - b;
		return result;
	}

	public static double[] operator_multiply(double[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] * b;
		return result;
	}

	public static double[] operator_divide(double[] a, double b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] / b;
		return result;
	}

	public static double[] operator_plus(double[] a, double[] b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] + b[i];
		return result;
	}

	public static double[] operator_minus(double[] a, double[] b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] - b[i];
		return result;
	}

	public static double[] operator_multiply(double[] a, double[] b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] * b[i];
		return result;
	}

	public static double[] operator_divide(double[] a, double[] b) 
	{
		double[] result = new double[a.length];
		for (int i=0 ; i<a.length ; ++i)
			result[i] = a[i] / b[i];
		return result;
	}
	
	// REAL MATRIX
	public static double[][] operator_multiply(double[][] a, int v) 
	{ 
		return operator_multiply(a, (double)v);
	}
	
	public static double[][] operator_multiply(double[][] a, double v) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = a[i][j] * v;
		return result;
	}
	
	public static double[][] operator_multiply(double[][] a, double[][] b) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = a[i][j] * b[i][j];
		return result;
	}
	
	public static double[][] operator_divide(double[][] a, int v) 
	{ 
		return operator_divide(a, (double)v);
	}
	
	public static double[][] operator_divide(double[][] a, double v) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = a[i][j] / v;
		return result;
	}

	public static double[][] operator_plus(double[][] a, double[][] b) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = a[i][j] + b[i][j];
		return result;
	}

	public static double[][] operator_minus(double[][] a, double[][] b) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = a[i][j] - b[i][j];
		return result;
	}
	
	public static double[][] operator_minus(double[][] a) 
	{ 
		double[][] result = new double[a.length][a[0].length];
		for (int i=0 ; i<a.length ; ++i)
			for (int j=0 ; j<a[0].length ; ++j)
				result[i][j] = -a[i][j];
		return result;
	}	
}
