/*** GENERATED FILE - DO NOT OVERWRITE ***/

package bugiter;

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
public final class BugIter
{
	public final static class Options
	{
		public double maxTime;
		public int maxIter;
		public int maxIterK;
		public int maxIterL;
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
			// maxIterK
			if (o.has("maxIterK"))
			{
				final JsonElement valueof_maxIterK = o.get("maxIterK");
				assert(valueof_maxIterK.isJsonPrimitive());
				maxIterK = valueof_maxIterK.getAsJsonPrimitive().getAsInt();
			}
			else
				maxIterK = 500;
			// maxIterL
			if (o.has("maxIterL"))
			{
				final JsonElement valueof_maxIterL = o.get("maxIterL");
				assert(valueof_maxIterL.isJsonPrimitive());
				maxIterL = valueof_maxIterL.getAsJsonPrimitive().getAsInt();
			}
			else
				maxIterL = 500;
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
	private final int nbCells, nbNodes;

	// User options
	private final Options options;

	// Global variables
	protected int n;
	protected int k;
	protected int l;
	protected double t_n;
	protected double t_nplus1;
	protected double t_n0;
	protected double[][] X;
	protected double[] u_n;
	protected double[] u_nplus1;
	protected double[] v_n;
	protected double[] v_nplus1;
	protected double[] v_nplus1_k;
	protected double[] v_nplus1_kplus1;
	protected double[] v_nplus1_k0;
	protected double[] w_n;
	protected double[] w_nplus1;
	protected double[] w_nplus1_l;
	protected double[] w_nplus1_lplus1;
	protected double[] w_nplus1_l0;

	public BugIter(CartesianMesh2D aMesh, Options aOptions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbCells = mesh.getNbCells();
		nbNodes = mesh.getNbNodes();

		// User options
		options = aOptions;

		// Initialize variables with default values

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

	/**
	 * Job computeTn called @1.0 in executeTimeLoopN method.
	 * In variables: deltat, t_n
	 * Out variables: t_nplus1
	 */
	protected void computeTn()
	{
		t_nplus1 = t_n + options.deltat;
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
	 * Job iniU called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: u_n
	 */
	protected void iniU()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			u_n[cCells] = 0.0;
		});
	}

