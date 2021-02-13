/*** GENERATED FILE - DO NOT OVERWRITE ***/

package hydroremap;

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
public final class H
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

	// Additional modules
	protected R1 r1;
	protected R2 r2;

	// Global variables
	protected final double t;
	protected double[][] X;
	protected double[] hv1;
	protected double[] hv2;
	protected double[] hv3;
	protected double[] hv4;
	protected double[] hv5;
	protected double[] hv6;
	protected double[] hv7;

	public H(CartesianMesh2D aMesh, Options aOptions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();

		// User options
		options = aOptions;

		// Initialize variables with default values
		t = 0.0;

		// Allocate arrays
		X = new double[nbNodes][2];
		hv1 = new double[nbCells];
		hv2 = new double[nbCells];
		hv3 = new double[nbCells];
		hv4 = new double[nbCells];
		hv5 = new double[nbCells];
		hv6 = new double[nbCells];
		hv7 = new double[nbCells];

		// Copy node coordinates
		double[][] gNodes = mesh.getGeometry().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes ->
		{
			X[rNodes][0] = gNodes[rNodes][0];
			X[rNodes][1] = gNodes[rNodes][1];
		});
	}

	/**
	 * Job hj1 called @1.0 in simulate method.
	 * In variables: hv2
	 * Out variables: hv3
	 */
	protected void hj1()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			hv3[cCells] = hv2[cCells];
		});
	}

	/**
	 * Job hj2 called @2.0 in simulate method.
	 * In variables: hv3
	 * Out variables: hv5
	 */
	protected void hj2()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			hv5[cCells] = hv3[cCells];
		});
	}

	/**
	 * Job hj3 called @4.0 in simulate method.
	 * In variables: hv4, hv5, hv6
	 * Out variables: hv7
	 */
	protected void hj3()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			hv7[cCells] = hv4[cCells] + hv5[cCells] + hv6[cCells];
		});
	}

	public void simulate()
	{
		System.out.println("Start execution of h");
		hj1(); // @1.0
		r1.rj1(); // @1.0
		hj2(); // @2.0
		r2.rj1(); // @2.0
		r1.rj2(); // @2.0
		r2.rj2(); // @3.0
		hj3(); // @4.0
		System.out.println("End of execution of h");
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
			H.Options hOptions = new H.Options();
			if (o.has("h")) hOptions.jsonInit(o.get("h").toString());
			H h = new H(mesh, hOptions);
			R1.Options r1Options = new R1.Options();
			if (o.has("r1")) r1Options.jsonInit(o.get("r1").toString());
			R1 r1 = new R1(mesh, r1Options);
			r1.setMainModule(h);
			R2.Options r2Options = new R2.Options();
			if (o.has("r2")) r2Options.jsonInit(o.get("r2").toString());
			R2 r2 = new R2(mesh, r2Options);
			r2.setMainModule(h);

			// Start simulation
			h.simulate();

			// Non regression testing
			if (hOptions.nonRegression != null && hOptions.nonRegression.equals("CreateReference"))
				h.createDB("HydroRemapDB.ref");
			if (hOptions.nonRegression != null && hOptions.nonRegression.equals("CompareToReference"))
			{
				h.createDB("HydroRemapDB.current");
				if (!LevelDBUtils.compareDB("HydroRemapDB.current", "HydroRemapDB.ref"))
					ret = 1;
				LevelDBUtils.destroyDB("HydroRemapDB.current");
				System.exit(ret);
			}
		}
		else
		{
			System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.err.println("        Expecting user data file name, for example HydroRemap.json");
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
			batch.put(bytes("h::t"), LevelDBUtils.serialize(t));
			batch.put(bytes("h::X"), LevelDBUtils.serialize(X));
			batch.put(bytes("h::hv1"), LevelDBUtils.serialize(hv1));
			batch.put(bytes("h::hv2"), LevelDBUtils.serialize(hv2));
			batch.put(bytes("h::hv3"), LevelDBUtils.serialize(hv3));
			batch.put(bytes("h::hv4"), LevelDBUtils.serialize(hv4));
			batch.put(bytes("h::hv5"), LevelDBUtils.serialize(hv5));
			batch.put(bytes("h::hv6"), LevelDBUtils.serialize(hv6));
			batch.put(bytes("h::hv7"), LevelDBUtils.serialize(hv7));
			batch.put(bytes("r1::rv3"), LevelDBUtils.serialize(r1.rv3));
			batch.put(bytes("r2::rv2"), LevelDBUtils.serialize(r2.rv2));

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
