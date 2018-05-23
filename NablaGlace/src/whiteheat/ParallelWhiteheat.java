package whiteheat;

import static fr.cea.nabla.javalib.types.MathFunctions.det;
import static fr.cea.nabla.javalib.types.MathFunctions.norm;

import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.mesh.CartesianMesh2DGenerator;
import fr.cea.nabla.javalib.mesh.Mesh;
import fr.cea.nabla.javalib.mesh.NumericMesh2D;
import fr.cea.nabla.javalib.mesh.VtkFileWriter2D;
import fr.cea.nabla.javalib.types.Real2;

@SuppressWarnings("all")
public final class ParallelWhiteheat
{
	// Options
	public final double LENGTH = 1.0;
	public final int X_EDGE_ELEMS = 8;
	public final int Y_EDGE_ELEMS = 8;
	public final int Z_EDGE_ELEMS = 1;
	public final double option_stoptime = 0.1;
	public final int option_max_iterations = 48;

	// Mesh
	private final NumericMesh2D mesh;
	private final int nbNodes, nbCells, nbFaces, nbNodesOfCell;
	private final VtkFileWriter2D writer;
	
	// Global Variables
	private double t, deltat, t_n_plus_1, sumReductionBidonVolume;

	// Array Variables
	private Real2 X[], center[];
	private double u[], V[], f[], tmp[], surface[], u_n_plus_1[];
	private double[][] C_ic; // inutile pour whiteheat, juste pour faire une double boucle
	
