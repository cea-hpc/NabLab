package test;

import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class Test
{
	public final static class Options
	{
		public final double X_EDGE_LENGTH = 0.01;
		public final double Y_EDGE_LENGTH = X_EDGE_LENGTH;
		public final int X_EDGE_ELEMS = 100;
		public final int Y_EDGE_ELEMS = 10;
		public final int Z_EDGE_ELEMS = 1;
		public final double option_stoptime = 0.2;
		public final int option_max_iterations = 20000;
	}

	private final Options options;
	private int iteration;

	// Mesh
	private final NumericMesh2D mesh;
	private final int nbNodes;
	private final FileWriter writer;

	// Global Variables
	private double t;
	private double[] u, v, w1, w2, w3, w4, w5, w6;

	// Connectivity Variables
	private double[][] X;

	public Test(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		writer = new PvdFileWriter2D("Test");
		nbNodes = mesh.getNbNodes();

		u = new double[] {0.0, 0.1};
		v = new double[] {0.0, 0.1, 0.2};

		// Allocate arrays
		X = new double[nbNodes][2];
		u = new double[2];
		v = new double[3];
		w1 = new double[2];
		w2 = new double[2];
		w3 = new double[3];
		w4 = new double[2];
		w5 = new double[3];
		w6 = new double[2];

		// Copy node coordinates
		ArrayList<double[]> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X[rNodes] = gNodes.get(rNodes));
	}

	public void simulate()
	{
		System.out.println("Début de l'exécution du module Test");
		j1(); // @-1.0
		j2(); // @-1.0
		j3(); // @-1.0
		j4(); // @-1.0
		j5(); // @-1.0
		j6(); // @-1.0
		System.out.println("Fin de l'exécution du module Test");
	}

	public static void main(String[] args)
	{
		Test.Options o = new Test.Options();
		Mesh gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		Test i = new Test(o, nm);
		i.simulate();
	}

	/**
	 * Job j1 @-1.0
	 * In variables: u
	 * Out variables: w1
	 */
	private void j1() 
	{
		w1 = h(u);
	}		

	/**
	 * Job j2 @-1.0
	 * In variables: u
	 * Out variables: w2
	 */
	private void j2() 
	{
		w2 = i(u);
	}		

	/**
	 * Job j3 @-1.0
	 * In variables: v
	 * Out variables: w3
	 */
	private void j3() 
	{
		w3 = i(v);
	}		

	/**
	 * Job j4 @-1.0
	 * In variables: u
	 * Out variables: w4
	 */
	private void j4() 
	{
		w4 = j(u);
	}		

	/**
	 * Job j5 @-1.0
	 * In variables: v
	 * Out variables: w5
	 */
	private void j5() 
	{
		w5 = j(v);
	}		

	/**
	 * Job j6 @-1.0
	 * In variables: u
	 * Out variables: w6
	 */
	private void j6() 
	{
		w6 = k(u);
	}		

	private double[] j(double[] x) 
	{
		final int a = x.length;
		double[] y = new double[a];
		for (int i=0; i<a; i++)
			y[i] = 2 * x[i];
		return y;
	}

	private double[] h(double[] a) 
	{
		return ArrayOperations.multiply(2, a);
	}

	private double[] i(double[] x) 
	{
		final int a = x.length;
		return ArrayOperations.multiply(2, x);
	}

	private double[] k(double[] x) 
	{
		final int b = x.length;
		return j(x);
	}
};
