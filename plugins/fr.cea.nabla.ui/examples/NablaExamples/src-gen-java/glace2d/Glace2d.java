/*** GENERATED FILE - DO NOT OVERWRITE ***/

package glace2d;

import static org.iq80.leveldb.impl.Iq80DBFactory.bytes;
import static org.iq80.leveldb.impl.Iq80DBFactory.factory;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.stream.IntStream;

import org.iq80.leveldb.DB;
import org.iq80.leveldb.WriteBatch;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import fr.cea.nabla.javalib.*;
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
		public String nonRegression;

		public void jsonInit(final String jsonContent)
		{
			final JsonParser parser = new JsonParser();
			final JsonElement json = parser.parse(jsonContent);
			assert(json.isJsonObject());
			final JsonObject o = json.getAsJsonObject();
			// outputPath
			assert(o.has("outputPath"));
			final JsonElement valueof_outputPath = o.get("outputPath");
			outputPath = valueof_outputPath.getAsJsonPrimitive().getAsString();
			// outputPeriod
			assert(o.has("outputPeriod"));
			final JsonElement valueof_outputPeriod = o.get("outputPeriod");
			assert(valueof_outputPeriod.isJsonPrimitive());
			outputPeriod = valueof_outputPeriod.getAsJsonPrimitive().getAsInt();
			// stopTime
			if (o.has("stopTime"))
			{
				final JsonElement valueof_stopTime = o.get("stopTime");
				assert(valueof_stopTime.isJsonPrimitive());
				stopTime = valueof_stopTime.getAsJsonPrimitive().getAsDouble();
			}
			else
				stopTime = 0.2;
			// maxIterations
			if (o.has("maxIterations"))
			{
				final JsonElement valueof_maxIterations = o.get("maxIterations");
				assert(valueof_maxIterations.isJsonPrimitive());
				maxIterations = valueof_maxIterations.getAsJsonPrimitive().getAsInt();
			}
			else
				maxIterations = 20000;
			// gamma
			if (o.has("gamma"))
			{
				final JsonElement valueof_gamma = o.get("gamma");
				assert(valueof_gamma.isJsonPrimitive());
				gamma = valueof_gamma.getAsJsonPrimitive().getAsDouble();
			}
			else
				gamma = 1.4;
			// xInterface
			if (o.has("xInterface"))
			{
				final JsonElement valueof_xInterface = o.get("xInterface");
				assert(valueof_xInterface.isJsonPrimitive());
				xInterface = valueof_xInterface.getAsJsonPrimitive().getAsDouble();
			}
			else
				xInterface = 0.5;
			// deltatIni
			if (o.has("deltatIni"))
			{
				final JsonElement valueof_deltatIni = o.get("deltatIni");
				assert(valueof_deltatIni.isJsonPrimitive());
				deltatIni = valueof_deltatIni.getAsJsonPrimitive().getAsDouble();
			}
			else
				deltatIni = 1.0E-5;
			// deltatCfl
			if (o.has("deltatCfl"))
			{
				final JsonElement valueof_deltatCfl = o.get("deltatCfl");
				assert(valueof_deltatCfl.isJsonPrimitive());
				deltatCfl = valueof_deltatCfl.getAsJsonPrimitive().getAsDouble();
			}
			else
				deltatCfl = 0.4;
			// rhoIniZg
			if (o.has("rhoIniZg"))
			{
				final JsonElement valueof_rhoIniZg = o.get("rhoIniZg");
				assert(valueof_rhoIniZg.isJsonPrimitive());
				rhoIniZg = valueof_rhoIniZg.getAsJsonPrimitive().getAsDouble();
			}
			else
				rhoIniZg = 1.0;
			// rhoIniZd
			if (o.has("rhoIniZd"))
			{
				final JsonElement valueof_rhoIniZd = o.get("rhoIniZd");
				assert(valueof_rhoIniZd.isJsonPrimitive());
				rhoIniZd = valueof_rhoIniZd.getAsJsonPrimitive().getAsDouble();
			}
			else
				rhoIniZd = 0.125;
			// pIniZg
			if (o.has("pIniZg"))
			{
				final JsonElement valueof_pIniZg = o.get("pIniZg");
				assert(valueof_pIniZg.isJsonPrimitive());
				pIniZg = valueof_pIniZg.getAsJsonPrimitive().getAsDouble();
			}
			else
				pIniZg = 1.0;
			// pIniZd
			if (o.has("pIniZd"))
			{
				final JsonElement valueof_pIniZd = o.get("pIniZd");
				assert(valueof_pIniZd.isJsonPrimitive());
				pIniZd = valueof_pIniZd.getAsJsonPrimitive().getAsDouble();
			}
			else
				pIniZd = 0.1;
			// Non regression
			if (o.has("nonRegression"))
			{
				final JsonElement valueof_nonRegression = o.get("nonRegression");
				nonRegression = valueof_nonRegression.getAsJsonPrimitive().getAsString();
			}
		}
	}

	// Mesh and mesh variables
	private final CartesianMesh2D mesh;
	private final int nbNodes, nbCells, nbInnerNodes, nbTopNodes, nbBottomNodes, nbLeftNodes, nbRightNodes, nbNodesOfCell, nbCellsOfNode;

	// User options
	private final Options options;
	private final FileWriter writer;

	// Global variables
	protected int lastDump;
	protected int n;
	protected double t_n;
	protected double t_nplus1;
	protected double t_n0;
	protected double deltat_n;
	protected double deltat_nplus1;
	protected double deltat_n0;
	protected double[][] X_n;
	protected double[][] X_nplus1;
	protected double[][] X_n0;
	protected double[][] b;
	protected double[][] bt;
	protected double[][][] Ar;
	protected double[][][] Mt;
	protected double[][] ur;
	protected double[] c;
	protected double[] m;
	protected double[] p;
	protected double[] rho;
	protected double[] e;
	protected double[] E_n;
	protected double[] E_nplus1;
	protected double[] V;
	protected double[] deltatj;
	protected double[][] uj_n;
	protected double[][] uj_nplus1;
	protected double[][] l;
	protected double[][][] Cjr_ic;
	protected double[][][] C;
	protected double[][][] F;
	protected double[][][][] Ajr;

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

		// User options
		options = aOptions;
		writer = new PvdFileWriter2D("Glace2d", options.outputPath);

		// Initialize variables with default values
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

	/**
	 * Job computeCjr called @1.0 in executeTimeLoopN method.
	 * In variables: X_n
	 * Out variables: C
	 */
	protected void computeCjr()
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
	 * Job computeInternalEnergy called @1.0 in executeTimeLoopN method.
	 * In variables: E_n, uj_n
	 * Out variables: e
	 */
	protected void computeInternalEnergy()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			e[jCells] = E_n[jCells] - 0.5 * dot(uj_n[jCells], uj_n[jCells]);
		});
	}

	/**
	 * Job iniCjrIc called @1.0 in simulate method.
	 * In variables: X_n0
	 * Out variables: Cjr_ic
	 */
	protected void iniCjrIc()
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
	 * Job iniTime called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: t_n0
	 */
	protected void iniTime()
	{
		t_n0 = 0.0;
	}

	/**
	 * Job iniTimeStep called @1.0 in simulate method.
	 * In variables: deltatIni
	 * Out variables: deltat_n0
	 */
	protected void iniTimeStep()
	{
		deltat_n0 = options.deltatIni;
	}

	/**
	 * Job computeLjr called @2.0 in executeTimeLoopN method.
	 * In variables: C
	 * Out variables: l
	 */
	protected void computeLjr()
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
	 * Job computeV called @2.0 in executeTimeLoopN method.
	 * In variables: C, X_n
	 * Out variables: V
	 */
	protected void computeV()
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
	 * Job initialize called @2.0 in simulate method.
	 * In variables: Cjr_ic, X_n0, gamma, pIniZd, pIniZg, rhoIniZd, rhoIniZg, xInterface
	 * Out variables: E_n, m, p, rho, uj_n
	 */
	protected void initialize()
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
	 * Job setUpTimeLoopN called @2.0 in simulate method.
	 * In variables: X_n0, deltat_n0, t_n0
	 * Out variables: X_n, deltat_n, t_n
	 */
	protected void setUpTimeLoopN()
	{
		t_n = t_n0;
		deltat_n = deltat_n0;
		IntStream.range(0, X_n.length).parallel().forEach(i2 -> 
		{
			for (int i1=0 ; i1<X_n[i2].length ; i1++)
				X_n[i2][i1] = X_n0[i2][i1];
		});
	}

	/**
	 * Job computeDensity called @3.0 in executeTimeLoopN method.
	 * In variables: V, m
	 * Out variables: rho
	 */
	protected void computeDensity()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			rho[jCells] = m[jCells] / V[jCells];
		});
	}

	/**
	 * Job executeTimeLoopN called @3.0 in simulate method.
	 * In variables: Ajr, Ar, C, E_n, F, Mt, V, X_n, b, bt, c, deltatCfl, deltat_n, deltat_nplus1, deltatj, e, gamma, l, m, p, rho, t_n, uj_n, ur
	 * Out variables: Ajr, Ar, C, E_nplus1, F, Mt, V, X_nplus1, b, bt, c, deltat_nplus1, deltatj, e, l, p, rho, t_nplus1, uj_nplus1, ur
	 */
	protected void executeTimeLoopN()
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
	 * Job computeEOSp called @4.0 in executeTimeLoopN method.
	 * In variables: e, gamma, rho
	 * Out variables: p
	 */
	protected void computeEOSp()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			p[jCells] = (options.gamma - 1.0) * rho[jCells] * e[jCells];
		});
	}

	/**
	 * Job computeEOSc called @5.0 in executeTimeLoopN method.
	 * In variables: gamma, p, rho
	 * Out variables: c
	 */
	protected void computeEOSc()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			c[jCells] = Math.sqrt(options.gamma * p[jCells] / rho[jCells]);
		});
	}

	/**
	 * Job computeAjr called @6.0 in executeTimeLoopN method.
	 * In variables: C, c, l, rho
	 * Out variables: Ajr
	 */
	protected void computeAjr()
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
	 * Job computedeltatj called @6.0 in executeTimeLoopN method.
	 * In variables: V, c, l
	 * Out variables: deltatj
	 */
	protected void computedeltatj()
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
	 * Job computeAr called @7.0 in executeTimeLoopN method.
	 * In variables: Ajr
	 * Out variables: Ar
	 */
	protected void computeAr()
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
	 * Job computeBr called @7.0 in executeTimeLoopN method.
	 * In variables: Ajr, C, p, uj_n
	 * Out variables: b
	 */
	protected void computeBr()
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
	 * Job computeDt called @7.0 in executeTimeLoopN method.
	 * In variables: deltatCfl, deltatj
	 * Out variables: deltat_nplus1
	 */
	protected void computeDt()
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
	 * Job computeBoundaryConditions called @8.0 in executeTimeLoopN method.
	 * In variables: Ar, b
	 * Out variables: Mt, bt
	 */
	protected void computeBoundaryConditions()
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
	 * Job computeBt called @8.0 in executeTimeLoopN method.
	 * In variables: b
	 * Out variables: bt
	 */
	protected void computeBt()
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
	 * Job computeMt called @8.0 in executeTimeLoopN method.
	 * In variables: Ar
	 * Out variables: Mt
	 */
	protected void computeMt()
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
	 * Job computeTn called @8.0 in executeTimeLoopN method.
	 * In variables: deltat_nplus1, t_n
	 * Out variables: t_nplus1
	 */
	protected void computeTn()
	{
		t_nplus1 = t_n + deltat_nplus1;
	}

	/**
	 * Job computeU called @9.0 in executeTimeLoopN method.
	 * In variables: Mt, bt
	 * Out variables: ur
	 */
	protected void computeU()
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			ur[rNodes] = matVectProduct(inverse(Mt[rNodes]), bt[rNodes]);
		});
	}

	/**
	 * Job computeFjr called @10.0 in executeTimeLoopN method.
	 * In variables: Ajr, C, p, uj_n, ur
	 * Out variables: F
	 */
	protected void computeFjr()
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
	 * Job computeXn called @10.0 in executeTimeLoopN method.
	 * In variables: X_n, deltat_n, ur
	 * Out variables: X_nplus1
	 */
	protected void computeXn()
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			X_nplus1[rNodes] = ArrayOperations.plus(X_n[rNodes], ArrayOperations.multiply(deltat_n, ur[rNodes]));
		});
	}

	/**
	 * Job computeEn called @11.0 in executeTimeLoopN method.
	 * In variables: E_n, F, deltat_n, m, ur
	 * Out variables: E_nplus1
	 */
	protected void computeEn()
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
	 * Job computeUn called @11.0 in executeTimeLoopN method.
	 * In variables: F, deltat_n, m, uj_n
	 * Out variables: uj_nplus1
	 */
	protected void computeUn()
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

	public void simulate()
	{
		System.out.println("Start execution of glace2d");
		iniCjrIc(); // @1.0
		iniTime(); // @1.0
		iniTimeStep(); // @1.0
		initialize(); // @2.0
		setUpTimeLoopN(); // @2.0
		executeTimeLoopN(); // @3.0
		System.out.println("End of execution of glace2d");
	}

	public static void main(String[] args) throws IOException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			JsonParser parser = new JsonParser();
			JsonObject o = parser.parse(new FileReader(dataFileName)).getAsJsonObject();
			int ret = 0;

			// Mesh instanciation
			assert(o.has("mesh"));
			CartesianMesh2DFactory meshFactory = new CartesianMesh2DFactory();
			meshFactory.jsonInit(o.get("mesh").toString());
			CartesianMesh2D mesh = meshFactory.create();

			// Module instanciation(s)
			Glace2d.Options glace2dOptions = new Glace2d.Options();
			if (o.has("glace2d")) glace2dOptions.jsonInit(o.get("glace2d").toString());
			Glace2d glace2d = new Glace2d(mesh, glace2dOptions);

			// Start simulation
			glace2d.simulate();

			// Non regression testing
			if (glace2dOptions.nonRegression != null && glace2dOptions.nonRegression.equals("CreateReference"))
				glace2d.createDB("Glace2dDB.ref");
			if (glace2dOptions.nonRegression != null && glace2dOptions.nonRegression.equals("CompareToReference"))
			{
				glace2d.createDB("Glace2dDB.current");
				if (!LevelDBUtils.compareDB("Glace2dDB.current", "Glace2dDB.ref"))
					ret = 1;
				LevelDBUtils.destroyDB("Glace2dDB.current");
				System.exit(ret);
			}
		}
		else
		{
			System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.err.println("        Expecting user data file name, for example Glace2d.json");
			System.exit(1);
		}
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

	private void createDB(String db_name) throws IOException
	{
		org.iq80.leveldb.Options levelDBOptions = new org.iq80.leveldb.Options();

		// Destroy if exists
		factory.destroy(new File(db_name), levelDBOptions);

		// Create data base
		levelDBOptions.createIfMissing(true);
		DB db = factory.open(new File(db_name), levelDBOptions);

		WriteBatch batch = db.createWriteBatch();
		try
		{
			batch.put(bytes("lastDump"), LevelDBUtils.serialize(lastDump));
			batch.put(bytes("n"), LevelDBUtils.serialize(n));
			batch.put(bytes("t_n"), LevelDBUtils.serialize(t_n));
			batch.put(bytes("t_nplus1"), LevelDBUtils.serialize(t_nplus1));
			batch.put(bytes("t_n0"), LevelDBUtils.serialize(t_n0));
			batch.put(bytes("deltat_n"), LevelDBUtils.serialize(deltat_n));
			batch.put(bytes("deltat_nplus1"), LevelDBUtils.serialize(deltat_nplus1));
			batch.put(bytes("deltat_n0"), LevelDBUtils.serialize(deltat_n0));
			batch.put(bytes("X_n"), LevelDBUtils.serialize(X_n));
			batch.put(bytes("X_nplus1"), LevelDBUtils.serialize(X_nplus1));
			batch.put(bytes("X_n0"), LevelDBUtils.serialize(X_n0));
			batch.put(bytes("b"), LevelDBUtils.serialize(b));
			batch.put(bytes("bt"), LevelDBUtils.serialize(bt));
			batch.put(bytes("Ar"), LevelDBUtils.serialize(Ar));
			batch.put(bytes("Mt"), LevelDBUtils.serialize(Mt));
			batch.put(bytes("ur"), LevelDBUtils.serialize(ur));
			batch.put(bytes("c"), LevelDBUtils.serialize(c));
			batch.put(bytes("m"), LevelDBUtils.serialize(m));
			batch.put(bytes("p"), LevelDBUtils.serialize(p));
			batch.put(bytes("rho"), LevelDBUtils.serialize(rho));
			batch.put(bytes("e"), LevelDBUtils.serialize(e));
			batch.put(bytes("E_n"), LevelDBUtils.serialize(E_n));
			batch.put(bytes("E_nplus1"), LevelDBUtils.serialize(E_nplus1));
			batch.put(bytes("V"), LevelDBUtils.serialize(V));
			batch.put(bytes("deltatj"), LevelDBUtils.serialize(deltatj));
			batch.put(bytes("uj_n"), LevelDBUtils.serialize(uj_n));
			batch.put(bytes("uj_nplus1"), LevelDBUtils.serialize(uj_nplus1));
			batch.put(bytes("l"), LevelDBUtils.serialize(l));
			batch.put(bytes("Cjr_ic"), LevelDBUtils.serialize(Cjr_ic));
			batch.put(bytes("C"), LevelDBUtils.serialize(C));
			batch.put(bytes("F"), LevelDBUtils.serialize(F));
			batch.put(bytes("Ajr"), LevelDBUtils.serialize(Ajr));

			db.write(batch);
		}
		finally
		{
			// Make sure you close the batch to avoid resource leaks.
			batch.close();
		}
		db.close();
		System.out.println("Reference database " + db_name + " created.");
	}
};
