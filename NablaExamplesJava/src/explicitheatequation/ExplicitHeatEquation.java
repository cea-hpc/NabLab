package explicitheatequation;

import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.Utils;
import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class ExplicitHeatEquation
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
	private double[][] X, Xc, alpha;
	private double[] xc, yc, u, V, D, faceLength, faceConductivity, u_nplus1;

	public ExplicitHeatEquation(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		writer = new PvdFileWriter2D("ExplicitHeatEquation");
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
		u = new double[nbCells];
		V = new double[nbCells];
		D = new double[nbCells];
		faceLength = new double[nbFaces];
		faceConductivity = new double[nbFaces];
		alpha = new double[nbCells][nbCells];
		u_nplus1 = new double[nbCells];

		// Copy node coordinates
		ArrayList<double[]> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X[rNodes] = gNodes.get(rNodes));
	}

	public void simulate()
	{
		System.out.println("Début de l'exécution du module ExplicitHeatEquation");
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
		System.out.println("Fin de l'exécution du module ExplicitHeatEquation");
	}

	public static void main(String[] args)
	{
		ExplicitHeatEquation.Options o = new ExplicitHeatEquation.Options();
		Mesh gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		ExplicitHeatEquation i = new ExplicitHeatEquation(o, nm);
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
			double[] reduction83321187 = {0.0, 0.0};
			{
				int[] nodesOfCellC = mesh.getNodesOfCell(cId);
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.length; pNodesOfCellC++)
				{
					int pId = nodesOfCellC[pNodesOfCellC];
					int pNodes = pId;
					reduction83321187 = ArrayOperations.plus(reduction83321187, (X[pNodes]));
				}
			}
			Xc[cCells] = ArrayOperations.multiply(0.25, reduction83321187);
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
			double reduction_1884650213 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int pNodesOfCellJ=0; pNodesOfCellJ<nodesOfCellJ.length; pNodesOfCellJ++)
				{
					int pId = nodesOfCellJ[pNodesOfCellJ];
					int pPlus1Id = nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					int pNodes = pId;
					int pPlus1Nodes = pPlus1Id;
					reduction_1884650213 = reduction_1884650213 + (MathFunctions.det(X[pNodes], X[pPlus1Nodes]));
				}
			}
			V[jCells] = 0.5 * reduction_1884650213;
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
			double reduction_1283758977 = 0.0;
			{
				int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
				for (int pNodesOfFaceF=0; pNodesOfFaceF<nodesOfFaceF.length; pNodesOfFaceF++)
				{
					int pId = nodesOfFaceF[pNodesOfFaceF];
					int pPlus1Id = nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace];
					int pNodes = pId;
					int pPlus1Nodes = pPlus1Id;
					reduction_1283758977 = reduction_1283758977 + (MathFunctions.norm(ArrayOperations.minus(X[pNodes], X[pPlus1Nodes])));
				}
			}
			faceLength[fFaces] = 0.5 * reduction_1283758977;
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
				u[cCells] = options.u0;
			else 
				u[cCells] = 0.0;
		});
	}		

	/**
	 * Job computeDeltaTn @-2.0
	 * In variables: X_EDGE_LENGTH, Y_EDGE_LENGTH, D
	 * Out variables: deltat
	 */
	private void computeDeltaTn() 
	{
		double reduction_714853031 = IntStream.range(0, nbCells).boxed().parallel().reduce(
			Double.MAX_VALUE, 
			(r, cCells) -> MathFunctions.min(r, options.X_EDGE_LENGTH * options.Y_EDGE_LENGTH / D[cCells]),
			(r1, r2) -> MathFunctions.min(r1, r2)
		);
		deltat = reduction_714853031 * 0.24;
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
			double reduction1970506419 = 1.0;
			{
				int[] cellsOfFaceF = mesh.getCellsOfFace(fId);
				for (int c1CellsOfFaceF=0; c1CellsOfFaceF<cellsOfFaceF.length; c1CellsOfFaceF++)
				{
					int c1Id = cellsOfFaceF[c1CellsOfFaceF];
					int c1Cells = c1Id;
					reduction1970506419 = reduction1970506419 * (D[c1Cells]);
				}
			}
			double reduction1628650791 = 0.0;
			{
				int[] cellsOfFaceF = mesh.getCellsOfFace(fId);
				for (int c2CellsOfFaceF=0; c2CellsOfFaceF<cellsOfFaceF.length; c2CellsOfFaceF++)
				{
					int c2Id = cellsOfFaceF[c2CellsOfFaceF];
					int c2Cells = c2Id;
					reduction1628650791 = reduction1628650791 + (D[c2Cells]);
				}
			}
			faceConductivity[fFaces] = 2.0 * reduction1970506419 / reduction1628650791;
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
					double alphaExtraDiag = deltat / V[cCells] * (faceLength[fFaces] * faceConductivity[fFaces]) / MathFunctions.norm(ArrayOperations.minus(Xc[cCells], Xc[dCells]));
					alpha[cCells][dCells] = alphaExtraDiag;
					alphaDiag = alphaDiag + alphaExtraDiag;
				}
			}
			alpha[cCells][cCells] = 1 - alphaDiag;
		});
	}		

	/**
	 * Job UpdateU @1.0
	 * In variables: alpha, u
	 * Out variables: u_nplus1
	 */
	private void updateU() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			int cId = cCells;
			double reduction_230660488 = 0.0;
			{
				int[] neighbourCellsC = mesh.getNeighbourCells(cId);
				for (int dNeighbourCellsC=0; dNeighbourCellsC<neighbourCellsC.length; dNeighbourCellsC++)
				{
					int dId = neighbourCellsC[dNeighbourCellsC];
					int dCells = dId;
					reduction_230660488 = reduction_230660488 + (alpha[cCells][dCells] * u[dCells]);
				}
			}
			u_nplus1[cCells] = alpha[cCells][cCells] * u[cCells] + reduction_230660488;
		});
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
			cellVariables.put("Temperature", u);
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
		double[] tmpSwitch = u;
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
