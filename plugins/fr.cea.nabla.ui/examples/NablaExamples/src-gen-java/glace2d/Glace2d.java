package glace2d;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.HashMap;
import java.util.stream.IntStream;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.stream.JsonReader;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class Glace2d
{
	public final static class Options
	{
		public String outputPath;
		public int outputPeriod;
		public double stopTime;
		public int maxIterations;
		public double gamma;
		public double xInterface;
		public double deltatIni;
		public double deltatCfl;
		public double rhoIniZg;
		public double rhoIniZd;
		public double pIniZg;
		public double pIniZd;
	}

	// Mesh and mesh variables
	private final CartesianMesh2D mesh;
	private final int nbNodes, nbCells, nbInnerNodes, nbTopNodes, nbBottomNodes, nbLeftNodes, nbRightNodes, nbNodesOfCell, nbCellsOfNode;

	// User options and external classes
	private final Options options;
	private final FileWriter writer;

	// Global definitions
	private double t_n;
	private double t_nplus1;
	private double deltat_n;
	private double deltat_nplus1;
	private int lastDump;

	// Global declarations
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

	public Glace2d(CartesianMesh2D aMesh, Options aOptions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbInnerNodes = mesh.getNbInnerNodes();
		nbTopNodes = mesh.getNbTopNodes();
		nbBottomNodes = mesh.getNbBottomNodes();
		nbLeftNodes = mesh.getNbLeftNodes();
		nbRightNodes = mesh.getNbRightNodes();
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;
		nbCellsOfNode = CartesianMesh2D.MaxNbCellsOfNode;

		// User options and external classes initialization
		options = aOptions;
		writer = new PvdFileWriter2D("Glace2d", options.outputPath);

		// Initialize variables with default values
		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat_n = options.deltatIni;
		deltat_nplus1 = options.deltatIni;
		lastDump = Integer.MIN_VALUE;

		// Allocate arrays
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
			JsonParser parser = new JsonParser();
			JsonObject o = parser.parse(new FileReader(dataFileName)).getAsJsonObject();
			Gson gson = new Gson();

			assert(o.has("mesh"));
			CartesianMesh2DFactory meshFactory = gson.fromJson(o.get("mesh"), CartesianMesh2DFactory.class);
			CartesianMesh2D mesh = meshFactory.create();
			assert(o.has("options"));
			Glace2d.Options options = gson.fromJson(o.get("options"), Glace2d.Options.class);

			Glace2d simulator = new Glace2d(mesh, options);
			simulator.simulate();
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
			double reduction0 = 0.0;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rNodes = rId;
					reduction0 = sumR0(reduction0, dot(C[jCells][rNodesOfCellJ], X_n[rNodes]));
				}
			}
			V[jCells] = 0.5 * reduction0;
		});
	}

	/**
	 * Job Initialize called @2.0 in simulate method.
	 * In variables: Cjr_ic, X_n0, gamma, pIniZd, pIniZg, rhoIniZd, rhoIniZg, xInterface
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
			if (center[0] < options.xInterface)
			{
				rho_ic = options.rhoIniZg;
				p_ic = options.pIniZg;
			}
			else
			{
				rho_ic = options.rhoIniZd;
				p_ic = options.pIniZd;
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
	 * In variables: Ajr, Ar, C, E_n, F, Mt, V, X_n, b, bt, c, deltatCfl, deltat_n, deltat_nplus1, deltatj, e, gamma, l, m, p, rho, t_n, uj_n, ur
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
			if (n >= lastDump + options.outputPeriod)
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
			continueLoop = (t_nplus1 < options.stopTime && n + 1 < options.maxIterations);
		
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
		// force a last output at the end
		dumpVariables(n);
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
			double reduction0 = 0.0;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					reduction0 = sumR0(reduction0, l[jCells][rNodesOfCellJ]);
				}
			}
			deltatj[jCells] = 2.0 * V[jCells] / (c[jCells] * reduction0);
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
			double[][] reduction0 = new double[][] {{0.0, 0.0}, {0.0, 0.0}};
			{
				final int[] cellsOfNodeR = mesh.getCellsOfNode(rId);
				final int nbCellsOfNodeR = cellsOfNodeR.length;
				for (int jCellsOfNodeR=0; jCellsOfNodeR<nbCellsOfNodeR; jCellsOfNodeR++)
				{
					final int jId = cellsOfNodeR[jCellsOfNodeR];
					final int jCells = jId;
					final int rNodesOfCellJ = Utils.indexOf(mesh.getNodesOfCell(jId), rId);
					reduction0 = sumR2(reduction0, Ajr[jCells][rNodesOfCellJ]);
				}
			}
			Ar[rNodes] = reduction0;
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
			double[] reduction0 = new double[] {0.0, 0.0};
			{
				final int[] cellsOfNodeR = mesh.getCellsOfNode(rId);
				final int nbCellsOfNodeR = cellsOfNodeR.length;
				for (int jCellsOfNodeR=0; jCellsOfNodeR<nbCellsOfNodeR; jCellsOfNodeR++)
				{
					final int jId = cellsOfNodeR[jCellsOfNodeR];
					final int jCells = jId;
					final int rNodesOfCellJ = Utils.indexOf(mesh.getNodesOfCell(jId), rId);
					reduction0 = sumR1(reduction0, ArrayOperations.plus(ArrayOperations.multiply(p[jCells], C[jCells][rNodesOfCellJ]), matVectProduct(Ajr[jCells][rNodesOfCellJ], uj_n[jCells])));
				}
			}
			b[rNodes] = reduction0;
		});
	}

	/**
	 * Job ComputeDt called @7.0 in executeTimeLoopN method.
	 * In variables: deltatCfl, deltatj
	 * Out variables: deltat_nplus1
	 */
	private void computeDt()
	{
		double reduction0 = Double.MAX_VALUE;
		reduction0 = IntStream.range(0, nbCells).boxed().parallel().reduce
		(
			Double.MAX_VALUE,
			(accu, jCells) ->
			{
				return minR0(accu, deltatj[jCells]);
			},
			(r1, r2) -> minR0(r1, r2)
		);
		deltat_nplus1 = options.deltatCfl * reduction0;
	}

	/**
	 * Job ComputeBoundaryConditions called @8.0 in executeTimeLoopN method.
	 * In variables: Ar, b
	 * Out variables: Mt, bt
	 */
	private void computeBoundaryConditions()
	{
		final double[][] I = new double[][] {new double[] {1.0, 0.0}, new double[] {0.0, 1.0}};
		{
			final int[] topNodes = mesh.getTopNodes();
			final int nbTopNodes = topNodes.length;
			IntStream.range(0, nbTopNodes).parallel().forEach(rTopNodes -> 
			{
				final int rId = topNodes[rTopNodes];
				final int rNodes = rId;
				final double[] N = new double[] {0.0, 1.0};
				final double[][] NxN = tensProduct(N, N);
				final double[][] IcP = ArrayOperations.minus(I, NxN);
				bt[rNodes] = matVectProduct(IcP, b[rNodes]);
				Mt[rNodes] = ArrayOperations.plus(ArrayOperations.multiply(IcP, (ArrayOperations.multiply(Ar[rNodes], IcP))), ArrayOperations.multiply(NxN, trace(Ar[rNodes])));
			});
		}
		{
			final int[] bottomNodes = mesh.getBottomNodes();
			final int nbBottomNodes = bottomNodes.length;
			IntStream.range(0, nbBottomNodes).parallel().forEach(rBottomNodes -> 
			{
				final int rId = bottomNodes[rBottomNodes];
				final int rNodes = rId;
				final double[] N = new double[] {0.0, -1.0};
				final double[][] NxN = tensProduct(N, N);
				final double[][] IcP = ArrayOperations.minus(I, NxN);
				bt[rNodes] = matVectProduct(IcP, b[rNodes]);
				Mt[rNodes] = ArrayOperations.plus(ArrayOperations.multiply(IcP, (ArrayOperations.multiply(Ar[rNodes], IcP))), ArrayOperations.multiply(NxN, trace(Ar[rNodes])));
			});
		}
		{
			final int[] leftNodes = mesh.getLeftNodes();
			final int nbLeftNodes = leftNodes.length;
			IntStream.range(0, nbLeftNodes).parallel().forEach(rLeftNodes -> 
			{
				final int rId = leftNodes[rLeftNodes];
				final int rNodes = rId;
				Mt[rNodes] = I;
				bt[rNodes] = new double[] {0.0, 0.0};
			});
		}
		{
			final int[] rightNodes = mesh.getRightNodes();
			final int nbRightNodes = rightNodes.length;
			IntStream.range(0, nbRightNodes).parallel().forEach(rRightNodes -> 
			{
				final int rId = rightNodes[rRightNodes];
				final int rNodes = rId;
				Mt[rNodes] = I;
				bt[rNodes] = new double[] {0.0, 0.0};
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
			double reduction0 = 0.0;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rNodes = rId;
					reduction0 = sumR0(reduction0, dot(F[jCells][rNodesOfCellJ], ur[rNodes]));
				}
			}
			E_nplus1[jCells] = E_n[jCells] - (deltat_n / m[jCells]) * reduction0;
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
			double[] reduction0 = new double[] {0.0, 0.0};
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					reduction0 = sumR1(reduction0, F[jCells][rNodesOfCellJ]);
				}
			}
			uj_nplus1[jCells] = ArrayOperations.minus(uj_n[jCells], ArrayOperations.multiply((deltat_n / m[jCells]), reduction0));
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
		if (!writer.isDisabled())
		{
			VtkFileContent content = new VtkFileContent(iteration, t_n, X_n, mesh.getGeometry().getQuads());
			content.addCellVariable("Density", rho);
			writer.writeFile(content);
			lastDump = n;
		}
	}
};
