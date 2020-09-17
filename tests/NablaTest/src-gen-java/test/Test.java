package test;

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

@SuppressWarnings("all")
public final class Test
{
	public final static class Options
	{
		public String nonRegression;
		public double maxTime;
		public int maxIter;
		public double deltat;
	}

	public final static class OptionsDeserializer implements JsonDeserializer<Options>
	{
		@Override
		public Options deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException
		{
			final JsonObject d = json.getAsJsonObject();
			Options options = new Options();
			// maxTime
			if (d.has("maxTime"))
			{
				final JsonElement valueof_maxTime = d.get("maxTime");
				options.maxTime = valueof_maxTime.getAsJsonPrimitive().getAsDouble();
			}
			else
				options.maxTime = 0.1;
			// maxIter
			if (d.has("maxIter"))
			{
				final JsonElement valueof_maxIter = d.get("maxIter");
				options.maxIter = valueof_maxIter.getAsJsonPrimitive().getAsInt();
			}
			else
				options.maxIter = 500;
			// deltat
			if (d.has("deltat"))
			{
				final JsonElement valueof_deltat = d.get("deltat");
				options.deltat = valueof_deltat.getAsJsonPrimitive().getAsDouble();
			}
			else
				options.deltat = 1.0;
			return options;
		}
	}

	// Mesh and mesh variables
	private final CartesianMesh2D mesh;
	private final int nbNodes, nbCells;

	// User options and external classes
	private final Options options;

	// Global variables
	private int n;
	private int k;
	private double t_n;
	private double t_nplus1;
	private double[][] X;
	private double[] e1;
	private double[] e2_n;
	private double[] e2_nplus1;
	private double[] e2_nplus1_k;
	private double[] e2_nplus1_kplus1;
	private double[] e2_nplus1_k0;
	private double[] e_n;
	private double[] e_nplus1;
	private double[] e_n0;

	public Test(CartesianMesh2D aMesh, Options aOptions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();

		// User options and external classes initialization
		options = aOptions;

		// Initialize variables with default values
		t_n = 0.0;
		t_nplus1 = 0.0;

		// Allocate arrays
		X = new double[nbNodes][2];
		e1 = new double[nbCells];
		e2_n = new double[nbCells];
		e2_nplus1 = new double[nbCells];
		e2_nplus1_k = new double[nbCells];
		e2_nplus1_kplus1 = new double[nbCells];
		e2_nplus1_k0 = new double[nbCells];
		e_n = new double[nbCells];
		e_nplus1 = new double[nbCells];
		e_n0 = new double[nbCells];

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
		System.out.println("Start execution of module Test");
		initE(); // @1.0
		setUpTimeLoopN(); // @2.0
		executeTimeLoopN(); // @3.0
		System.out.println("End of execution of module Test");
	}

	public static void main(String[] args) throws IOException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			JsonParser parser = new JsonParser();
			JsonObject o = parser.parse(new FileReader(dataFileName)).getAsJsonObject();
			GsonBuilder gsonBuilder = new GsonBuilder();
			gsonBuilder.registerTypeAdapter(Options.class, new Test.OptionsDeserializer());
			Gson gson = gsonBuilder.create();

			assert(o.has("mesh"));
			CartesianMesh2DFactory meshFactory = gson.fromJson(o.get("mesh"), CartesianMesh2DFactory.class);
			CartesianMesh2D mesh = meshFactory.create();
			assert(o.has("options"));
			Test.Options options = gson.fromJson(o.get("options"), Test.Options.class);

			Test simulator = new Test(mesh, options);
			simulator.simulate();

