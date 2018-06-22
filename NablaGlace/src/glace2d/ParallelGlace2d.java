package glace2d;

import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class ParallelGlace2d
{
	public final static class Options
	{
		public final double LENGTH = 1.125;
		public final int X_EDGE_ELEMS = 4;
		public final int Y_EDGE_ELEMS = 4;
		public final double option_stoptime = 0.1;
		public final int option_max_iterations = 32768;
	}
	
	private final Options options;

	// Mesh
	private final NumericMesh2D mesh;
	private final int nbNodes, nbCells, nbNodesOfCell;
	private final VtkFileWriter2D writer;

	// Global Variables
	private double option_deltat_min, option_deltat_max, option_deltat_control, option_deltat_min_variation, option_deltat_max_variation, deltat, global_deltat, t;
	private boolean option_deltat_last_exact;

	// Array Variables
	private Real2 coord[], node_u[], node_u_second_member[], u[], CQs[][], reconstructed_u[][], momentum_fluxes_sum[];
	private Real2x2 node_u_matrix[], AQs[][];
	private double m[], rho[], p[], css[], glace_deltat[], absCQs[][], rhoE[], reconstructed_p[][], total_energy_fluxes_sum[];
	
	public ParallelGlace2d(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbNodesOfCell = NumericMesh2D.MaxNbNodesOfCell;
		writer = new VtkFileWriter2D("Glace2d", mesh.getGeometricMesh());

		// Arrays allocation
		coord = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			coord[iNodes] = new Real2(0.0);
		});
		node_u = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			node_u[iNodes] = new Real2(0.0);
		});
		node_u_second_member = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			node_u_second_member[iNodes] = new Real2(0.0);
		});
		node_u_matrix = new Real2x2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			node_u_matrix[iNodes] = new Real2x2(0.0);
		});
		m = new double[nbCells];
		rho = new double[nbCells];
		p = new double[nbCells];
		u = new Real2[nbCells];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			u[iCells] = new Real2(0.0);
		});
		css = new double[nbCells];
		glace_deltat = new double[nbCells];
		absCQs = new double[nbCells][nbNodesOfCell];
		CQs = new Real2[nbCells][nbNodesOfCell];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			IntStream.range(0, nbNodesOfCell).parallel().forEach(iNodesOfCell -> 
			{
				CQs[iCells][iNodesOfCell] = new Real2(0.0);
			});
		});
		AQs = new Real2x2[nbCells][nbNodesOfCell];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			IntStream.range(0, nbNodesOfCell).parallel().forEach(iNodesOfCell -> 
			{
				AQs[iCells][iNodesOfCell] = new Real2x2(0.0);
			});
		});
		rhoE = new double[nbCells];
		reconstructed_u = new Real2[nbCells][nbNodesOfCell];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			IntStream.range(0, nbNodesOfCell).parallel().forEach(iNodesOfCell -> 
			{
				reconstructed_u[iCells][iNodesOfCell] = new Real2(0.0);
			});
		});
		reconstructed_p = new double[nbCells][nbNodesOfCell];
		momentum_fluxes_sum = new Real2[nbCells];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			momentum_fluxes_sum[iCells] = new Real2(0.0);
		});
		total_energy_fluxes_sum = new double[nbCells];

		// Copy node coordinates
		ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> coord[rNodes] = gNodes.get(rNodes));
	}
	
	/**
	 * Job ComputeAQsMatrices @0.0
	 * In variables: rho, css, CQs, absCQs
	 * Out variables: AQs
	 */
	private void computeAQsMatrices() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double rhoc = rho[jCells] * css[jCells];
			int[] nodesOfCell = mesh.getNodesOfCell(jId);
			for (int rNodesOfCell=0; rNodesOfCell<nodesOfCell.length; rNodesOfCell++)
			{
				{
					AQs[jCells][rNodesOfCell].operator_set(Glace2dFunctions.tensProduct(CQs[jCells][rNodesOfCell], CQs[jCells][rNodesOfCell]));
					AQs[jCells][rNodesOfCell].operator_set(AQs[jCells][rNodesOfCell].operator_multiply((rhoc / absCQs[jCells][rNodesOfCell])));
				}
			}
		});
	}		
	
	/**
	 * Job TemporalSchemeReconstructPressure @0.0
	 * In variables: p
	 * Out variables: reconstructed_p
	 */
	private void temporalSchemeReconstructPressure() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			int[] nodesOfCell = mesh.getNodesOfCell(jId);
			for (int rNodesOfCell=0; rNodesOfCell<nodesOfCell.length; rNodesOfCell++)
			{
				reconstructed_p[jCells][rNodesOfCell] = p[jCells];
			}
		});
	}		
	
	/**
	 * Job TemporalSchemeReconstructVelocity @0.0
	 * In variables: u
	 * Out variables: reconstructed_u
	 */
	private void temporalSchemeReconstructVelocity() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			int[] nodesOfCell = mesh.getNodesOfCell(jId);
			for (int rNodesOfCell=0; rNodesOfCell<nodesOfCell.length; rNodesOfCell++)
			{
				reconstructed_u[jCells][rNodesOfCell].operator_set(u[jCells]);
			}
		});
	}		
	
	/**
	 * Job TemporalSchemeIniMatricesAndSecondMember @0.0
	 * In variables: 
	 * Out variables: node_u_matrix, node_u_second_member
	 */
	private void temporalSchemeIniMatricesAndSecondMember() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			node_u_matrix[rNodes].operator_set(new Real2x2(new Real2(0.0, 0.0), new Real2(0.0, 0.0)));
			node_u_second_member[rNodes].operator_set(new Real2(0.0, 0.0));
		});
	}		
	
	/**
	 * Job TemporalSchemeAssembleMatricesAndSecondMember @0.0
	 * In variables: AQs, reconstructed_u, CQs, reconstructed_p
	 * Out variables: node_u_matrix, node_u_second_member
	 */
	private void temporalSchemeAssembleMatricesAndSecondMember() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			int[] nodesOfCell = mesh.getNodesOfCell(jId);
			for (int rNodesOfCell=0; rNodesOfCell<nodesOfCell.length; rNodesOfCell++)
			{
				int rId = nodesOfCell[rNodesOfCell];
				int rNodes = rId;
				{
					Real2x2 local_matrix = AQs[jCells][rNodesOfCell];
					node_u_matrix[rNodes].operator_set(node_u_matrix[rNodes].operator_plus(local_matrix));
					node_u_second_member[rNodes].operator_set(node_u_second_member[rNodes].operator_plus(Glace2dFunctions.matVectProduct(local_matrix, reconstructed_u[jCells][rNodesOfCell])));
					node_u_second_member[rNodes].operator_set(node_u_second_member[rNodes].operator_plus(CQs[jCells][rNodesOfCell].operator_multiply(reconstructed_p[jCells][rNodesOfCell])));
				}
			}
		});
	}		
	
	/**
	 * Job TemporalSchemeComputeNodesVelocity @0.0
	 * In variables: node_u_second_member
	 * Out variables: node_u_matrix, node_u
	 */
	private void temporalSchemeComputeNodesVelocity() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			double determinent = Glace2dFunctions.matrixDeterminant(node_u_matrix[rNodes]);
			node_u_matrix[rNodes].operator_set(Glace2dFunctions.inverseMatrix(node_u_matrix[rNodes], determinent));
			node_u[rNodes].operator_set(Glace2dFunctions.matVectProduct(node_u_matrix[rNodes], node_u_second_member[rNodes]));
		});
	}		
	
	/**
	 * Job TemporalSchemeIniFluxesSum @0.0
	 * In variables: 
	 * Out variables: momentum_fluxes_sum, total_energy_fluxes_sum
	 */
	private void temporalSchemeIniFluxesSum() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			momentum_fluxes_sum[jCells].operator_set(new Real2(0.0, 0.0));
			total_energy_fluxes_sum[jCells] = 0.0;
		});
	}		
	
	/**
	 * Job TemporalSchemeComputeStandardFluxesSum @0.0
	 * In variables: reconstructed_u, node_u, AQs, reconstructed_p, CQs
	 * Out variables: momentum_fluxes_sum, total_energy_fluxes_sum
	 */
	private void temporalSchemeComputeStandardFluxesSum() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			int[] nodesOfCell = mesh.getNodesOfCell(jId);
			for (int rNodesOfCell=0; rNodesOfCell<nodesOfCell.length; rNodesOfCell++)
			{
				int rId = nodesOfCell[rNodesOfCell];
				int rNodes = rId;
				{
					Real2 deltau = reconstructed_u[jCells][rNodesOfCell].operator_minus(node_u[rNodes]);
					Real2 FQs = Glace2dFunctions.matVectProduct(AQs[jCells][rNodesOfCell], deltau);
					FQs.operator_set(FQs.operator_plus(CQs[jCells][rNodesOfCell].operator_multiply(reconstructed_p[jCells][rNodesOfCell])));
					momentum_fluxes_sum[jCells].operator_set(momentum_fluxes_sum[jCells].operator_minus(FQs));
					total_energy_fluxes_sum[jCells] = total_energy_fluxes_sum[jCells] - MathFunctions.dot(FQs, node_u[rNodes]);
				}
			}
		});
	}		
	
	/**
	 * Job TemporalSchemeApplyFluxesStandard @0.0
	 * In variables: deltat, momentum_fluxes_sum, m, total_energy_fluxes_sum
	 * Out variables: u, rhoE
	 */
	private void temporalSchemeApplyFluxesStandard() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			u[jCells].operator_set(u[jCells].operator_plus(momentum_fluxes_sum[jCells].operator_multiply(deltat).operator_divide(m[jCells])));
			rhoE[jCells] = rhoE[jCells] + deltat * total_energy_fluxes_sum[jCells] / m[jCells];
		});
	}		
	
	/**
	 * Job TemporalSchemeMoveNodes @0.0
	 * In variables: deltat, node_u
	 * Out variables: coord
	 */
	private void temporalSchemeMoveNodes() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			coord[rNodes].operator_set(coord[rNodes].operator_plus(node_u[rNodes].operator_multiply(deltat)));
		});
	}		
	
	/**
	 * Job GlobalDeltaTReduction @0.0
	 * In variables: glace_deltat
	 * Out variables: global_deltat
	 */
	private void globalDeltaTReduction() 
	{
		{
			double reduceMin1157190618 = IntStream.range(0, nbCells).boxed().parallel().reduce(
					Double.MAX_VALUE, 
					(r, jCells) -> Math.min(r, glace_deltat[jCells]),
					(r1, r2) -> Math.min(r1, r2)
			);

			global_deltat = reduceMin1157190618;
		}
	}		
	
	/**
	 * Job GlaceTimeStepCtrl @0.0
	 * In variables: option_deltat_control, global_deltat, option_deltat_max_variation, option_deltat_min_variation, option_deltat_max, option_deltat_min, option_deltat_last_exact, t, option_stoptime
	 * Out variables: deltat
	 */
	private void glaceTimeStepCtrl() 
	{
		{
			double new_deltat = option_deltat_control * global_deltat;
			double max_time_step = (1.0 + option_deltat_max_variation) * deltat;
			double min_time_step = (1.0 - option_deltat_min_variation) * deltat;
			if (new_deltat > max_time_step) 
				new_deltat = max_time_step;
			if (new_deltat < min_time_step) 
				new_deltat = min_time_step;
			new_deltat = MathFunctions.min(new_deltat, option_deltat_max);
			new_deltat = MathFunctions.max(new_deltat, option_deltat_min);
			if (option_deltat_last_exact && ((t + new_deltat) > options.option_stoptime)) 
				new_deltat = options.option_stoptime - t;
			deltat = new_deltat;
		}
	}		
	
	/**
	 * Job Init_option_deltat_min @0.0
	 * In variables: 
	 * Out variables: option_deltat_min
	 */
	private void init_option_deltat_min() 
	{
		option_deltat_min = 1.0E-12;
	}		
	
	/**
	 * Job Init_option_deltat_max @0.0
	 * In variables: 
	 * Out variables: option_deltat_max
	 */
	private void init_option_deltat_max() 
	{
		option_deltat_max = 0.01;
	}		
	
	/**
	 * Job Init_option_deltat_control @0.0
	 * In variables: 
	 * Out variables: option_deltat_control
	 */
	private void init_option_deltat_control() 
	{
		option_deltat_control = 0.1;
	}		
	
	/**
	 * Job Init_option_deltat_min_variation @0.0
	 * In variables: 
	 * Out variables: option_deltat_min_variation
	 */
	private void init_option_deltat_min_variation() 
	{
		option_deltat_min_variation = 0.99;
	}		
	
	/**
	 * Job Init_option_deltat_max_variation @0.0
	 * In variables: 
	 * Out variables: option_deltat_max_variation
	 */
	private void init_option_deltat_max_variation() 
	{
		option_deltat_max_variation = 0.1;
	}		
	
	/**
	 * Job Init_option_deltat_last_exact @0.0
	 * In variables: 
	 * Out variables: option_deltat_last_exact
	 */
	private void init_option_deltat_last_exact() 
	{
		option_deltat_last_exact = true;
	}		

	public void simulate()
	{
		System.out.println("Début de l'exécution du module Glace2d");
		
		int iteration = 0;
		while (t < options.option_stoptime && iteration < options.option_max_iterations)
		{
			System.out.println("t = " + t);
			iteration++;
			writer.writeFile(iteration);
		}
		System.out.println("Fin de l'exécution du module Glace2d");
	}

	public static void main(String[] args)
	{
		ParallelGlace2d.Options o = new ParallelGlace2d.Options();
		Mesh<Real2> gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.LENGTH, o.LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		ParallelGlace2d i = new ParallelGlace2d(o, nm);
		i.simulate();
	}
};
