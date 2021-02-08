/*** GENERATED FILE - DO NOT OVERWRITE ***/

package iterativeheatequation;

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
public final class IterativeHeatEquation
{
	public final static class Options
	{
		public String outputPath;
		public int outputPeriod;
		public double u0;
		public double stopTime;
		public int maxIterations;
		public int maxIterationsK;
		public double epsilon;
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
			// u0
			if (o.has("u0"))
			{
				final JsonElement valueof_u0 = o.get("u0");
				assert(valueof_u0.isJsonPrimitive());
				u0 = valueof_u0.getAsJsonPrimitive().getAsDouble();
			}
			else
				u0 = 1.0;
			// stopTime
			if (o.has("stopTime"))
			{
				final JsonElement valueof_stopTime = o.get("stopTime");
				assert(valueof_stopTime.isJsonPrimitive());
				stopTime = valueof_stopTime.getAsJsonPrimitive().getAsDouble();
			}
			else
				stopTime = 0.1;
			// maxIterations
			if (o.has("maxIterations"))
			{
				final JsonElement valueof_maxIterations = o.get("maxIterations");
				assert(valueof_maxIterations.isJsonPrimitive());
				maxIterations = valueof_maxIterations.getAsJsonPrimitive().getAsInt();
			}
			else
				maxIterations = 500000000;
			// maxIterationsK
			if (o.has("maxIterationsK"))
			{
				final JsonElement valueof_maxIterationsK = o.get("maxIterationsK");
				assert(valueof_maxIterationsK.isJsonPrimitive());
				maxIterationsK = valueof_maxIterationsK.getAsJsonPrimitive().getAsInt();
			}
			else
				maxIterationsK = 1000;
			// epsilon
			if (o.has("epsilon"))
			{
				final JsonElement valueof_epsilon = o.get("epsilon");
				assert(valueof_epsilon.isJsonPrimitive());
				epsilon = valueof_epsilon.getAsJsonPrimitive().getAsDouble();
			}
			else
				epsilon = 1.0E-8;
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
	private final int nbNodes, nbCells, nbFaces, nbNeighbourCells, nbNodesOfFace, nbCellsOfFace, nbNodesOfCell;

	// User options
	private final Options options;
	private final FileWriter writer;

	// Global variables
	protected int lastDump;
	protected int n;
	protected int k;
	protected final double[] vectOne;
	protected double deltat;
	protected double t_n;
	protected double t_nplus1;
	protected double t_n0;
	protected double[][] X;
	protected double[][] Xc;
	protected double[] u_n;
	protected double[] u_nplus1;
	protected double[] u_nplus1_k;
	protected double[] u_nplus1_kplus1;
	protected double[] V;
	protected double[] D;
	protected double[] faceLength;
	protected double[] faceConductivity;
	protected double[][] alpha;
	protected double residual;

	public IterativeHeatEquation(CartesianMesh2D aMesh, Options aOptions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbFaces = mesh.getNbFaces();
		nbNeighbourCells = CartesianMesh2D.MaxNbNeighbourCells;
		nbNodesOfFace = CartesianMesh2D.MaxNbNodesOfFace;
		nbCellsOfFace = CartesianMesh2D.MaxNbCellsOfFace;
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;

		// User options
		options = aOptions;
		writer = new PvdFileWriter2D("IterativeHeatEquation", options.outputPath);

		// Initialize variables with default values
		lastDump = Integer.MIN_VALUE;
		vectOne = new double[] {1.0, 1.0};
		deltat = 0.001;

		// Allocate arrays
		X = new double[nbNodes][2];
		Xc = new double[nbCells][2];
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
		IntStream.range(0, nbNodes).parallel().forEach(rNodes ->
		{
			X[rNodes][0] = gNodes[rNodes][0];
			X[rNodes][1] = gNodes[rNodes][1];
		});
	}

