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
		public final double LENGTH = 0.01;
		public final int X_EDGE_ELEMS = 100;
		public final int Y_EDGE_ELEMS = 10;
		public final int Z_EDGE_ELEMS = 1;
		public final double option_stoptime = 0.2;
		public final int option_max_iterations = 20000;
		public final double gammma = 1.4;
		public final double option_x_interface = 0.5;
		public final double option_deltat_ini = 1.0E-5;
		public final double option_deltat_cfl = 0.4;
		public final double option_rho_ini_zg = 1.0;
		public final double option_rho_ini_zd = 0.125;
		public final double option_p_ini_zg = 1.0;
		public final double option_p_ini_zd = 0.1;
	}
	
	private final Options options;

	// Mesh
	private final NumericMesh2D mesh;
	private final int nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;
	private final VtkFileWriter2D writer;

	// Global Variables
	private double t = 0.0;
	private double deltat = 0.0;
	private double deltat_n_plus_1 = 0.0;
	private double t_n_plus_1 = 0.0;

	// Array Variables
	private Real2 coord[], X[], b[], bt[], ur[], uj[], center[], C_ic[][], C[][], F[][], X_n_plus_1[], uj_n_plus_1[];
	private Real2x2 Ar[], Mt[], Ajr[][];
	private double p_ic[], rho_ic[], V_ic[], c[], m[], p[], rho[], e[], E[], V[], deltatj[], l[][], E_n_plus_1[];
	
	public Glace2d(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbNodesOfCell = NumericMesh2D.MaxNbNodesOfCell;
		nbCellsOfNode = NumericMesh2D.MaxNbCellsOfNode;
		nbInnerNodes = mesh.getNbInnerNodes();
		nbOuterFaces = mesh.getNbOuterFaces();
		nbNodesOfFace = NumericMesh2D.MaxNbNodesOfFace;
		writer = new VtkFileWriter2D("Glace2d");

		// Arrays allocation
		coord = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			coord[iNodes] = new Real2(0.0);
		});
		X = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			X[iNodes] = new Real2(0.0);
		});
		b = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			b[iNodes] = new Real2(0.0);
		});
		bt = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			bt[iNodes] = new Real2(0.0);
		});
		Ar = new Real2x2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			Ar[iNodes] = new Real2x2(0.0);
		});
		Mt = new Real2x2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			Mt[iNodes] = new Real2x2(0.0);
		});
		ur = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			ur[iNodes] = new Real2(0.0);
		});
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
		uj = new Real2[nbCells];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			uj[iCells] = new Real2(0.0);
		});
		center = new Real2[nbCells];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			center[iCells] = new Real2(0.0);
		});
		l = new double[nbCells][nbNodesOfCell];
		C_ic = new Real2[nbCells][nbNodesOfCell];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			IntStream.range(0, nbNodesOfCell).parallel().forEach(iNodesOfCell -> 
			{
				C_ic[iCells][iNodesOfCell] = new Real2(0.0);
			});
		});
		C = new Real2[nbCells][nbNodesOfCell];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			IntStream.range(0, nbNodesOfCell).parallel().forEach(iNodesOfCell -> 
			{
				C[iCells][iNodesOfCell] = new Real2(0.0);
			});
		});
		F = new Real2[nbCells][nbNodesOfCell];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			IntStream.range(0, nbNodesOfCell).parallel().forEach(iNodesOfCell -> 
			{
				F[iCells][iNodesOfCell] = new Real2(0.0);
			});
		});
		Ajr = new Real2x2[nbCells][nbNodesOfCell];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			IntStream.range(0, nbNodesOfCell).parallel().forEach(iNodesOfCell -> 
			{
				Ajr[iCells][iNodesOfCell] = new Real2x2(0.0);
			});
		});
		X_n_plus_1 = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			X_n_plus_1[iNodes] = new Real2(0.0);
		});
		uj_n_plus_1 = new Real2[nbCells];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			uj_n_plus_1[iCells] = new Real2(0.0);
		});
		E_n_plus_1 = new double[nbCells];

		// Copy node coordinates
		ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> coord[rNodes] = gNodes.get(rNodes));
	}
	
	/**
	 * Job IniCenter @-3.0
	 * In variables: coord
	 * Out variables: center
	 */
	private void iniCenter() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			Real2 sum18166371 = new Real2(0.0, 0.0);
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum18166371.operator_set(sum18166371.operator_plus((coord[rNodes])));
			}
			center[jCells].operator_set(sum18166371.operator_multiply((1.0 / 4.0)));
		});
	}		
	
	/**
	 * Job ComputeCjrIc @-3.0
	 * In variables: coord
	 * Out variables: C_ic
	 */
	private void computeCjrIc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				int prevRNodesOfCellJ = (rNodesOfCellJ-1+nodesOfCellJ.length)%nodesOfCellJ.length;
				int nextRNodesOfCellJ = (rNodesOfCellJ+1+nodesOfCellJ.length)%nodesOfCellJ.length;
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int prevRId = nodesOfCellJ[prevRNodesOfCellJ];
				int nextRId = nodesOfCellJ[nextRNodesOfCellJ];
				int rNodes = rId;
				int prevRNodes = prevRId;
				int nextRNodes = nextRId;
				C_ic[jCells][rNodesOfCellJ].operator_set(Glace2dFunctions.perp(coord[nextRNodes].operator_minus(coord[prevRNodes])).operator_multiply(0.5));
			}
		});
	}		
	
	/**
	 * Job ComputeXn0 @-3.0
	 * In variables: coord
	 * Out variables: X
	 */
	private void computeXn0() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			X[rNodes].operator_set(coord[rNodes]);
		});
	}		
	
	/**
	 * Job ComputeUn0 @-3.0
	 * In variables: 
	 * Out variables: uj
	 */
	private void computeUn0() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			uj[jCells].operator_set(new Real2(0.0, 0.0));
		});
	}		
	
	/**
	 * Job ComputeDt0 @-3.0
	 * In variables: option_deltat_ini
	 * Out variables: deltat
	 */
	private void computeDt0() 
	{
		deltat = options.option_deltat_ini;
	}		
	
	/**
	 * Job ComputeTn0 @-3.0
	 * In variables: 
	 * Out variables: t
	 */
	private void computeTn0() 
	{
		t = 0.0;
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
			if (center[jCells].getX() < options.option_x_interface) 
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
	 * In variables: C_ic, coord
	 * Out variables: V_ic
	 */
	private void iniVIc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double sum_730409219 = 0.0;
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum_730409219 = sum_730409219 + (MathFunctions.dot(C_ic[jCells][rNodesOfCellJ], coord[rNodes]));
			}
			V_ic[jCells] = 0.5 * sum_730409219;
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
	 * Job ComputeEn0 @-1.0
	 * In variables: p_ic, gammma, rho_ic
	 * Out variables: E
	 */
	private void computeEn0() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			E[jCells] = p_ic[jCells] / ((options.gammma - 1.0) * rho_ic[jCells]);
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
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				int prevRNodesOfCellJ = (rNodesOfCellJ-1+nodesOfCellJ.length)%nodesOfCellJ.length;
				int nextRNodesOfCellJ = (rNodesOfCellJ+1+nodesOfCellJ.length)%nodesOfCellJ.length;
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int prevRId = nodesOfCellJ[prevRNodesOfCellJ];
				int nextRId = nodesOfCellJ[nextRNodesOfCellJ];
				int rNodes = rId;
				int prevRNodes = prevRId;
				int nextRNodes = nextRId;
				C[jCells][rNodesOfCellJ].operator_set(Glace2dFunctions.perp(X[nextRNodes].operator_minus(X[prevRNodes])).operator_multiply(0.5));
			}
		});
	}		
	
	/**
	 * Job ComputeInternalEngergy @1.0
	 * In variables: E, uj
	 * Out variables: e
	 */
	private void computeInternalEngergy() 
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
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				l[jCells][rNodesOfCellJ] = MathFunctions.norm(C[jCells][rNodesOfCellJ]);
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
			double sum_633767535 = 0.0;
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum_633767535 = sum_633767535 + (MathFunctions.dot(C[jCells][rNodesOfCellJ], X[rNodes]));
			}
			V[jCells] = 0.5 * sum_633767535;
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
	 * In variables: gammma, rho, e
	 * Out variables: p
	 */
	private void computeEOSp() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			p[jCells] = (options.gammma - 1.0) * rho[jCells] * e[jCells];
		});
	}		
	
	/**
	 * Job ComputeEOSc @5.0
	 * In variables: gammma, p, rho
	 * Out variables: c
	 */
	private void computeEOSc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			c[jCells] = MathFunctions.sqrt(options.gammma * p[jCells] / rho[jCells]);
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
			double sum_199882145 = 0.0;
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				sum_199882145 = sum_199882145 + (l[jCells][rNodesOfCellJ]);
			}
			deltatj[jCells] = 2.0 * V[jCells] / (c[jCells] * sum_199882145);
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
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				Ajr[jCells][rNodesOfCellJ].operator_set(Glace2dFunctions.tensProduct(C[jCells][rNodesOfCellJ], C[jCells][rNodesOfCellJ]).operator_multiply(((rho[jCells] * c[jCells]) / l[jCells][rNodesOfCellJ])));
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
			Real2x2 sum1245405141 = new Real2x2(new Real2(0.0, 0.0), new Real2(0.0, 0.0));
			int[] cellsOfNodeR = mesh.getCellsOfNode(rId);
			for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.length; jCellsOfNodeR++)
			{
				int jId = cellsOfNodeR[jCellsOfNodeR];
				int jCells = jId;
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				int rNodesOfCellJ = Utils.indexOf(nodesOfCellJ,rId);
				sum1245405141.operator_set(sum1245405141.operator_plus((Ajr[jCells][rNodesOfCellJ])));
			}
			Ar[rNodes].operator_set(sum1245405141);
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
			Real2 sum1408291699 = new Real2(0.0, 0.0);
			int[] cellsOfNodeR = mesh.getCellsOfNode(rId);
			for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.length; jCellsOfNodeR++)
			{
				int jId = cellsOfNodeR[jCellsOfNodeR];
				int jCells = jId;
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				int rNodesOfCellJ = Utils.indexOf(nodesOfCellJ,rId);
				sum1408291699.operator_set(sum1408291699.operator_plus((C[jCells][rNodesOfCellJ].operator_multiply(p[jCells]).operator_plus(Glace2dFunctions.matVectProduct(Ajr[jCells][rNodesOfCellJ], uj[jCells])))));
			}
			b[rNodes].operator_set(sum1408291699);
		});
	}		
	
	/**
	 * Job ComputeDt @7.0
	 * In variables: deltatj, option_deltat_cfl
	 * Out variables: deltat_n_plus_1
	 */
	private void computeDt() 
	{
		double reduceMin398185839 = IntStream.range(0, nbCells).boxed().parallel().reduce(
			Double.MAX_VALUE, 
			(r, jCells) -> MathFunctions.reduceMin(r, deltatj[jCells]),
			(r1, r2) -> MathFunctions.reduceMin(r1, r2)
		);
		deltat_n_plus_1 = options.option_deltat_cfl * reduceMin398185839;
	}		
	
	/**
	 * Job Copy_deltat_n_plus_1_to_deltat @8.0
	 * In variables: deltat_n_plus_1
	 * Out variables: deltat
	 */
	private void copy_deltat_n_plus_1_to_deltat() 
	{
		double tmpSwitch = deltat;
		deltat = deltat_n_plus_1;
		deltat_n_plus_1 = tmpSwitch;
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
			Mt[rNodes].operator_set(Ar[rNodes]);
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
			bt[rNodes].operator_set(b[rNodes]);
		});
	}		
	
	/**
	 * Job OuterFacesComputations @8.0
	 * In variables: X_EDGE_ELEMS, LENGTH, Y_EDGE_ELEMS, X, b, Ar
	 * Out variables: bt, Mt
	 */
	private void outerFacesComputations() 
	{
		int[] outerFaces = mesh.getOuterFaces();
		IntStream.range(0, nbOuterFaces).parallel().forEach(kOuterFaces -> 
		{
			int kId = outerFaces[kOuterFaces];
			double epsilon = 1.0E-10;
			Real2x2 I = new Real2x2(new Real2(1.0, 0.0), new Real2(0.0, 1.0));
			double X_MIN = 0.0;
			double X_MAX = options.X_EDGE_ELEMS * options.LENGTH;
			double Y_MIN = 0.0;
			double Y_MAX = options.Y_EDGE_ELEMS * options.LENGTH;
			Real2 nY = new Real2(0.0, 1.0);
			int[] nodesOfFaceK = mesh.getNodesOfFace(kId);
			for (int rNodesOfFaceK=0; rNodesOfFaceK<nodesOfFaceK.length; rNodesOfFaceK++)
			{
				int rId = nodesOfFaceK[rNodesOfFaceK];
				int rNodes = rId;
				if ((X[rNodes].getY() - Y_MIN < epsilon) || (X[rNodes].getY() - Y_MAX < epsilon)) 
				{
					double sign = 0.0;
					if (X[rNodes].getY() - Y_MIN < epsilon) 
						sign = -1.0;
					else 
						sign = 1.0;
					Real2 n = nY.operator_multiply(sign);
					Real2x2 nxn = Glace2dFunctions.tensProduct(n, n);
					Real2x2 IcP = I.operator_minus(nxn);
					bt[rNodes].operator_set(Glace2dFunctions.matVectProduct(IcP, b[rNodes]));
					Mt[rNodes].operator_set(IcP.operator_multiply((Ar[rNodes].operator_multiply(IcP))).operator_plus(nxn.operator_multiply(Glace2dFunctions.trace(Ar[rNodes]))));
				}
				if ((MathFunctions.fabs(X[rNodes].getX() - X_MIN) < epsilon) || ((MathFunctions.fabs(X[rNodes].getX() - X_MAX) < epsilon))) 
				{
					Mt[rNodes].operator_set(I);
					bt[rNodes].operator_set(new Real2(0.0, 0.0));
				}
			}
		});
	}		
	
	/**
	 * Job ComputeTn @8.0
	 * In variables: t, deltat_n_plus_1
	 * Out variables: t_n_plus_1
	 */
	private void computeTn() 
	{
		t_n_plus_1 = t + deltat_n_plus_1;
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
	
	/**
	 * Job ComputeU @9.0
	 * In variables: Mt, bt
	 * Out variables: ur
	 */
	private void computeU() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			ur[rNodes].operator_set(Glace2dFunctions.matVectProduct(Glace2dFunctions.inverse(Mt[rNodes]), bt[rNodes]));
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
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				F[jCells][rNodesOfCellJ].operator_set(C[jCells][rNodesOfCellJ].operator_multiply(p[jCells]).operator_plus(Glace2dFunctions.matVectProduct(Ajr[jCells][rNodesOfCellJ], (uj[jCells].operator_minus(ur[rNodes])))));
			}
		});
	}		
	
	/**
	 * Job ComputeXn @10.0
	 * In variables: X, deltat, ur
	 * Out variables: X_n_plus_1
	 */
	private void computeXn() 
	{
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> 
		{
			X_n_plus_1[rNodes].operator_set(X[rNodes].operator_plus(ur[rNodes].operator_multiply(deltat)));
		});
	}		
	
	/**
	 * Job Copy_X_n_plus_1_to_X @11.0
	 * In variables: X_n_plus_1
	 * Out variables: X
	 */
	private void copy_X_n_plus_1_to_X() 
	{
		Real2[] tmpSwitch = X;
		X = X_n_plus_1;
		X_n_plus_1 = tmpSwitch;
	}		
	
	/**
	 * Job ComputeUn @11.0
	 * In variables: F, uj, deltat, m
	 * Out variables: uj_n_plus_1
	 */
	private void computeUn() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			Real2 sum_207811149 = new Real2(0.0, 0.0);
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				sum_207811149.operator_set(sum_207811149.operator_plus((F[jCells][rNodesOfCellJ])));
			}
			uj_n_plus_1[jCells].operator_set(uj[jCells].operator_minus(sum_207811149.operator_multiply((deltat / m[jCells]))));
		});
	}		
	
	/**
	 * Job ComputeEn @11.0
	 * In variables: F, ur, E, deltat, m
	 * Out variables: E_n_plus_1
	 */
	private void computeEn() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double sum_310187603 = 0.0;
			int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.length; rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum_310187603 = sum_310187603 + (MathFunctions.dot(F[jCells][rNodesOfCellJ], ur[rNodes]));
			}
			E_n_plus_1[jCells] = E[jCells] - (deltat / m[jCells]) * sum_310187603;
		});
	}		
	
	/**
	 * Job Copy_uj_n_plus_1_to_uj @12.0
	 * In variables: uj_n_plus_1
	 * Out variables: uj
	 */
	private void copy_uj_n_plus_1_to_uj() 
	{
		Real2[] tmpSwitch = uj;
		uj = uj_n_plus_1;
		uj_n_plus_1 = tmpSwitch;
	}		
	
	/**
	 * Job Copy_E_n_plus_1_to_E @12.0
	 * In variables: E_n_plus_1
	 * Out variables: E
	 */
	private void copy_E_n_plus_1_to_E() 
	{
		double[] tmpSwitch = E;
		E = E_n_plus_1;
		E_n_plus_1 = tmpSwitch;
	}		

	public void simulate()
	{
		System.out.println("Début de l'exécution du module Glace2d");
		iniCenter(); // @-3.0
		computeCjrIc(); // @-3.0
		computeXn0(); // @-3.0
		computeUn0(); // @-3.0
		computeDt0(); // @-3.0
		computeTn0(); // @-3.0
		iniIc(); // @-2.0
		iniVIc(); // @-2.0
		iniM(); // @-1.0
		computeEn0(); // @-1.0

		HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
		HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
		cellVariables.put("Density", rho);
		int iteration = 0;
		while (t < options.option_stoptime && iteration < options.option_max_iterations)
		{
			iteration++;
			System.out.println("[" + iteration + "] t = " + t);
			computeCjr(); // @1.0
			computeInternalEngergy(); // @1.0
			computeLjr(); // @2.0
			computeV(); // @2.0
			computeDensity(); // @3.0
			computeEOSp(); // @4.0
			computeEOSc(); // @5.0
			computedeltatj(); // @6.0
			computeAjr(); // @6.0
			computeAr(); // @7.0
			computeBr(); // @7.0
			computeDt(); // @7.0
			copy_deltat_n_plus_1_to_deltat(); // @8.0
			computeMt(); // @8.0
			computeBt(); // @8.0
			outerFacesComputations(); // @8.0
			computeTn(); // @8.0
			copy_t_n_plus_1_to_t(); // @9.0
			computeU(); // @9.0
			computeFjr(); // @10.0
			computeXn(); // @10.0
			copy_X_n_plus_1_to_X(); // @11.0
			computeUn(); // @11.0
			computeEn(); // @11.0
			copy_uj_n_plus_1_to_uj(); // @12.0
			copy_E_n_plus_1_to_E(); // @12.0
			writer.writeFile(iteration, X, mesh.getGeometricMesh().getQuads(), cellVariables, nodeVariables);
		}
		System.out.println("Fin de l'exécution du module Glace2d");
	}

	public static void main(String[] args)
	{
		Glace2d.Options o = new Glace2d.Options();
		Mesh<Real2> gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.LENGTH, o.LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		Glace2d i = new Glace2d(o, nm);
		i.simulate();
	}
};
