/* DO NOT EDIT THIS FILE - it is machine generated */

package iteration;

import java.io.FileReader;
import java.io.IOException;
import java.util.stream.IntStream;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonElement;

import fr.cea.nabla.javalib.*;
import fr.cea.nabla.javalib.mesh.*;

public final class Iteration
{
	// Mesh and mesh variables
	private final CartesianMesh2D mesh;
	@SuppressWarnings("unused")
	private final int nbNodes, nbCells;

	// Options and global variables
	int n;
	int k;
	int l;
	static final double maxTime = 0.1;
	static final int maxIter = 500;
	static final int maxIterK = 500;
	static final int maxIterL = 500;
	static final double deltat = 1.0;
	double t_n;
	double t_nplus1;
	double t_n0;
	double[][] X;
	double[] u_n;
	double[] u_nplus1;
	double[] v1_n;
	double[] v1_nplus1;
	double[] v1_nplus1_k;
	double[] v1_nplus1_kplus1;
	double[] v1_nplus1_k0;
	double[] v2_n;
	double[] v2_nplus1;
	double[] v2_n0;
	double[] v2_nplus1_k;
	double[] v2_nplus1_kplus1;
	double[] w_n;
	double[] w_nplus1;
	double[] w_nplus1_l;
	double[] w_nplus1_lplus1;
	double[] w_nplus1_l0;

	public Iteration(CartesianMesh2D aMesh)
	{
		// Mesh and mesh variables initialization
		mesh = aMesh;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
	}