	/**
	 * Job computeFaceLength called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: faceLength
	 */
	protected void computeFaceLength()
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			final int fId = fFaces;
			double reduction0 = 0.0;
			{
				final int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
				final int nbNodesOfFaceF = nodesOfFaceF.length;
				for (int pNodesOfFaceF=0; pNodesOfFaceF<nbNodesOfFaceF; pNodesOfFaceF++)
				{
					final int pId = nodesOfFaceF[pNodesOfFaceF];
					final int pPlus1Id = nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace];
					final int pNodes = pId;
					final int pPlus1Nodes = pPlus1Id;
					reduction0 = sumR0(reduction0, norm(ArrayOperations.minus(X[pNodes], X[pPlus1Nodes])));
				}
			}
			faceLength[fFaces] = 0.5 * reduction0;
		});
	}

	/**
	 * Job computeTn called @1.0 in executeTimeLoopN method.
	 * In variables: deltat, t_n
	 * Out variables: t_nplus1
	 */
	protected void computeTn()
	{
		t_nplus1 = t_n + deltat;
	}

	/**
	 * Job computeV called @1.0 in simulate method.
	 * In variables: X
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
				for (int pNodesOfCellJ=0; pNodesOfCellJ<nbNodesOfCellJ; pNodesOfCellJ++)
				{
					final int pId = nodesOfCellJ[pNodesOfCellJ];
					final int pPlus1Id = nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					final int pNodes = pId;
					final int pPlus1Nodes = pPlus1Id;
					reduction0 = sumR0(reduction0, det(X[pNodes], X[pPlus1Nodes]));
				}
			}
			V[jCells] = 0.5 * reduction0;
		});
	}

	/**
	 * Job initD called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: D
	 */
	protected void initD()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			D[cCells] = 1.0;
		});
	}

	/**
	 * Job initTime called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: t_n0
	 */
	protected void initTime()
	{
		t_n0 = 0.0;
	}

	/**
	 * Job initXc called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: Xc
	 */
	protected void initXc()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			final int cId = cCells;
			double[] reduction0 = new double[] {0.0, 0.0};
			{
				final int[] nodesOfCellC = mesh.getNodesOfCell(cId);
				final int nbNodesOfCellC = nodesOfCellC.length;
				for (int pNodesOfCellC=0; pNodesOfCellC<nbNodesOfCellC; pNodesOfCellC++)
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
	 * Job setUpTimeLoopK called @1.0 in executeTimeLoopN method.
	 * In variables: u_n
	 * Out variables: u_nplus1_k
	 */
	protected void setUpTimeLoopK()
	{
		IntStream.range(0, u_nplus1_k.length).parallel().forEach(i1 -> 
		{
			u_nplus1_k[i1] = u_n[i1];
		});
	}

	/**
	 * Job updateU called @1.0 in executeTimeLoopK method.
	 * In variables: alpha, u_n, u_nplus1_k
	 * Out variables: u_nplus1_kplus1
	 */
	protected void updateU()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			final int cId = cCells;
			double reduction0 = 0.0;
			{
				final int[] neighbourCellsC = mesh.getNeighbourCells(cId);
				final int nbNeighbourCellsC = neighbourCellsC.length;
				for (int dNeighbourCellsC=0; dNeighbourCellsC<nbNeighbourCellsC; dNeighbourCellsC++)
				{
					final int dId = neighbourCellsC[dNeighbourCellsC];
					final int dCells = dId;
					reduction0 = sumR0(reduction0, alpha[cCells][dCells] * u_nplus1_k[dCells]);
				}
			}
			u_nplus1_kplus1[cCells] = u_n[cCells] + alpha[cCells][cCells] * u_nplus1_k[cCells] + reduction0;
		});
	}

	/**
	 * Job computeDeltaTn called @2.0 in simulate method.
	 * In variables: D, V
	 * Out variables: deltat
	 */
	protected void computeDeltaTn()
	{
		double reduction0 = Double.MAX_VALUE;
		reduction0 = IntStream.range(0, nbCells).boxed().parallel().reduce
		(
			Double.MAX_VALUE,
			(accu, cCells) ->
			{
				return minR0(accu, V[cCells] / D[cCells]);
			},
			(r1, r2) -> minR0(r1, r2)
		);
		deltat = reduction0 * 0.1;
	}

	/**
	 * Job computeFaceConductivity called @2.0 in simulate method.
	 * In variables: D
	 * Out variables: faceConductivity
	 */
	protected void computeFaceConductivity()
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			final int fId = fFaces;
			double reduction0 = 1.0;
			{
				final int[] cellsOfFaceF = mesh.getCellsOfFace(fId);
				final int nbCellsOfFaceF = cellsOfFaceF.length;
				for (int c1CellsOfFaceF=0; c1CellsOfFaceF<nbCellsOfFaceF; c1CellsOfFaceF++)
				{
					final int c1Id = cellsOfFaceF[c1CellsOfFaceF];
					final int c1Cells = c1Id;
					reduction0 = prodR0(reduction0, D[c1Cells]);
				}
			}
			double reduction1 = 0.0;
			{
				final int[] cellsOfFaceF = mesh.getCellsOfFace(fId);
				final int nbCellsOfFaceF = cellsOfFaceF.length;
				for (int c2CellsOfFaceF=0; c2CellsOfFaceF<nbCellsOfFaceF; c2CellsOfFaceF++)
				{
					final int c2Id = cellsOfFaceF[c2CellsOfFaceF];
					final int c2Cells = c2Id;
					reduction1 = sumR0(reduction1, D[c2Cells]);
				}
			}
			faceConductivity[fFaces] = 2.0 * reduction0 / reduction1;
		});
	}

	/**
	 * Job computeResidual called @2.0 in executeTimeLoopK method.
	 * In variables: u_nplus1_k, u_nplus1_kplus1
	 * Out variables: residual
	 */
	protected void computeResidual()
	{
		double reduction0 = -Double.MAX_VALUE;
		reduction0 = IntStream.range(0, nbCells).boxed().parallel().reduce
		(
			-Double.MAX_VALUE,
			(accu, jCells) ->
			{
				return maxR0(accu, Math.abs(u_nplus1_kplus1[jCells] - u_nplus1_k[jCells]));
			},
			(r1, r2) -> maxR0(r1, r2)
		);
		residual = reduction0;
	}

	/**
	 * Job executeTimeLoopK called @2.0 in executeTimeLoopN method.
	 * In variables: alpha, u_n, u_nplus1_k, u_nplus1_kplus1
	 * Out variables: residual, u_nplus1_kplus1
	 */
	protected void executeTimeLoopK()
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
			continueLoop = (residual > options.epsilon && check(k + 1 < options.maxIterationsK));
		
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
	 * Job initU called @2.0 in simulate method.
	 * In variables: Xc, u0, vectOne
	 * Out variables: u_n
	 */
	protected void initU()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			if (norm(ArrayOperations.minus(Xc[cCells], vectOne)) < 0.5)
				u_n[cCells] = options.u0;
			else
				u_n[cCells] = 0.0;
		});
	}

	/**
	 * Job setUpTimeLoopN called @2.0 in simulate method.
	 * In variables: t_n0
	 * Out variables: t_n
	 */
	protected void setUpTimeLoopN()
	{
		t_n = t_n0;
	}

	/**
	 * Job computeAlphaCoeff called @3.0 in simulate method.
	 * In variables: V, Xc, deltat, faceConductivity, faceLength
	 * Out variables: alpha
	 */
	protected void computeAlphaCoeff()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			final int cId = cCells;
			double alphaDiag = 0.0;
			{
				final int[] neighbourCellsC = mesh.getNeighbourCells(cId);
				final int nbNeighbourCellsC = neighbourCellsC.length;
				for (int dNeighbourCellsC=0; dNeighbourCellsC<nbNeighbourCellsC; dNeighbourCellsC++)
				{
					final int dId = neighbourCellsC[dNeighbourCellsC];
					final int dCells = dId;
					final int fId = mesh.getCommonFace(cId, dId);
					final int fFaces = fId;
					final double alphaExtraDiag = deltat / V[cCells] * (faceLength[fFaces] * faceConductivity[fFaces]) / norm(ArrayOperations.minus(Xc[cCells], Xc[dCells]));
					alpha[cCells][dCells] = alphaExtraDiag;
					alphaDiag = alphaDiag + alphaExtraDiag;
				}
			}
			alpha[cCells][cCells] = -alphaDiag;
		});
	}

	/**
	 * Job tearDownTimeLoopK called @3.0 in executeTimeLoopN method.
	 * In variables: u_nplus1_kplus1
	 * Out variables: u_nplus1
	 */
	protected void tearDownTimeLoopK()
	{
		IntStream.range(0, u_nplus1.length).parallel().forEach(i1 -> 
		{
			u_nplus1[i1] = u_nplus1_kplus1[i1];
		});
	}

	/**
	 * Job executeTimeLoopN called @4.0 in simulate method.
	 * In variables: alpha, deltat, t_n, u_n, u_nplus1_k, u_nplus1_kplus1
	 * Out variables: residual, t_nplus1, u_nplus1, u_nplus1_k, u_nplus1_kplus1
	 */
	protected void executeTimeLoopN()
	{
		n = 0;
		boolean continueLoop = true;
		do
		{
			n++;
			System.out.printf("[%5d] t: %5.5f - deltat: %5.5f\n", n, t_n, deltat);
			if (n >= lastDump + options.outputPeriod)
				dumpVariables(n);
			computeTn(); // @1.0
			setUpTimeLoopK(); // @1.0
			executeTimeLoopK(); // @2.0
			tearDownTimeLoopK(); // @3.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options.stopTime && n + 1 < options.maxIterations);
		
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
		// force a last output at the end
		dumpVariables(n);
	}

	private boolean check(boolean a)
	{
		if (a)
			return true;
		else
			throw new RuntimeException("Assertion failed");
	}

	private double norm(double[] a)
	{
		final int x = a.length;
		return Math.sqrt(dot(a, a));
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

	private double det(double[] a, double[] b)
	{
		return (a[0] * b[1] - a[1] * b[0]);
	}

	private double[] sumR1(double[] a, double[] b)
	{
		final int x = a.length;
		return ArrayOperations.plus(a, b);
	}

	private double minR0(double a, double b)
	{
		return Math.min(a, b);
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
		return Math.max(a, b);
	}

	public void simulate()
	{
		System.out.println("Start execution of iterativeHeatEquation");
		computeFaceLength(); // @1.0
		computeV(); // @1.0
		initD(); // @1.0
		initTime(); // @1.0
		initXc(); // @1.0
		computeDeltaTn(); // @2.0
		computeFaceConductivity(); // @2.0
		initU(); // @2.0
		setUpTimeLoopN(); // @2.0
		computeAlphaCoeff(); // @3.0
		executeTimeLoopN(); // @4.0
		System.out.println("End of execution of iterativeHeatEquation");
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
			IterativeHeatEquation.Options iterativeHeatEquationOptions = new IterativeHeatEquation.Options();
			if (o.has("iterativeHeatEquation")) iterativeHeatEquationOptions.jsonInit(o.get("iterativeHeatEquation").toString());
			IterativeHeatEquation iterativeHeatEquation = new IterativeHeatEquation(mesh, iterativeHeatEquationOptions);

			// Start simulation
			iterativeHeatEquation.simulate();

			// Non regression testing
			if (iterativeHeatEquationOptions.nonRegression != null && iterativeHeatEquationOptions.nonRegression.equals("CreateReference"))
				iterativeHeatEquation.createDB("IterativeHeatEquationDB.ref");
			if (iterativeHeatEquationOptions.nonRegression != null && iterativeHeatEquationOptions.nonRegression.equals("CompareToReference"))
			{
				iterativeHeatEquation.createDB("IterativeHeatEquationDB.current");
				if (!LevelDBUtils.compareDB("IterativeHeatEquationDB.current", "IterativeHeatEquationDB.ref"))
					ret = 1;
				LevelDBUtils.destroyDB("IterativeHeatEquationDB.current");
				System.exit(ret);
			}
		}
		else
		{
			System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.err.println("        Expecting user data file name, for example IterativeHeatEquation.json");
			System.exit(1);
		}
	}

	private void dumpVariables(int iteration)
	{
		if (!writer.isDisabled())
		{
			VtkFileContent content = new VtkFileContent(iteration, t_n, X, mesh.getGeometry().getQuads());
			content.addCellVariable("Temperature", u_n);
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
			batch.put(bytes("k"), LevelDBUtils.serialize(k));
			batch.put(bytes("vectOne"), LevelDBUtils.serialize(vectOne));
			batch.put(bytes("deltat"), LevelDBUtils.serialize(deltat));
			batch.put(bytes("t_n"), LevelDBUtils.serialize(t_n));
			batch.put(bytes("t_nplus1"), LevelDBUtils.serialize(t_nplus1));
			batch.put(bytes("t_n0"), LevelDBUtils.serialize(t_n0));
			batch.put(bytes("X"), LevelDBUtils.serialize(X));
			batch.put(bytes("Xc"), LevelDBUtils.serialize(Xc));
			batch.put(bytes("u_n"), LevelDBUtils.serialize(u_n));
			batch.put(bytes("u_nplus1"), LevelDBUtils.serialize(u_nplus1));
			batch.put(bytes("u_nplus1_k"), LevelDBUtils.serialize(u_nplus1_k));
			batch.put(bytes("u_nplus1_kplus1"), LevelDBUtils.serialize(u_nplus1_kplus1));
			batch.put(bytes("V"), LevelDBUtils.serialize(V));
			batch.put(bytes("D"), LevelDBUtils.serialize(D));
			batch.put(bytes("faceLength"), LevelDBUtils.serialize(faceLength));
			batch.put(bytes("faceConductivity"), LevelDBUtils.serialize(faceConductivity));
			batch.put(bytes("alpha"), LevelDBUtils.serialize(alpha));
			batch.put(bytes("residual"), LevelDBUtils.serialize(residual));

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
