package implicitheatequation;

import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

import org.apache.commons.math3.linear.*;

@SuppressWarnings("all")
public final class ImplicitHeatEquation
{
	public final static class Options
	{
		public final double X_LENGTH = 2.0;
		public final double Y_LENGTH = 2.0;
		public final double u0 = 1.0;
		public final double[] vectOne = {1.0, 1.0};
		public final int X_EDGE_ELEMS = 40;
		public final int Y_EDGE_ELEMS = 40;
		public final int Z_EDGE_ELEMS = 1;
		public final double X_EDGE_LENGTH = X_LENGTH / X_EDGE_ELEMS;
		public final double Y_EDGE_LENGTH = Y_LENGTH / Y_EDGE_ELEMS;
		public final double option_stoptime = 1.0;
		public final int option_max_iterations = 500000000;
	}

	private final Options options;
	private int iteration;

	// Mesh
	private final NumericMesh2D mesh;
	private final int nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbCellsOfFace, nbNeighbourCells;
	private final FileWriter writer;

	// Global Variables
	private double t, deltat, t_nplus1;

	// Connectivity Variables
	private double[][] X, Xc;
	private double[] xc, yc, V, D, faceLength, faceConductivity;

	// Linear Algebra Variables
	private Vector u;
	private Matrix alpha;
	private Vector u_nplus1;

