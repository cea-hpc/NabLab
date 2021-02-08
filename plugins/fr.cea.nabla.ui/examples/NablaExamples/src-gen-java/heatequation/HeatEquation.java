/*** GENERATED FILE - DO NOT OVERWRITE ***/

package heatequation;

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
public final class HeatEquation
{
	public final static class Options
	{
		public String outputPath;
		public int outputPeriod;
		public double stopTime;
		public int maxIterations;
		public double PI;
		public double alpha;
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
				stopTime = 0.1;
			// maxIterations
			if (o.has("maxIterations"))
			{
				final JsonElement valueof_maxIterations = o.get("maxIterations");
				assert(valueof_maxIterations.isJsonPrimitive());
				maxIterations = valueof_maxIterations.getAsJsonPrimitive().getAsInt();
			}
			else
				maxIterations = 500;
			// PI
			if (o.has("PI"))
			{
				final JsonElement valueof_PI = o.get("PI");
				assert(valueof_PI.isJsonPrimitive());
				PI = valueof_PI.getAsJsonPrimitive().getAsDouble();
			}
			else
				PI = 3.1415926;
			// alpha
			if (o.has("alpha"))
			{
				final JsonElement valueof_alpha = o.get("alpha");
				assert(valueof_alpha.isJsonPrimitive());
				alpha = valueof_alpha.getAsJsonPrimitive().getAsDouble();
			}
			else
				alpha = 1.0;
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
	private final int nbNodes, nbCells, nbFaces, nbNeighbourCells, nbNodesOfFace, nbNodesOfCell;

	// User options
	private final Options options;
	private final FileWriter writer;

	// Global variables
	protected int lastDump;
	protected int n;
	protected final double deltat;
	protected double t_n;
	protected double t_nplus1;
	protected double t_n0;
	protected double[][] X;
	protected double[][] center;
	protected double[] u_n;
	protected double[] u_nplus1;
	protected double[] V;
	protected double[] f;
	protected double[] outgoingFlux;
	protected double[] surface;

	public HeatEquation(CartesianMesh2D aMesh, Options aOptions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbFaces = mesh.getNbFaces();
		nbNeighbourCells = CartesianMesh2D.MaxNbNeighbourCells;
		nbNodesOfFace = CartesianMesh2D.MaxNbNodesOfFace;
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;

		// User options
		options = aOptions;
		writer = new PvdFileWriter2D("HeatEquation", options.outputPath);

		// Initialize variables with default values
		lastDump = Integer.MIN_VALUE;
		deltat = 0.001;

		// Allocate arrays
		X = new double[nbNodes][2];
		center = new double[nbCells][2];
		u_n = new double[nbCells];
		u_nplus1 = new double[nbCells];
		V = new double[nbCells];
		f = new double[nbCells];
		outgoingFlux = new double[nbCells];
		surface = new double[nbFaces];

		// Copy node coordinates
		double[][] gNodes = mesh.getGeometry().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes ->
		{
			X[rNodes][0] = gNodes[rNodes][0];
			X[rNodes][1] = gNodes[rNodes][1];
		});
	}

	/**
	 * Job computeOutgoingFlux called @1.0 in executeTimeLoopN method.
	 * In variables: V, center, deltat, surface, u_n
	 * Out variables: outgoingFlux
	 */
	protected void computeOutgoingFlux()
	{
		IntStream.range(0, nbCells).parallel().forEach(j1Cells -> 
		{
			final int j1Id = j1Cells;
			double reduction0 = 0.0;
			{
				final int[] neighbourCellsJ1 = mesh.getNeighbourCells(j1Id);
				final int nbNeighbourCellsJ1 = neighbourCellsJ1.length;
				for (int j2NeighbourCellsJ1=0; j2NeighbourCellsJ1<nbNeighbourCellsJ1; j2NeighbourCellsJ1++)
				{
					final int j2Id = neighbourCellsJ1[j2NeighbourCellsJ1];
					final int j2Cells = j2Id;
					final int cfId = mesh.getCommonFace(j1Id, j2Id);
					final int cfFaces = cfId;
					double reduction1 = (u_n[j2Cells] - u_n[j1Cells]) / norm(ArrayOperations.minus(center[j2Cells], center[j1Cells])) * surface[cfFaces];
					reduction0 = sumR0(reduction0, reduction1);
				}
			}
			outgoingFlux[j1Cells] = deltat / V[j1Cells] * reduction0;
		});
	}

