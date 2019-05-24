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
	private double v[], u[], Cjr[][];
	
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
		v = new double[nbNodes];
		u = new double[nbCells];
		Cjr = new double[nbCells][nbNodesOfCell];

		// Copy node coordinates
		ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X[rNodes] = gNodes.get(rNodes));
	}
	
	/**
	 * Job IniU @-3.0
	 * In variables: 
	 * Out variables: u
	 */
	private void iniU() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			u[jCells] = 2.0;
		});
	}		
	
	/**
	 * Job IniV @-3.0
	 * In variables: 
	 * Out variables: v
	 */
	private void iniV() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			v[rNodes] = 3.0;
		});
	}		
	
	/**
	 * Job TestInternal @-2.0
	 * In variables: v
	 * Out variables: u
	 */
	private void testInternal() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduceProd1025701828 = 1.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int r1NodesOfCellJ=0; r1NodesOfCellJ<nodesOfCellJ.length; r1NodesOfCellJ++)
				{
					int r1Id = nodesOfCellJ[r1NodesOfCellJ];
					int r1Nodes = r1Id;
					reduceProd1025701828 = reduceProd1025701828 * (v[r1Nodes]);
				}
			}
			double reduceSum_981480406 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int r2NodesOfCellJ=0; r2NodesOfCellJ<nodesOfCellJ.length; r2NodesOfCellJ++)
				{
					int r2Id = nodesOfCellJ[r2NodesOfCellJ];
					int r2Nodes = r2Id;
					reduceSum_981480406 = reduceSum_981480406 + (v[r2Nodes]);
				}
			}
			u[jCells] = reduceProd1025701828 + reduceSum_981480406;
		});
	}		
	
	/**
	 * Job TestInternal2 @-2.0
	 * In variables: v
	 * Out variables: u
	 */
	private void testInternal2() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduceProd1025701828 = 1.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int r1NodesOfCellJ=0; r1NodesOfCellJ<nodesOfCellJ.length; r1NodesOfCellJ++)
				{
					int r1Id = nodesOfCellJ[r1NodesOfCellJ];
					int r1Nodes = r1Id;
					reduceProd1025701828 = reduceProd1025701828 * (v[r1Nodes]);
				}
			}
			double a = reduceProd1025701828;
			double reduceSum_981480406 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int r2NodesOfCellJ=0; r2NodesOfCellJ<nodesOfCellJ.length; r2NodesOfCellJ++)
				{
					int r2Id = nodesOfCellJ[r2NodesOfCellJ];
					int r2Nodes = r2Id;
					reduceSum_981480406 = reduceSum_981480406 + (v[r2Nodes]);
				}
			}
			double b = reduceSum_981480406;
			u[jCells] = a + b;
		});
	}		
	
	/**
	 * Job TestExternal @-1.0
	 * In variables: u
	 * Out variables: total
	 */
	private void testExternal() 
	{
		double reduceProd106920220 = IntStream.range(0, nbCells).boxed().parallel().reduce(
			1.0, 
			(r, j1Cells) -> MathFunctions.reduceProd(r, u[j1Cells]),
			(r1, r2) -> MathFunctions.reduceProd(r1, r2)
		);
		double reduceSum_1900262014 = IntStream.range(0, nbCells).boxed().parallel().reduce(
			0.0, 
			(r, j2Cells) -> MathFunctions.reduceSum(r, u[j2Cells]),
			(r1, r2) -> MathFunctions.reduceSum(r1, r2)
		);
		total = reduceProd106920220 + reduceSum_1900262014;
	}		

	public void simulate()
	{
		System.out.println("Début de l'exécution du module Test");
		iniU(); // @-3.0
		iniV(); // @-3.0
		testInternal(); // @-2.0
		testInternal2(); // @-2.0
		testExternal(); // @-1.0
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
