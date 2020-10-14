package implicitheatequation;

import static org.iq80.leveldb.impl.Iq80DBFactory.bytes;
import static org.iq80.leveldb.impl.Iq80DBFactory.factory;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.stream.IntStream;

import org.iq80.leveldb.DB;
import org.iq80.leveldb.WriteBatch;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonParser;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;
import fr.cea.nabla.javalib.utils.*;

import org.apache.commons.math3.linear.*;

@SuppressWarnings("all")
public final class ImplicitHeatEquation
{
	public final static class Options
	{
		public String outputPath;
		public String nonRegression;
		public int outputPeriod;
		public double u0;
		public double stopTime;
		public int maxIterations;
	}

	public final static class OptionsDeserializer implements JsonDeserializer<Options>
	{
		@Override
		public Options deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException
		{
			final JsonObject d = json.getAsJsonObject();
			Options options = new Options();
			// outputPath
			assert(d.has("outputPath"));
			final JsonElement valueof_outputPath = d.get("outputPath");
			options.outputPath = valueof_outputPath.getAsJsonPrimitive().getAsString();
			// Non regression
			if(d.has("nonRegression"))
			{
				final JsonElement valueof_nonRegression = d.get("nonRegression");
				options.nonRegression = valueof_nonRegression.getAsJsonPrimitive().getAsString();
			}
			// outputPeriod
			assert(d.has("outputPeriod"));
			final JsonElement valueof_outputPeriod = d.get("outputPeriod");
			assert(valueof_outputPeriod.isJsonPrimitive());
			options.outputPeriod = valueof_outputPeriod.getAsJsonPrimitive().getAsInt();
			// u0
			if (d.has("u0"))
			{
				final JsonElement valueof_u0 = d.get("u0");
				assert(valueof_u0.isJsonPrimitive());
				options.u0 = valueof_u0.getAsJsonPrimitive().getAsDouble();
			}
			else
				options.u0 = 1.0;
			// stopTime
			if (d.has("stopTime"))
			{
				final JsonElement valueof_stopTime = d.get("stopTime");
				assert(valueof_stopTime.isJsonPrimitive());
				options.stopTime = valueof_stopTime.getAsJsonPrimitive().getAsDouble();
			}
			else
				options.stopTime = 1.0;
			// maxIterations
			if (d.has("maxIterations"))
			{
				final JsonElement valueof_maxIterations = d.get("maxIterations");
				assert(valueof_maxIterations.isJsonPrimitive());
				options.maxIterations = valueof_maxIterations.getAsJsonPrimitive().getAsInt();
			}
			else
				options.maxIterations = 500000000;
			return options;
		}
	}

	// Mesh and mesh variables
	private final CartesianMesh2D mesh;
	private final int nbNodes, nbCells, nbFaces, nbNeighbourCells, nbNodesOfFace, nbCellsOfFace, nbNodesOfCell;

	// User options and external classes
	private final Options options;
	private LinearAlgebraFunctions linearAlgebraFunctions;
	private final FileWriter writer;

	// Global variables
	private int lastDump;
	private int n;
	private final double[] vectOne;
	private double t_n;
	private double t_nplus1;
	private double deltat;
	private double[][] X;
	private double[][] Xc;
	private Vector u_n;
	private Vector u_nplus1;
	private double[] V;
	private double[] D;
	private double[] faceLength;
	private double[] faceConductivity;
	private Matrix alpha;

	public ImplicitHeatEquation(CartesianMesh2D aMesh, Options aOptions, LinearAlgebraFunctions aLinearAlgebraFunctions)
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

		// User options and external classes initialization
		options = aOptions;
		linearAlgebraFunctions = aLinearAlgebraFunctions;
		writer = new PvdFileWriter2D("ImplicitHeatEquation", options.outputPath);

		// Initialize variables with default values
		lastDump = Integer.MIN_VALUE;
		vectOne = new double[] {1.0, 1.0};
		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat = 0.001;

		// Allocate arrays
		X = new double[nbNodes][2];
		Xc = new double[nbCells][2];
		u_n = Vector.createDenseVector(nbCells);
		u_nplus1 = Vector.createDenseVector(nbCells);
		V = new double[nbCells];
		D = new double[nbCells];
		faceLength = new double[nbFaces];
		faceConductivity = new double[nbFaces];
		alpha = Matrix.createDenseMatrix(nbCells, nbCells);

