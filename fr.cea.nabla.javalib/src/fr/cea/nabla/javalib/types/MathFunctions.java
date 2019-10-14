package fr.cea.nabla.javalib.types;

public class MathFunctions 
{
	public static double fabs(double v) { return Math.abs(v); }
	public static double sqrt(double v) { return Math.sqrt(v); }
	public static double norm(double[] a) { return Math.sqrt(dot(a,a)); }
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

	/** Determinant en 2D */
	public static double det(double[] a, double[] b)
	{
		return (a[0]*b[1] - a[1]*b[0]);
	}
}
