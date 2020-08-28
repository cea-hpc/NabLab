package depthinit;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.HashMap;
import java.util.stream.IntStream;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.stream.JsonReader;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class DepthInit
{
	public final static class Options
	{
		public double maxTime;
		public int maxIter;
		public double deltat;
	}

	// Mesh and mesh variables
	private final CartesianMesh2D mesh;
	private final int nbCells, nbNodes;

	// User options and external classes
	private final Options options;
	private DepthInitFunctions depthInitFunctions;

	// Global definitions
	private final double t;

	// Global declarations
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

	public static void main(String[] args) throws FileNotFoundException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			JsonParser parser = new JsonParser();
			JsonObject o = parser.parse(new FileReader(dataFileName)).getAsJsonObject();
			Gson gson = new Gson();

			assert(o.has("mesh"));
			CartesianMesh2DFactory meshFactory = gson.fromJson(o.get("mesh"), CartesianMesh2DFactory.class);
			CartesianMesh2D mesh = meshFactory.create();
			assert(o.has("options"));
			DepthInit.Options options = gson.fromJson(o.get("options"), DepthInit.Options.class);
			DepthInitFunctions depthInitFunctions = (o.has("depthInitFunctions") ? gson.fromJson(o.get("depthInitFunctions"), DepthInitFunctions.class) : new DepthInitFunctions());

			DepthInit simulator = new DepthInit(mesh, options, depthInitFunctions);
			simulator.simulate();
		}
		else
		{
			System.out.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.out.println("        Expecting user data file name, for example DepthInitDefaultOptions.json");
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
};