	public ImplicitHeatEquation(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		writer = new PvdFileWriter2D("ImplicitHeatEquation");
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbFaces = mesh.getNbFaces();
		nbNodesOfCell = NumericMesh2D.MaxNbNodesOfCell;
		nbNodesOfFace = NumericMesh2D.MaxNbNodesOfFace;
		nbCellsOfFace = NumericMesh2D.MaxNbCellsOfFace;
		nbNeighbourCells = NumericMesh2D.MaxNbNeighbourCells;

		t = 0.0;
		deltat = 0.001;
		t_nplus1 = 0.0;

		// Allocate arrays
		X = new double[nbNodes][2];
		Xc = new double[nbCells][2];
		xc = new double[nbCells];
		yc = new double[nbCells];
		u = Vector.createDenseVector(nbCells);
		V = new double[nbCells];
		D = new double[nbCells];
		faceLength = new double[nbFaces];
		faceConductivity = new double[nbFaces];
		alpha = Matrix.createDenseMatrix(nbCells, nbCells);
		u_nplus1 = Vector.createDenseVector(nbCells);

		// Copy node coordinates
		ArrayList<double[]> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X[rNodes] = gNodes.get(rNodes));
	}

	public void simulate()
	{
		System.out.println("Début de l'exécution du module ImplicitHeatEquation");
		initXc(); // @-3.0
		initD(); // @-3.0
		computeV(); // @-3.0
		computeFaceLength(); // @-3.0
		initXcAndYc(); // @-2.0
		initU(); // @-2.0
		computeDeltaTn(); // @-2.0
		computeFaceConductivity(); // @-2.0
		computeAlphaCoeff(); // @-1.0

		iteration = 0;
		while (t < options.option_stoptime && iteration < options.option_max_iterations)
		{
			iteration++;
			System.out.println("[" + iteration + "] t = " + t);
			updateU(); // @1.0
			computeTn(); // @1.0
			dumpVariables(); // @1.0
			copy_u_nplus1_to_u(); // @2.0
			copy_t_nplus1_to_t(); // @2.0
		}
		System.out.println("Fin de l'exécution du module ImplicitHeatEquation");
	}

	public static void main(String[] args)
	{
		ImplicitHeatEquation.Options o = new ImplicitHeatEquation.Options();
		Mesh gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		ImplicitHeatEquation i = new ImplicitHeatEquation(o, nm);
		i.simulate();
	}

	/**
	 * Job InitXc @-3.0
	 * In variables: X
	 * Out variables: Xc
	 */
	private void initXc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			int cId = cCells;
			double[] reduction0 = {0.0, 0.0};
			{
				int[] nodesOfCellC = mesh.getNodesOfCell(cId);
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.length; pNodesOfCellC++)
				{
					int pId = nodesOfCellC[pNodesOfCellC];
					int pNodes = pId;
					reduction0 = ArrayOperations.plus(reduction0, (X[pNodes]));
				}
			}
			Xc[cCells] = ArrayOperations.multiply(0.25, reduction0);
		});
	}

	/**
	 * Job InitD @-3.0
	 * In variables: 
	 * Out variables: D
	 */
	private void initD() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			D[cCells] = 1.0;
		});
	}

	/**
	 * Job ComputeV @-3.0
	 * In variables: X
	 * Out variables: V
	 */
	private void computeV() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduction2 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int pNodesOfCellJ=0; pNodesOfCellJ<nodesOfCellJ.length; pNodesOfCellJ++)
				{
					int pId = nodesOfCellJ[pNodesOfCellJ];
					int pPlus1Id = nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					int pNodes = pId;
					int pPlus1Nodes = pPlus1Id;
					reduction2 = reduction2 + (MathFunctions.det(X[pNodes], X[pPlus1Nodes]));
				}
			}
			V[jCells] = 0.5 * reduction2;
		});
	}

	/**
	 * Job ComputeFaceLength @-3.0
	 * In variables: X
	 * Out variables: faceLength
	 */
	private void computeFaceLength() 
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			int fId = fFaces;
			double reduction3 = 0.0;
			{
				int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
				for (int pNodesOfFaceF=0; pNodesOfFaceF<nodesOfFaceF.length; pNodesOfFaceF++)
				{
					int pId = nodesOfFaceF[pNodesOfFaceF];
					int pPlus1Id = nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace];
					int pNodes = pId;
					int pPlus1Nodes = pPlus1Id;
					reduction3 = reduction3 + (MathFunctions.norm(ArrayOperations.minus(X[pNodes], X[pPlus1Nodes])));
				}
			}
			faceLength[fFaces] = 0.5 * reduction3;
		});
	}

	/**
	 * Job InitXcAndYc @-2.0
	 * In variables: Xc
	 * Out variables: xc, yc
	 */
	private void initXcAndYc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			xc[cCells] = Xc[cCells][0];
			yc[cCells] = Xc[cCells][1];
		});
	}

	/**
	 * Job InitU @-2.0
	 * In variables: Xc, vectOne, u0
	 * Out variables: u
	 */
	private void initU() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			if (MathFunctions.norm(ArrayOperations.minus(Xc[cCells], options.vectOne)) < 0.5) 
				u.set(cCells, options.u0);
			else 
				u.set(cCells, 0.0);
		});
	}

	/**
	 * Job computeDeltaTn @-2.0
	 * In variables: X_EDGE_LENGTH, Y_EDGE_LENGTH, D
	 * Out variables: deltat
	 */
	private void computeDeltaTn() 
	{
		double reduction1 = IntStream.range(0, nbCells).boxed().parallel().reduce(
			Double.MAX_VALUE, 
			(r, cCells) -> MathFunctions.min(r, options.X_EDGE_LENGTH * options.Y_EDGE_LENGTH / D[cCells]),
			(r1, r2) -> MathFunctions.min(r1, r2)
		);
		deltat = reduction1 * 0.24;
	}

	/**
	 * Job ComputeFaceConductivity @-2.0
	 * In variables: D
	 * Out variables: faceConductivity
	 */
	private void computeFaceConductivity() 
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			int fId = fFaces;
			double reduction4 = 1.0;
			{
				int[] cellsOfFaceF = mesh.getCellsOfFace(fId);
				for (int c1CellsOfFaceF=0; c1CellsOfFaceF<cellsOfFaceF.length; c1CellsOfFaceF++)
				{
					int c1Id = cellsOfFaceF[c1CellsOfFaceF];
					int c1Cells = c1Id;
					reduction4 = reduction4 * (D[c1Cells]);
				}
			}
			double reduction5 = 0.0;
			{
				int[] cellsOfFaceF = mesh.getCellsOfFace(fId);
				for (int c2CellsOfFaceF=0; c2CellsOfFaceF<cellsOfFaceF.length; c2CellsOfFaceF++)
				{
					int c2Id = cellsOfFaceF[c2CellsOfFaceF];
					int c2Cells = c2Id;
					reduction5 = reduction5 + (D[c2Cells]);
				}
			}
			faceConductivity[fFaces] = 2.0 * reduction4 / reduction5;
		});
	}

	/**
	 * Job computeAlphaCoeff @-1.0
	 * In variables: deltat, V, faceLength, faceConductivity, Xc
	 * Out variables: alpha
	 */
	private void computeAlphaCoeff() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			int cId = cCells;
			double alphaDiag = 0.0;
			{
				int[] neighbourCellsC = mesh.getNeighbourCells(cId);
				for (int dNeighbourCellsC=0; dNeighbourCellsC<neighbourCellsC.length; dNeighbourCellsC++)
				{
					int dId = neighbourCellsC[dNeighbourCellsC];
					int dCells = dId;
					int fCommonFaceCD = mesh.getCommonFace(cId, dId);
					int fId = fCommonFaceCD;
					int fFaces = fId;
					double alphaExtraDiag = -deltat / V[cCells] * (faceLength[fFaces] * faceConductivity[fFaces]) / MathFunctions.norm(ArrayOperations.minus(Xc[cCells], Xc[dCells]));
					alpha.set(cCells, dCells, alphaExtraDiag);
					alphaDiag = alphaDiag + alphaExtraDiag;
				}
			}
			alpha.set(cCells, cCells, 1 - alphaDiag);
		});
	}

	/**
	 * Job UpdateU @1.0
	 * In variables: alpha, u
	 * Out variables: u_nplus1
	 */
	private void updateU() 
	{
		u_nplus1 = LinearAlgebraFunctions.solveLinearSystem(alpha, u);
	}

	/**
	 * Job ComputeTn @1.0
	 * In variables: t, deltat
	 * Out variables: t_nplus1
	 */
	private void computeTn() 
	{
		t_nplus1 = t + deltat;
	}

	/**
	 * Job dumpVariables @1.0
	 * In variables: u
	 * Out variables: 
	 */
	private void dumpVariables() 
	{
		if (iteration % 1 == 0)
		{
			HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
			HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
			cellVariables.put("Temperature", u.toArray());
			writer.writeFile(iteration, t, X, mesh.getGeometricMesh().getQuads(), cellVariables, nodeVariables);
		}
	}

	/**
	 * Job Copy_u_nplus1_to_u @2.0
	 * In variables: u_nplus1
	 * Out variables: u
	 */
	private void copy_u_nplus1_to_u() 
	{
		Vector tmpSwitch = u;
		u = u_nplus1;
		u_nplus1 = tmpSwitch;
	}

	/**
	 * Job Copy_t_nplus1_to_t @2.0
	 * In variables: t_nplus1
	 * Out variables: t
	 */
	private void copy_t_nplus1_to_t() 
	{
		double tmpSwitch = t;
		t = t_nplus1;
		t_nplus1 = tmpSwitch;
	}
};
