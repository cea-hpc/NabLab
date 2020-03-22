package iterativeheatequation;

import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class IterativeHeatEquation
{
	public final static class Options
	{
		public final double X_LENGTH = 2.0;
		public final double Y_LENGTH = 2.0;
		public final double u0 = 1.0;
		public final double[] vectOne = new double[] {1.0, 1.0};
		public final int X_EDGE_ELEMS = 40;
		public final int Y_EDGE_ELEMS = 40;
		public final double X_EDGE_LENGTH = X_LENGTH / X_EDGE_ELEMS;
		public final double Y_EDGE_LENGTH = Y_LENGTH / Y_EDGE_ELEMS;
		public final double option_stoptime = 0.1;
		public final int option_max_iterations = 500000000;
		public final int option_max_iterations_k = 1000;
	}

	private final Options options;

	// Mesh
	private final CartesianMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbCellsOfFace, nbNeighbourCells;

	// Global Variables
	private int n, k, lastDump;
	private double t_n, t_nplus1, deltat, epsilon, residual;

	// Connectivity Variables
	private double[][] X, Xc, alpha;
	private double[] xc, yc, u_n, u_nplus1, u_nplus1_k, u_nplus1_kplus1, V, D, faceLength, faceConductivity;

	public IterativeHeatEquation(Options aOptions, CartesianMesh2D aCartesianMesh2D)
	{
		options = aOptions;
		mesh = aCartesianMesh2D;
		writer = new PvdFileWriter2D("IterativeHeatEquation");
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbFaces = mesh.getNbFaces();
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;
		nbNodesOfFace = CartesianMesh2D.MaxNbNodesOfFace;
		nbCellsOfFace = CartesianMesh2D.MaxNbCellsOfFace;
		nbNeighbourCells = CartesianMesh2D.MaxNbNeighbourCells;

		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat = 0.001;
		epsilon = 1.0E-8;
		lastDump = Integer.MIN_VALUE;

		// Allocate arrays
		X = new double[nbNodes][2];
		Xc = new double[nbCells][2];
		xc = new double[nbCells];
		yc = new double[nbCells];
		u_n = new double[nbCells];
		u_nplus1 = new double[nbCells];
		u_nplus1_k = new double[nbCells];
		u_nplus1_kplus1 = new double[nbCells];
		V = new double[nbCells];
		D = new double[nbCells];
		faceLength = new double[nbFaces];
		faceConductivity = new double[nbFaces];
		alpha = new double[nbCells][nbCells];

		// Copy node coordinates
		double[][] gNodes = mesh.getGeometry().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> {
			X[rNodes][0] = gNodes[rNodes][0];
			X[rNodes][1] = gNodes[rNodes][1];
		});
	}

	public void simulate()
	{
		System.out.println("Start execution of module IterativeHeatEquation");
		computeFaceLength(); // @1.0
		computeV(); // @1.0
		initD(); // @1.0
		initXc(); // @1.0
		computeFaceConductivity(); // @2.0
		initU(); // @2.0
		initXcAndYc(); // @2.0
		computeDeltaTn(); // @2.0
		computeAlphaCoeff(); // @3.0
		executeTimeLoopN(); // @4.0
		System.out.println("End of execution of module IterativeHeatEquation");
	}

	public static void main(String[] args)
	{
		IterativeHeatEquation.Options o = new IterativeHeatEquation.Options();
		CartesianMesh2D mesh = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		IterativeHeatEquation i = new IterativeHeatEquation(o, mesh);
		i.simulate();
	}

	/**
	 * Job ComputeFaceLength called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: faceLength
	 */
	private void computeFaceLength()
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			final int fId = fFaces;
			double reduction3 = 0.0;
			{
				final int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
				final int nbElemsPNodesOfFaceF = nodesOfFaceF.length;
				for (int pNodesOfFaceF=0; pNodesOfFaceF<nbElemsPNodesOfFaceF; pNodesOfFaceF++)
				{
					final int pId = nodesOfFaceF[pNodesOfFaceF];
					final int pPlus1Id = nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace];
					final int pNodes = pId;
					final int pPlus1Nodes = pPlus1Id;
					reduction3 = sumR0(reduction3, MathFunctions.norm(ArrayOperations.minus(X[pNodes], X[pPlus1Nodes])));
				}
			}
			faceLength[fFaces] = 0.5 * reduction3;
		});
	}

	/**
	 * Job ComputeTn called @1.0 in executeTimeLoopN method.
	 * In variables: deltat, t_n
	 * Out variables: t_nplus1
	 */
	private void computeTn()
	{
		t_nplus1 = t_n + deltat;
	}

	/**
	 * Job ComputeV called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: V
	 */
	private void computeV()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			final int jId = jCells;
			double reduction2 = 0.0;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbElemsPNodesOfCellJ = nodesOfCellJ.length;
				for (int pNodesOfCellJ=0; pNodesOfCellJ<nbElemsPNodesOfCellJ; pNodesOfCellJ++)
				{
					final int pId = nodesOfCellJ[pNodesOfCellJ];
					final int pPlus1Id = nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					final int pNodes = pId;
					final int pPlus1Nodes = pPlus1Id;
					reduction2 = sumR0(reduction2, MathFunctions.det(X[pNodes], X[pPlus1Nodes]));
				}
			}
			V[jCells] = 0.5 * reduction2;
		});
	}

	/**
	 * Job InitD called @1.0 in simulate method.
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
	 * Job InitXc called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: Xc
	 */
	private void initXc()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			final int cId = cCells;
			double[] reduction0 = new double[] {0.0, 0.0};
			{
				final int[] nodesOfCellC = mesh.getNodesOfCell(cId);
				final int nbElemsPNodesOfCellC = nodesOfCellC.length;
				for (int pNodesOfCellC=0; pNodesOfCellC<nbElemsPNodesOfCellC; pNodesOfCellC++)
				{
					final int pId = nodesOfCellC[pNodesOfCellC];
					final int pNodes = pId;
					reduction0 = sumR1(reduction0, X[pNodes]);
				}
			}
			Xc[cCells] = ArrayOperations.multiply(0.25, reduction0);
		});
	}

	/**
	 * Job SetUpTimeLoopK called @1.0 in executeTimeLoopN method.
	 * In variables: u_n
	 * Out variables: u_nplus1_k
	 */
	private void setUpTimeLoopK()
	{
		IntStream.range(0, u_nplus1_k.length).parallel().forEach(i1 -> 
		{
			u_nplus1_k[i1] = u_n[i1];
		});
	}

	/**
	 * Job UpdateU called @1.0 in executeTimeLoopK method.
	 * In variables: alpha, u_n, u_nplus1_k
	 * Out variables: u_nplus1_kplus1
	 */
	private void updateU()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			final int cId = cCells;
			double reduction6 = 0.0;
			{
				final int[] neighbourCellsC = mesh.getNeighbourCells(cId);
				final int nbElemsDNeighbourCellsC = neighbourCellsC.length;
				for (int dNeighbourCellsC=0; dNeighbourCellsC<nbElemsDNeighbourCellsC; dNeighbourCellsC++)
				{
					final int dId = neighbourCellsC[dNeighbourCellsC];
					final int dCells = dId;
					reduction6 = sumR0(reduction6, alpha[cCells][dCells] * u_nplus1_k[dCells]);
				}
			}
			u_nplus1_kplus1[cCells] = u_n[cCells] + alpha[cCells][cCells] * u_nplus1_k[cCells] + reduction6;
		});
	}

	/**
	 * Job ComputeFaceConductivity called @2.0 in simulate method.
	 * In variables: D
	 * Out variables: faceConductivity
	 */
	private void computeFaceConductivity()
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			final int fId = fFaces;
			double reduction4 = 1.0;
			{
				final int[] cellsOfFaceF = mesh.getCellsOfFace(fId);
				final int nbElemsC1CellsOfFaceF = cellsOfFaceF.length;
				for (int c1CellsOfFaceF=0; c1CellsOfFaceF<nbElemsC1CellsOfFaceF; c1CellsOfFaceF++)
				{
					final int c1Id = cellsOfFaceF[c1CellsOfFaceF];
					final int c1Cells = c1Id;
					reduction4 = prodR0(reduction4, D[c1Cells]);
				}
			}
			double reduction5 = 0.0;
			{
				final int[] cellsOfFaceF = mesh.getCellsOfFace(fId);
				final int nbElemsC2CellsOfFaceF = cellsOfFaceF.length;
				for (int c2CellsOfFaceF=0; c2CellsOfFaceF<nbElemsC2CellsOfFaceF; c2CellsOfFaceF++)
				{
					final int c2Id = cellsOfFaceF[c2CellsOfFaceF];
					final int c2Cells = c2Id;
					reduction5 = sumR0(reduction5, D[c2Cells]);
				}
			}
			faceConductivity[fFaces] = 2.0 * reduction4 / reduction5;
		});
	}

	/**
	 * Job ComputeResidual called @2.0 in executeTimeLoopK method.
	 * In variables: u_nplus1_k, u_nplus1_kplus1
	 * Out variables: residual
	 */
	private void computeResidual()
	{
		double reduction7 = Double.MIN_VALUE;
		reduction7 = IntStream.range(0, nbCells).boxed().parallel().reduce
		(
			Double.MIN_VALUE,
			(accu, jCells) ->
			{
				return maxR0(accu, MathFunctions.fabs(u_nplus1_kplus1[jCells] - u_nplus1_k[jCells]));
			},
			(r1, r2) -> maxR0(r1, r2)
		);
		residual = reduction7;
	}

	/**
	 * Job ExecuteTimeLoopK called @2.0 in executeTimeLoopN method.
	 * In variables: alpha, u_n, u_nplus1_k, u_nplus1_kplus1
	 * Out variables: residual, u_nplus1_kplus1
	 */
	private void executeTimeLoopK()
	{
		k = 0;
		boolean continueLoop = true;
		do
		{
			k++;
			System.out.printf("	[%5d] t: %5.5f - deltat: %5.5f\n", k, t_n, deltat);
			updateU(); // @1.0
			computeResidual(); // @2.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (residual > epsilon && k + 1 < options.option_max_iterations_k);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double[] tmp_u_nplus1_k = u_nplus1_k;
				u_nplus1_k = u_nplus1_kplus1;
				u_nplus1_kplus1 = tmp_u_nplus1_k;
			} 
		} while (continueLoop);
	}

	/**
	 * Job InitU called @2.0 in simulate method.
	 * In variables: Xc, u0, vectOne
	 * Out variables: u_n
	 */
	private void initU()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			if (MathFunctions.norm(ArrayOperations.minus(Xc[cCells], options.vectOne)) < 0.5)
				u_n[cCells] = options.u0;
			else
				u_n[cCells] = 0.0;
		});
	}

	/**
	 * Job InitXcAndYc called @2.0 in simulate method.
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
	 * Job computeDeltaTn called @2.0 in simulate method.
	 * In variables: D, X_EDGE_LENGTH, Y_EDGE_LENGTH
	 * Out variables: deltat
	 */
	private void computeDeltaTn()
	{
		double reduction1 = Double.MAX_VALUE;
		reduction1 = IntStream.range(0, nbCells).boxed().parallel().reduce
		(
			Double.MAX_VALUE,
			(accu, cCells) ->
			{
				return minR0(accu, options.X_EDGE_LENGTH * options.Y_EDGE_LENGTH / D[cCells]);
			},
			(r1, r2) -> minR0(r1, r2)
		);
		deltat = reduction1 * 0.1;
	}

	/**
	 * Job TearDownTimeLoopK called @3.0 in executeTimeLoopN method.
	 * In variables: u_nplus1_kplus1
	 * Out variables: u_nplus1
	 */
	private void tearDownTimeLoopK()
	{
		IntStream.range(0, u_nplus1.length).parallel().forEach(i1 -> 
		{
			u_nplus1[i1] = u_nplus1_kplus1[i1];
		});
	}

	/**
	 * Job computeAlphaCoeff called @3.0 in simulate method.
	 * In variables: V, Xc, deltat, faceConductivity, faceLength
	 * Out variables: alpha
	 */
	private void computeAlphaCoeff()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			final int cId = cCells;
			double alphaDiag = 0.0;
			{
				final int[] neighbourCellsC = mesh.getNeighbourCells(cId);
				final int nbElemsDNeighbourCellsC = neighbourCellsC.length;
				for (int dNeighbourCellsC=0; dNeighbourCellsC<nbElemsDNeighbourCellsC; dNeighbourCellsC++)
				{
					final int dId = neighbourCellsC[dNeighbourCellsC];
					final int dCells = dId;
					final int fId = mesh.getCommonFace(cId, dId);
					final int fFaces = fId;
					double alphaExtraDiag = deltat / V[cCells] * (faceLength[fFaces] * faceConductivity[fFaces]) / MathFunctions.norm(ArrayOperations.minus(Xc[cCells], Xc[dCells]));
					alpha[cCells][dCells] = alphaExtraDiag;
					alphaDiag = alphaDiag + alphaExtraDiag;
				}
			}
			alpha[cCells][cCells] = -alphaDiag;
		});
	}

	/**
	 * Job ExecuteTimeLoopN called @4.0 in simulate method.
	 * In variables: alpha, deltat, t_n, u_n, u_nplus1_k, u_nplus1_kplus1
	 * Out variables: residual, t_nplus1, u_nplus1, u_nplus1_k, u_nplus1_kplus1
	 */
	private void executeTimeLoopN()
	{
		n = 0;
		boolean continueLoop = true;
		do
		{
			n++;
			System.out.printf("[%5d] t: %5.5f - deltat: %5.5f\n", n, t_n, deltat);
			dumpVariables(n);
			computeTn(); // @1.0
			setUpTimeLoopK(); // @1.0
			executeTimeLoopK(); // @2.0
			tearDownTimeLoopK(); // @3.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options.option_stoptime && n + 1 < options.option_max_iterations);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double tmp_t_n = t_n;
				t_n = t_nplus1;
				t_nplus1 = tmp_t_n;
				double[] tmp_u_n = u_n;
				u_n = u_nplus1;
				u_nplus1 = tmp_u_n;
			} 
		} while (continueLoop);
	}

	private double[] sumR1(double[] a, double[] b)
	{
		final int x = a.length;
		return ArrayOperations.plus(a, b);
	}

	private double minR0(double a, double b)
	{
		return MathFunctions.min(a, b);
	}

	private double sumR0(double a, double b)
	{
		return a + b;
	}

	private double prodR0(double a, double b)
	{
		return a * b;
	}

	private double maxR0(double a, double b)
	{
		return MathFunctions.max(a, b);
	}

	private void dumpVariables(int iteration)
	{
		if (n >= lastDump + 1.0)
		{
			HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
			HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
			cellVariables.put("Temperature", u_n);
			writer.writeFile(iteration, t_n, X, mesh.getGeometry().getQuads(), cellVariables, nodeVariables);
			lastDump = n;
		}
	}
};