	/**
	 * Job computeSurface called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: surface
	 */
	protected void computeSurface()
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			final int fId = fFaces;
			double reduction0 = 0.0;
			{
				final int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
				final int nbNodesOfFaceF = nodesOfFaceF.length;
				for (int rNodesOfFaceF=0; rNodesOfFaceF<nbNodesOfFaceF; rNodesOfFaceF++)
				{
					final int rId = nodesOfFaceF[rNodesOfFaceF];
					final int rPlus1Id = nodesOfFaceF[(rNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace];
					final int rNodes = rId;
					final int rPlus1Nodes = rPlus1Id;
					reduction0 = sumR0(reduction0, norm(ArrayOperations.minus(X[rNodes], X[rPlus1Nodes])));
				}
			}
			surface[fFaces] = 0.5 * reduction0;
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
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					final int rNodes = rId;
					final int rPlus1Nodes = rPlus1Id;
					reduction0 = sumR0(reduction0, det(X[rNodes], X[rPlus1Nodes]));
				}
			}
			V[jCells] = 0.5 * reduction0;
		});
	}

	/**
	 * Job iniCenter called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: center
	 */
	protected void iniCenter()
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
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rNodes = rId;
					reduction0 = sumR1(reduction0, X[rNodes]);
				}
			}
			center[jCells] = ArrayOperations.multiply(0.25, reduction0);
		});
	}

	/**
	 * Job iniF called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: f
	 */
	protected void iniF()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			f[jCells] = 0.0;
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
	 * Job computeUn called @2.0 in executeTimeLoopN method.
	 * In variables: deltat, f, outgoingFlux, u_n
	 * Out variables: u_nplus1
	 */
	protected void computeUn()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			u_nplus1[jCells] = f[jCells] * deltat + u_n[jCells] + outgoingFlux[jCells];
		});
	}

	/**
	 * Job iniUn called @2.0 in simulate method.
	 * In variables: PI, alpha, center
	 * Out variables: u_n
	 */
	protected void iniUn()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			u_n[jCells] = Math.cos(2 * options.PI * options.alpha * center[jCells][0]);
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
	 * Job executeTimeLoopN called @3.0 in simulate method.
	 * In variables: V, center, deltat, f, outgoingFlux, surface, t_n, u_n
	 * Out variables: outgoingFlux, t_nplus1, u_nplus1
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
			computeOutgoingFlux(); // @1.0
			computeTn(); // @1.0
			computeUn(); // @2.0
		
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

	private double det(double[] a, double[] b)
	{
		return (a[0] * b[1] - a[1] * b[0]);
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

	private double[] sumR1(double[] a, double[] b)
	{
		final int x = a.length;
		return ArrayOperations.plus(a, b);
	}

	private double sumR0(double a, double b)
	{
		return a + b;
	}

	public void simulate()
	{
		System.out.println("Start execution of heatEquation");
		computeSurface(); // @1.0
		computeV(); // @1.0
		iniCenter(); // @1.0
		iniF(); // @1.0
		iniTime(); // @1.0
		iniUn(); // @2.0
		setUpTimeLoopN(); // @2.0
		executeTimeLoopN(); // @3.0
		System.out.println("End of execution of heatEquation");
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
			HeatEquation.Options heatEquationOptions = new HeatEquation.Options();
			if (o.has("heatEquation")) heatEquationOptions.jsonInit(o.get("heatEquation").toString());
			HeatEquation heatEquation = new HeatEquation(mesh, heatEquationOptions);

			// Start simulation
			heatEquation.simulate();

			// Non regression testing
			if (heatEquationOptions.nonRegression != null && heatEquationOptions.nonRegression.equals("CreateReference"))
				heatEquation.createDB("HeatEquationDB.ref");
			if (heatEquationOptions.nonRegression != null && heatEquationOptions.nonRegression.equals("CompareToReference"))
			{
				heatEquation.createDB("HeatEquationDB.current");
				if (!LevelDBUtils.compareDB("HeatEquationDB.current", "HeatEquationDB.ref"))
					ret = 1;
				LevelDBUtils.destroyDB("HeatEquationDB.current");
				System.exit(ret);
			}
		}
		else
		{
			System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.err.println("        Expecting user data file name, for example HeatEquation.json");
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
			batch.put(bytes("deltat"), LevelDBUtils.serialize(deltat));
			batch.put(bytes("t_n"), LevelDBUtils.serialize(t_n));
			batch.put(bytes("t_nplus1"), LevelDBUtils.serialize(t_nplus1));
			batch.put(bytes("t_n0"), LevelDBUtils.serialize(t_n0));
			batch.put(bytes("X"), LevelDBUtils.serialize(X));
			batch.put(bytes("center"), LevelDBUtils.serialize(center));
			batch.put(bytes("u_n"), LevelDBUtils.serialize(u_n));
			batch.put(bytes("u_nplus1"), LevelDBUtils.serialize(u_nplus1));
			batch.put(bytes("V"), LevelDBUtils.serialize(V));
			batch.put(bytes("f"), LevelDBUtils.serialize(f));
			batch.put(bytes("outgoingFlux"), LevelDBUtils.serialize(outgoingFlux));
			batch.put(bytes("surface"), LevelDBUtils.serialize(surface));

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
