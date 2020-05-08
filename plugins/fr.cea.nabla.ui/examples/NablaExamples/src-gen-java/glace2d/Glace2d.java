package glace2d;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.HashMap;
import java.util.stream.IntStream;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.stream.JsonReader;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class Glace2d
{
	public final static class Options
	{
		public double X_EDGE_LENGTH;
		public double Y_EDGE_LENGTH;
		public int X_EDGE_ELEMS;
		public int Y_EDGE_ELEMS;
		public double option_stoptime;
		public int option_max_iterations;
		public double gamma;
		public double option_x_interface;
		public double option_deltat_ini;
		public double option_deltat_cfl;
		public double option_rho_ini_zg;
		public double option_rho_ini_zd;
		public double option_p_ini_zg;
		public double option_p_ini_zd;

		public static Options createOptions(String jsonFileName) throws FileNotFoundException
		{
			Gson gson = new Gson();
			JsonReader reader = new JsonReader(new FileReader(jsonFileName));
			return gson.fromJson(reader, Options.class);
		}
	}

	private final Options options;

	// Mesh
	private final CartesianMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;

	// Global Variables
	private double t_n;
	private double t_nplus1;
	private double deltat_n;
	private double deltat_nplus1;
	private int lastDump;
	private int n;
	private double[][] X_n;
	private double[][] X_nplus1;
	private double[][] X_n0;
	private double[][] b;
	private double[][] bt;
	private double[][][] Ar;
	private double[][][] Mt;
	private double[][] ur;
	private double[] c;
	private double[] m;
	private double[] p;
	private double[] rho;
	private double[] e;
	private double[] E_n;
	private double[] E_nplus1;
	private double[] V;
	private double[] deltatj;
	private double[][] uj_n;
	private double[][] uj_nplus1;
	private double[][] l;
	private double[][][] Cjr_ic;
	private double[][][] C;
	private double[][][] F;
	private double[][][][] Ajr;

	public Glace2d(Options aOptions, CartesianMesh2D aCartesianMesh2D)
	{
		options = aOptions;
		mesh = aCartesianMesh2D;
		writer = new PvdFileWriter2D("Glace2d");
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;
		nbCellsOfNode = CartesianMesh2D.MaxNbCellsOfNode;
		nbInnerNodes = mesh.getNbInnerNodes();
		nbOuterFaces = mesh.getNbOuterFaces();
		nbNodesOfFace = CartesianMesh2D.MaxNbNodesOfFace;

		// Initialize variables
		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat_n = options.option_deltat_ini;
		deltat_nplus1 = options.option_deltat_ini;
		lastDump = Integer.MIN_VALUE;
		X_n = new double[nbNodes][2];
		X_nplus1 = new double[nbNodes][2];
		X_n0 = new double[nbNodes][2];
		b = new double[nbNodes][2];
		bt = new double[nbNodes][2];
		Ar = new double[nbNodes][2][2];
		Mt = new double[nbNodes][2][2];
		ur = new double[nbNodes][2];
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
		l = new double[nbCells][nbNodesOfCell];
		Cjr_ic = new double[nbCells][nbNodesOfCell][2];
		C = new double[nbCells][nbNodesOfCell][2];
		F = new double[nbCells][nbNodesOfCell][2];
		Ajr = new double[nbCells][nbNodesOfCell][2][2];

		// Copy node coordinates
		double[][] gNodes = mesh.getGeometry().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes ->
		{
			X_n0[rNodes][0] = gNodes[rNodes][0];
			X_n0[rNodes][1] = gNodes[rNodes][1];
		});
	}

	public void simulate()
	{
		System.out.println("Start execution of module Glace2d");
		iniCjrIc(); // @1.0
		setUpTimeLoopN(); // @1.0
		initialize(); // @2.0
		executeTimeLoopN(); // @3.0
		System.out.println("End of execution of module Glace2d");
	}

	public static void main(String[] args) throws FileNotFoundException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			Glace2d.Options o = Glace2d.Options.createOptions(dataFileName);
			CartesianMesh2D mesh = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
			Glace2d i = new Glace2d(o, mesh);
			i.simulate();
		}
		else
		{
			System.out.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.out.println("        Expecting user data file name, for example Glace2dDefaultOptions.json");
		}
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
			final int jId = jCells;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					final int rMinus1Id = nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell];
					final int rPlus1Nodes = rPlus1Id;
					final int rMinus1Nodes = rMinus1Id;
					C[jCells][rNodesOfCellJ] = ArrayOperations.multiply(0.5, perp(ArrayOperations.minus(X_n[rPlus1Nodes], X_n[rMinus1Nodes])));
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
			e[jCells] = E_n[jCells] - 0.5 * dot(uj_n[jCells], uj_n[jCells]);
		});
	}

	/**
	 * Job IniCjrIc called @1.0 in simulate method.
	 * In variables: X_n0
	 * Out variables: Cjr_ic
	 */
	private void iniCjrIc()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			final int jId = jCells;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					final int rMinus1Id = nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell];
					final int rPlus1Nodes = rPlus1Id;
					final int rMinus1Nodes = rMinus1Id;
					Cjr_ic[jCells][rNodesOfCellJ] = ArrayOperations.multiply(0.5, perp(ArrayOperations.minus(X_n0[rPlus1Nodes], X_n0[rMinus1Nodes])));
				}
			}
		});
	}

	/**
	 * Job SetUpTimeLoopN called @1.0 in simulate method.
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
			final int jId = jCells;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					l[jCells][rNodesOfCellJ] = norm(C[jCells][rNodesOfCellJ]);
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
			final int jId = jCells;
			double reduction5 = 0.0;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rNodes = rId;
					reduction5 = sumR0(reduction5, dot(C[jCells][rNodesOfCellJ], X_n[rNodes]));
				}
			}
			V[jCells] = 0.5 * reduction5;
		});
	}

	/**
	 * Job Initialize called @2.0 in simulate method.
	 * In variables: Cjr_ic, X_n0, gamma, option_p_ini_zd, option_p_ini_zg, option_rho_ini_zd, option_rho_ini_zg, option_x_interface
	 * Out variables: E_n, m, p, rho, uj_n
	 */
	private void initialize()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			final int jId = jCells;
			double rho_ic;
			double p_ic;
			double[] reduction0 = new double[] {0.0, 0.0};
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rNodes = rId;
					reduction0 = sumR1(reduction0, X_n0[rNodes]);
				}
			}
			final double[] center = ArrayOperations.multiply(0.25, reduction0);
			if (center[0] < options.option_x_interface)
			{
				rho_ic = options.option_rho_ini_zg;
				p_ic = options.option_p_ini_zg;
			}
			else
			{
				rho_ic = options.option_rho_ini_zd;
				p_ic = options.option_p_ini_zd;
			}
			double reduction1 = 0.0;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rNodes = rId;
					reduction1 = sumR0(reduction1, dot(Cjr_ic[jCells][rNodesOfCellJ], X_n0[rNodes]));
				}
			}
			final double V_ic = 0.5 * reduction1;
			m[jCells] = rho_ic * V_ic;
			p[jCells] = p_ic;
			rho[jCells] = rho_ic;
			E_n[jCells] = p_ic / ((options.gamma - 1.0) * rho_ic);
			uj_n[jCells] = new double[] {0.0, 0.0};
		});
	}

	/**
	 * Job ComputeDensity called @3.0 in executeTimeLoopN method.
	 * In variables: V, m
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
	 * Job ExecuteTimeLoopN called @3.0 in simulate method.
	 * In variables: Ajr, Ar, C, E_n, F, Mt, V, X_EDGE_ELEMS, X_EDGE_LENGTH, X_n, Y_EDGE_ELEMS, Y_EDGE_LENGTH, b, bt, c, deltat_n, deltat_nplus1, deltatj, e, gamma, l, m, option_deltat_cfl, p, rho, t_n, uj_n, ur
	 * Out variables: Ajr, Ar, C, E_nplus1, F, Mt, V, X_nplus1, b, bt, c, deltat_nplus1, deltatj, e, l, p, rho, t_nplus1, uj_nplus1, ur
	 */
	private void executeTimeLoopN()
	{
		n = 0;
		boolean continueLoop = true;
		do
		{
			n++;
			System.out.printf("[%5d] t: %5.5f - deltat: %5.5f\n", n, t_n, deltat_n);
			dumpVariables(n);
			computeCjr(); // @1.0
			computeInternalEnergy(); // @1.0
			computeLjr(); // @2.0
			computeV(); // @2.0
			computeDensity(); // @3.0
			computeEOSp(); // @4.0
			computeEOSc(); // @5.0
			computeAjr(); // @6.0
			computedeltatj(); // @6.0
			computeAr(); // @7.0
			computeBr(); // @7.0
			computeDt(); // @7.0
			computeBoundaryConditions(); // @8.0
			computeBt(); // @8.0
			computeMt(); // @8.0
			computeTn(); // @8.0
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
				double tmp_t_n = t_n;
				t_n = t_nplus1;
				t_nplus1 = tmp_t_n;
				double tmp_deltat_n = deltat_n;
				deltat_n = deltat_nplus1;
				deltat_nplus1 = tmp_deltat_n;
				double[][] tmp_X_n = X_n;
				X_n = X_nplus1;
				X_nplus1 = tmp_X_n;
				double[] tmp_E_n = E_n;
				E_n = E_nplus1;
				E_nplus1 = tmp_E_n;
				double[][] tmp_uj_n = uj_n;
				uj_n = uj_nplus1;
				uj_nplus1 = tmp_uj_n;
			} 
		} while (continueLoop);
	}

	/**
	 * Job ComputeEOSp called @4.0 in executeTimeLoopN method.
	 * In variables: e, gamma, rho
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
	 * Job ComputeEOSc called @5.0 in executeTimeLoopN method.
	 * In variables: gamma, p, rho
	 * Out variables: c
	 */
	private void computeEOSc()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			c[jCells] = Math.sqrt(options.gamma * p[jCells] / rho[jCells]);
		});
	}

	/**
	 * Job ComputeAjr called @6.0 in executeTimeLoopN method.
	 * In variables: C, c, l, rho
	 * Out variables: Ajr
	 */
	private void computeAjr()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			final int jId = jCells;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					Ajr[jCells][rNodesOfCellJ] = ArrayOperations.multiply(((rho[jCells] * c[jCells]) / l[jCells][rNodesOfCellJ]), tensProduct(C[jCells][rNodesOfCellJ], C[jCells][rNodesOfCellJ]));
				}
			}
		});
	}

	/**
	 * Job Computedeltatj called @6.0 in executeTimeLoopN method.
	 * In variables: V, c, l
	 * Out variables: deltatj
	 */
	private void computedeltatj()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			final int jId = jCells;
			double reduction2 = 0.0;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					reduction2 = sumR0(reduction2, l[jCells][rNodesOfCellJ]);
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
			final int rId = rNodes;
			double[][] reduction3 = new double[][] {{0.0, 0.0}, {0.0, 0.0}};
			{
				final int[] cellsOfNodeR = mesh.getCellsOfNode(rId);
				final int nbCellsOfNodeR = cellsOfNodeR.length;
				for (int jCellsOfNodeR=0; jCellsOfNodeR<nbCellsOfNodeR; jCellsOfNodeR++)
				{
					final int jId = cellsOfNodeR[jCellsOfNodeR];
					final int jCells = jId;
					final int rNodesOfCellJ = Utils.indexOf(mesh.getNodesOfCell(jId), rId);
					reduction3 = sumR2(reduction3, Ajr[jCells][rNodesOfCellJ]);
				}
			}
			Ar[rNodes] = reduction3;
		});
	}

	/**
	 * Job ComputeBr called @7.0 in executeTimeLoopN method.
	 * In variables: Ajr, C, p, uj_n
	 * Out variables: b
	 */
	private void computeBr()
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			final int rId = rNodes;
			double[] reduction4 = new double[] {0.0, 0.0};
			{
				final int[] cellsOfNodeR = mesh.getCellsOfNode(rId);
				final int nbCellsOfNodeR = cellsOfNodeR.length;
				for (int jCellsOfNodeR=0; jCellsOfNodeR<nbCellsOfNodeR; jCellsOfNodeR++)
				{
					final int jId = cellsOfNodeR[jCellsOfNodeR];
					final int jCells = jId;
					final int rNodesOfCellJ = Utils.indexOf(mesh.getNodesOfCell(jId), rId);
					reduction4 = sumR1(reduction4, ArrayOperations.plus(ArrayOperations.multiply(p[jCells], C[jCells][rNodesOfCellJ]), matVectProduct(Ajr[jCells][rNodesOfCellJ], uj_n[jCells])));
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
		double reduction8 = Double.MAX_VALUE;
		reduction8 = IntStream.range(0, nbCells).boxed().parallel().reduce
		(
			Double.MAX_VALUE,
			(accu, jCells) ->
			{
				return minR0(accu, deltatj[jCells]);
			},
			(r1, r2) -> minR0(r1, r2)
		);
		deltat_nplus1 = options.option_deltat_cfl * reduction8;
	}

	/**
	 * Job ComputeBoundaryConditions called @8.0 in executeTimeLoopN method.
	 * In variables: Ar, X_EDGE_ELEMS, X_EDGE_LENGTH, X_n, Y_EDGE_ELEMS, Y_EDGE_LENGTH, b
	 * Out variables: Mt, bt
	 */
	private void computeBoundaryConditions()
	{
		{
			final int[] outerFaces = mesh.getOuterFaces();
			final int nbOuterFaces = outerFaces.length;
			IntStream.range(0, nbOuterFaces).parallel().forEach(fOuterFaces -> 
			{
				final int fId = outerFaces[fOuterFaces];
				final double epsilon = 1.0E-10;
				final double[][] I = new double[][] {new double[] {1.0, 0.0}, new double[] {0.0, 1.0}};
				final double X_MIN = 0.0;
				final double X_MAX = options.X_EDGE_ELEMS * options.X_EDGE_LENGTH;
				final double Y_MIN = 0.0;
				final double Y_MAX = options.Y_EDGE_ELEMS * options.Y_EDGE_LENGTH;
				final double[] nY = new double[] {0.0, 1.0};
				{
					final int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
					final int nbNodesOfFaceF = nodesOfFaceF.length;
					for (int rNodesOfFaceF=0; rNodesOfFaceF<nbNodesOfFaceF; rNodesOfFaceF++)
					{
						final int rId = nodesOfFaceF[rNodesOfFaceF];
						final int rNodes = rId;
						if ((X_n[rNodes][1] - Y_MIN < epsilon) || (X_n[rNodes][1] - Y_MAX < epsilon))
						{
							double sign = 0.0;
							if (X_n[rNodes][1] - Y_MIN < epsilon)
								sign = -1.0;
							else
								sign = 1.0;
							final double[] N = ArrayOperations.multiply(sign, nY);
							final double[][] NxN = tensProduct(N, N);
							final double[][] IcP = ArrayOperations.minus(I, NxN);
							bt[rNodes] = matVectProduct(IcP, b[rNodes]);
							Mt[rNodes] = ArrayOperations.plus(ArrayOperations.multiply(IcP, (ArrayOperations.multiply(Ar[rNodes], IcP))), ArrayOperations.multiply(NxN, trace(Ar[rNodes])));
						}
						if ((Math.abs(X_n[rNodes][0] - X_MIN) < epsilon) || ((Math.abs(X_n[rNodes][0] - X_MAX) < epsilon)))
						{
							Mt[rNodes] = I;
							bt[rNodes] = new double[] {0.0, 0.0};
						}
					}
				}
			});
		}
	}

	/**
	 * Job ComputeBt called @8.0 in executeTimeLoopN method.
	 * In variables: b
	 * Out variables: bt
	 */
	private void computeBt()
	{
		{
			final int[] innerNodes = mesh.getInnerNodes();
			final int nbInnerNodes = innerNodes.length;
			IntStream.range(0, nbInnerNodes).parallel().forEach(rInnerNodes -> 
			{
				final int rId = innerNodes[rInnerNodes];
				final int rNodes = rId;
				bt[rNodes] = b[rNodes];
			});
		}
	}

	/**
	 * Job ComputeMt called @8.0 in executeTimeLoopN method.
	 * In variables: Ar
	 * Out variables: Mt
	 */
	private void computeMt()
	{
		{
			final int[] innerNodes = mesh.getInnerNodes();
			final int nbInnerNodes = innerNodes.length;
			IntStream.range(0, nbInnerNodes).parallel().forEach(rInnerNodes -> 
			{
				final int rId = innerNodes[rInnerNodes];
				final int rNodes = rId;
				Mt[rNodes] = Ar[rNodes];
			});
		}
	}

	/**
	 * Job ComputeTn called @8.0 in executeTimeLoopN method.
	 * In variables: deltat_nplus1, t_n
	 * Out variables: t_nplus1
	 */
	private void computeTn()
	{
		t_nplus1 = t_n + deltat_nplus1;
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
			ur[rNodes] = matVectProduct(inverse(Mt[rNodes]), bt[rNodes]);
		});
	}

	/**
	 * Job ComputeFjr called @10.0 in executeTimeLoopN method.
	 * In variables: Ajr, C, p, uj_n, ur
	 * Out variables: F
	 */
	private void computeFjr()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			final int jId = jCells;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rNodes = rId;
					F[jCells][rNodesOfCellJ] = ArrayOperations.plus(ArrayOperations.multiply(p[jCells], C[jCells][rNodesOfCellJ]), matVectProduct(Ajr[jCells][rNodesOfCellJ], (ArrayOperations.minus(uj_n[jCells], ur[rNodes]))));
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
	 * In variables: E_n, F, deltat_n, m, ur
	 * Out variables: E_nplus1
	 */
	private void computeEn()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			final int jId = jCells;
			double reduction7 = 0.0;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rNodes = rId;
					reduction7 = sumR0(reduction7, dot(F[jCells][rNodesOfCellJ], ur[rNodes]));
				}
			}
			E_nplus1[jCells] = E_n[jCells] - (deltat_n / m[jCells]) * reduction7;
		});
	}

	/**
	 * Job ComputeUn called @11.0 in executeTimeLoopN method.
	 * In variables: F, deltat_n, m, uj_n
	 * Out variables: uj_nplus1
	 */
	private void computeUn()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			final int jId = jCells;
			double[] reduction6 = new double[] {0.0, 0.0};
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					reduction6 = sumR1(reduction6, F[jCells][rNodesOfCellJ]);
				}
			}
			uj_nplus1[jCells] = ArrayOperations.minus(uj_n[jCells], ArrayOperations.multiply((deltat_n / m[jCells]), reduction6));
		});
	}

	private double det(double[][] a)
	{
		return a[0][0] * a[1][1] - a[0][1] * a[1][0];
	}

	private double[] perp(double[] a)
	{
		return new double[] {a[1], -a[0]};
	}

	private double dot(double[] a, double[] b)
	{
		final int x = a.length;
		double result = 0.0;
		for (int i=0; i<x; i++)
		{
			result = result + a[i] * b[i];
		}
		return result;
	}

	private double norm(double[] a)
	{
		final int x = a.length;
		return Math.sqrt(dot(a, a));
	}

	private double[][] tensProduct(double[] a, double[] b)
	{
		final int l = a.length;
		double[][] result = new double[l][l];
		for (int ia=0; ia<l; ia++)
		{
			for (int ib=0; ib<l; ib++)
			{
				result[ia][ib] = a[ia] * b[ib];
			}
		}
		return result;
	}

	private double[] matVectProduct(double[][] a, double[] b)
	{
		final int x = a.length;
		final int y = a[0].length;
		double[] result = new double[x];
		for (int ix=0; ix<x; ix++)
		{
			double[] tmp = new double[y];
			for (int iy=0; iy<y; iy++)
			{
				tmp[iy] = a[ix][iy];
			}
			result[ix] = dot(tmp, b);
		}
		return result;
	}

	private double trace(double[][] a)
	{
		final int l = a.length;
		double result = 0.0;
		for (int ia=0; ia<l; ia++)
		{
			result = result + a[ia][ia];
		}
		return result;
	}

	private double[][] inverse(double[][] a)
	{
		final double alpha = 1.0 / det(a);
		return new double[][] {new double[] {a[1][1] * alpha, -a[0][1] * alpha}, new double[] {-a[1][0] * alpha, a[0][0] * alpha}};
	}

	private double[] sumR1(double[] a, double[] b)
	{
		final int x = a.length;
		return ArrayOperations.plus(a, b);
	}

	private double sumR0(double a, double b)
	{
		return a + b;
	}

	private double[][] sumR2(double[][] a, double[][] b)
	{
		final int x = a.length;
		return ArrayOperations.plus(a, b);
	}

	private double minR0(double a, double b)
	{
		return Math.min(a, b);
	}

	private void dumpVariables(int iteration)
	{
		if (n >= lastDump + 1.0)
		{
			HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
			HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
			cellVariables.put("Density", rho);
			writer.writeFile(iteration, t_n, X_n, mesh.getGeometry().getQuads(), cellVariables, nodeVariables);
			lastDump = n;
		}
	}
};
