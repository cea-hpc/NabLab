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
		public final int Z_EDGE_ELEMS = 1;
		public final double option_stoptime = 0.1;
		public final int option_max_iterations = 500;
		public final double PI = 3.1415926;
		public final double alpha = 1.0;
	}

	private final Options options;

	// Mesh
	private final NumericMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbNeighbourCells;

	// Global Variables
	private double t_n, t_nplus1, deltat;
	private int iterationN, lastDump;

	// Connectivity Variables
	private double[][] X, center;
	private double[] u_n, u_nplus1, V, f, outgoingFlux, surface;

	public HeatEquation(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		writer = new PvdFileWriter2D("HeatEquation");
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbFaces = mesh.getNbFaces();
		nbNodesOfCell = NumericMesh2D.MaxNbNodesOfCell;
		nbNodesOfFace = NumericMesh2D.MaxNbNodesOfFace;
		nbNeighbourCells = NumericMesh2D.MaxNbNeighbourCells;

		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat = 0.001;
		lastDump = iterationN;

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
		ArrayList<double[]> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X[rNodes] = gNodes.get(rNodes));
	}

	public void simulate()
	{
		System.out.println("Début de l'exécution du module HeatEquation");
		iniF(); // @1.0
		iniCenter(); // @1.0
		computeV(); // @1.0
		computeSurface(); // @1.0
		iniUn(); // @2.0
		executeTimeLoopN(); // @3.0
		System.out.println("Fin de l'exécution du module HeatEquation");
	}

	public static void main(String[] args)
	{
		HeatEquation.Options o = new HeatEquation.Options();
		Mesh gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		HeatEquation i = new HeatEquation(o, nm);
		i.simulate();
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
	 * Job IniCenter called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: center
	 */
	private void iniCenter()
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double[] reduction0 = {0.0, 0.0};
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					reduction0 = ArrayOperations.plus(reduction0, (X[rNodes]));
				}
			}
			center[jCells] = ArrayOperations.multiply(0.25, reduction0);
		});
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
			int jId = jCells;
			double reduction1 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					int rNodes = rId;
					int rPlus1Nodes = rPlus1Id;
					reduction1 = reduction1 + (MathFunctions.det(X[rNodes], X[rPlus1Nodes]));
				}
			}
			V[jCells] = 0.5 * reduction1;
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
			int fId = fFaces;
			double reduction2 = 0.0;
			{
				int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
				for (int rNodesOfFaceF=0; rNodesOfFaceF<nodesOfFaceF.length; rNodesOfFaceF++)
				{
					int rId = nodesOfFaceF[rNodesOfFaceF];
					int rPlus1Id = nodesOfFaceF[(rNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace];
					int rNodes = rId;
					int rPlus1Nodes = rPlus1Id;
					reduction2 = reduction2 + (MathFunctions.norm(ArrayOperations.minus(X[rNodes], X[rPlus1Nodes])));
				}
			}
			surface[fFaces] = 0.5 * reduction2;
		});
	}

	/**
	 * Job ComputeOutgoingFlux called @1.0 in executeTimeLoopN method.
	 * In variables: u_n, center, surface, deltat, V
	 * Out variables: outgoingFlux
	 */
	private void computeOutgoingFlux()
	{
		IntStream.range(0, nbCells).parallel().forEach(j1Cells -> 
		{
			int j1Id = j1Cells;
			double reduction3 = 0.0;
			{
				int[] neighbourCellsJ1 = mesh.getNeighbourCells(j1Id);
				for (int j2NeighbourCellsJ1=0; j2NeighbourCellsJ1<neighbourCellsJ1.length; j2NeighbourCellsJ1++)
				{
					int j2Id = neighbourCellsJ1[j2NeighbourCellsJ1];
					int j2Cells = j2Id;
					int cfCommonFaceJ1J2 = mesh.getCommonFace(j1Id, j2Id);
					int cfId = cfCommonFaceJ1J2;
					int cfFaces = cfId;
					reduction3 = reduction3 + ((u_n[j2Cells] - u_n[j1Cells]) / MathFunctions.norm(ArrayOperations.minus(center[j2Cells], center[j1Cells])) * surface[cfFaces]);
				}
			}
			outgoingFlux[j1Cells] = deltat / V[j1Cells] * reduction3;
		});
	}

	/**
	 * Job ComputeTn called @1.0 in executeTimeLoopN method.
	 * In variables: t_n, deltat
	 * Out variables: t_nplus1
	 */
	private void computeTn()
	{
		t_nplus1 = t_n + deltat;
	}

	/**
	 * Job dumpVariables called @1.0 in executeTimeLoopN method.
	 * In variables: u_n, iterationN
	 * Out variables: 
	 */
	private void dumpVariables()
	{
		if (iterationN >= lastDump)
		{
			HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
			HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
			cellVariables.put("Temperature", u_n);
			writer.writeFile(iterationN, t_n, X, mesh.getGeometricMesh().getQuads(), cellVariables, nodeVariables);
			lastDump = iterationN;
		}
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
	 * Job ComputeUn called @2.0 in executeTimeLoopN method.
	 * In variables: f, deltat, u_n, outgoingFlux
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
	 * Job executeTimeLoopN called @3.0 in simulate method.
	 * In variables: deltat, iterationN, surface, outgoingFlux, V, f, center, t_n, u_n
	 * Out variables: u_nplus1, t_nplus1, outgoingFlux
	 */
	private void executeTimeLoopN()
	{
		iterationN = 0;
		do
		{
			iterationN++;
			System.out.println("[iterationN : " + iterationN + "] t : " + t_n);
			dumpVariables(); // @1.0
			computeOutgoingFlux(); // @1.0
			computeTn(); // @1.0
			computeUn(); // @2.0
		
			// Switch variables to prepare next iteration
			double tmpT_n = t_n;
			t_n = t_nplus1;
			t_nplus1 = tmpT_n;
			double[] tmpU_n = u_n;
			u_n = u_nplus1;
			u_nplus1 = tmpU_n;
		} while ((t_n < options.option_stoptime && iterationN < options.option_max_iterations));
	}
};
