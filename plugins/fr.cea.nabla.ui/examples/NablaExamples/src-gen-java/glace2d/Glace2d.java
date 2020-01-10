package glace2d;

import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class Glace2d
{
	public final static class Options
	{
		public final double X_EDGE_LENGTH = 0.01;
		public final double Y_EDGE_LENGTH = X_EDGE_LENGTH;
		public final int X_EDGE_ELEMS = 100;
		public final int Y_EDGE_ELEMS = 10;
		public final double option_stoptime = 0.2;
		public final int option_max_iterations = 20000;
		public final double gamma = 1.4;
		public final double option_x_interface = 0.5;
		public final double option_deltat_ini = 1.0E-5;
		public final double option_deltat_cfl = 0.4;
		public final double option_rho_ini_zg = 1.0;
		public final double option_rho_ini_zd = 0.125;
		public final double option_p_ini_zg = 1.0;
		public final double option_p_ini_zd = 0.1;
	}

	private final Options options;

	// Mesh
	private final NumericMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;

	// Global Variables
	private int n, nbCalls, lastDump;
	private double t_n, t_nplus1, deltat_n, deltat_nplus1;

	// Connectivity Variables
	private double[][] X_n, X_nplus1, X_n0, b, bt, ur, uj_n, uj_nplus1, center, l;
	private double[][][] Ar, Mt, C_ic, C, F;
	private double[] p_ic, rho_ic, V_ic, c, m, p, rho, e, E_n, E_nplus1, V, deltatj;
	private double[][][][] Ajr;

	public Glace2d(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		writer = new PvdFileWriter2D("Glace2d");
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbNodesOfCell = NumericMesh2D.MaxNbNodesOfCell;
		nbCellsOfNode = NumericMesh2D.MaxNbCellsOfNode;
		nbInnerNodes = mesh.getNbInnerNodes();
		nbOuterFaces = mesh.getNbOuterFaces();
		nbNodesOfFace = NumericMesh2D.MaxNbNodesOfFace;

		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat_n = options.option_deltat_ini;
		deltat_nplus1 = options.option_deltat_ini;
		nbCalls = 0;
		lastDump = n;

		// Allocate arrays
		X_n = new double[nbNodes][2];
		X_nplus1 = new double[nbNodes][2];
		X_n0 = new double[nbNodes][2];
		b = new double[nbNodes][2];
		bt = new double[nbNodes][2];
		Ar = new double[nbNodes][2][2];
		Mt = new double[nbNodes][2][2];
		ur = new double[nbNodes][2];
		p_ic = new double[nbCells];
		rho_ic = new double[nbCells];
		V_ic = new double[nbCells];
		c = new double[nbCells];
		m = new double[nbCells];
		p = new double[nbCells];
		rho = new double[nbCells];
		e = new double[nbCells];
		E_n = new double[nbCells];
		E_nplus1 = new double[nbCells];
		V = new double[nbCells];
		deltatj = new double[nbCells];
		uj_n = new double[nbCells][2];
		uj_nplus1 = new double[nbCells][2];
		center = new double[nbCells][2];
		l = new double[nbCells][nbNodesOfCell];
		C_ic = new double[nbCells][nbNodesOfCell][2];
		C = new double[nbCells][nbNodesOfCell][2];
		F = new double[nbCells][nbNodesOfCell][2];
		Ajr = new double[nbCells][nbNodesOfCell][2][2];

		// Copy node coordinates
		ArrayList<double[]> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X_n0[rNodes] = gNodes.get(rNodes));
	}

	public void simulate()
	{
		System.out.println("Début de l'exécution du module Glace2d");
		computeCjrIc(); // @1.0
		iniCenter(); // @1.0
		iniUn(); // @1.0
		setUpTimeLoopN(); // @1.0
		iniIc(); // @2.0
		iniVIc(); // @2.0
		iniEn(); // @3.0
		iniM(); // @3.0
		executeTimeLoopN(); // @4.0
		System.out.println("Fin de l'exécution du module Glace2d");
	}

	public static void main(String[] args)
	{
		Glace2d.Options o = new Glace2d.Options();
		Mesh gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		Glace2d i = new Glace2d(o, nm);
		i.simulate();
	}

	/**
	 * Job ComputeCjr called @1.0 in executeTimeLoopN method.
	 * In variables: X_n
	 * Out variables: C
	 */
	private void computeCjr()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rMinus1Id = nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell];
					int rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					int rMinus1Nodes = rMinus1Id;
					int rPlus1Nodes = rPlus1Id;
					C[jCells][rNodesOfCellJ] = ArrayOperations.multiply(0.5, perp(ArrayOperations.minus(X_n[rPlus1Nodes], X_n[rMinus1Nodes])));
				}
			}
		});
	}

	/**
	 * Job ComputeCjrIc called @1.0 in simulate method.
	 * In variables: X_n0
	 * Out variables: C_ic
	 */
	private void computeCjrIc()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rMinus1Id = nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell];
					int rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					int rMinus1Nodes = rMinus1Id;
					int rPlus1Nodes = rPlus1Id;
					C_ic[jCells][rNodesOfCellJ] = ArrayOperations.multiply(0.5, perp(ArrayOperations.minus(X_n0[rPlus1Nodes], X_n0[rMinus1Nodes])));
				}
			}
		});
	}

	/**
	 * Job ComputeInternalEnergy called @1.0 in executeTimeLoopN method.
	 * In variables: E_n, uj_n
	 * Out variables: e
	 */
	private void computeInternalEnergy()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			e[jCells] = E_n[jCells] - 0.5 * MathFunctions.dot(uj_n[jCells], uj_n[jCells]);
		});
	}

	/**
	 * Job IniCenter called @1.0 in simulate method.
	 * In variables: X_n0
	 * Out variables: center
	 */
	private void iniCenter()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double[] reduction0 = {0.0, 0.0};
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					reduction0 = ArrayOperations.plus(reduction0, (X_n0[rNodes]));
				}
			}
			center[jCells] = ArrayOperations.multiply(0.25, reduction0);
		});
	}

	/**
	 * Job IniUn called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: uj_n
	 */
	private void iniUn()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			uj_n[jCells][0] = 0.0;
			uj_n[jCells][1] = 0.0;
		});
	}

	/**
	 * Job setUpTimeLoopN called @1.0 in simulate method.
	 * In variables: X_n0
	 * Out variables: X_n
	 */
	private void setUpTimeLoopN()
	{
		IntStream.range(0, X_n.length).parallel().forEach(i2 -> 
		{
			for (int i1=0 ; i1<X_n[i2].length ; i1++)
				X_n[i2][i1] = X_n0[i2][i1];
		});
	}

	/**
	 * Job ComputeLjr called @2.0 in executeTimeLoopN method.
	 * In variables: C
	 * Out variables: l
	 */
	private void computeLjr()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					l[jCells][rNodesOfCellJ] = MathFunctions.norm(C[jCells][rNodesOfCellJ]);
				}
			}
		});
	}

	/**
	 * Job ComputeV called @2.0 in executeTimeLoopN method.
	 * In variables: C, X_n
	 * Out variables: V
	 */
	private void computeV()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduction5 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					reduction5 = reduction5 + (MathFunctions.dot(C[jCells][rNodesOfCellJ], X_n[rNodes]));
				}
			}
			V[jCells] = 0.5 * reduction5;
		});
	}

	/**
	 * Job IniIc called @2.0 in simulate method.
	 * In variables: center, option_x_interface, option_rho_ini_zg, option_p_ini_zg, option_rho_ini_zd, option_p_ini_zd
	 * Out variables: rho_ic, p_ic
	 */
	private void iniIc()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			if (center[jCells][0] < options.option_x_interface) 
			{
				rho_ic[jCells] = options.option_rho_ini_zg;
				p_ic[jCells] = options.option_p_ini_zg;
			}
			else 
			{
				rho_ic[jCells] = options.option_rho_ini_zd;
				p_ic[jCells] = options.option_p_ini_zd;
			}
		});
	}

	/**
	 * Job IniVIc called @2.0 in simulate method.
	 * In variables: C_ic, X_n0
	 * Out variables: V_ic
	 */
	private void iniVIc()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduction1 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					reduction1 = reduction1 + (MathFunctions.dot(C_ic[jCells][rNodesOfCellJ], X_n0[rNodes]));
				}
			}
			V_ic[jCells] = 0.5 * reduction1;
		});
	}

	/**
	 * Job ComputeDensity called @3.0 in executeTimeLoopN method.
	 * In variables: m, V
	 * Out variables: rho
	 */
	private void computeDensity()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			rho[jCells] = m[jCells] / V[jCells];
		});
	}

	/**
	 * Job IniEn called @3.0 in simulate method.
	 * In variables: p_ic, gamma, rho_ic
	 * Out variables: E_n
	 */
	private void iniEn()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			E_n[jCells] = p_ic[jCells] / ((options.gamma - 1.0) * rho_ic[jCells]);
		});
	}

	/**
	 * Job IniM called @3.0 in simulate method.
	 * In variables: rho_ic, V_ic
	 * Out variables: m
	 */
	private void iniM()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			m[jCells] = rho_ic[jCells] * V_ic[jCells];
		});
	}

	/**
	 * Job ComputeEOSp called @4.0 in executeTimeLoopN method.
	 * In variables: gamma, rho, e
	 * Out variables: p
	 */
	private void computeEOSp()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			p[jCells] = (options.gamma - 1.0) * rho[jCells] * e[jCells];
		});
	}

	/**
	 * Job dumpVariables called @4.0 in executeTimeLoopN method.
	 * In variables: rho, n
	 * Out variables: 
	 */
	private void dumpVariables()
	{
		nbCalls++;
		if (n >= lastDump)
		{
			HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
			HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
			cellVariables.put("Density", rho);
			writer.writeFile(nbCalls, t_n, X_n, mesh.getGeometricMesh().getQuads(), cellVariables, nodeVariables);
			lastDump = n;
		}
	}

	/**
	 * Job executeTimeLoopN called @4.0 in simulate method.
	 * In variables: t_n, c, X_EDGE_ELEMS, bt, gamma, deltat_n, ur, Ar, l, m, Y_EDGE_ELEMS, n, option_deltat_cfl, E_n, Mt, deltatj, X_n, deltat_nplus1, e, Ajr, Y_EDGE_LENGTH, uj_n, V, F, rho, p, b, X_EDGE_LENGTH, C
	 * Out variables: Mt, X_nplus1, deltatj, deltat_nplus1, e, c, bt, Ajr, E_nplus1, ur, V, uj_nplus1, Ar, F, l, t_nplus1, rho, p, b, C
	 */
	private void executeTimeLoopN()
	{
		n = 0;
		boolean continueLoop = true;
		do
		{
			n++;
			System.out.println("[" + n + "] t : " + t_n);
			computeCjr(); // @1.0
			computeInternalEnergy(); // @1.0
			computeLjr(); // @2.0
			computeV(); // @2.0
			computeDensity(); // @3.0
			computeEOSp(); // @4.0
			dumpVariables(); // @4.0
			computeEOSc(); // @5.0
			computeAjr(); // @6.0
			computedeltatj(); // @6.0
			computeAr(); // @7.0
			computeBr(); // @7.0
			computeDt(); // @7.0
			computeBt(); // @8.0
			computeMt(); // @8.0
			computeTn(); // @8.0
			outerFacesComputations(); // @8.0
			computeU(); // @9.0
			computeFjr(); // @10.0
			computeXn(); // @10.0
			computeEn(); // @11.0
			computeUn(); // @11.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options.option_stoptime && n + 1 < options.option_max_iterations);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double tmpT_n = t_n;
				t_n = t_nplus1;
				t_nplus1 = tmpT_n;
				double tmpDeltat_n = deltat_n;
				deltat_n = deltat_nplus1;
				deltat_nplus1 = tmpDeltat_n;
				double[][] tmpX_n = X_n;
				X_n = X_nplus1;
				X_nplus1 = tmpX_n;
				double[] tmpE_n = E_n;
				E_n = E_nplus1;
				E_nplus1 = tmpE_n;
				double[][] tmpUj_n = uj_n;
				uj_n = uj_nplus1;
				uj_nplus1 = tmpUj_n;
			} 
		} while (continueLoop);
	}

	/**
	 * Job ComputeEOSc called @5.0 in executeTimeLoopN method.
	 * In variables: gamma, p, rho
	 * Out variables: c
	 */
	private void computeEOSc()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			c[jCells] = MathFunctions.sqrt(options.gamma * p[jCells] / rho[jCells]);
		});
	}

	/**
	 * Job ComputeAjr called @6.0 in executeTimeLoopN method.
	 * In variables: rho, c, l, C
	 * Out variables: Ajr
	 */
	private void computeAjr()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					Ajr[jCells][rNodesOfCellJ] = ArrayOperations.multiply(((rho[jCells] * c[jCells]) / l[jCells][rNodesOfCellJ]), tensProduct(C[jCells][rNodesOfCellJ], C[jCells][rNodesOfCellJ]));
				}
			}
		});
	}

	/**
	 * Job Computedeltatj called @6.0 in executeTimeLoopN method.
	 * In variables: l, V, c
	 * Out variables: deltatj
	 */
	private void computedeltatj()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduction2 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					reduction2 = reduction2 + (l[jCells][rNodesOfCellJ]);
				}
			}
			deltatj[jCells] = 2.0 * V[jCells] / (c[jCells] * reduction2);
		});
	}

	/**
	 * Job ComputeAr called @7.0 in executeTimeLoopN method.
	 * In variables: Ajr
	 * Out variables: Ar
	 */
	private void computeAr()
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			int rId = rNodes;
			double[][] reduction3 = {{0.0, 0.0}, {0.0, 0.0}};
			{
				int[] cellsOfNodeR = mesh.getCellsOfNode(rId);
				for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.length; jCellsOfNodeR++)
				{
					int jId = cellsOfNodeR[jCellsOfNodeR];
					int jCells = jId;
					int rNodesOfCellJ = Utils.indexOf(mesh.getNodesOfCell(jId), rId);
					reduction3 = ArrayOperations.plus(reduction3, (Ajr[jCells][rNodesOfCellJ]));
				}
			}
			Ar[rNodes] = reduction3;
		});
	}

	/**
	 * Job ComputeBr called @7.0 in executeTimeLoopN method.
	 * In variables: p, C, Ajr, uj_n
	 * Out variables: b
	 */
	private void computeBr()
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			int rId = rNodes;
			double[] reduction4 = {0.0, 0.0};
			{
				int[] cellsOfNodeR = mesh.getCellsOfNode(rId);
				for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.length; jCellsOfNodeR++)
				{
					int jId = cellsOfNodeR[jCellsOfNodeR];
					int jCells = jId;
					int rNodesOfCellJ = Utils.indexOf(mesh.getNodesOfCell(jId), rId);
					reduction4 = ArrayOperations.plus(reduction4, (ArrayOperations.plus(ArrayOperations.multiply(p[jCells], C[jCells][rNodesOfCellJ]), MathFunctions.matVectProduct(Ajr[jCells][rNodesOfCellJ], uj_n[jCells]))));
				}
			}
			b[rNodes] = reduction4;
		});
	}

	/**
	 * Job ComputeDt called @7.0 in executeTimeLoopN method.
	 * In variables: deltatj, option_deltat_cfl
	 * Out variables: deltat_nplus1
	 */
	private void computeDt()
	{
		double reduction8 = IntStream.range(0, nbCells).boxed().parallel().reduce(
			Double.MAX_VALUE, 
			(r, jCells) -> MathFunctions.min(r, deltatj[jCells]),
			(r1, r2) -> MathFunctions.min(r1, r2)
		);
		deltat_nplus1 = options.option_deltat_cfl * reduction8;
	}

	/**
	 * Job ComputeBt called @8.0 in executeTimeLoopN method.
	 * In variables: b
	 * Out variables: bt
	 */
	private void computeBt()
	{
		int[] innerNodes = mesh.getInnerNodes();
		IntStream.range(0, nbInnerNodes).parallel().forEach(rInnerNodes -> 
		{
			int rId = innerNodes[rInnerNodes];
			int rNodes = rId;
			bt[rNodes] = b[rNodes];
		});
	}

	/**
	 * Job ComputeMt called @8.0 in executeTimeLoopN method.
	 * In variables: Ar
	 * Out variables: Mt
	 */
	private void computeMt()
	{
		int[] innerNodes = mesh.getInnerNodes();
		IntStream.range(0, nbInnerNodes).parallel().forEach(rInnerNodes -> 
		{
			int rId = innerNodes[rInnerNodes];
			int rNodes = rId;
			Mt[rNodes] = Ar[rNodes];
		});
	}

	/**
	 * Job ComputeTn called @8.0 in executeTimeLoopN method.
	 * In variables: t_n, deltat_nplus1
	 * Out variables: t_nplus1
	 */
	private void computeTn()
	{
		t_nplus1 = t_n + deltat_nplus1;
	}

	/**
	 * Job OuterFacesComputations called @8.0 in executeTimeLoopN method.
	 * In variables: X_EDGE_ELEMS, X_EDGE_LENGTH, Y_EDGE_ELEMS, Y_EDGE_LENGTH, X_n, b, Ar
	 * Out variables: bt, Mt
	 */
	private void outerFacesComputations()
	{
		int[] outerFaces = mesh.getOuterFaces();
		IntStream.range(0, nbOuterFaces).parallel().forEach(fOuterFaces -> 
		{
			int fId = outerFaces[fOuterFaces];
			final double epsilon = 1.0E-10;
			double[][] I = new double[][] {new double[] {1.0, 0.0}, new double[] {0.0, 1.0}};
			double X_MIN = 0.0;
			double X_MAX = options.X_EDGE_ELEMS * options.X_EDGE_LENGTH;
			double Y_MIN = 0.0;
			double Y_MAX = options.Y_EDGE_ELEMS * options.Y_EDGE_LENGTH;
			double[] nY = new double[] {0.0, 1.0};
			{
				int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
				for (int rNodesOfFaceF=0; rNodesOfFaceF<nodesOfFaceF.length; rNodesOfFaceF++)
				{
					int rId = nodesOfFaceF[rNodesOfFaceF];
					int rNodes = rId;
					if ((X_n[rNodes][1] - Y_MIN < epsilon) || (X_n[rNodes][1] - Y_MAX < epsilon)) 
					{
						double sign = 0.0;
						if (X_n[rNodes][1] - Y_MIN < epsilon) 
							sign = -1.0;
						else 
							sign = 1.0;
						double[] N = ArrayOperations.multiply(sign, nY);
						double[][] NxN = tensProduct(N, N);
						double[][] IcP = ArrayOperations.minus(I, NxN);
						bt[rNodes] = MathFunctions.matVectProduct(IcP, b[rNodes]);
						Mt[rNodes] = ArrayOperations.plus(ArrayOperations.multiply(IcP, (ArrayOperations.multiply(Ar[rNodes], IcP))), ArrayOperations.multiply(NxN, trace(Ar[rNodes])));
					}
					if ((MathFunctions.fabs(X_n[rNodes][0] - X_MIN) < epsilon) || ((MathFunctions.fabs(X_n[rNodes][0] - X_MAX) < epsilon))) 
					{
						Mt[rNodes] = I;
						bt[rNodes][0] = 0.0;
						bt[rNodes][1] = 0.0;
					}
				}
			}
		});
	}

	/**
	 * Job ComputeU called @9.0 in executeTimeLoopN method.
	 * In variables: Mt, bt
	 * Out variables: ur
	 */
	private void computeU()
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			ur[rNodes] = MathFunctions.matVectProduct(inverse(Mt[rNodes]), bt[rNodes]);
		});
	}

	/**
	 * Job ComputeFjr called @10.0 in executeTimeLoopN method.
	 * In variables: p, C, Ajr, uj_n, ur
	 * Out variables: F
	 */
	private void computeFjr()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					F[jCells][rNodesOfCellJ] = ArrayOperations.plus(ArrayOperations.multiply(p[jCells], C[jCells][rNodesOfCellJ]), MathFunctions.matVectProduct(Ajr[jCells][rNodesOfCellJ], (ArrayOperations.minus(uj_n[jCells], ur[rNodes]))));
				}
			}
		});
	}

	/**
	 * Job ComputeXn called @10.0 in executeTimeLoopN method.
	 * In variables: X_n, deltat_n, ur
	 * Out variables: X_nplus1
	 */
	private void computeXn()
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			X_nplus1[rNodes] = ArrayOperations.plus(X_n[rNodes], ArrayOperations.multiply(deltat_n, ur[rNodes]));
		});
	}

	/**
	 * Job ComputeEn called @11.0 in executeTimeLoopN method.
	 * In variables: F, ur, E_n, deltat_n, m
	 * Out variables: E_nplus1
	 */
	private void computeEn()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduction7 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					reduction7 = reduction7 + (MathFunctions.dot(F[jCells][rNodesOfCellJ], ur[rNodes]));
				}
			}
			E_nplus1[jCells] = E_n[jCells] - (deltat_n / m[jCells]) * reduction7;
		});
	}

	/**
	 * Job ComputeUn called @11.0 in executeTimeLoopN method.
	 * In variables: F, uj_n, deltat_n, m
	 * Out variables: uj_nplus1
	 */
	private void computeUn()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double[] reduction6 = {0.0, 0.0};
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					reduction6 = ArrayOperations.plus(reduction6, (F[jCells][rNodesOfCellJ]));
				}
			}
			uj_nplus1[jCells] = ArrayOperations.minus(uj_n[jCells], ArrayOperations.multiply((deltat_n / m[jCells]), reduction6));
		});
	}

	private double[] perp(double[] a)
	{
		return new double[] {a[1], -a[0]};
	}

	private double[][] tensProduct(double[] a, double[] b)
	{
		final int l = a.length;
		double[][] result = new double[l][l];
		for (int ia=0; ia<l; ia++)
			for (int ib=0; ib<l; ib++)
				result[ia][ib] = a[ia] * b[ib];
		return result;
	}

	private double trace(double[][] a)
	{
		final int l = a.length;
		double result = 0.0;
		for (int ia=0; ia<l; ia++)
			result = result + a[ia][ia];
		return result;
	}

	private double[][] inverse(double[][] a)
	{
		double alpha = 1.0 / MathFunctions.det(a);
		return new double[][] {new double[] {a[1][1] * alpha, -a[0][1] * alpha}, new double[] {-a[1][0] * alpha, a[0][0] * alpha}};
	}
};
