package depthinit;

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
public final class DepthInit
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
	private final int nbCells, nbNodes;

	// User options and external classes
	private final Options options;
	private DepthInitFunctions depthInitFunctions;

	// Global variables
	private final double t;
	private double[][] X;
	private double[] eta;

	public DepthInit(CartesianMesh2D aMesh, Options aOptions, DepthInitFunctions aDepthInitFunctions)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbCells = mesh.getNbCells();
		nbNodes = mesh.getNbNodes();

		// User options and external classes initialization
		options = aOptions;
		depthInitFunctions = aDepthInitFunctions;

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

	public void simulate()
	{
		System.out.println("Start execution of module DepthInit");
		initFromFile(); // @1.0
		System.out.println("End of execution of module DepthInit");
	}

	public static void main(String[] args) throws IOException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			JsonParser parser = new JsonParser();
			JsonObject o = parser.parse(new FileReader(dataFileName)).getAsJsonObject();
			GsonBuilder gsonBuilder = new GsonBuilder();
			gsonBuilder.registerTypeAdapter(Options.class, new DepthInit.OptionsDeserializer());
			Gson gson = gsonBuilder.create();

			assert(o.has("mesh"));
			CartesianMesh2DFactory meshFactory = gson.fromJson(o.get("mesh"), CartesianMesh2DFactory.class);
			CartesianMesh2D mesh = meshFactory.create();
			assert(o.has("options"));
			DepthInit.Options options = gson.fromJson(o.get("options"), DepthInit.Options.class);
			DepthInitFunctions depthInitFunctions = (o.has("depthInitFunctions") ? gson.fromJson(o.get("depthInitFunctions"), DepthInitFunctions.class) : new DepthInitFunctions());

			DepthInit simulator = new DepthInit(mesh, options, depthInitFunctions);
			simulator.simulate();

			// Non regression testing
			if (options.nonRegression!=null &&  options.nonRegression.equals("CreateReference"))
				simulator.createDB("DepthInitDB.ref");
			if (options.nonRegression!=null &&  options.nonRegression.equals("CompareToReference"))
			{
				simulator.createDB("DepthInitDB.current");
				LevelDBUtils.compareDB("DepthInitDB.current", "DepthInitDB.ref");
				LevelDBUtils.destroyDB("DepthInitDB.current");
			}
		}
		else
		{
			System.out.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.out.println("        Expecting user data file name, for example DepthInitDefault.json");
		}
	}

	/**
	 * Job initFromFile called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: eta
	 */
	private void initFromFile()
	{
		for (int jCells=0; jCells<nbCells; jCells++)
		{
			eta[jCells] = depthInitFunctions.nextWaveHeight();
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
