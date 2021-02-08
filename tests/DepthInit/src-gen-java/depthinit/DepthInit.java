/*** GENERATED FILE - DO NOT OVERWRITE ***/

package depthinit;

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
public final class DepthInit
{
	public final static class Options
	{
		public double maxTime;
		public int maxIter;
		public double deltat;
		public batilib.BatiLibJava batiLib;
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
			// batiLib
			batiLib = new batilib.BatiLibJava();
			if (o.has("batiLib"))
				batiLib.jsonInit(o.get("batiLib").toString());
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
	protected final double t;
	protected double[][] X;
	protected double[] eta;

	public DepthInit(CartesianMesh2D aMesh, Options aOptions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbCells = mesh.getNbCells();
		nbNodes = mesh.getNbNodes();

		// User options
		options = aOptions;

		// Initialize variables with default values
		t = 0.0;

		// Allocate arrays
		X = new double[nbNodes][2];
		eta = new double[nbCells];

		// Copy node coordinates
		double[][] gNodes = mesh.getGeometry().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes ->
		{
			X[rNodes][0] = gNodes[rNodes][0];
			X[rNodes][1] = gNodes[rNodes][1];
		});
	}

	/**
	 * Job initFromFile called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: eta
	 */
	protected void initFromFile()
	{
		for (int jCells=0; jCells<nbCells; jCells++)
		{
			eta[jCells] = options.batiLib.nextWaveHeight();
		}
	}

	public void simulate()
	{
		System.out.println("Start execution of depthInit");
		initFromFile(); // @1.0
		System.out.println("End of execution of depthInit");
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
			DepthInit.Options depthInitOptions = new DepthInit.Options();
			if (o.has("depthInit")) depthInitOptions.jsonInit(o.get("depthInit").toString());
			DepthInit depthInit = new DepthInit(mesh, depthInitOptions);

			// Start simulation
			depthInit.simulate();

			// Non regression testing
			if (depthInitOptions.nonRegression != null && depthInitOptions.nonRegression.equals("CreateReference"))
				depthInit.createDB("DepthInitDB.ref");
			if (depthInitOptions.nonRegression != null && depthInitOptions.nonRegression.equals("CompareToReference"))
			{
				depthInit.createDB("DepthInitDB.current");
				if (!LevelDBUtils.compareDB("DepthInitDB.current", "DepthInitDB.ref"))
					ret = 1;
				LevelDBUtils.destroyDB("DepthInitDB.current");
				System.exit(ret);
			}
		}
		else
		{
			System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.err.println("        Expecting user data file name, for example DepthInit.json");
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
			batch.put(bytes("t"), LevelDBUtils.serialize(t));
			batch.put(bytes("X"), LevelDBUtils.serialize(X));
			batch.put(bytes("eta"), LevelDBUtils.serialize(eta));

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
