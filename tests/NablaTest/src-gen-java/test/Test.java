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
		public final int Y_EDGE_ELEMS = 100;
		public final int max_time_iterations = 500000000;
		public final double final_time = 1.0;
	}

	private final Options options;

	// Mesh
	private final CartesianMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes, nbCells, nbNodesOfCell;

	// Global Variables
	private double t, deltat;

	// Connectivity Variables
	private double[][] X;
	private double[] U, c1, c2;
	private double[][][] C;

	public Test(Options aOptions, CartesianMesh2D aCartesianMesh2D)
	{
		options = aOptions;
		mesh = aCartesianMesh2D;
		writer = new PvdFileWriter2D("Test");
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;

		t = 0.0;
		deltat = 0.001;

		// Allocate arrays
		X = new double[nbNodes][2];
		U = new double[nbCells];
		C = new double[nbCells][nbNodesOfCell][2];
		c1 = new double[nbCells];
		c2 = new double[nbCells];

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
		computeCjr(); // @1.0
		System.out.println("End of execution of module Test");
	}

	public static void main(String[] args)
	{
		Test.Options o = new Test.Options();
		CartesianMesh2D mesh = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		Test i = new Test(o, mesh);
		i.simulate();
	}

	/**
	 * Job ComputeCjr called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: C
	 */
	private void computeCjr()
	{
		{
			final int[] cells = mesh.getCells();
			final int nbCells = cells.length;
			IntStream.range(0, nbCells).parallel().forEach(jCells -> 
			{
				final int jId = cells[jCells];
				final int[] rCellsJ = mesh.getNodesOfCell(jId);
				final int cardRCellsJ = rCellsJ.length;
				double[] tmp = new double[cardRCellsJ];
				{
					final int nbRCellsJ = rCellsJ.length;
					for (int rRCellsJ=0; rRCellsJ<nbRCellsJ; rRCellsJ++)
					{
						final int rId = rCellsJ[rRCellsJ];
						final int rPlus1Id = rCellsJ[(rRCellsJ+1+nbNodesOfCell)%nbNodesOfCell];
						final int rMinus1Id = rCellsJ[(rRCellsJ-1+nbNodesOfCell)%nbNodesOfCell];
						final int rNodes = rId;
						final int rNodesOfCellJ = Utils.indexOf(mesh.getNodesOfCell(jId), rId);
						final int rPlus1Nodes = rPlus1Id;
						final int rMinus1Nodes = rMinus1Id;
						tmp[rRCellsJ] = X[rNodes][0];
						C[jCells][rNodesOfCellJ] = ArrayOperations.multiply(0.5, (ArrayOperations.minus(X[rPlus1Nodes], X[rMinus1Nodes])));
					}
				}
			});
		}
	}
};
