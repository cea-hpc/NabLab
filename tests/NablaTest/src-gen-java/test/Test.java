package test;

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
public final class Test
{
	public final static class Options
	{
		public double maxTime;
		public int maxIter;
		public double X_EDGE_LENGTH;
		public double Y_EDGE_LENGTH;
		public int X_EDGE_ELEMS;
		public int Y_EDGE_ELEMS;
		public double deltat;

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

	// Mesh (can depend on previous definitions)
	private final CartesianMesh2D mesh;
	private final int nbNodes, nbCells;

	// Global declarations
	private int n;
	private int k;
	private double[][] X;
	private double[] e1;
	private double[] e2_n;
	private double[] e2_nplus1;
	private double[] e2_nplus1_k;
	private double[] e2_nplus1_kplus1;
	private double[] e2_nplus1_k0;
	private double[] e_n;
	private double[] e_nplus1;
	private double[] e_n0;

	public Test(Options aOptions)
	{
		options = aOptions;

		// Initialize variables with default values
		t_n = 0.0;
		t_nplus1 = 0.0;

		// Initialize mesh variables
		mesh = CartesianMesh2DGenerator.generate(options.X_EDGE_ELEMS, options.Y_EDGE_ELEMS, options.X_EDGE_LENGTH, options.Y_EDGE_LENGTH);
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();

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
		System.out.println("Start execution of module Test");
		initE(); // @1.0
		setUpTimeLoopN(); // @2.0
		executeTimeLoopN(); // @3.0
		System.out.println("End of execution of module Test");
	}

	public static void main(String[] args) throws FileNotFoundException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			Test.Options options = Test.Options.createOptions(dataFileName);
			Test simulator = new Test(options);
			simulator.simulate();
		}
		else
		{
			System.out.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.out.println("        Expecting user data file name, for example TestDefaultOptions.json");
		}
	}

	/**
	 * Job computeE1 called @1.0 in executeTimeLoopN method.
	 * In variables: e_n
	 * Out variables: e1
	 */
	private void computeE1()
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
	private void computeE2()
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
	private void initE()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e_n0[cCells] = 0.0;
		});
	}

	/**
	 * Job updateT called @1.0 in executeTimeLoopN method.
	 * In variables: deltat, t_n
	 * Out variables: t_nplus1
	 */
	private void updateT()
	{
		t_nplus1 = t_n + options.deltat;
	}

	/**
	 * Job InitE2 called @2.0 in executeTimeLoopN method.
	 * In variables: e1
	 * Out variables: e2_nplus1_k0
	 */
	private void initE2()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e2_nplus1_k0[cCells] = e1[cCells];
		});
	}

	/**
	 * Job SetUpTimeLoopN called @2.0 in simulate method.
	 * In variables: e_n0
	 * Out variables: e_n
	 */
	private void setUpTimeLoopN()
	{
		IntStream.range(0, e_n.length).parallel().forEach(i1 -> 
		{
			e_n[i1] = e_n0[i1];
		});
	}

	/**
	 * Job ExecuteTimeLoopN called @3.0 in simulate method.
	 * In variables: deltat, e1, e2_nplus1, e2_nplus1_k, e2_nplus1_k0, e2_nplus1_kplus1, e_n, t_n
	 * Out variables: e1, e2_nplus1, e2_nplus1_k, e2_nplus1_k0, e2_nplus1_kplus1, e_nplus1, t_nplus1
	 */
	private void executeTimeLoopN()
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
	 * Job SetUpTimeLoopK called @3.0 in executeTimeLoopN method.
	 * In variables: e2_nplus1_k0
	 * Out variables: e2_nplus1_k
	 */
	private void setUpTimeLoopK()
	{
		IntStream.range(0, e2_nplus1_k.length).parallel().forEach(i1 -> 
		{
			e2_nplus1_k[i1] = e2_nplus1_k0[i1];
		});
	}

	/**
	 * Job ExecuteTimeLoopK called @4.0 in executeTimeLoopN method.
	 * In variables: e2_nplus1_k
	 * Out variables: e2_nplus1_kplus1
	 */
	private void executeTimeLoopK()
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
	 * Job TearDownTimeLoopK called @5.0 in executeTimeLoopN method.
	 * In variables: e2_nplus1_kplus1
	 * Out variables: e2_nplus1
	 */
	private void tearDownTimeLoopK()
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
	private void updateE()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			e_nplus1[cCells] = e2_nplus1[cCells] - 3;
		});
	}
};
