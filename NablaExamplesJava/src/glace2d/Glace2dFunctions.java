package glace2d;

import static fr.cea.nabla.javalib.types.MathFunctions.dot;

public class Glace2dFunctions 
{
	static double trace(double[][] a)
	{
		double result = 0.0;
		for (int ia=0 ; ia<a.length ; ++ia)
			result += a[ia][ia];
		return result;
	}
	
	// only for 2D vectors
  	static double[] perp(double[] a)
  	{
  		return new double[] { a[1], -a[0] };
  	}

  	static double[][] tensProduct(double[] a, double[] b)
	{
		double[][] result = new double[a.length][b.length];
		for (int ia=0 ; ia<a.length ; ++ia)
			for (int ib=0 ; ib<b.length ; ++ib)
				result[ia][ib] = a[ia]*b[ib];
		return result;
	}

	static double[] matVectProduct(double[][] a, double[] b)
	{
		double[] result = new double[a.length];
		for (int ia=0 ; ia<a.length ; ++ia)
			result[ia] = dot(a[ia], b);
		return result;
	}

	// only for 2x2 matrices
	static double[][] inverse(double[][] m)
	{
		double[][] result = new double[2][2];
		double alpha = 1.0/det(m);
		result[0][0] = m[1][1] * alpha;
		result[0][1] = -m[0][1] * alpha;
		result[1][0] = -m[1][0] * alpha;
		result[1][1] = -m[0][0] * alpha;
		return result;
 	}

	// only for 2x2 matrices
	private static double det(double[][] a)
	{
		return a[0][0] * a[1][1] - a[0][1] * a[1][0];
	}
}
