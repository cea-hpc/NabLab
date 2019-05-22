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
		public final int X_EDGE_ELEMS = 2;
		public final int Y_EDGE_ELEMS = 2;
		public final int Z_EDGE_ELEMS = 1;
	}
	
	private final Options options;

	// Mesh
	private final NumericMesh2D mesh;
	private final int nbNodes, nbCells, nbNodesOfCell;
	private final VtkFileWriter2D writer;

	// Global Variables
	private double total;

	// Array Variables
	private Real2 X[];
	private double u[], Cjr[][];
	
	public Test(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		writer = new VtkFileWriter2D("Test");

		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbNodesOfCell = NumericMesh2D.MaxNbNodesOfCell;


		// Arrays allocation
		X = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			X[iNodes] = new Real2(0.0);
		});
		u = new double[nbCells];
		Cjr = new double[nbCells][nbNodesOfCell];

		// Copy node coordinates
		ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X[rNodes] = gNodes.get(rNodes));
	}
	
	/**
	 * Job IniU @-2.0
	 * In variables: 
	 * Out variables: u
	 */
	private void iniU() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			u[jCells] = 3.0;
		});
	}		
	
	/**
	 * Job TestFunctionCall @-1.0
	 * In variables: u
	 * Out variables: total
	 */
	private void testFunctionCall() 
	{
		double reduceProd420234885 = IntStream.range(0, nbCells).boxed().parallel().reduce(
			1.0, 
			(r, jCells) -> MathFunctions.reduceProd(r, u[jCells]),
			(r1, r2) -> MathFunctions.reduceProd(r1, r2)
		);
		total = reduceProd420234885;
	}		

	public void simulate()
	{
		System.out.println("Début de l'exécution du module Test");
		iniU(); // @-2.0
		testFunctionCall(); // @-1.0
		System.out.println(total);
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
