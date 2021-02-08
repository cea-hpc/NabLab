/*** GENERATED FILE - DO NOT OVERWRITE ***/

package test;

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
public final class Test
{
	public final static class Options
	{
		public double maxTime;
		public int maxIter;
		public double deltat;
		public String nonRegression;

		public void jsonInit(final String jsonContent)
		{
			final JsonParser parser = new JsonParser();
			final JsonElement json = parser.parse(jsonContent);
			assert(json.isJsonObject());
			final JsonObject o = json.getAsJsonObject();
			// maxTime
			if (o.has("maxTime"))
			{
				final JsonElement valueof_maxTime = o.get("maxTime");
				assert(valueof_maxTime.isJsonPrimitive());
				maxTime = valueof_maxTime.getAsJsonPrimitive().getAsDouble();
			}
			else
				maxTime = 0.1;
			// maxIter
			if (o.has("maxIter"))
			{
				final JsonElement valueof_maxIter = o.get("maxIter");
				assert(valueof_maxIter.isJsonPrimitive());
				maxIter = valueof_maxIter.getAsJsonPrimitive().getAsInt();
			}
			else
				maxIter = 500;
			// deltat
			if (o.has("deltat"))
			{
				final JsonElement valueof_deltat = o.get("deltat");
				assert(valueof_deltat.isJsonPrimitive());
				deltat = valueof_deltat.getAsJsonPrimitive().getAsDouble();
			}
			else
				deltat = 1.0;
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
	private final int nbNodes, nbCells;

	// User options
	private final Options options;

	// Global variables
	protected int n;
	protected int k;
	protected double t_n;
	protected double t_nplus1;
	protected double t_n0;
	protected double[][] X;
	protected double[] e1;
	protected double[] e2_n;
	protected double[] e2_nplus1;
	protected double[] e2_nplus1_k;
	protected double[] e2_nplus1_kplus1;
	protected double[] e2_nplus1_k0;
	protected double[] e_n;
	protected double[] e_nplus1;
	protected double[] e_n0;
	protected double[] v;
	protected double[][] M;

	public Test(CartesianMesh2D aMesh, Options aOptions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();

		// User options
		options = aOptions;

		// Initialize variables with default values

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
		v = new double[nbCells];
		M = new double[nbCells][nbCells];

		// Copy node coordinates
		double[][] gNodes = mesh.getGeometry().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes ->
		{
			X[rNodes][0] = gNodes[rNodes][0];
			X[rNodes][1] = gNodes[rNodes][1];
		});
	}

	/**
	 * Job computeE1 called @1.0 in executeTimeLoopN method.
	 * In variables: e_n
	 * Out variables: e1
	 */
	protected void computeE1()
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
	protected void computeE2()
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
	protected void initE()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e_n0[cCells] = 0.0;
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
	 * Job updateT called @1.0 in executeTimeLoopN method.
	 * In variables: deltat, t_n
	 * Out variables: t_nplus1
	 */
	protected void updateT()
	{
		t_nplus1 = t_n + options.deltat;
	}

	/**
	 * Job initE2 called @2.0 in executeTimeLoopN method.
	 * In variables: e1
	 * Out variables: e2_nplus1_k0
	 */
	protected void initE2()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e2_nplus1_k0[cCells] = e1[cCells];
		});
	}

	/**
	 * Job setUpTimeLoopN called @2.0 in simulate method.
	 * In variables: e_n0, t_n0
	 * Out variables: e_n, t_n
	 */
	protected void setUpTimeLoopN()
	{
		t_n = t_n0;
		IntStream.range(0, e_n.length).parallel().forEach(i1 -> 
		{
			e_n[i1] = e_n0[i1];
		});
	}

	/**
	 * Job executeTimeLoopN called @3.0 in simulate method.
	 * In variables: deltat, e1, e2_nplus1, e2_nplus1_k, e2_nplus1_k0, e2_nplus1_kplus1, e_n, t_n
	 * Out variables: e1, e2_nplus1, e2_nplus1_k, e2_nplus1_k0, e2_nplus1_kplus1, e_nplus1, t_nplus1
	 */
	protected void executeTimeLoopN()
	{
		n = 0;
		boolean continueLoop = true;
		do
		{
			n++;
			System.out.printf("[%5d] t: %5.5f - deltat: %5.5f\n", n, t_n, options.deltat);
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
	 * Job setUpTimeLoopK called @3.0 in executeTimeLoopN method.
	 * In variables: e2_nplus1_k0
	 * Out variables: e2_nplus1_k
	 */
	protected void setUpTimeLoopK()
	{
		IntStream.range(0, e2_nplus1_k.length).parallel().forEach(i1 -> 
		{
			e2_nplus1_k[i1] = e2_nplus1_k0[i1];
		});
	}

	/**
	 * Job executeTimeLoopK called @4.0 in executeTimeLoopN method.
	 * In variables: e2_nplus1_k
	 * Out variables: e2_nplus1_kplus1
	 */
	protected void executeTimeLoopK()
	{
		k = 0;
		boolean continueLoop = true;
		do
		{
			k++;
			System.out.printf("	[%5d] t: %5.5f - deltat: %5.5f\n", k, t_n, options.deltat);
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
	 * Job tearDownTimeLoopK called @5.0 in executeTimeLoopN method.
	 * In variables: e2_nplus1_kplus1
	 * Out variables: e2_nplus1
	 */
	protected void tearDownTimeLoopK()
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
	protected void updateE()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e_nplus1[cCells] = e2_nplus1[cCells] - 3;
		});
	}

	public void simulate()
	{
		System.out.println("Start execution of test");
		initE(); // @1.0
		initTime(); // @1.0
		setUpTimeLoopN(); // @2.0
		executeTimeLoopN(); // @3.0
		System.out.println("End of execution of test");
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
			Test.Options testOptions = new Test.Options();
			if (o.has("test")) testOptions.jsonInit(o.get("test").toString());
			Test test = new Test(mesh, testOptions);

			// Start simulation
			test.simulate();

			// Non regression testing
			if (testOptions.nonRegression != null && testOptions.nonRegression.equals("CreateReference"))
				test.createDB("TestDB.ref");
			if (testOptions.nonRegression != null && testOptions.nonRegression.equals("CompareToReference"))
			{
				test.createDB("TestDB.current");
				if (!LevelDBUtils.compareDB("TestDB.current", "TestDB.ref"))
					ret = 1;
				LevelDBUtils.destroyDB("TestDB.current");
				System.exit(ret);
			}
		}
		else
		{
			System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.err.println("        Expecting user data file name, for example Test.json");
			System.exit(1);
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
			batch.put(bytes("n"), LevelDBUtils.serialize(n));
			batch.put(bytes("k"), LevelDBUtils.serialize(k));
			batch.put(bytes("t_n"), LevelDBUtils.serialize(t_n));
			batch.put(bytes("t_nplus1"), LevelDBUtils.serialize(t_nplus1));
			batch.put(bytes("t_n0"), LevelDBUtils.serialize(t_n0));
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
			batch.put(bytes("v"), LevelDBUtils.serialize(v));
			batch.put(bytes("M"), LevelDBUtils.serialize(M));

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
