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

import org.apache.commons.math3.linear.*;

@SuppressWarnings("all")
public final class MyModule
{
	public final static class Options
	{
		public String outputPath;
		public int outputPeriod;
		public double X_LENGTH;
		public double Y_LENGTH;
		public int X_EDGE_ELEMS;
		public int Y_EDGE_ELEMS;
		public double X_EDGE_LENGTH;
		public double Y_EDGE_LENGTH;
		public int maxIterations;
		public double stopTime;
		public double[] vectOne;

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
	private double t_nplus1;
	private final double deltat;
	private final double rho;
	private final double lambda;
	private int lastDump;

	// Mesh (can depend on previous definitions)
	private final CartesianMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes, nbCells, nbNodesOfCell, nbNeighbourCells;

	// Global declarations
	private int n;
	private double[][] X;
	private double[][] Xc;
	private double[] xc;
	private double[] yc;
	private Vector e_n;
	private Vector e_nplus1;
	private Matrix alpha;

	public MyModule(Options aOptions)
	{
		options = aOptions;

		// Initialize variables with default values
		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat = 0.01;
		rho = 1.0;
		lambda = rho * deltat / (options.X_EDGE_LENGTH) * (options.X_EDGE_LENGTH);
		lastDump = Integer.MIN_VALUE;

		// Initialize mesh variables
		mesh = CartesianMesh2DGenerator.generate(options.X_EDGE_ELEMS, options.Y_EDGE_ELEMS, options.X_EDGE_LENGTH, options.Y_EDGE_LENGTH);
		writer = new PvdFileWriter2D("MyModule", options.outputPath);
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;
		nbNeighbourCells = CartesianMesh2D.MaxNbNeighbourCells;

		// Allocate arrays
		X = new double[nbNodes][2];
		Xc = new double[nbCells][2];
		xc = new double[nbCells];
		yc = new double[nbCells];
		e_n = Vector.createDenseVector(nbCells);
		e_nplus1 = Vector.createDenseVector(nbCells);
		alpha = Matrix.createDenseMatrix(nbCells, nbCells);

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
		computealphaMatrix(); // @1.0
		initXc(); // @1.0
		initE(); // @2.0
		initXcAndYc(); // @2.0
		executeTimeLoopN(); // @3.0
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
	 * Job ComputeTn called @1.0 in executeTimeLoopN method.
	 * In variables: deltat, t_n
	 * Out variables: t_nplus1
	 */
	private void computeTn()
	{
		t_nplus1 = t_n + deltat;
	}

	/**
	 * Job ComputealphaMatrix called @1.0 in simulate method.
	 * In variables: lambda
	 * Out variables: alpha
	 */
	private void computealphaMatrix()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			final int cId = cCells;
			{
				final int[] neighbourCellsC = mesh.getNeighbourCells(cId);
				final int nbNeighbourCellsC = neighbourCellsC.length;
				for (int vNeighbourCellsC=0; vNeighbourCellsC<nbNeighbourCellsC; vNeighbourCellsC++)
				{
					final int vId = neighbourCellsC[vNeighbourCellsC];
					final int vCells = vId;
					alpha.set(cCells, vCells, -lambda);
				}
			}
			alpha.set(cCells, cCells, 4 * lambda + 1);
		});
	}

	/**
	 * Job InitXc called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: Xc
	 */
	private void initXc()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			final int cId = cCells;
			double[] reduction0 = new double[] {0.0, 0.0};
			{
				final int[] nodesOfCellC = mesh.getNodesOfCell(cId);
				final int nbNodesOfCellC = nodesOfCellC.length;
				for (int pNodesOfCellC=0; pNodesOfCellC<nbNodesOfCellC; pNodesOfCellC++)
				{
					final int pId = nodesOfCellC[pNodesOfCellC];
					final int pNodes = pId;
					reduction0 = sumR1(reduction0, X[pNodes]);
				}
			}
			Xc[cCells] = ArrayOperations.multiply(0.25, reduction0);
		});
	}

	/**
	 * Job UpdateE called @1.0 in executeTimeLoopN method.
	 * In variables: alpha, e_n
	 * Out variables: e_nplus1
	 */
	private void updateE()
	{
		e_nplus1 = LinearAlgebraFunctions.solveLinearSystem(alpha, e_n);
	}

	/**
	 * Job InitE called @2.0 in simulate method.
	 * In variables: Xc, vectOne
	 * Out variables: e_n
	 */
	private void initE()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			if (norm(ArrayOperations.minus(Xc[cCells], options.vectOne)) < 0.5)
				e_n.set(cCells, 5.0);
			else
				e_n.set(cCells, 0.0);
		});
	}

	/**
	 * Job InitXcAndYc called @2.0 in simulate method.
	 * In variables: Xc
	 * Out variables: xc, yc
	 */
	private void initXcAndYc()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			xc[cCells] = Xc[cCells][0];
			yc[cCells] = Xc[cCells][1];
		});
	}

	/**
	 * Job ExecuteTimeLoopN called @3.0 in simulate method.
	 * In variables: alpha, deltat, e_n, t_n
	 * Out variables: e_nplus1, t_nplus1
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
			computeTn(); // @1.0
			updateE(); // @1.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options.stopTime && n < options.maxIterations);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double tmp_t_n = t_n;
				t_n = t_nplus1;
				t_nplus1 = tmp_t_n;
				Vector tmp_e_n = e_n;
				e_n = e_nplus1;
				e_nplus1 = tmp_e_n;
			} 
		} while (continueLoop);
		// force a last output at the end
		dumpVariables(n);
	}

	private double norm(double[] a)
	{
		final int x = a.length;
		return Math.sqrt(dot(a, a));
	}

	private double dot(double[] a, double[] b)
	{
		final int x = a.length;
		double result = 0.0;
		for (int i=0; i<x; i++)
		{
			result = result + a[i] * b[i];
		}
		return result;
	}

	private double[] sumR1(double[] a, double[] b)
	{
		final int x = a.length;
		return ArrayOperations.plus(a, b);
	}

	private void dumpVariables(int iteration)
	{
		if (!writer.isDisabled())
		{
			VtkFileContent content = new VtkFileContent(iteration, t_n, X, mesh.getGeometry().getQuads());
			content.addCellVariable("Energy", e_n.toArray());
			writer.writeFile(content);
			lastDump = n;
		}
	}
};
