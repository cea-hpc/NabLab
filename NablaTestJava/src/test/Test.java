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
		public final int X_EDGE_ELEMS = 10;
		public final int Y_EDGE_ELEMS = 10;
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
	 * Job TestFunctionCall @-1.0
	 * In variables: Cjr
	 * Out variables: u
	 */
	private void testFunctionCall() 
	{
		int[] cells = mesh.getCells();
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = cells[jCells];
			double sum1007414498 = 0.0;
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				sum1007414498 = sum1007414498 + (Cjr[jCells][rNodesOfCellJ]);
			}
			u[jCells] = sum1007414498;
		});
	}		

	public void simulate()
	{
		System.out.println("Début de l'exécution du module Test");
		testFunctionCall(); // @-1.0
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
