package mymodule;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.HashMap;
import java.util.stream.IntStream;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.stream.JsonReader;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class MyModule
{
	public final static class Options
	{
		public String outputPath;
		public int outputPeriod;
		public double X_EDGE_LENGTH;
		public double Y_EDGE_LENGTH;
		public int X_EDGE_ELEMS;
		public int Y_EDGE_ELEMS;
		public int maxIter;
		public double maxTime;

		public static Options createOptions(String jsonFileName) throws FileNotFoundException
		{
			Gson gson = new Gson();
			JsonReader reader = new JsonReader(new FileReader(jsonFileName));
			return gson.fromJson(reader, Options.class);
		}
	}

	private final Options options;

	// Global definitions
	private double t_n;
	private final double t_nplus1;
	private final double deltat;
	private final double v;
	private int lastDump;

	// Mesh (can depend on previous definitions)
	private final CartesianMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes, nbCells, nbNeighbourCells, nbNodesOfCell;

	// Global declarations
	private int n;
	private double[][] X;
	private double[][] Xc;
	private double[] xc;
	private double[] yc;
	private double[] e;
	private double[][] alpha;

	public MyModule(Options aOptions)
	{
		options = aOptions;

		// Initialize variables with default values
		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat = 0.01;
		v = 1.0;
		lastDump = Integer.MIN_VALUE;

		// Initialize mesh variables
		mesh = CartesianMesh2DGenerator.generate(options.X_EDGE_ELEMS, options.Y_EDGE_ELEMS, options.X_EDGE_LENGTH, options.Y_EDGE_LENGTH);
		writer = new PvdFileWriter2D("MyModule", options.outputPath);
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbNeighbourCells = CartesianMesh2D.MaxNbNeighbourCells;
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;

		// Allocate arrays
		X = new double[nbNodes][2];
		Xc = new double[nbCells][2];
		xc = new double[nbCells];
		yc = new double[nbCells];
		e = new double[nbNodes];
		alpha = new double[nbCells][nbCells];

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
		System.out.println("Start execution of module MyModule");
		executeTimeLoopN(); // @1.0
		initE(); // @1.0
		System.out.println("End of execution of module MyModule");
	}

	public static void main(String[] args) throws FileNotFoundException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			MyModule.Options options = MyModule.Options.createOptions(dataFileName);
			MyModule simulator = new MyModule(options);
			simulator.simulate();
		}
		else
		{
			System.out.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.out.println("        Expecting user data file name, for example MyModuleDefaultOptions.json");
		}
	}

	/**
	 * Job ExecuteTimeLoopN called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: 
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
		
			// Evaluate loop condition with variables at time n
			continueLoop = (n + 1 < options.maxIter && t_nplus1 < options.maxTime);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double tmp_t_n = t_n;
				t_n = t_nplus1;
				t_nplus1 = tmp_t_n;
			} 
		} while (continueLoop);
		// force a last output at the end
		dumpVariables(n);
	}

	/**
	 * Job InitE called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: e
	 */
	private void initE()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			final int cId = cCells;
			final int cNodes = cId;
			e[cNodes] = 0.0;
		});
	}

	private void dumpVariables(int iteration)
	{
		if (!writer.isDisabled())
		{
			VtkFileContent content = new VtkFileContent(iteration, t_n, X, mesh.getGeometry().getQuads());
			content.addNodeVariable("Energy", e);
			writer.writeFile(content);
			lastDump = n;
		}
	}
};
