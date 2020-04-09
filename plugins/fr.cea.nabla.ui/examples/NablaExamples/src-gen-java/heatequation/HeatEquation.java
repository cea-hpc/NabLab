package heatequation;

import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class HeatEquation
{
	public final static class Options
	{
		public final double X_EDGE_LENGTH = 0.1;
		public final double Y_EDGE_LENGTH = X_EDGE_LENGTH;
		public final int X_EDGE_ELEMS = 20;
		public final int Y_EDGE_ELEMS = 20;
		public final double option_stoptime = 0.1;
		public final int option_max_iterations = 500;
		public final double PI = 3.1415926;
		public final double alpha = 1.0;
	}

	private final Options options;

	// Mesh
	private final CartesianMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbNeighbourCells;

	// Global Variables
	private int n, lastDump;
	private double t_n, t_nplus1, deltat;

	// Connectivity Variables
	private double[][] X, center;
	private double[] u_n, u_nplus1, V, f, outgoingFlux, surface;

	public HeatEquation(Options aOptions, CartesianMesh2D aCartesianMesh2D)
	{
		options = aOptions;
		mesh = aCartesianMesh2D;
		writer = new PvdFileWriter2D("HeatEquation");
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbFaces = mesh.getNbFaces();
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;
		nbNodesOfFace = CartesianMesh2D.MaxNbNodesOfFace;
		nbNeighbourCells = CartesianMesh2D.MaxNbNeighbourCells;

		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat = 0.001;
		lastDump = Integer.MIN_VALUE;

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
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> {
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

	public static void main(String[] args)
	{
		HeatEquation.Options o = new HeatEquation.Options();
		CartesianMesh2D mesh = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		HeatEquation i = new HeatEquation(o, mesh);
		i.simulate();
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
			double reduction3 = 0.0;
			{
				final int[] neighbourCellsJ1 = mesh.getNeighbourCells(j1Id);
				final int nbNeighbourCellsJ1 = neighbourCellsJ1.length;
				for (int j2NeighbourCellsJ1=0; j2NeighbourCellsJ1<nbNeighbourCellsJ1; j2NeighbourCellsJ1++)
				{
					final int j2Id = neighbourCellsJ1[j2NeighbourCellsJ1];
					final int j2Cells = j2Id;
					final int cfId = mesh.getCommonFace(j1Id, j2Id);
					final int cfFaces = cfId;
					reduction3 = sumR0(reduction3, (u_n[j2Cells] - u_n[j1Cells]) / MathFunctions.norm(ArrayOperations.minus(center[j2Cells], center[j1Cells])) * surface[cfFaces]);
				}
			}
			outgoingFlux[j1Cells] = deltat / V[j1Cells] * reduction3;
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
			double reduction2 = 0.0;
			{
				final int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
				final int nbNodesOfFaceF = nodesOfFaceF.length;
				for (int rNodesOfFaceF=0; rNodesOfFaceF<nbNodesOfFaceF; rNodesOfFaceF++)
				{
					final int rId = nodesOfFaceF[rNodesOfFaceF];
					final int rPlus1Id = nodesOfFaceF[(rNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace];
					final int rNodes = rId;
					final int rPlus1Nodes = rPlus1Id;
					reduction2 = sumR0(reduction2, MathFunctions.norm(ArrayOperations.minus(X[rNodes], X[rPlus1Nodes])));
				}
			}
			surface[fFaces] = 0.5 * reduction2;
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
			double reduction1 = 0.0;
			{
				final int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				final int nbNodesOfCellJ = nodesOfCellJ.length;
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					final int rId = nodesOfCellJ[rNodesOfCellJ];
					final int rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					final int rNodes = rId;
					final int rPlus1Nodes = rPlus1Id;
					reduction1 = sumR0(reduction1, MathFunctions.det(X[rNodes], X[rPlus1Nodes]));
				}
			}
			V[jCells] = 0.5 * reduction1;
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
			u_n[jCells] = MathFunctions.cos(2 * options.PI * options.alpha * center[jCells][0]);
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
			dumpVariables(n);
			computeOutgoingFlux(); // @1.0
			computeTn(); // @1.0
			computeUn(); // @2.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options.option_stoptime && n + 1 < options.option_max_iterations);
		
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
		if (n >= lastDump + 1.0)
		{
			HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
			HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
			cellVariables.put("Temperature", u_n);
			writer.writeFile(iteration, t_n, X, mesh.getGeometry().getQuads(), cellVariables, nodeVariables);
			lastDump = n;
		}
	}
};
