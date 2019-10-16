package glace2d;

import java.util.HashMap;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.Utils;
import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class Glace2d
{
	public final static class Options
	{
		public final double X_EDGE_LENGTH = 0.01;
		public final double Y_EDGE_LENGTH = X_EDGE_LENGTH;
		public final int X_EDGE_ELEMS = 100;
		public final int Y_EDGE_ELEMS = 10;
		public final int Z_EDGE_ELEMS = 1;
		public final double option_stoptime = 0.2;
		public final int option_max_iterations = 20000;
		public final double gamma = 1.4;
		public final double option_x_interface = 0.5;
		public final double option_deltat_ini = 1.0E-5;
		public final double option_deltat_cfl = 0.4;
		public final double option_rho_ini_zg = 1.0;
		public final double option_rho_ini_zd = 0.125;
		public final double option_p_ini_zg = 1.0;
		public final double option_p_ini_zd = 0.1;
	}
	
	private final Options options;
	private int iteration;

	// Mesh
	private final NumericMesh2D mesh;
	private final int nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;
	private final FileWriter writer;

	// Global Variables
	private double t, deltat, deltat_nplus1, t_nplus1;
	
	// Connectivity Variables
	private double[][] X, b, bt, ur, uj, center, l, X_n0, X_nplus1, uj_nplus1;
	private double[][][] Ar, Mt, C_ic, C, F;
	private double[] p_ic, rho_ic, V_ic, c, m, p, rho, e, E, V, deltatj, E_nplus1;
	private double[][][][] Ajr;
	
	public Glace2d(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		writer = new PvdFileWriter2D("Glace2d");

		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbNodesOfCell = NumericMesh2D.MaxNbNodesOfCell;
		nbCellsOfNode = NumericMesh2D.MaxNbCellsOfNode;
		nbInnerNodes = mesh.getNbInnerNodes();
		nbOuterFaces = mesh.getNbOuterFaces();
		nbNodesOfFace = NumericMesh2D.MaxNbNodesOfFace;

		t = 0.0;
		deltat = options.option_deltat_ini;
		deltat_nplus1 = options.option_deltat_ini;
		t_nplus1 = 0.0;

		// Allocate arrays
		X = new double[nbNodes][2];
		b = new double[nbNodes][2];
		bt = new double[nbNodes][2];
		Ar = new double[nbNodes][2][2];
		Mt = new double[nbNodes][2][2];
		ur = new double[nbNodes][2];
		p_ic = new double[nbCells];
		rho_ic = new double[nbCells];
		V_ic = new double[nbCells];
		c = new double[nbCells];
		m = new double[nbCells];
		p = new double[nbCells];
		rho = new double[nbCells];
		e = new double[nbCells];
		E = new double[nbCells];
		V = new double[nbCells];
		deltatj = new double[nbCells];
		uj = new double[nbCells][2];
		center = new double[nbCells][2];
		l = new double[nbCells][nbNodesOfCell];
		C_ic = new double[nbCells][nbNodesOfCell][2];
		C = new double[nbCells][nbNodesOfCell][2];
		F = new double[nbCells][nbNodesOfCell][2];
		Ajr = new double[nbCells][nbNodesOfCell][2][2];
		X_n0 = new double[nbNodes][2];
		X_nplus1 = new double[nbNodes][2];
		uj_nplus1 = new double[nbCells][2];
		E_nplus1 = new double[nbCells];

		// Copy node coordinates
		ArrayList<double[]> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X_n0[rNodes] = gNodes.get(rNodes));
	}

	public void simulate()
	{
		System.out.println("Début de l'exécution du module Glace2d");
		copy_X_n0_to_X(); // @-3.0
		iniCenter(); // @-3.0
		computeCjrIc(); // @-3.0
		iniUn(); // @-3.0
		iniIc(); // @-2.0
		iniVIc(); // @-2.0
		iniM(); // @-1.0
		iniEn(); // @-1.0

		iteration = 0;
		while (t < options.option_stoptime && iteration < options.option_max_iterations)
		{
			iteration++;
			System.out.println("[" + iteration + "] t = " + t);
			computeCjr(); // @1.0
			computeInternalEnergy(); // @1.0
			computeLjr(); // @2.0
			computeV(); // @2.0
			computeDensity(); // @3.0
			computeEOSp(); // @4.0
			dumpVariables(); // @4.0
			computeEOSc(); // @5.0
			computedeltatj(); // @6.0
			computeAjr(); // @6.0
			computeAr(); // @7.0
			computeBr(); // @7.0
			computeDt(); // @7.0
			copy_deltat_nplus1_to_deltat(); // @8.0
			computeMt(); // @8.0
			computeBt(); // @8.0
			outerFacesComputations(); // @8.0
			computeTn(); // @8.0
			copy_t_nplus1_to_t(); // @9.0
			computeU(); // @9.0
			computeFjr(); // @10.0
			computeXn(); // @10.0
			copy_X_nplus1_to_X(); // @11.0
			computeUn(); // @11.0
			computeEn(); // @11.0
			copy_uj_nplus1_to_uj(); // @12.0
			copy_E_nplus1_to_E(); // @12.0
		}
		System.out.println("Fin de l'exécution du module Glace2d");
	}

	public static void main(String[] args)
	{
		Glace2d.Options o = new Glace2d.Options();
		Mesh<double[]> gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		Glace2d i = new Glace2d(o, nm);
		i.simulate();
	}
	
	/**
	 * Job Copy_X_n0_to_X @-3.0
	 * In variables: X_n0
	 * Out variables: X
	 */
	private void copy_X_n0_to_X() 
	{
		IntStream.range(0, X.length).parallel().forEach(i -> X[i] = X_n0[i]);
	}		
	
	/**
	 * Job IniCenter @-3.0
	 * In variables: X_n0
	 * Out variables: center
	 */
	private void iniCenter() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double[] reduction1270435399 = new double[] {0.0, 0.0};
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					reduction1270435399 = ArrayOperations.plus(reduction1270435399, (X_n0[rNodes]));
				}
			}
			center[jCells] = ArrayOperations.multiply(0.25, reduction1270435399);
		});
	}		
	
	/**
	 * Job ComputeCjrIc @-3.0
	 * In variables: X_n0
	 * Out variables: C_ic
	 */
	private void computeCjrIc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rMinus1Id = nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell];
					int rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					int rMinus1Nodes = rMinus1Id;
					int rPlus1Nodes = rPlus1Id;
					C_ic[jCells][rNodesOfCellJ] = ArrayOperations.multiply(0.5, Glace2dFunctions.perp(ArrayOperations.minus(X_n0[rPlus1Nodes], X_n0[rMinus1Nodes])));
				}
			}
		});
	}		
	
	/**
	 * Job IniUn @-3.0
	 * In variables: 
	 * Out variables: uj
	 */
	private void iniUn() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			uj[jCells][0] = 0.0;
			uj[jCells][1] = 0.0;
		});
	}		
	
	/**
	 * Job IniIc @-2.0
	 * In variables: center, option_x_interface, option_rho_ini_zg, option_p_ini_zg, option_rho_ini_zd, option_p_ini_zd
	 * Out variables: rho_ic, p_ic
	 */
	private void iniIc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			if (center[jCells][0] < options.option_x_interface) 
			{
				rho_ic[jCells] = options.option_rho_ini_zg;
				p_ic[jCells] = options.option_p_ini_zg;
			}
			else 
			{
				rho_ic[jCells] = options.option_rho_ini_zd;
				p_ic[jCells] = options.option_p_ini_zd;
			}
		});
	}		
	
	/**
	 * Job IniVIc @-2.0
	 * In variables: C_ic, X_n0
	 * Out variables: V_ic
	 */
	private void iniVIc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduction_985651369 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					reduction_985651369 = reduction_985651369 + (MathFunctions.dot(C_ic[jCells][rNodesOfCellJ], X_n0[rNodes]));
				}
			}
			V_ic[jCells] = 0.5 * reduction_985651369;
		});
	}		
	
	/**
	 * Job IniM @-1.0
	 * In variables: rho_ic, V_ic
	 * Out variables: m
	 */
	private void iniM() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			m[jCells] = rho_ic[jCells] * V_ic[jCells];
		});
	}		
	
	/**
	 * Job IniEn @-1.0
	 * In variables: p_ic, gamma, rho_ic
	 * Out variables: E
	 */
	private void iniEn() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			E[jCells] = p_ic[jCells] / ((options.gamma - 1.0) * rho_ic[jCells]);
		});
	}		
	
	/**
	 * Job ComputeCjr @1.0
	 * In variables: X
	 * Out variables: C
	 */
	private void computeCjr() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rMinus1Id = nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell];
					int rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					int rMinus1Nodes = rMinus1Id;
					int rPlus1Nodes = rPlus1Id;
					C[jCells][rNodesOfCellJ] = ArrayOperations.multiply(0.5, Glace2dFunctions.perp(ArrayOperations.minus(X[rPlus1Nodes], X[rMinus1Nodes])));
				}
			}
		});
	}		
	
	/**
	 * Job ComputeInternalEnergy @1.0
	 * In variables: E, uj
	 * Out variables: e
	 */
	private void computeInternalEnergy() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			e[jCells] = E[jCells] - 0.5 * MathFunctions.dot(uj[jCells], uj[jCells]);
		});
	}		
	
	/**
	 * Job ComputeLjr @2.0
	 * In variables: C
	 * Out variables: l
	 */
	private void computeLjr() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					l[jCells][rNodesOfCellJ] = MathFunctions.norm(C[jCells][rNodesOfCellJ]);
				}
			}
		});
	}		
	
	/**
	 * Job ComputeV @2.0
	 * In variables: C, X
	 * Out variables: V
	 */
	private void computeV() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduction_1003648137 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					reduction_1003648137 = reduction_1003648137 + (MathFunctions.dot(C[jCells][rNodesOfCellJ], X[rNodes]));
				}
			}
			V[jCells] = 0.5 * reduction_1003648137;
		});
	}		
	
	/**
	 * Job ComputeDensity @3.0
	 * In variables: m, V
	 * Out variables: rho
	 */
	private void computeDensity() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			rho[jCells] = m[jCells] / V[jCells];
		});
	}		
	
	/**
	 * Job ComputeEOSp @4.0
	 * In variables: gamma, rho, e
	 * Out variables: p
	 */
	private void computeEOSp() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			p[jCells] = (options.gamma - 1.0) * rho[jCells] * e[jCells];
		});
	}		
	
	/**
	 * Job dumpVariables @4.0
	 * In variables: rho
	 * Out variables: 
	 */
	private void dumpVariables() 
	{
		if (iteration % 1 == 0)
		{
			HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
			HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
			cellVariables.put("Density", rho);
			writer.writeFile(iteration, t, X, mesh.getGeometricMesh().getQuads(), cellVariables, nodeVariables);
		}
	}		
	
	/**
	 * Job ComputeEOSc @5.0
	 * In variables: gamma, p, rho
	 * Out variables: c
	 */
	private void computeEOSc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			c[jCells] = MathFunctions.sqrt(options.gamma * p[jCells] / rho[jCells]);
		});
	}		
	
	/**
	 * Job Computedeltatj @6.0
	 * In variables: l, V, c
	 * Out variables: deltatj
	 */
	private void computedeltatj() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduction_1877857069 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					reduction_1877857069 = reduction_1877857069 + (l[jCells][rNodesOfCellJ]);
				}
			}
			deltatj[jCells] = 2.0 * V[jCells] / (c[jCells] * reduction_1877857069);
		});
	}		
	
	/**
	 * Job ComputeAjr @6.0
	 * In variables: rho, c, l, C
	 * Out variables: Ajr
	 */
	private void computeAjr() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					Ajr[jCells][rNodesOfCellJ] = ArrayOperations.multiply(((rho[jCells] * c[jCells]) / l[jCells][rNodesOfCellJ]), Glace2dFunctions.tensProduct(C[jCells][rNodesOfCellJ], C[jCells][rNodesOfCellJ]));
				}
			}
		});
	}		
	
	/**
	 * Job ComputeAr @7.0
	 * In variables: Ajr
	 * Out variables: Ar
	 */
	private void computeAr() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			int rId = rNodes;
			double[][] reduction833380395 = new double[][] {{0.0, 0.0}, {0.0, 0.0}};
			{
				int[] cellsOfNodeR = mesh.getCellsOfNode(rId);
				for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.length; jCellsOfNodeR++)
				{
					int jId = cellsOfNodeR[jCellsOfNodeR];
					int jCells = jId;
					int rNodesOfCellJ = Utils.indexOf(mesh.getNodesOfCell(jId), rId);
					reduction833380395 = ArrayOperations.plus(reduction833380395, (Ajr[jCells][rNodesOfCellJ]));
				}
			}
			Ar[rNodes] = reduction833380395;
		});
	}		
	
	/**
	 * Job ComputeBr @7.0
	 * In variables: p, C, Ajr, uj
	 * Out variables: b
	 */
	private void computeBr() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			int rId = rNodes;
			double[] reduction84436631 = new double[] {0.0, 0.0};
			{
				int[] cellsOfNodeR = mesh.getCellsOfNode(rId);
				for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.length; jCellsOfNodeR++)
				{
					int jId = cellsOfNodeR[jCellsOfNodeR];
					int jCells = jId;
					int rNodesOfCellJ = Utils.indexOf(mesh.getNodesOfCell(jId), rId);
					reduction84436631 = ArrayOperations.plus(reduction84436631, (ArrayOperations.plus(ArrayOperations.multiply(p[jCells], C[jCells][rNodesOfCellJ]), Glace2dFunctions.matVectProduct(Ajr[jCells][rNodesOfCellJ], uj[jCells]))));
				}
			}
			b[rNodes] = reduction84436631;
		});
	}		
	
	/**
	 * Job ComputeDt @7.0
	 * In variables: deltatj, option_deltat_cfl
	 * Out variables: deltat_nplus1
	 */
	private void computeDt() 
	{
		double reduction1979477213 = IntStream.range(0, nbCells).boxed().parallel().reduce(
			Double.MAX_VALUE, 
			(r, jCells) -> MathFunctions.min(r, deltatj[jCells]),
			(r1, r2) -> MathFunctions.min(r1, r2)
		);
		deltat_nplus1 = options.option_deltat_cfl * reduction1979477213;
	}		
	
	/**
	 * Job Copy_deltat_nplus1_to_deltat @8.0
	 * In variables: deltat_nplus1
	 * Out variables: deltat
	 */
	private void copy_deltat_nplus1_to_deltat() 
	{
		double tmpSwitch = deltat;
		deltat = deltat_nplus1;
		deltat_nplus1 = tmpSwitch;
	}		
	
	/**
	 * Job ComputeMt @8.0
	 * In variables: Ar
	 * Out variables: Mt
	 */
	private void computeMt() 
	{
		int[] innerNodes = mesh.getInnerNodes();
		IntStream.range(0, nbInnerNodes).parallel().forEach(rInnerNodes -> 
		{
			int rId = innerNodes[rInnerNodes];
			int rNodes = rId;
			Mt[rNodes] = Ar[rNodes];
		});
	}		
	
	/**
	 * Job ComputeBt @8.0
	 * In variables: b
	 * Out variables: bt
	 */
	private void computeBt() 
	{
		int[] innerNodes = mesh.getInnerNodes();
		IntStream.range(0, nbInnerNodes).parallel().forEach(rInnerNodes -> 
		{
			int rId = innerNodes[rInnerNodes];
			int rNodes = rId;
			bt[rNodes] = b[rNodes];
		});
	}		
	
	/**
	 * Job OuterFacesComputations @8.0
	 * In variables: X_EDGE_ELEMS, X_EDGE_LENGTH, Y_EDGE_ELEMS, Y_EDGE_LENGTH, X, b, Ar
	 * Out variables: bt, Mt
	 */
	private void outerFacesComputations() 
	{
		int[] outerFaces = mesh.getOuterFaces();
		IntStream.range(0, nbOuterFaces).parallel().forEach(kOuterFaces -> 
		{
			int kId = outerFaces[kOuterFaces];
			final double epsilon = 1.0E-10;
			double[][] I = new double[][] {new double[] {1.0, 0.0}, new double[] {0.0, 1.0}};
			double X_MIN = 0.0;
			double X_MAX = options.X_EDGE_ELEMS * options.X_EDGE_LENGTH;
			double Y_MIN = 0.0;
			double Y_MAX = options.Y_EDGE_ELEMS * options.Y_EDGE_LENGTH;
			double[] nY = new double[] {0.0, 1.0};
			{
				int[] nodesOfFaceK = mesh.getNodesOfFace(kId);
				for (int rNodesOfFaceK=0; rNodesOfFaceK<nodesOfFaceK.length; rNodesOfFaceK++)
				{
					int rId = nodesOfFaceK[rNodesOfFaceK];
					int rNodes = rId;
					if ((X[rNodes][1] - Y_MIN < epsilon) || (X[rNodes][1] - Y_MAX < epsilon)) 
					{
						double sign = 0.0;
						if (X[rNodes][1] - Y_MIN < epsilon) 
							sign = -1.0;
						else 
							sign = 1.0;
						double[] n = ArrayOperations.multiply(sign, nY);
						double[][] nxn = Glace2dFunctions.tensProduct(n, n);
						double[][] IcP = ArrayOperations.minus(I, nxn);
						bt[rNodes] = Glace2dFunctions.matVectProduct(IcP, b[rNodes]);
						Mt[rNodes] = ArrayOperations.plus(ArrayOperations.multiply(IcP, (ArrayOperations.multiply(Ar[rNodes], IcP))), ArrayOperations.multiply(nxn, Glace2dFunctions.trace(Ar[rNodes])));
					}
					if ((MathFunctions.fabs(X[rNodes][0] - X_MIN) < epsilon) || ((MathFunctions.fabs(X[rNodes][0] - X_MAX) < epsilon))) 
					{
						Mt[rNodes] = I;
						bt[rNodes][0] = 0.0;
						bt[rNodes][1] = 0.0;
					}
				}
			}
		});
	}		
	
	/**
	 * Job ComputeTn @8.0
	 * In variables: t, deltat_nplus1
	 * Out variables: t_nplus1
	 */
	private void computeTn() 
	{
		t_nplus1 = t + deltat_nplus1;
	}		
	
	/**
	 * Job Copy_t_nplus1_to_t @9.0
	 * In variables: t_nplus1
	 * Out variables: t
	 */
	private void copy_t_nplus1_to_t() 
	{
		double tmpSwitch = t;
		t = t_nplus1;
		t_nplus1 = tmpSwitch;
	}		
	
	/**
	 * Job ComputeU @9.0
	 * In variables: Mt, bt
	 * Out variables: ur
	 */
	private void computeU() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			ur[rNodes] = Glace2dFunctions.matVectProduct(Glace2dFunctions.inverse(Mt[rNodes]), bt[rNodes]);
		});
	}		
	
	/**
	 * Job ComputeFjr @10.0
	 * In variables: p, C, Ajr, uj, ur
	 * Out variables: F
	 */
	private void computeFjr() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					F[jCells][rNodesOfCellJ] = ArrayOperations.plus(ArrayOperations.multiply(p[jCells], C[jCells][rNodesOfCellJ]), Glace2dFunctions.matVectProduct(Ajr[jCells][rNodesOfCellJ], (ArrayOperations.minus(uj[jCells], ur[rNodes]))));
				}
			}
		});
	}		
	
	/**
	 * Job ComputeXn @10.0
	 * In variables: X, deltat, ur
	 * Out variables: X_nplus1
	 */
	private void computeXn() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			X_nplus1[rNodes] = ArrayOperations.plus(X[rNodes], ArrayOperations.multiply(deltat, ur[rNodes]));
		});
	}		
	
	/**
	 * Job Copy_X_nplus1_to_X @11.0
	 * In variables: X_nplus1
	 * Out variables: X
	 */
	private void copy_X_nplus1_to_X() 
	{
		double[][] tmpSwitch = X;
		X = X_nplus1;
		X_nplus1 = tmpSwitch;
	}		
	
	/**
	 * Job ComputeUn @11.0
	 * In variables: F, uj, deltat, m
	 * Out variables: uj_nplus1
	 */
	private void computeUn() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double[] reduction_1886203389 = new double[] {0.0, 0.0};
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					reduction_1886203389 = ArrayOperations.plus(reduction_1886203389, (F[jCells][rNodesOfCellJ]));
				}
			}
			uj_nplus1[jCells] = ArrayOperations.minus(uj[jCells], ArrayOperations.multiply((deltat / m[jCells]), reduction_1886203389));
		});
	}		
	
	/**
	 * Job ComputeEn @11.0
	 * In variables: F, ur, E, deltat, m
	 * Out variables: E_nplus1
	 */
	private void computeEn() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduction241165959 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
				{
					int rId = nodesOfCellJ[rNodesOfCellJ];
					int rNodes = rId;
					reduction241165959 = reduction241165959 + (MathFunctions.dot(F[jCells][rNodesOfCellJ], ur[rNodes]));
				}
			}
			E_nplus1[jCells] = E[jCells] - (deltat / m[jCells]) * reduction241165959;
		});
	}		
	
	/**
	 * Job Copy_uj_nplus1_to_uj @12.0
	 * In variables: uj_nplus1
	 * Out variables: uj
	 */
	private void copy_uj_nplus1_to_uj() 
	{
		double[][] tmpSwitch = uj;
		uj = uj_nplus1;
		uj_nplus1 = tmpSwitch;
	}		
	
	/**
	 * Job Copy_E_nplus1_to_E @12.0
	 * In variables: E_nplus1
	 * Out variables: E
	 */
	private void copy_E_nplus1_to_E() 
	{
		double[] tmpSwitch = E;
		E = E_nplus1;
		E_nplus1 = tmpSwitch;
	}		
};