		// Copy node coordinates
		double[][] gNodes = mesh.getGeometry().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes ->
		{
			X[rNodes][0] = gNodes[rNodes][0];
			X[rNodes][1] = gNodes[rNodes][1];
		});
	}

	public void simulate()
	{
		System.out.println("Start execution of module ImplicitHeatEquation");
		computeFaceLength(); // @1.0
		computeV(); // @1.0
		initD(); // @1.0
		initXc(); // @1.0
		computeDeltaTn(); // @2.0
		computeFaceConductivity(); // @2.0
		initU(); // @2.0
		computeAlphaCoeff(); // @3.0
		executeTimeLoopN(); // @4.0
		System.out.println("End of execution of module ImplicitHeatEquation");
	}

	public static void main(String[] args) throws IOException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			JsonParser parser = new JsonParser();
			JsonObject o = parser.parse(new FileReader(dataFileName)).getAsJsonObject();
			GsonBuilder gsonBuilder = new GsonBuilder();
			gsonBuilder.registerTypeAdapter(Options.class, new ImplicitHeatEquation.OptionsDeserializer());
			Gson gson = gsonBuilder.create();
			int ret = 0;

			assert(o.has("mesh"));
			CartesianMesh2DFactory meshFactory = gson.fromJson(o.get("mesh"), CartesianMesh2DFactory.class);
			CartesianMesh2D mesh = meshFactory.create();
			assert(o.has("options"));
			ImplicitHeatEquation.Options options = gson.fromJson(o.get("options"), ImplicitHeatEquation.Options.class);
			LinearAlgebraFunctions linearAlgebraFunctions = (o.has("linearAlgebraFunctions") ? gson.fromJson(o.get("linearAlgebraFunctions"), LinearAlgebraFunctions.class) : new LinearAlgebraFunctions());

			ImplicitHeatEquation simulator = new ImplicitHeatEquation(mesh, options, linearAlgebraFunctions);
			simulator.simulate();

			// Non regression testing
			if (options.nonRegression!=null &&  options.nonRegression.equals("CreateReference"))
				simulator.createDB("ImplicitHeatEquationDB.ref");
			if (options.nonRegression!=null &&  options.nonRegression.equals("CompareToReference"))
			{
				simulator.createDB("ImplicitHeatEquationDB.current");
				if (!LevelDBUtils.compareDB("ImplicitHeatEquationDB.current", "ImplicitHeatEquationDB.ref"))
					ret = 1;
				LevelDBUtils.destroyDB("ImplicitHeatEquationDB.current");
				System.exit(ret);
			}
		}
		else
		{
			System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.err.println("        Expecting user data file name, for example ImplicitHeatEquationDefault.json");
			System.exit(1);
		}
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
	 * Job UpdateU called @1.0 in executeTimeLoopN method.
	 * In variables: alpha, u_n
	 * Out variables: u_nplus1
	 */
	private void updateU()
	{
		u_nplus1 = linearAlgebraFunctions.solveLinearSystem(alpha, u_n);
	}

	/**
	 * Job ComputeDeltaTn called @2.0 in simulate method.
	 * In variables: D, V
	 * Out variables: deltat
	 */
	private void computeDeltaTn()
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
		deltat = reduction0 * 0.24;
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
	 * Job InitU called @2.0 in simulate method.
	 * In variables: Xc, u0, vectOne
	 * Out variables: u_n
	 */
	private void initU()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			if (norm(ArrayOperations.minus(Xc[cCells], vectOne)) < 0.5)
				u_n.set(cCells, options.u0);
			else
				u_n.set(cCells, 0.0);
		});
	}

	/**
	 * Job ComputeAlphaCoeff called @3.0 in simulate method.
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
				final int nbNeighbourCellsC = neighbourCellsC.length;
				for (int dNeighbourCellsC=0; dNeighbourCellsC<nbNeighbourCellsC; dNeighbourCellsC++)
				{
					final int dId = neighbourCellsC[dNeighbourCellsC];
					final int dCells = dId;
					final int fId = mesh.getCommonFace(cId, dId);
					final int fFaces = fId;
					final double alphaExtraDiag = -deltat / V[cCells] * (faceLength[fFaces] * faceConductivity[fFaces]) / norm(ArrayOperations.minus(Xc[cCells], Xc[dCells]));
					alpha.set(cCells, dCells, alphaExtraDiag);
					alphaDiag = alphaDiag + alphaExtraDiag;
				}
			}
			alpha.set(cCells, cCells, 1 - alphaDiag);
		});
	}

	/**
	 * Job ExecuteTimeLoopN called @4.0 in simulate method.
	 * In variables: alpha, deltat, t_n, u_n
	 * Out variables: t_nplus1, u_nplus1
	 */
	private void executeTimeLoopN()
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
			updateU(); // @1.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options.stopTime && n + 1 < options.maxIterations);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double tmp_t_n = t_n;
				t_n = t_nplus1;
				t_nplus1 = tmp_t_n;
				Vector tmp_u_n = u_n;
				u_n = u_nplus1;
				u_nplus1 = tmp_u_n;
			} 
		} while (continueLoop);
		// force a last output at the end
		dumpVariables(n);
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

	private void dumpVariables(int iteration)
	{
		if (!writer.isDisabled())
		{
			VtkFileContent content = new VtkFileContent(iteration, t_n, X, mesh.getGeometry().getQuads());
			content.addCellVariable("Temperature", u_n.toArray());
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
			batch.put(bytes("vectOne"), LevelDBUtils.serialize(vectOne));
			batch.put(bytes("t_n"), LevelDBUtils.serialize(t_n));
			batch.put(bytes("t_nplus1"), LevelDBUtils.serialize(t_nplus1));
			batch.put(bytes("deltat"), LevelDBUtils.serialize(deltat));
			batch.put(bytes("X"), LevelDBUtils.serialize(X));
			batch.put(bytes("Xc"), LevelDBUtils.serialize(Xc));
			batch.put(bytes("V"), LevelDBUtils.serialize(V));
			batch.put(bytes("D"), LevelDBUtils.serialize(D));
			batch.put(bytes("faceLength"), LevelDBUtils.serialize(faceLength));
			batch.put(bytes("faceConductivity"), LevelDBUtils.serialize(faceConductivity));

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