			// Non regression testing
			if (options.nonRegression!=null &&  options.nonRegression.equals("CreateReference"))
				simulator.createDB("TestDB.ref");
			if (options.nonRegression!=null &&  options.nonRegression.equals("CompareToReference"))
			{
				simulator.createDB("TestDB.current");
				LevelDBUtils.compareDB("TestDB.current", "TestDB.ref");
				LevelDBUtils.destroyDB("TestDB.current");
			}
		}
		else
		{
			System.out.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.out.println("        Expecting user data file name, for example TestDefault.json");
		}
	}

	/**
	 * Job computeE1 called @1.0 in executeTimeLoopN method.
	 * In variables: e_n
	 * Out variables: e1
	 */
	private void computeE1()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e1[cCells] = e_n[cCells] + 3.0;
		});
	}

	/**
	 * Job computeE2 called @1.0 in executeTimeLoopK method.
	 * In variables: e2_nplus1_k
	 * Out variables: e2_nplus1_kplus1
	 */
	private void computeE2()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e2_nplus1_kplus1[cCells] = e2_nplus1_k[cCells] + 0.4;
		});
	}

	/**
	 * Job initE called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: e_n0
	 */
	private void initE()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e_n0[cCells] = 0.0;
		});
	}

	/**
	 * Job updateT called @1.0 in executeTimeLoopN method.
	 * In variables: deltat, t_n
	 * Out variables: t_nplus1
	 */
	private void updateT()
	{
		t_nplus1 = t_n + options.deltat;
	}

	/**
	 * Job InitE2 called @2.0 in executeTimeLoopN method.
	 * In variables: e1
	 * Out variables: e2_nplus1_k0
	 */
	private void initE2()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e2_nplus1_k0[cCells] = e1[cCells];
		});
	}

	/**
	 * Job SetUpTimeLoopN called @2.0 in simulate method.
	 * In variables: e_n0
	 * Out variables: e_n
	 */
	private void setUpTimeLoopN()
	{
		IntStream.range(0, e_n.length).parallel().forEach(i1 -> 
		{
			e_n[i1] = e_n0[i1];
		});
	}

	/**
	 * Job ExecuteTimeLoopN called @3.0 in simulate method.
	 * In variables: deltat, e1, e2_nplus1, e2_nplus1_k, e2_nplus1_k0, e2_nplus1_kplus1, e_n, t_n
	 * Out variables: e1, e2_nplus1, e2_nplus1_k, e2_nplus1_k0, e2_nplus1_kplus1, e_nplus1, t_nplus1
	 */
	private void executeTimeLoopN()
	{
		n = 0;
		boolean continueLoop = true;
		do
		{
			n++;
			System.out.printf("	[%5d] t: %5.5f - deltat: %5.5f\n", n, t_n, options.deltat);
			computeE1(); // @1.0
			updateT(); // @1.0
			initE2(); // @2.0
			setUpTimeLoopK(); // @3.0
			executeTimeLoopK(); // @4.0
			tearDownTimeLoopK(); // @5.0
			updateE(); // @6.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (n + 1 < options.maxIter && t_nplus1 < options.maxTime);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double tmp_t_n = t_n;
				t_n = t_nplus1;
				t_nplus1 = tmp_t_n;
				double[] tmp_e2_n = e2_n;
				e2_n = e2_nplus1;
				e2_nplus1 = tmp_e2_n;
				double[] tmp_e_n = e_n;
				e_n = e_nplus1;
				e_nplus1 = tmp_e_n;
			} 
		} while (continueLoop);
	}

	/**
	 * Job SetUpTimeLoopK called @3.0 in executeTimeLoopN method.
	 * In variables: e2_nplus1_k0
	 * Out variables: e2_nplus1_k
	 */
	private void setUpTimeLoopK()
	{
		IntStream.range(0, e2_nplus1_k.length).parallel().forEach(i1 -> 
		{
			e2_nplus1_k[i1] = e2_nplus1_k0[i1];
		});
	}

	/**
	 * Job ExecuteTimeLoopK called @4.0 in executeTimeLoopN method.
	 * In variables: e2_nplus1_k
	 * Out variables: e2_nplus1_kplus1
	 */
	private void executeTimeLoopK()
	{
		k = 0;
		boolean continueLoop = true;
		do
		{
			k++;
			System.out.printf("		[%5d] t: %5.5f - deltat: %5.5f\n", k, t_n, options.deltat);
			computeE2(); // @1.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (k + 1 < 10);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double[] tmp_e2_nplus1_k = e2_nplus1_k;
				e2_nplus1_k = e2_nplus1_kplus1;
				e2_nplus1_kplus1 = tmp_e2_nplus1_k;
			} 
		} while (continueLoop);
	}

	/**
	 * Job TearDownTimeLoopK called @5.0 in executeTimeLoopN method.
	 * In variables: e2_nplus1_kplus1
	 * Out variables: e2_nplus1
	 */
	private void tearDownTimeLoopK()
	{
		IntStream.range(0, e2_nplus1.length).parallel().forEach(i1 -> 
		{
			e2_nplus1[i1] = e2_nplus1_kplus1[i1];
		});
	}

	/**
	 * Job updateE called @6.0 in executeTimeLoopN method.
	 * In variables: e2_nplus1
	 * Out variables: e_nplus1
	 */
	private void updateE()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e_nplus1[cCells] = e2_nplus1[cCells] - 3;
		});
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
			batch.put(bytes("n"), LevelDBUtils.serialize(n));
			batch.put(bytes("k"), LevelDBUtils.serialize(k));
			batch.put(bytes("t_n"), LevelDBUtils.serialize(t_n));
			batch.put(bytes("t_nplus1"), LevelDBUtils.serialize(t_nplus1));
			batch.put(bytes("X"), LevelDBUtils.serialize(X));
			batch.put(bytes("e1"), LevelDBUtils.serialize(e1));
			batch.put(bytes("e2_n"), LevelDBUtils.serialize(e2_n));
			batch.put(bytes("e2_nplus1"), LevelDBUtils.serialize(e2_nplus1));
			batch.put(bytes("e2_nplus1_k"), LevelDBUtils.serialize(e2_nplus1_k));
			batch.put(bytes("e2_nplus1_kplus1"), LevelDBUtils.serialize(e2_nplus1_kplus1));
			batch.put(bytes("e2_nplus1_k0"), LevelDBUtils.serialize(e2_nplus1_k0));
			batch.put(bytes("e_n"), LevelDBUtils.serialize(e_n));
			batch.put(bytes("e_nplus1"), LevelDBUtils.serialize(e_nplus1));
			batch.put(bytes("e_n0"), LevelDBUtils.serialize(e_n0));

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
