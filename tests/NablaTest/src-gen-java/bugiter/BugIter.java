package bugiter;

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
public final class BugIter
{
	public final static class Options
	{
		public String nonRegression;
		public double maxTime;
		public int maxIter;
		public int maxIterK;
		public int maxIterL;
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
			// maxIterK
			if (d.has("maxIterK"))
			{
				final JsonElement valueof_maxIterK = d.get("maxIterK");
				options.maxIterK = valueof_maxIterK.getAsJsonPrimitive().getAsInt();
			}
			else
				options.maxIterK = 500;
			// maxIterL
			if (d.has("maxIterL"))
			{
				final JsonElement valueof_maxIterL = d.get("maxIterL");
				options.maxIterL = valueof_maxIterL.getAsJsonPrimitive().getAsInt();
			}
			else
				options.maxIterL = 500;
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
	private final int nbCells, nbNodes;

	// User options and external classes
	private final Options options;

	// Global variables
	private int n;
	private int k;
	private int l;
	private double t_n;
	private double t_nplus1;
	private double[][] X;
	private double[] u_n;
	private double[] u_nplus1;
	private double[] v_n;
	private double[] v_nplus1;
	private double[] v_nplus1_k;
	private double[] v_nplus1_kplus1;
	private double[] v_nplus1_k0;
	private double[] w_n;
	private double[] w_nplus1;
	private double[] w_nplus1_l;
	private double[] w_nplus1_lplus1;
	private double[] w_nplus1_l0;

	public BugIter(CartesianMesh2D aMesh, Options aOptions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbCells = mesh.getNbCells();
		nbNodes = mesh.getNbNodes();

		// User options and external classes initialization
		options = aOptions;

		// Initialize variables with default values
		t_n = 0.0;
		t_nplus1 = 0.0;

		// Allocate arrays
		X = new double[nbNodes][2];
		u_n = new double[nbCells];
		u_nplus1 = new double[nbCells];
		v_n = new double[nbCells];
		v_nplus1 = new double[nbCells];
		v_nplus1_k = new double[nbCells];
		v_nplus1_kplus1 = new double[nbCells];
		v_nplus1_k0 = new double[nbCells];
		w_n = new double[nbCells];
		w_nplus1 = new double[nbCells];
		w_nplus1_l = new double[nbCells];
		w_nplus1_lplus1 = new double[nbCells];
		w_nplus1_l0 = new double[nbCells];

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
		System.out.println("Start execution of module BugIter");
		initU(); // @1.0
		executeTimeLoopN(); // @2.0
		System.out.println("End of execution of module BugIter");
	}

	public static void main(String[] args) throws IOException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			JsonParser parser = new JsonParser();
			JsonObject o = parser.parse(new FileReader(dataFileName)).getAsJsonObject();
			GsonBuilder gsonBuilder = new GsonBuilder();
			gsonBuilder.registerTypeAdapter(Options.class, new BugIter.OptionsDeserializer());
			Gson gson = gsonBuilder.create();

			assert(o.has("mesh"));
			CartesianMesh2DFactory meshFactory = gson.fromJson(o.get("mesh"), CartesianMesh2DFactory.class);
			CartesianMesh2D mesh = meshFactory.create();
			assert(o.has("options"));
			BugIter.Options options = gson.fromJson(o.get("options"), BugIter.Options.class);

			BugIter simulator = new BugIter(mesh, options);
			simulator.simulate();

