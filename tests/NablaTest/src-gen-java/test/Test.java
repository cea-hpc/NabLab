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
		public final int X_EDGE_ELEMS = 10;
		public final int Y_EDGE_ELEMS = 10;
	}

	private final Options options;

	// Mesh
	private final CartesianMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes;

	// Global Variables
	private double t, deltat, r0, r1, r2, r3;
	private int n0, n1, n2, n3;
	private double[] u, v, w, alpha, beta, res1;
	private double[][] delta, rho, res2;

	// Connectivity Variables
	private double[][] X;

	public Test(Options aOptions, CartesianMesh2D aCartesianMesh2D)
	{
		options = aOptions;
		mesh = aCartesianMesh2D;
		writer = new PvdFileWriter2D("Test");
		nbNodes = mesh.getNbNodes();

		t = 0.0;
		deltat = 0.001;
		n0 = 0;
		n1 = TestFunctions.getOne();
		n2 = addOne(n1);
		n3 = TestFunctions.add(n1, n2);
		r0 = 0.0;
		r1 = addOne(r0);
		r2 = TestFunctions.add(r1, n1);
		r3 = TestFunctions.add(r2, r1);
		u = new double[] {1.0, 1.0};
		v = new double[] {2.0, 2.0};
		w = TestFunctions.add(u, v);
		alpha = new double[] {1.0, 1.0, 1.0};
		beta = new double[] {2.0, 2.0, 2.0};
		res1 = TestFunctions.add(alpha, beta);
		delta = new double[][] {{1.0, 1.0}, {1.0, 1.0}};
		rho = new double[][] {{2.0, 2.0}, {2.0, 2.0}};
		res2 = TestFunctions.add(delta, rho);

		// Allocate arrays
		X = new double[nbNodes][2];
		u = new double[2];
		v = new double[2];
		w = new double[2];
		alpha = new double[3];
		beta = new double[3];
		res1 = new double[3];
		delta = new double[2][2];
		rho = new double[2][2];
		res2 = new double[2][2];

		// Copy node coordinates
		double[][] gNodes = mesh.getGeometry().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> {
			X[rNodes][0] = gNodes[rNodes][0];
			X[rNodes][1] = gNodes[rNodes][1];
		});
	}

	public void simulate()
	{
		System.out.println("Start execution of module Test");
		System.out.println("End of execution of module Test");
	}

	public static void main(String[] args)
	{
		Test.Options o = new Test.Options();
		CartesianMesh2D mesh = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		Test i = new Test(o, mesh);
		i.simulate();
	}

	private int addOne(int a)
	{
		return a + 1;
	}

	private double addOne(double a)
	{
		return a + 1;
	}
};