	public void jsonInit(final String jsonContent)
	{
		final Gson gson = new Gson();
		final JsonObject options = gson.fromJson(jsonContent, JsonObject.class);
		X = new double[nbNodes][2];
		u_n = new double[nbCells];
		u_nplus1 = new double[nbCells];
		v1_n = new double[nbCells];
		v1_nplus1 = new double[nbCells];
		v1_nplus1_k = new double[nbCells];
		v1_nplus1_kplus1 = new double[nbCells];
		v1_nplus1_k0 = new double[nbCells];
		v2_n = new double[nbCells];
		v2_nplus1 = new double[nbCells];
		v2_n0 = new double[nbCells];
		v2_nplus1_k = new double[nbCells];
		v2_nplus1_kplus1 = new double[nbCells];
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
		t_nplus1 = t_n + deltat;
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
	 * Job iniV1 called @1.0 in executeTimeLoopN method.
	 * In variables: u_n
	 * Out variables: v1_nplus1_k0
	 */
	protected void iniV1()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			v1_nplus1_k0[cCells] = u_n[cCells] + 1;
		});
	}

	/**
	 * Job iniV2 called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: v2_n0
	 */
	protected void iniV2()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			v2_n0[cCells] = 1.0;
		});
	}

	/**
	 * Job updateV1 called @1.0 in executeTimeLoopK method.
	 * In variables: v1_nplus1_k
	 * Out variables: v1_nplus1_kplus1
	 */
	protected void updateV1()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			v1_nplus1_kplus1[cCells] = v1_nplus1_k[cCells] + 1.5;
		});
	}

	/**
	 * Job updateV2 called @1.0 in executeTimeLoopK method.
	 * In variables: v2_nplus1_k
	 * Out variables: v2_nplus1_kplus1
	 */
	protected void updateV2()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			v2_nplus1_kplus1[cCells] = v2_nplus1_k[cCells] + 2;
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
	 * In variables: v1_nplus1_k0, v2_n
	 * Out variables: v1_nplus1_k, v2_nplus1_k
	 */
	protected void setUpTimeLoopK()
	{
		IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
		{
			v1_nplus1_k[i1Cells] = v1_nplus1_k0[i1Cells];
		});
		IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
		{
			v2_nplus1_k[i1Cells] = v2_n[i1Cells];
		});
	}

	/**
	 * Job setUpTimeLoopN called @2.0 in simulate method.
	 * In variables: t_n0, v2_n0
	 * Out variables: t_n, v2_n
	 */
	protected void setUpTimeLoopN()
	{
		t_n = t_n0;
		IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
		{
			v2_n[i1Cells] = v2_n0[i1Cells];
		});
	}

	/**
	 * Job executeTimeLoopK called @3.0 in executeTimeLoopN method.
	 * In variables: k, maxIterK, v1_nplus1_k, v2_nplus1_k
	 * Out variables: v1_nplus1_kplus1, v2_nplus1_kplus1
	 */
	protected void executeTimeLoopK()
	{
		k = 0;
		boolean continueLoop = true;
		do
		{
			k++;
			System.out.printf("Start iteration k: %5d\n", k);
		
			updateV1(); // @1.0
			updateV2(); // @1.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (k + 1 < maxIterK);
		
			IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
			{
				v1_nplus1_k[i1Cells] = v1_nplus1_kplus1[i1Cells];
			});
			IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
			{
				v2_nplus1_k[i1Cells] = v2_nplus1_kplus1[i1Cells];
			});
		} while (continueLoop);
	}

	/**
	 * Job executeTimeLoopN called @3.0 in simulate method.
	 * In variables: maxIter, maxTime, n, t_n, t_nplus1, u_n, v1_n, v2_n, w_n
	 * Out variables: t_nplus1, u_nplus1, v1_nplus1, v2_nplus1, w_nplus1
	 */
	protected void executeTimeLoopN()
	{
		n = 0;
		boolean continueLoop = true;
		do
		{
			n++;
			System.out.printf("START ITERATION n: %5d - t: %5.5f - deltat: %5.5f\n", n, t_n, deltat);
		
			computeTn(); // @1.0
			iniV1(); // @1.0
			setUpTimeLoopK(); // @2.0
			executeTimeLoopK(); // @3.0
			tearDownTimeLoopK(); // @4.0
			iniW(); // @5.0
			setUpTimeLoopL(); // @6.0
			executeTimeLoopL(); // @7.0
			tearDownTimeLoopL(); // @8.0
			updateU(); // @9.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < maxTime && n + 1 < maxIter);
		
			t_n = t_nplus1;
			IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
			{
				u_n[i1Cells] = u_nplus1[i1Cells];
			});
			IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
			{
				v1_n[i1Cells] = v1_nplus1[i1Cells];
			});
			IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
			{
				v2_n[i1Cells] = v2_nplus1[i1Cells];
			});
			IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
			{
				w_n[i1Cells] = w_nplus1[i1Cells];
			});
		} while (continueLoop);
		
		System.out.printf("FINAL TIME: %5.5f - deltat: %5.5f\n", t_n, deltat);
	}

	/**
	 * Job tearDownTimeLoopK called @4.0 in executeTimeLoopN method.
	 * In variables: v1_nplus1_kplus1, v2_nplus1_kplus1
	 * Out variables: v1_nplus1, v2_nplus1
	 */
	protected void tearDownTimeLoopK()
	{
		IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
		{
			v1_nplus1[i1Cells] = v1_nplus1_kplus1[i1Cells];
		});
		IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
		{
			v2_nplus1[i1Cells] = v2_nplus1_kplus1[i1Cells];
		});
	}

	/**
	 * Job iniW called @5.0 in executeTimeLoopN method.
	 * In variables: v1_nplus1
	 * Out variables: w_nplus1_l0
	 */
	protected void iniW()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			w_nplus1_l0[cCells] = v1_nplus1[cCells];
		});
	}

	/**
	 * Job setUpTimeLoopL called @6.0 in executeTimeLoopN method.
	 * In variables: w_nplus1_l0
	 * Out variables: w_nplus1_l
	 */
	protected void setUpTimeLoopL()
	{
		IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
		{
			w_nplus1_l[i1Cells] = w_nplus1_l0[i1Cells];
		});
	}

	/**
	 * Job executeTimeLoopL called @7.0 in executeTimeLoopN method.
	 * In variables: l, maxIterL, w_nplus1_l
	 * Out variables: w_nplus1_lplus1
	 */
	protected void executeTimeLoopL()
	{
		l = 0;
		boolean continueLoop = true;
		do
		{
			l++;
			System.out.printf("Start iteration l: %5d\n", l);
		
			updateW(); // @1.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (l + 1 < maxIterL);
		
			IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
			{
				w_nplus1_l[i1Cells] = w_nplus1_lplus1[i1Cells];
			});
		} while (continueLoop);
	}

	/**
	 * Job tearDownTimeLoopL called @8.0 in executeTimeLoopN method.
	 * In variables: w_nplus1_lplus1
	 * Out variables: w_nplus1
	 */
	protected void tearDownTimeLoopL()
	{
		IntStream.range(0, nbCells).parallel().forEach(i1Cells -> 
		{
			w_nplus1[i1Cells] = w_nplus1_lplus1[i1Cells];
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
		System.out.println("Start execution of iteration");
		iniTime(); // @1.0
		iniU(); // @1.0
		iniV2(); // @1.0
		setUpTimeLoopN(); // @2.0
		executeTimeLoopN(); // @3.0
		System.out.println("End of execution of iteration");
	}

	public static void main(String[] args) throws IOException
	{
		if (args.length == 1)
		{
			final String dataFileName = args[0];
			final Gson gson = new Gson();
			final JsonObject o = gson.fromJson(new FileReader(dataFileName), JsonObject.class);

			// Mesh instanciation
			assert(o.has("mesh"));
			CartesianMesh2D mesh = new CartesianMesh2D();
			mesh.jsonInit(o.get("mesh").toString());

			// Module instanciation(s)
			Iteration iteration = new Iteration(mesh);
			if (o.has("iteration")) iteration.jsonInit(o.get("iteration").toString());

			// Start simulation
			iteration.simulate();
		}
		else
		{
			System.err.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.err.println("        Expecting user data file name, for example Iteration.json");
			System.exit(1);
		}
	}
};