			// Non regression testing
			if (options.nonRegression!=null &&  options.nonRegression.equals("CreateReference"))
				simulator.createDB("BugIterDB.ref");
			if (options.nonRegression!=null &&  options.nonRegression.equals("CompareToReference"))
			{
				simulator.createDB("BugIterDB.current");
				LevelDBUtils.compareDB("BugIterDB.current", "BugIterDB.ref");
				LevelDBUtils.destroyDB("BugIterDB.current");
			}
		}
		else
		{
			System.out.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.out.println("        Expecting user data file name, for example BugIterDefault.json");
		}
	}

	/**
	 * Job ComputeTn called @1.0 in executeTimeLoopN method.
	 * In variables: deltat, t_n
	 * Out variables: t_nplus1
	 */
	private void computeTn()
	{
		t_nplus1 = t_n + options.deltat;
	}

	/**
	 * Job IniV called @1.0 in executeTimeLoopN method.
	 * In variables: u_n
	 * Out variables: v_nplus1_k0
	 */
	private void iniV()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			v_nplus1_k0[cCells] = u_n[cCells] + 1;
		});
	}

	/**
	 * Job InitU called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: u_n
	 */
	private void initU()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			u_n[cCells] = 0.0;
		});
	}

	/**
	 * Job UpdateV called @1.0 in executeTimeLoopK method.
	 * In variables: v_nplus1_k
	 * Out variables: v_nplus1_kplus1
	 */
	private void updateV()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			v_nplus1_kplus1[cCells] = v_nplus1_k[cCells] + 1.5;
		});
	}

	/**
	 * Job UpdateW called @1.0 in executeTimeLoopL method.
	 * In variables: w_nplus1_l
	 * Out variables: w_nplus1_lplus1
	 */
	private void updateW()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			w_nplus1_lplus1[cCells] = w_nplus1_l[cCells] + 2.5;
		});
	}

	/**
	 * Job ExecuteTimeLoopN called @2.0 in simulate method.
	 * In variables: deltat, t_n, u_n, v_nplus1, v_nplus1_k, v_nplus1_k0, v_nplus1_kplus1, w_nplus1, w_nplus1_l, w_nplus1_l0, w_nplus1_lplus1
	 * Out variables: t_nplus1, u_nplus1, v_nplus1, v_nplus1_k, v_nplus1_k0, v_nplus1_kplus1, w_nplus1, w_nplus1_l, w_nplus1_l0, w_nplus1_lplus1
	 */
	private void executeTimeLoopN()
	{
		n = 0;
		boolean continueLoop = true;
		do
		{
			n++;
			System.out.printf("	[%5d] t: %5.5f - deltat: %5.5f\n", n, t_n, options.deltat);
			computeTn(); // @1.0
			iniV(); // @1.0
			setUpTimeLoopK(); // @2.0
			executeTimeLoopK(); // @3.0
			tearDownTimeLoopK(); // @4.0
			iniW(); // @5.0
			setUpTimeLoopL(); // @6.0
			executeTimeLoopL(); // @7.0
			tearDownTimeLoopL(); // @8.0
			updateU(); // @9.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options.maxTime && n + 1 < options.maxIter);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double tmp_t_n = t_n;
				t_n = t_nplus1;
				t_nplus1 = tmp_t_n;
				double[] tmp_u_n = u_n;
				u_n = u_nplus1;
				u_nplus1 = tmp_u_n;
				double[] tmp_v_n = v_n;
				v_n = v_nplus1;
				v_nplus1 = tmp_v_n;
				double[] tmp_w_n = w_n;
				w_n = w_nplus1;
				w_nplus1 = tmp_w_n;
			} 
		} while (continueLoop);
	}

	/**
	 * Job SetUpTimeLoopK called @2.0 in executeTimeLoopN method.
	 * In variables: v_nplus1_k0
	 * Out variables: v_nplus1_k
	 */
	private void setUpTimeLoopK()
	{
		IntStream.range(0, v_nplus1_k.length).parallel().forEach(i1 -> 
		{
			v_nplus1_k[i1] = v_nplus1_k0[i1];
		});
	}

	/**
	 * Job ExecuteTimeLoopK called @3.0 in executeTimeLoopN method.
	 * In variables: v_nplus1_k
	 * Out variables: v_nplus1_kplus1
	 */
	private void executeTimeLoopK()
	{
		k = 0;
		boolean continueLoop = true;
		do
		{
			k++;
			System.out.printf("		[%5d] t: %5.5f - deltat: %5.5f\n", k, t_n, options.deltat);
			updateV(); // @1.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (k + 1 < options.maxIterK);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double[] tmp_v_nplus1_k = v_nplus1_k;
				v_nplus1_k = v_nplus1_kplus1;
				v_nplus1_kplus1 = tmp_v_nplus1_k;
			} 
		} while (continueLoop);
	}

	/**
	 * Job TearDownTimeLoopK called @4.0 in executeTimeLoopN method.
	 * In variables: v_nplus1_kplus1
	 * Out variables: v_nplus1
	 */
	private void tearDownTimeLoopK()
	{
		IntStream.range(0, v_nplus1.length).parallel().forEach(i1 -> 
		{
			v_nplus1[i1] = v_nplus1_kplus1[i1];
		});
	}

	/**
	 * Job IniW called @5.0 in executeTimeLoopN method.
	 * In variables: v_nplus1
	 * Out variables: w_nplus1_l0
	 */
	private void iniW()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			w_nplus1_l0[cCells] = v_nplus1[cCells];
		});
	}

	/**
	 * Job SetUpTimeLoopL called @6.0 in executeTimeLoopN method.
	 * In variables: w_nplus1_l0
	 * Out variables: w_nplus1_l
	 */
	private void setUpTimeLoopL()
	{
		IntStream.range(0, w_nplus1_l.length).parallel().forEach(i1 -> 
		{
			w_nplus1_l[i1] = w_nplus1_l0[i1];
		});
	}

	/**
	 * Job ExecuteTimeLoopL called @7.0 in executeTimeLoopN method.
	 * In variables: w_nplus1_l
	 * Out variables: w_nplus1_lplus1
	 */
	private void executeTimeLoopL()
	{
		l = 0;
		boolean continueLoop = true;
		do
		{
			l++;
			System.out.printf("		[%5d] t: %5.5f - deltat: %5.5f\n", l, t_n, options.deltat);
			updateW(); // @1.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (l + 1 < options.maxIterL);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double[] tmp_w_nplus1_l = w_nplus1_l;
				w_nplus1_l = w_nplus1_lplus1;
				w_nplus1_lplus1 = tmp_w_nplus1_l;
			} 
		} while (continueLoop);
	}

	/**
	 * Job TearDownTimeLoopL called @8.0 in executeTimeLoopN method.
	 * In variables: w_nplus1_lplus1
	 * Out variables: w_nplus1
	 */
	private void tearDownTimeLoopL()
	{
		IntStream.range(0, w_nplus1.length).parallel().forEach(i1 -> 
		{
			w_nplus1[i1] = w_nplus1_lplus1[i1];
		});
	}

	/**
	 * Job UpdateU called @9.0 in executeTimeLoopN method.
	 * In variables: w_nplus1
	 * Out variables: u_nplus1
	 */
	private void updateU()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			u_nplus1[cCells] = w_nplus1[cCells];
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
			batch.put(bytes("l"), LevelDBUtils.serialize(l));
			batch.put(bytes("t_n"), LevelDBUtils.serialize(t_n));
			batch.put(bytes("t_nplus1"), LevelDBUtils.serialize(t_nplus1));
			batch.put(bytes("X"), LevelDBUtils.serialize(X));
			batch.put(bytes("u_n"), LevelDBUtils.serialize(u_n));
			batch.put(bytes("u_nplus1"), LevelDBUtils.serialize(u_nplus1));
			batch.put(bytes("v_n"), LevelDBUtils.serialize(v_n));
			batch.put(bytes("v_nplus1"), LevelDBUtils.serialize(v_nplus1));
			batch.put(bytes("v_nplus1_k"), LevelDBUtils.serialize(v_nplus1_k));
			batch.put(bytes("v_nplus1_kplus1"), LevelDBUtils.serialize(v_nplus1_kplus1));
			batch.put(bytes("v_nplus1_k0"), LevelDBUtils.serialize(v_nplus1_k0));
			batch.put(bytes("w_n"), LevelDBUtils.serialize(w_n));
			batch.put(bytes("w_nplus1"), LevelDBUtils.serialize(w_nplus1));
			batch.put(bytes("w_nplus1_l"), LevelDBUtils.serialize(w_nplus1_l));
			batch.put(bytes("w_nplus1_lplus1"), LevelDBUtils.serialize(w_nplus1_lplus1));
			batch.put(bytes("w_nplus1_l0"), LevelDBUtils.serialize(w_nplus1_l0));

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
