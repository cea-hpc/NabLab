package explicitheatequation;

import java.util.HashMap;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.stream.IntStream;

import fr.cea.nabla.javalib.Utils;
import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class ExplicitHeatEquation
{
	public final static class Options
	{
		public final double X_LENGTH = 2.0;
		public final double Y_LENGTH = 2.0;
		public final int X_EDGE_ELEMS = 40;
		public final int Y_EDGE_ELEMS = 40;
		public final int Z_EDGE_ELEMS = 1;
		public final double X_EDGE_LENGTH = X_LENGTH / X_EDGE_ELEMS;
		public final double Y_EDGE_LENGTH = Y_LENGTH / Y_EDGE_ELEMS;
		public final double option_stoptime = 1.0;
		public final int option_max_iterations = 500000000;
		public final double u0 = 1.0;
		public final Real2 vectOne = new Real2(1.0, 1.0);
	}
	
	private final Options options;

	// Mesh
	private final NumericMesh2D mesh;
	private final int nbNodes, nbCells, nbFaces, nbNeighbourCells, nbNodesOfCell, nbNodesOfFace, nbCellsOfFace;
	private final VtkFileWriter2D writer;

	// Global Variables
	private double t, deltat, t_nplus1;

	// Array Variables
	private Real2 X[], Xc[];
	private double xc[], yc[], u[], V[], D[], faceLength[], faceConductivity[], alpha[][], alpha_self[], u_nplus1[];
	
	public ExplicitHeatEquation(Options aOptions, NumericMesh2D aNumericMesh2D)
	{
		options = aOptions;
		mesh = aNumericMesh2D;
		writer = new VtkFileWriter2D("ExplicitHeatEquation");

		nbNodes = mesh.getNbNodes();
		nbCells = mesh.getNbCells();
		nbFaces = mesh.getNbFaces();
		nbNeighbourCells = NumericMesh2D.MaxNbNeighbourCells;
		nbNodesOfCell = NumericMesh2D.MaxNbNodesOfCell;
		nbNodesOfFace = NumericMesh2D.MaxNbNodesOfFace;
		nbCellsOfFace = NumericMesh2D.MaxNbCellsOfFace;

		t = 0.0;
		deltat = 0.001;
		t_nplus1 = 0.0;

		// Arrays allocation
		X = new Real2[nbNodes];
		IntStream.range(0, nbNodes).parallel().forEach(iNodes -> 
		{
			X[iNodes] = new Real2(0.0);
		});
		Xc = new Real2[nbCells];
		IntStream.range(0, nbCells).parallel().forEach(iCells -> 
		{
			Xc[iCells] = new Real2(0.0);
		});
		xc = new double[nbCells];
		yc = new double[nbCells];
		u = new double[nbCells];
		V = new double[nbCells];
		D = new double[nbCells];
		faceLength = new double[nbFaces];
		faceConductivity = new double[nbFaces];
		alpha = new double[nbCells][nbNeighbourCells];
		alpha_self = new double[nbCells];
		u_nplus1 = new double[nbCells];

		// Copy node coordinates
		ArrayList<Real2> gNodes = mesh.getGeometricMesh().getNodes();
		IntStream.range(0, nbNodes).parallel().forEach(rNodes -> X[rNodes] = gNodes.get(rNodes));
	}
	
	/**
	 * Job InitXc @-4.0
	 * In variables: X
	 * Out variables: Xc
	 */
	private void initXc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			int cId = cCells;
			Real2 reduceSum_2061046 = new Real2(0.0, 0.0);
			{
				int[] nodesOfCellC = mesh.getNodesOfCell(cId);
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.length; pNodesOfCellC++)
				{
					int pId = nodesOfCellC[pNodesOfCellC];
					int pNodes = pId;
					reduceSum_2061046.operator_set(reduceSum_2061046.operator_plus((X[pNodes])));
				}
			}
			Xc[cCells].operator_set(reduceSum_2061046.operator_multiply(0.25));
		});
	}		
	
	/**
	 * Job InitD @-4.0
	 * In variables: 
	 * Out variables: D
	 */
	private void initD() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			D[cCells] = 1.0;
		});
	}		
	
	/**
	 * Job ComputeV @-4.0
	 * In variables: X
	 * Out variables: V
	 */
	private void computeV() 
	{
		IntStream.range(0, nbCells).parallel().forEach(jCells -> 
		{
			int jId = jCells;
			double reduceSum269008882 = 0.0;
			{
				int[] nodesOfCellJ = mesh.getNodesOfCell(jId);
				for (int pNodesOfCellJ=0; pNodesOfCellJ<nodesOfCellJ.length; pNodesOfCellJ++)
				{
					int pId = nodesOfCellJ[pNodesOfCellJ];
					int pPlus1Id = nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell];
					int pNodes = pId;
					int pPlus1Nodes = pPlus1Id;
					reduceSum269008882 = reduceSum269008882 + (MathFunctions.det(X[pNodes], X[pPlus1Nodes]));
				}
			}
			V[jCells] = 0.5 * reduceSum269008882;
		});
	}		
	
	/**
	 * Job ComputeFaceLength @-4.0
	 * In variables: X
	 * Out variables: faceLength
	 */
	private void computeFaceLength() 
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			int fId = fFaces;
			double reduceSum_1276767410 = 0.0;
			{
				int[] nodesOfFaceF = mesh.getNodesOfFace(fId);
				for (int pNodesOfFaceF=0; pNodesOfFaceF<nodesOfFaceF.length; pNodesOfFaceF++)
				{
					int pId = nodesOfFaceF[pNodesOfFaceF];
					int pPlus1Id = nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace];
					int pNodes = pId;
					int pPlus1Nodes = pPlus1Id;
					reduceSum_1276767410 = reduceSum_1276767410 + (MathFunctions.norm(X[pNodes].operator_minus(X[pPlus1Nodes])));
				}
			}
			faceLength[fFaces] = 0.5 * reduceSum_1276767410;
		});
	}		
	
	/**
	 * Job InitXcAndYc @-3.0
	 * In variables: Xc
	 * Out variables: xc, yc
	 */
	private void initXcAndYc() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			xc[cCells] = Xc[cCells].getX();
			yc[cCells] = Xc[cCells].getY();
		});
	}		
	
	/**
	 * Job InitU @-3.0
	 * In variables: Xc, vectOne, u0
	 * Out variables: u
	 */
	private void initU() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			if (MathFunctions.norm(Xc[cCells].operator_minus(options.vectOne)) < 0.5) 
				u[cCells] = options.u0;
			else 
				u[cCells] = 0.0;
		});
	}		
	
	/**
	 * Job computeDeltaTn @-3.0
	 * In variables: X_EDGE_LENGTH, Y_EDGE_LENGTH, D
	 * Out variables: deltat
	 */
	private void computeDeltaTn() 
	{
		double reduceMin_208148189 = IntStream.range(0, nbCells).boxed().parallel().reduce(
			Double.MAX_VALUE, 
			(r, cCells) -> MathFunctions.reduceMin(r, options.X_EDGE_LENGTH * options.Y_EDGE_LENGTH / D[cCells]),
			(r1, r2) -> MathFunctions.reduceMin(r1, r2)
		);
		deltat = reduceMin_208148189 * 0.24;
	}		
	
	/**
	 * Job ComputeFaceConductivity @-3.0
	 * In variables: D
	 * Out variables: faceConductivity
	 */
	private void computeFaceConductivity() 
	{
		IntStream.range(0, nbFaces).parallel().forEach(fFaces -> 
		{
			int fId = fFaces;
			double reduceProd_784902332 = 1.0;
			{
				int[] cellsOfFaceF = mesh.getCellsOfFace(fId);
				for (int c1CellsOfFaceF=0; c1CellsOfFaceF<cellsOfFaceF.length; c1CellsOfFaceF++)
				{
					int c1Id = cellsOfFaceF[c1CellsOfFaceF];
					int c1Cells = c1Id;
					reduceProd_784902332 = reduceProd_784902332 * (D[c1Cells]);
				}
			}
			double reduceSum1502882730 = 0.0;
			{
				int[] cellsOfFaceF = mesh.getCellsOfFace(fId);
				for (int c2CellsOfFaceF=0; c2CellsOfFaceF<cellsOfFaceF.length; c2CellsOfFaceF++)
				{
					int c2Id = cellsOfFaceF[c2CellsOfFaceF];
					int c2Cells = c2Id;
					reduceSum1502882730 = reduceSum1502882730 + (D[c2Cells]);
				}
			}
			faceConductivity[fFaces] = 2.0 * reduceProd_784902332 / reduceSum1502882730;
		});
	}		
	
	/**
	 * Job computeAlphaCoeff @-2.0
	 * In variables: deltat, V, faceLength, faceConductivity, Xc
	 * Out variables: alpha
	 */
	private void computeAlphaCoeff() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			int cId = cCells;
			{
				int[] neighbourCellsC = mesh.getNeighbourCells(cId);
				for (int dNeighbourCellsC=0; dNeighbourCellsC<neighbourCellsC.length; dNeighbourCellsC++)
				{
					int dId = neighbourCellsC[dNeighbourCellsC];
					int dCells = dId;
					int fId = mesh.getCommonFace(cId, dId);
					int fFaces = fId;
					alpha[cCells][dNeighbourCellsC] = deltat / V[cCells] * (faceLength[fFaces] * faceConductivity[fFaces]) / MathFunctions.norm(Xc[cCells].operator_minus(Xc[dCells]));
				}
			}
		});
	}		
	
	/**
	 * Job computeOwnAlphaCoeff @-1.0
	 * In variables: alpha
	 * Out variables: alpha_self
	 */
	private void computeOwnAlphaCoeff() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			int cId = cCells;
			double reduceSum_502085502 = 0.0;
			{
				int[] neighbourCellsC = mesh.getNeighbourCells(cId);
				for (int dNeighbourCellsC=0; dNeighbourCellsC<neighbourCellsC.length; dNeighbourCellsC++)
				{
					reduceSum_502085502 = reduceSum_502085502 + (alpha[cCells][dNeighbourCellsC]);
				}
			}
			alpha_self[cCells] = 1 - reduceSum_502085502;
		});
	}		
	
	/**
	 * Job UpdateU @1.0
	 * In variables: alpha, u, alpha_self
	 * Out variables: u_nplus1
	 */
	private void updateU() 
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			int cId = cCells;
			double reduceSum_1460062710 = 0.0;
			{
				int[] neighbourCellsC = mesh.getNeighbourCells(cId);
				for (int dNeighbourCellsC=0; dNeighbourCellsC<neighbourCellsC.length; dNeighbourCellsC++)
				{
					int dId = neighbourCellsC[dNeighbourCellsC];
					int dCells = dId;
					reduceSum_1460062710 = reduceSum_1460062710 + (alpha[cCells][dNeighbourCellsC] * u[dCells]);
				}
			}
			u_nplus1[cCells] = alpha_self[cCells] * u[cCells] + reduceSum_1460062710;
		});
	}		
	
	/**
	 * Job ComputeTn @1.0
	 * In variables: t, deltat
	 * Out variables: t_nplus1
	 */
	private void computeTn() 
	{
		t_nplus1 = t + deltat;
	}		
	
	/**
	 * Job Copy_u_nplus1_to_u @2.0
	 * In variables: u_nplus1
	 * Out variables: u
	 */
	private void copy_u_nplus1_to_u() 
	{
		double[] tmpSwitch = u;
		u = u_nplus1;
		u_nplus1 = tmpSwitch;
	}		
	
	/**
	 * Job Copy_t_nplus1_to_t @2.0
	 * In variables: t_nplus1
	 * Out variables: t
	 */
	private void copy_t_nplus1_to_t() 
	{
		double tmpSwitch = t;
		t = t_nplus1;
		t_nplus1 = tmpSwitch;
	}		

	public void simulate()
	{
		System.out.println("Début de l'exécution du module ExplicitHeatEquation");
		initXc(); // @-4.0
		initD(); // @-4.0
		computeV(); // @-4.0
		computeFaceLength(); // @-4.0
		initXcAndYc(); // @-3.0
		initU(); // @-3.0
		computeDeltaTn(); // @-3.0
		computeFaceConductivity(); // @-3.0
		computeAlphaCoeff(); // @-2.0
		computeOwnAlphaCoeff(); // @-1.0

		HashMap<String, double[]> cellVariables = new HashMap<String, double[]>();
		HashMap<String, double[]> nodeVariables = new HashMap<String, double[]>();
		cellVariables.put("Vitesse", u);
		int iteration = 0;
		while (t < options.option_stoptime && iteration < options.option_max_iterations)
		{
			iteration++;
			System.out.println("[" + iteration + "] t = " + t);
			updateU(); // @1.0
			computeTn(); // @1.0
			copy_u_nplus1_to_u(); // @2.0
			copy_t_nplus1_to_t(); // @2.0
			writer.writeFile(iteration, X, mesh.getGeometricMesh().getQuads(), cellVariables, nodeVariables);
		}
		System.out.println("Fin de l'exécution du module ExplicitHeatEquation");
	}

	public static void main(String[] args)
	{
		ExplicitHeatEquation.Options o = new ExplicitHeatEquation.Options();
		Mesh<Real2> gm = CartesianMesh2DGenerator.generate(o.X_EDGE_ELEMS, o.Y_EDGE_ELEMS, o.X_EDGE_LENGTH, o.Y_EDGE_LENGTH);
		NumericMesh2D nm = new NumericMesh2D(gm);
		ExplicitHeatEquation i = new ExplicitHeatEquation(o, nm);
		i.simulate();
	}
};
