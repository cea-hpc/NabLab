package heatequation;

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
public final class HeatEquation
{
	public final static class Options
	{
		public String outputPath;
		public int outputPeriod;
		public double stopTime;
		public int maxIterations;
		public double X_EDGE_LENGTH;
		public double Y_EDGE_LENGTH;
		public int X_EDGE_ELEMS;
		public int Y_EDGE_ELEMS;
		public double PI;
		public double alpha;

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
	private int lastDump;

	// Mesh (can depend on previous definitions)
	private final CartesianMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes, nbCells, nbFaces, nbNeighbourCells, nbNodesOfFace, nbNodesOfCell;

	// Global declarations
	private int n;
	private double[][] X;
	private double[][] center;
	private double[] u_n;
	private double[] u_nplus1;
	private double[] V;
	private double[] f;
	private double[] outgoingFlux;
	private double[] surface;

	public HeatEquation(Options aOptions)
	{
		options = aOptions;

		// Initialize variables with default values
		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat = 0.001;
		lastDump = Integer.MIN_VALUE;

		// Initialize mesh variables
		mesh = CartesianMesh2DGenerator.generate(options.X_EDGE_ELEMS, options.Y_EDGE_ELEMS, options.X_EDGE_LENGTH, options.Y_EDGE_LENGTH);
		writer = new PvdFileWriter2D("HeatEquation", options.outputPath);
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbFaces = mesh.getNbFaces();
		nbNeighbourCells = CartesianMesh2D.MaxNbNeighbourCells;
		nbNodesOfFace = CartesianMesh2D.MaxNbNodesOfFace;
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;

		// Allocate arrays
		X = new double[nbNodes][2];
		center = new double[nbCells][2];
		u_n = new double[nbCells];
		u_nplus1 = new double[nbCells];
		V = new double[nbCells];
		f = new double[nbCells];
		outgoingFlux = new double[nbCells];
		surface = new double[nbFaces];

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
		System.out.println("Start execution of module HeatEquation");
		computeSurface(); // @1.0
		computeV(); // @1.0
		iniCenter(); // @1.0
		iniF(); // @1.0
		iniUn(); // @2.0
		executeTimeLoopN(); // @3.0
		System.out.println("End of execution of module HeatEquation");
	}

	public static void main(String[] args) throws FileNotFoundException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			HeatEquation.Options options = HeatEquation.Options.createOptions(dataFileName);
			HeatEquation simulator = new HeatEquation(options);
			simulator.simulate();
		}
		else
		{
			System.out.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.out.println("        Expecting user data file name, for example HeatEquationDefaultOptions.json");
		}
	}

	/**
	 * Job ComputeOutgoingFlux called @1.0 in executeTimeLoopN method.
	 * In variables: V, center, deltat, surface, u_n
	 * Out variables: outgoingFlux
	 */
	private void computeOutgoingFlux()
	{
		IntStream.range(0, nbCells).parallel().forEach(j1Cells -> 
		{
			final int j1Id = j1Cells;
			double reduction0 = 0.0;
			{
				final int[] neighbourCellsJ1 = mesh.getNeighbourCells(j1Id);
				final int nbNeighbourCellsJ1 = neighbourCellsJ1.length;
				for (int j2NeighbourCellsJ1=0; j2NeighbourCellsJ1<nbNeighbourCellsJ1; j2NeighbourCellsJ1++)
				{
					final int j2Id = neighbourCellsJ1[j2NeighbourCellsJ1];
					final int j2Cells = j2Id;
					final int cfId = mesh.getCommonFace(j1Id, j2Id);
					final int cfFaces = cfId;
					reduction0 = sumR0(reduction0, (u_n[j2Cells] - u_n[j1Cells]) / norm(ArrayOperations.minus(center[j2Cells], center[j1Cells])) * surface[cfFaces]);
				}
			}
			outgoingFlux[j1Cells] = deltat / V[j1Cells] * reduction0;
		});
	}

	/**
	 * Job ComputeSurface called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: surface
	 */
	private void computeSurface()
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			final int fId = fFaces;
			double reduction0 = 0.0;
			{
				final int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
				final int nbNodesOfFaceF = nodesOfFaceF.length;
				for (int rNodesOfFaceF=0; rNodesOfFaceF<nbNodesOfFaceF; rNodesOfFaceF++)
				{
					final int rId = nodesOfFaceF[rNodesOfFaceF];
					final int rPlus1Id = nodesOfFaceF[(rNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace];
					final int rNodes = rId;
					final int rPlus1Nodes = rPlus1Id;
					reduction0 = sumR0(reduction0, norm(ArrayOperations.minus(X[rNodes], X[rPlus1Nodes])));
				}
			}
			surface[fFaces] = 0.5 * reduction0;
		});
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
	 * Job ComputeV called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: V
	 */
	private void computeV()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			final int jId = jCells;
			double reduction0 = 0.0;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					final int rNodes = rId;
					final int rPlus1Nodes = rPlus1Id;
					reduction0 = sumR0(reduction0, det(X[rNodes], X[rPlus1Nodes]));
				}
			}
			V[jCells] = 0.5 * reduction0;
		});
	}

	/**
	 * Job IniCenter called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: center
	 */
	private void iniCenter()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			final int jId = jCells;
			double[] reduction0 = new double[] {0.0, 0.0};
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rNodes = rId;
					reduction0 = sumR1(reduction0, X[rNodes]);
				}
			}
			center[jCells] = ArrayOperations.multiply(0.25, reduction0);
		});
	}

	/**
	 * Job IniF called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: f
	 */
	private void iniF()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			f[jCells] = 0.0;
		});
	}

	/**
	 * Job ComputeUn called @2.0 in executeTimeLoopN method.
	 * In variables: deltat, f, outgoingFlux, u_n
	 * Out variables: u_nplus1
	 */
	private void computeUn()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			u_nplus1[jCells] = f[jCells] * deltat + u_n[jCells] + outgoingFlux[jCells];
		});
	}

	/**
	 * Job IniUn called @2.0 in simulate method.
	 * In variables: PI, alpha, center
	 * Out variables: u_n
	 */
	private void iniUn()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			u_n[jCells] = Math.cos(2 * options.PI * options.alpha * center[jCells][0]);
		});
	}

	/**
	 * Job ExecuteTimeLoopN called @3.0 in simulate method.
	 * In variables: V, center, deltat, f, outgoingFlux, surface, t_n, u_n
	 * Out variables: outgoingFlux, t_nplus1, u_nplus1
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
			computeOutgoingFlux(); // @1.0
			computeTn(); // @1.0
			computeUn(); // @2.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options.stopTime && n + 1 < options.maxIterations);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double tmp_t_n = t_n;
				t_n = t_nplus1;
				t_nplus1 = tmp_t_n;
				double[] tmp_u_n = u_n;
				u_n = u_nplus1;
				u_nplus1 = tmp_u_n;
			} 
		} while (continueLoop);
		// force a last output at the end
		dumpVariables(n);
	}

	private double det(double[] a, double[] b)
	{
		return (a[0] * b[1] - a[1] * b[0]);
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

	private double sumR0(double a, double b)
	{
		return a + b;
	}

	private void dumpVariables(int iteration)
	{
		if (!writer.isDisabled())
		{
			VtkFileContent content = new VtkFileContent(iteration, t_n, X, mesh.getGeometry().getQuads());
			content.addCellVariable("Temperature", u_n);
			writer.writeFile(content);
			lastDump = n;
		}
	}
};
