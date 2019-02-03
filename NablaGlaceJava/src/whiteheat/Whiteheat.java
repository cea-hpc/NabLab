package whiteheat;

import java.util.HashMap;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.Utils;
import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class Whiteheat
{
	public final static class Options
	{
		public final double LENGTH = 1.0;
		public final int X_EDGE_ELEMS = 8;
		public final int Y_EDGE_ELEMS = 8;
		public final int Z_EDGE_ELEMS = 1;
		public final double option_stoptime = 0.1;
		public final int option_max_iterations = 48;
	}
	
	private final Options options;

	// Mesh
	private final NumericMesh2D mesh;
	private final int nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbNeighbourCells;
	private final VtkFileWriter2D writer;

	// Global Variables
	private double deltat = 0.001;
	private double t, t_n_plus_1;

	// Array Variables
	private Real2 coord[], center[];
	private double u[], V[], f[], tmp[], surface[], u_n_plus_1[];
	
	public Whiteheat(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbFaces = mesh.getNbFaces();
		nbNodesOfCell = NumericMesh2D.MaxNbNodesOfCell;
		nbNodesOfFace = NumericMesh2D.MaxNbNodesOfFace;
		nbNeighbourCells = NumericMesh2D.MaxNbNeighbourCells;
		writer = new VtkFileWriter2D("Whiteheat");

		// Arrays allocation
		coord = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			coord[iNodes] = new Real2(0.0);
		});
		center = new Real2[nbCells];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			center[iCells] = new Real2(0.0);
		});
		u = new double[nbCells];
		V = new double[nbCells];
		f = new double[nbCells];
		tmp = new double[nbCells];
		surface = new double[nbFaces];
		u_n_plus_1 = new double[nbCells];

		// Copy node coordinates
		ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> coord[rNodes] = gNodes.get(rNodes));
	}
	
	/**
	 * Job IniF @-1.0
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
	 * Job IniCenter @-1.0
	 * In variables: coord
	 * Out variables: center
	 */
	private void iniCenter() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			Real2 sum30378343 = new Real2(0.0, 0.0);
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum30378343.operator_set(sum30378343.operator_plus((coord[rNodes])));
			}
			center[jCells].operator_set(sum30378343.operator_multiply(0.25));
		});
	}		
	
	/**
	 * Job ComputeV @-1.0
	 * In variables: coord
	 * Out variables: V
	 */
	private void computeV() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double sum1610638964 = 0.0;
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				int nextRNodesOfCellJ = (rNodesOfCellJ+1+nodesOfCellJ.length)%nodesOfCellJ.length;
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int nextRId = nodesOfCellJ[nextRNodesOfCellJ];
				int rNodes = rId;
				int nextRNodes = nextRId;
				sum1610638964 = sum1610638964 + (MathFunctions.det(coord[rNodes], coord[nextRNodes]));
			}
			V[jCells] = 0.5 * sum1610638964;
		});
	}		
	
	/**
	 * Job ComputeSurface @-1.0
	 * In variables: coord
	 * Out variables: surface
	 */
	private void computeSurface() 
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			int fId = fFaces;
			double sum173302234 = 0.0;
			int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
			for (int rNodesOfFaceF=0; rNodesOfFaceF<nodesOfFaceF.length; rNodesOfFaceF++)
			{
				int nextRNodesOfFaceF = (rNodesOfFaceF+1+nodesOfFaceF.length)%nodesOfFaceF.length;
				int rId = nodesOfFaceF[rNodesOfFaceF];
				int nextRId = nodesOfFaceF[nextRNodesOfFaceF];
				int rNodes = rId;
				int nextRNodes = nextRId;
				sum173302234 = sum173302234 + (MathFunctions.norm(coord[rNodes].operator_minus(coord[nextRNodes])));
			}
			surface[fFaces] = 0.5 * sum173302234;
		});
	}		
	
	/**
	 * Job Init_ComputeUn @-1.0
	 * In variables: 
	 * Out variables: u
	 */
	private void init_ComputeUn() 
	{
		IntStream.range(0, nbCells).parallel().forEach(j0Cells -> 
		{
			u[j0Cells] = 0.0;
		});
	}		
	
	/**
	 * Job Init_ComputeTn @-1.0
	 * In variables: 
	 * Out variables: t
	 */
	private void init_ComputeTn() 
	{
		t = 0.0;
	}		
	
	/**
	 * Job ComputeTmp @1.0
	 * In variables: u, center, surface, deltat, V
	 * Out variables: tmp
	 */
	private void computeTmp() 
	{
		IntStream.range(0, nbCells).parallel().forEach(j1Cells -> 
		{
			int j1Id = j1Cells;
			double sum225181829 = 0.0;
			int[] neighbourCellsJ1 = mesh.getNeighbourCells(j1Id);
			for (int j2NeighbourCellsJ1=0; j2NeighbourCellsJ1<neighbourCellsJ1.length; j2NeighbourCellsJ1++)
			{
				int j2Id = neighbourCellsJ1[j2NeighbourCellsJ1];
				int j2Cells = j2Id;
				sum225181829 = sum225181829 + ((u[j2Cells] - u[j1Cells]) / (MathFunctions.norm(center[j2Cells].operator_minus(center[j1Cells])) * surface[mesh.getCommonFace(j1Id,j2Id)]));
			}
			tmp[j1Cells] = deltat / V[j1Cells] * sum225181829;
		});
	}		
	
	/**
	 * Job Compute_ComputeTn @1.0
	 * In variables: t, deltat
	 * Out variables: t_n_plus_1
	 */
	private void compute_ComputeTn() 
	{
		t_n_plus_1 = t + deltat;
	}		
	
	/**
	 * Job Copy_t_n_plus_1_to_t @2.0
	 * In variables: t_n_plus_1
	 * Out variables: t
	 */
	private void copy_t_n_plus_1_to_t() 
	{
		double tmpSwitch = t;
		t = t_n_plus_1;
		t_n_plus_1 = tmpSwitch;
	}		
	
	/**
	 * Job Compute_ComputeUn @2.0
	 * In variables: f, deltat, u, tmp
	 * Out variables: u_n_plus_1
	 */
	private void compute_ComputeUn() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			u_n_plus_1[jCells] = f[jCells] * deltat + u[jCells] + tmp[jCells];
		});
	}		
	
	/**
	 * Job Copy_u_n_plus_1_to_u @3.0
	 * In variables: u_n_plus_1
	 * Out variables: u
	 */
	private void copy_u_n_plus_1_to_u() 
	{
		double[] tmpSwitch = u;
		u = u_n_plus_1;
		u_n_plus_1 = tmpSwitch;
	}		

	public void simulate()
	{
		System.out.println("Début de l'exécution du module Whiteheat");
		iniF(); // @-1.0
		iniCenter(); // @-1.0
		computeV(); // @-1.0
		computeSurface(); // @-1.0
		init_ComputeUn(); // @-1.0
		init_ComputeTn(); // @-1.0

		int iteration = 0;
		while (t < options.option_stoptime && iteration < options.option_max_iterations)
		{
			System.out.println("t = " + t);
			iteration++;
			computeTmp(); // @1.0
			compute_ComputeTn(); // @1.0
			copy_t_n_plus_1_to_t(); // @2.0
			compute_ComputeUn(); // @2.0
			copy_u_n_plus_1_to_u(); // @3.0
		}
		System.out.println("Fin de l'exécution du module Whiteheat");
	}

	public static void main(String[] args)
	{
		Whiteheat.Options o = new Whiteheat.Options();
		Mesh<Real2> gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.LENGTH, o.LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		Whiteheat i = new Whiteheat(o, nm);
		i.simulate();
	}
};
