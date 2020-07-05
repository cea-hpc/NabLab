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
		public double X_EDGE_LENGTH;
		public double Y_EDGE_LENGTH;
		public int X_EDGE_ELEMS;
		public int Y_EDGE_ELEMS;
		public double maxTime;
		public int maxIter;
		public double deltat;
	}

	private final Options options;
	private DepthInitFunctions depthInit;

	// Global definitions
	private final double t;

	// Mesh (can depend on previous definitions)
	private final CartesianMesh2D mesh;
	private final int nbCells, nbNodes;

	// Global declarations
	private double[][] X;
	private double[] eta;

	public DepthInit(Options aOptions, DepthInitFunctions aDepthInit)
	{
		options = aOptions;
		depthInit = aDepthInit;

		// Initialize variables with default values
		t = 0.0;

		// Initialize mesh variables
		mesh = CartesianMesh2DGenerator.generate(options.X_EDGE_ELEMS, options.Y_EDGE_ELEMS, options.X_EDGE_LENGTH, options.Y_EDGE_LENGTH);
		nbCells = mesh.getNbCells();
		nbNodes = mesh.getNbNodes();

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

			DepthInit.Options options = (o.has("options") ? gson.fromJson(o.get("options"), DepthInit.Options.class) : new DepthInit.Options());
			DepthInitFunctions depthInit = (o.has("depthInit") ? gson.fromJson(o.get("depthInit"), DepthInitFunctions.class) : new DepthInitFunctions());

			DepthInit simulator = new DepthInit(options, depthInit);
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
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			eta[jCells] = depthInit.nextWaveHeight();
		});
	}
};