	public ParallelWhiteheat()
	{
		// Mesh allocation
		Mesh<Real2> geometricMesh = CartesianMesh2DGenerator.generate(X_EDGE_ELEMS, Y_EDGE_ELEMS, LENGTH, LENGTH);
		mesh = new NumericMesh2D(geometricMesh);
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbFaces = mesh.getNbFaces();
		nbNodesOfCell = NumericMesh2D.MaxNbNodesOfCell;
		writer = new VtkFileWriter2D("ParallelWhiteHeat", geometricMesh);
		
		// Arrays allocation
		X = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			X[iNodes] = new Real2(0.0);
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
		C_ic = new double[nbCells][nbNodesOfCell]; // inutile pour whiteheat, juste pour faire une double boucle

		// Dumped variables
		writer.addCellVariable("u", u);
		
		// Copy node coordinates
		ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X[rNodes] = gNodes.get(rNodes));
	}
	
	/**
	 * Job Init_δt @-1.0
	 * In variables: 
	 * Out variables: δt
	 */
	private void init_deltat() 
	{
		deltat = 0.001;
	}		
	
	private void init_SumReductionBidonVolume()
	{
		sumReductionBidonVolume = 0.0;
	}
	
	/**
	 * Job IniF @-1.0
	 * In variables: 
	 * Out variables: f
	 */
	private void iniF() 
	{
		// int[] cells = mesh.getCells()
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			f[jCells] = 4.0;
		});
	}		
	
	// bidon = 1/4 * ∑{j∈cells()}(V{j}) 
	private void reduceSumBidonVolume()
	{
		sumReductionBidonVolume = IntStream.range(0, nbCells).parallel().boxed().reduce(0.0, (s, j) -> s + V[j], (s1, s2) -> s1 + s2);
	}

	private void bidonVolume()
	{
		double bidon = 1/4 * sumReductionBidonVolume;
	}
	
	// ∀j∈cells(),∀r∈nodesOfCell(j), C_ic{j,r} = 0.5 * norm(X{r});
	private void bidonDoubleBoucle()
	{
		// int[] cells = mesh.getCells();
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells; // cells[jCells]
			int[] nodesOfCell = mesh.getNodesOfCell(jCells);
			for (int rNodesOfCell =0; rNodesOfCell<nodesOfCell.length; rNodesOfCell++)
			{
				int rId = nodesOfCell[rNodesOfCell];
				int rNodes = rId; // int rNodes = mesh.getNodes().indexOf(rId)
				C_ic[jCells][rNodesOfCell] = 0.5 * norm(X[rNodes]);
			}
		});		
	}
	
	/**
	 * Job IniCenter @-1.0
	 * In variables: X
	 * Out variables: center
	 */
	private void iniCenter() 
	{
		// int[] cells = mesh.getCells();
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells; // cells[jCells]
			Real2 sum1 = new Real2(0.0, 0.0);
			int[] nodesOfCell = mesh.getNodesOfCell(jId);
			for (int rNodesOfCell=0; rNodesOfCell<nodesOfCell.length; rNodesOfCell++)
			{
				int rId = nodesOfCell[rNodesOfCell];
				int rNodes = rId; // nodes.indexOf(rId)
				sum1.operator_add(X[rNodes]);
			}
			center[jCells].operator_set(sum1.operator_multiply(0.25));
		});
	}	
	
	/**
	 * Job ComputeV @-1.0
	 * In variables: X
	 * Out variables: V
	 */
	private void computeV() 
	{
		// int[] cells = mesh.getCells();
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells; // cells[jCells]
			double sum1 = 0.0;
			int[] nodesOfCell = mesh.getNodesOfCell(jId);
			for (int rNodesOfCell=0; rNodesOfCell<nodesOfCell.length; rNodesOfCell++)
			{
				int nextRNodesOfCell = (rNodesOfCell+1+nodesOfCell.length)%nodesOfCell.length;
				int rId = nodesOfCell[rNodesOfCell];
				int nextRId = nodesOfCell[nextRNodesOfCell];
				int rNodes = rId; // nodes.indexOf(rId)
				int nextRNodes = nextRId; // nodes.indexOf(nextRId)
				sum1 += det(X[rNodes], X[nextRNodes]);
			}
			V[jCells] = 0.5 * sum1;
		});
	}		
	
	/**
	 * Job ComputeSurface @-1.0
	 * In variables: X
	 * Out variables: surface
	 */
	private void computeSurface() 
	{
		// int[] faces = mesh.getFaces()
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			int fId = fFaces; // faces[fFaces]
			double sum1 = 0.0;
			int[] nodesOfFace = mesh.getNodesOfFace(fId);
			for (int rNodesOfFace=0; rNodesOfFace<nodesOfFace.length; rNodesOfFace++)
			{
				int nextRNodesOfFace = (rNodesOfFace+1+nodesOfFace.length)%nodesOfFace.length;
				int rId = nodesOfFace[rNodesOfFace];
				int nextRId = nodesOfFace[nextRNodesOfFace];
				int rNodes = rId; // nodes.indexOf(rId)
				int nextRNodes = nextRId; // nodes.indexOf(nextRId)
				sum1 += norm(X[rNodes].operator_minus(X[nextRNodes]));
			}
			surface[fFaces] = 0.5 * sum1;
		});
	}		
	
	/**
	 * Job Init_ComputeUnPlus1 @-1.0
	 * In variables: 
	 * Out variables: u
	 */
	private void init_ComputeUn() 
	{
		// int[] cells = mesh.getCells()
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			u[jCells] = 0.0;
		});
	}		
	
	private void init_ComputeTn() 
	{
		t = 0.0;
	}		

	/**
	 * Job ComputeTmp @1.0
	 * In variables: u, center, surface, δt, V
	 * Out variables: tmp
	 */
	private void computeTmp() 
	{
		// int[] cells = mesh.getCells()
		IntStream.range(0, nbCells).parallel().forEach(j1Cells -> 
		{
			int j1Id = j1Cells; // cells[j1Cells]
			double sum1 = 0.0;
			int[] neighbourCells = mesh.getNeighbourCells(j1Id);
			for (int j2NeighbourCells=0; j2NeighbourCells<neighbourCells.length; j2NeighbourCells++)
			{
				int j2Id = neighbourCells[j2NeighbourCells];
				int j2Cells = j2Id; // cells.indexOf(j2Id)
				sum1 += (u[j2Cells] - u[j1Cells]) / (norm(center[j2Cells].operator_minus(center[j1Cells])) * surface[mesh.getCommonFace(j1Id,j2Id)]);
			}
			tmp[j1Cells] = deltat / V[j1Cells] * sum1;
		});
	}		
	
	/**
	 * Job Compute_ComputeUnPlus1 @2.0
	 * In variables: f, δt, u, tmp
	 * Out variables: u_n_plus_1
	 */
	private void compute_ComputeUn() 
	{
		// int[] cells = mesh.getCells()
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
	
	/**
	 * Job Compute_ComputeTn @8.0
	 * In variables: t, δt_n_plus_1
	 * Out variables: t_n_plus_1
	 */
	private void compute_ComputeTn() 
	{
		t_n_plus_1 = t + deltat;
	}		
	
	/**
	 * Job Copy_t_n_plus_1_to_t @9.0
	 * In variables: t_n_plus_1
	 * Out variables: t
	 */
	private void copy_t_n_plus_1_to_t() 
	{
		double tmpSwitch = t;
		t = t_n_plus_1;
		t_n_plus_1 = tmpSwitch;
	}		

	public void simulate()
	{
		System.out.println("Début de l'exécution du module whiteheat");
		init_deltat(); // @-1.0
		iniF(); // @-1.0
		iniCenter(); // @-1.0
		computeV(); // @-1.0
		computeSurface(); // @-1.0
		init_ComputeUn(); // @-1.0
		init_ComputeTn(); // @-1.0
		init_SumReductionBidonVolume(); // @-1.0
		
		int iteration = 0;
		while (t < option_stoptime && iteration < option_max_iterations)
		{
			System.out.println("A t = " + t);
			iteration++;
			computeTmp();
			compute_ComputeTn();
			copy_t_n_plus_1_to_t(); 
			compute_ComputeUn();  
			System.out.println("Val de u[0] = " + u[0]);
			copy_u_n_plus_1_to_u();
			writer.writeFile(iteration);
		}
		System.out.println("Fin de l'exécution du module whiteheat");
	}
	
	// Main
	public static void main(String[] args)
	{
		ParallelWhiteheat i = new ParallelWhiteheat();
		i.simulate();
	}
};