	/**
	 * Job iniV called @1.0 in executeTimeLoopN method.
	 * In variables: u_n
	 * Out variables: v_nplus1_k0
	 */
	protected void iniV()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			v_nplus1_k0[cCells] = u_n[cCells] + 1;
		});
	}

	/**
	 * Job updateV called @1.0 in executeTimeLoopK method.
	 * In variables: v_nplus1_k
	 * Out variables: v_nplus1_kplus1
	 */
	protected void updateV()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			v_nplus1_kplus1[cCells] = v_nplus1_k[cCells] + 1.5;
		});
	}

	/**
	 * Job updateW called @1.0 in executeTimeLoopL method.
	 * In variables: w_nplus1_l
	 * Out variables: w_nplus1_lplus1
	 */
	protected void updateW()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			w_nplus1_lplus1[cCells] = w_nplus1_l[cCells] + 2.5;
		});
	}

	/**
	 * Job setUpTimeLoopK called @2.0 in executeTimeLoopN method.
	 * In variables: v_nplus1_k0
	 * Out variables: v_nplus1_k
	 */
	protected void setUpTimeLoopK()
	{
		IntStream.range(0, v_nplus1_k.length).parallel().forEach(i1 -> 
		{
			v_nplus1_k[i1] = v_nplus1_k0[i1];
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
	 * Job executeTimeLoopK called @3.0 in executeTimeLoopN method.
	 * In variables: v_nplus1_k
	 * Out variables: v_nplus1_kplus1
	 */
	protected void executeTimeLoopK()
	{
		k = 0;
		boolean continueLoop = true;
		do
		{
			k++;
			System.out.printf("	[%5d] t: %5.5f - deltat: %5.5f\n", k, t_n, options.deltat);
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
	 * Job executeTimeLoopN called @3.0 in simulate method.
	 * In variables: deltat, t_n, u_n, v_nplus1, v_nplus1_k, v_nplus1_k0, v_nplus1_kplus1, w_nplus1, w_nplus1_l, w_nplus1_l0, w_nplus1_lplus1
	 * Out variables: t_nplus1, u_nplus1, v_nplus1, v_nplus1_k, v_nplus1_k0, v_nplus1_kplus1, w_nplus1, w_nplus1_l, w_nplus1_l0, w_nplus1_lplus1
	 */
	protected void executeTimeLoopN()
	{
		n = 0;
		boolean continueLoop = true;
		do
		{
			n++;
			System.out.printf("[%5d] t: %5.5f - deltat: %5.5f\n", n, t_n, options.deltat);
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
	 * Job tearDownTimeLoopK called @4.0 in executeTimeLoopN method.
	 * In variables: v_nplus1_kplus1
	 * Out variables: v_nplus1
	 */
	protected void tearDownTimeLoopK()
	{
		IntStream.range(0, v_nplus1.length).parallel().forEach(i1 -> 
		{
			v_nplus1[i1] = v_nplus1_kplus1[i1];
		});
	}

	/**
	 * Job iniW called @5.0 in executeTimeLoopN method.
	 * In variables: v_nplus1
	 * Out variables: w_nplus1_l0
	 */
	protected void iniW()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			w_nplus1_l0[cCells] = v_nplus1[cCells];
		});
	}

	/**
	 * Job setUpTimeLoopL called @6.0 in executeTimeLoopN method.
	 * In variables: w_nplus1_l0
	 * Out variables: w_nplus1_l
	 */
	protected void setUpTimeLoopL()
	{
		IntStream.range(0, w_nplus1_l.length).parallel().forEach(i1 -> 
		{
			w_nplus1_l[i1] = w_nplus1_l0[i1];
		});
	}

	/**
	 * Job executeTimeLoopL called @7.0 in executeTimeLoopN method.
	 * In variables: w_nplus1_l
	 * Out variables: w_nplus1_lplus1
	 */
	protected void executeTimeLoopL()
	{
		l = 0;
		boolean continueLoop = true;
		do
		{
			l++;
			System.out.printf("	[%5d] t: %5.5f - deltat: %5.5f\n", l, t_n, options.deltat);
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
	 * Job tearDownTimeLoopL called @8.0 in executeTimeLoopN method.
	 * In variables: w_nplus1_lplus1
	 * Out variables: w_nplus1
	 */
	protected void tearDownTimeLoopL()
	{
		IntStream.range(0, w_nplus1.length).parallel().forEach(i1 -> 
		{
			w_nplus1[i1] = w_nplus1_lplus1[i1];
		});
	}

	/**
	 * Job updateU called @9.0 in executeTimeLoopN method.
	 * In variables: w_nplus1
	 * Out variables: u_nplus1
	 */
	protected void updateU()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			u_nplus1[cCells] = w_nplus1[cCells];
		});
	}

	public void simulate()
	{
		System.out.println("Start execution of bugIter");
		iniTime(); // @1.0
		iniU(); // @1.0
		setUpTimeLoopN(); // @2.0
		executeTimeLoopN(); // @3.0
		System.out.println("End of execution of bugIter");
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
			BugIter.Options bugIterOptions = new BugIter.Options();
			if (o.has("bugIter")) bugIterOptions.jsonInit(o.get("bugIter").toString());
			BugIter bugIter = new BugIter(mesh, bugIterOptions);

			// Start simulation
			bugIter.simulate();

			// Non regression testing
			if (bugIterOptions.nonRegression != null && bugIterOptions.nonRegression.equals("CreateReference"))
				bugIter.createDB("BugIterDB.ref");
			if (bugIterOptions.nonRegression != null && bugIterOptions.nonRegression.equals("CompareToReference"))
			{
				bugIter.createDB("BugIterDB.current");
				if (!LevelDBUtils.compareDB("BugIterDB.current", "BugIterDB.ref"))
					ret = 1;
				LevelDBUtils.destroyDB("BugIterDB.current");
				System.exit(ret);
			}
		}
		else
		{
			System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.err.println("        Expecting user data file name, for example BugIter.json");
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
			batch.put(bytes("l"), LevelDBUtils.serialize(l));
			batch.put(bytes("t_n"), LevelDBUtils.serialize(t_n));
			batch.put(bytes("t_nplus1"), LevelDBUtils.serialize(t_nplus1));
			batch.put(bytes("t_n0"), LevelDBUtils.serialize(t_n0));
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
