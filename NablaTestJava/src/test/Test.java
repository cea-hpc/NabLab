package test;

import java.util.HashMap;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.Utils;
import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class Test
{
	public final static class Options
	{
		public final double LENGTH = 1.0;
		public final int X_EDGE_ELEMS = 8;
		public final int Y_EDGE_ELEMS = 8;
		public final int Z_EDGE_ELEMS = 1;
	}
	
	private final Options options;

	// Mesh
	private final NumericMesh2D mesh;
	private final int nbNodes, nbCells;
	private final VtkFileWriter2D writer;

	// Global Variables

	// Array Variables
	private Real2 X[], XX[], X_n0[], X_nplus1_2[], X_nplus1[];
	
	public Test(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		writer = new VtkFileWriter2D("Test");

		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();


		// Arrays allocation
		X = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			X[iNodes] = new Real2(0.0);
		});
		XX = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			XX[iNodes] = new Real2(0.0);
		});
		X_n0 = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			X_n0[iNodes] = new Real2(0.0);
		});
		X_nplus1_2 = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			X_nplus1_2[iNodes] = new Real2(0.0);
		});
		X_nplus1 = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			X_nplus1[iNodes] = new Real2(0.0);
		});

		// Copy node coordinates
		ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X_n0[rNodes] = gNodes.get(rNodes));
	}
	
	/**
	 * Job A @-2.0
	 * In variables: 
	 * Out variables: X_n0
	 */
	private void a() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			int jNodes = jId;
			X_n0[jNodes].operator_set(new Real2(0.0, 0.0));
		});
	}		
	
	/**
	 * Job Copy_X_n0_to_X @-1.0
	 * In variables: X_n0
	 * Out variables: X
	 */
	private void copy_X_n0_to_X() 
	{
		IntStream.range(0, X.length).parallel().forEach(i -> X[i] = X_n0[i]);
	}		
	
	/**
	 * Job B @1.0
	 * In variables: X
	 * Out variables: X_nplus1_2
	 */
	private void b() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			int jNodes = jId;
			X_nplus1_2[jNodes].operator_set(X[jNodes].operator_plus(1.0));
		});
	}		
	
	/**
	 * Job C @1.0
	 * In variables: X
	 * Out variables: X_nplus1
	 */
	private void c() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			int jNodes = jId;
			X_nplus1[jNodes].operator_set(X[jNodes].operator_plus(1.0));
		});
	}		
	
	/**
	 * Job Copy_X_nplus1_to_X @2.0
	 * In variables: X_nplus1
	 * Out variables: X
	 */
	private void copy_X_nplus1_to_X() 
	{
		Real2[] tmpSwitch = X;
		X = X_nplus1;
		X_nplus1 = tmpSwitch;
	}		
	
	/**
	 * Job D @2.0
	 * In variables: X_nplus1
	 * Out variables: XX
	 */
	private void d() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			int jNodes = jId;
			XX[jNodes].operator_set(X_nplus1[jNodes].operator_plus(1.0));
		});
	}		

	public void simulate()
	{
		System.out.println("Début de l'exécution du module Test");
		a(); // @-2.0
		copy_X_n0_to_X(); // @-1.0

		int iteration = 0;
		while (t < options.option_stoptime && iteration < options.option_max_iterations)
		{
			iteration++;
			System.out.println("[" + iteration + "] t = " + t);
			b(); // @1.0
			c(); // @1.0
			copy_X_nplus1_to_X(); // @2.0
			d(); // @2.0
		}
		System.out.println("Fin de l'exécution du module Test");
	}

	public static void main(String[] args)
	{
		Test.Options o = new Test.Options();
		Mesh<Real2> gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.LENGTH, o.LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		Test i = new Test(o, nm);
		i.simulate();
	}
};
