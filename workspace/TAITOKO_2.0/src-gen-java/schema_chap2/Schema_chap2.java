package schema_chap2;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.HashMap;
import java.util.stream.IntStream;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.stream.JsonReader;

import fr.cea.nabla.javalib.types.*;
import fr.cea.nabla.javalib.mesh.*;

@SuppressWarnings("all")
public final class Schema_chap2
{
	public final static class Options
	{
		public String outputPath;
		public int outputPeriod;
		public double X_LENGTH;
		public double Y_LENGTH;
		public int X_EDGE_ELEMS;
		public int Y_EDGE_ELEMS;
		public double X_EDGE_LENGTH;
		public double Y_EDGE_LENGTH;
		public int maxIter;
		public double stopTime;
	}

	private final Options options;

	// Global definitions
	private double t_n;
	private double t_nplus1;
	private final double deltat;
	private final double deltax;
	private final double deltay;
	private final double g;
	private final double C;
	private final double F;
	private int lastDump;

	// Mesh (can depend on previous definitions)
	private final CartesianMesh2D mesh;
	private final FileWriter writer;
	private final int nbNodes, nbFaces, nbInnerFaces, nbOuterFaces, nbInnerVerticalFaces, nbInnerHorizontalFaces, nbCompletelyInnerFaces, nbCompletelyInnerVerticalFaces, nbCompletelyInnerHorizontalFaces, nbCells, nbInnerCells, nbOuterCells, nbTopCells, nbBottomCells, nbLeftCells, nbRightCells, nbNeighbourCells, nbNodesOfCell, nbFacesOfCell, nbNodesOfFace, nbCellsOfFace;

	// Global declarations
	private int n;
	private double[][] X;
	private double[][] Xc;
	private double[] xc;
	private double[] yc;
	private double[] U_n;
	private double[] U_nplus1;
	private double[] U_n0;
	private double[] V_n;
	private double[] V_nplus1;
	private double[] V_n0;
	private double[] H_n;
	private double[] H_nplus1;
	private double[] H_n0;
	private double[] Rij_n;
	private double[] Rij_nplus1;
	private double[] Rij_n0;
	private double[] Fx;
	private double[] Fy;
	private double[] Dij;

	public Schema_chap2(Options aOptions)
	{
		options = aOptions;

		// Initialize variables with default values
		t_n = 0.0;
		t_nplus1 = 0.0;
		deltat = 0.05;
		deltax = options.X_EDGE_LENGTH;
		deltay = options.Y_EDGE_LENGTH;
		g = -9.8;
		C = 40.0;
		F = 1.0E-5;
		lastDump = Integer.MIN_VALUE;

		// Initialize mesh variables
		mesh = CartesianMesh2DGenerator.generate(options.X_EDGE_ELEMS, options.Y_EDGE_ELEMS, options.X_EDGE_LENGTH, options.Y_EDGE_LENGTH);
		writer = new PvdFileWriter2D("Schema_chap2", options.outputPath);
		nbNodes = mesh.getNbNodes();
		nbFaces = mesh.getNbFaces();
		nbInnerFaces = mesh.getNbInnerFaces();
		nbOuterFaces = mesh.getNbOuterFaces();
		nbInnerVerticalFaces = mesh.getNbInnerVerticalFaces();
		nbInnerHorizontalFaces = mesh.getNbInnerHorizontalFaces();
		nbCompletelyInnerFaces = mesh.getNbCompletelyInnerFaces();
		nbCompletelyInnerVerticalFaces = mesh.getNbCompletelyInnerVerticalFaces();
		nbCompletelyInnerHorizontalFaces = mesh.getNbCompletelyInnerHorizontalFaces();
		nbCells = mesh.getNbCells();
		nbInnerCells = mesh.getNbInnerCells();
		nbOuterCells = mesh.getNbOuterCells();
		nbTopCells = mesh.getNbTopCells();
		nbBottomCells = mesh.getNbBottomCells();
		nbLeftCells = mesh.getNbLeftCells();
		nbRightCells = mesh.getNbRightCells();
		nbNeighbourCells = CartesianMesh2D.MaxNbNeighbourCells;
		nbNodesOfCell = CartesianMesh2D.MaxNbNodesOfCell;
		nbFacesOfCell = CartesianMesh2D.MaxNbFacesOfCell;
		nbNodesOfFace = CartesianMesh2D.MaxNbNodesOfFace;
		nbCellsOfFace = CartesianMesh2D.MaxNbCellsOfFace;

		// Allocate arrays
		X = new double[nbNodes][2];
		Xc = new double[nbCells][2];
		xc = new double[nbCells];
		yc = new double[nbCells];
		U_n = new double[nbFaces];
		U_nplus1 = new double[nbFaces];
		U_n0 = new double[nbFaces];
		V_n = new double[nbFaces];
		V_nplus1 = new double[nbFaces];
		V_n0 = new double[nbFaces];
		H_n = new double[nbCells];
		H_nplus1 = new double[nbCells];
		H_n0 = new double[nbCells];
		Rij_n = new double[nbCells];
		Rij_nplus1 = new double[nbCells];
		Rij_n0 = new double[nbCells];
		Fx = new double[nbCells];
		Fy = new double[nbCells];
		Dij = new double[nbCells];

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
		System.out.println("Start execution of module Schema_chap2");
		initDij(); // @1.0
		initFxy(); // @1.0
		initRij(); // @1.0
		initU(); // @1.0
		initV(); // @1.0
		initXc(); // @1.0
		initXcAndYc(); // @2.0
		initH1(); // @3.0
		setUpTimeLoopN(); // @4.0
		executeTimeLoopN(); // @5.0
		System.out.println("End of execution of module Schema_chap2");
	}

	public static void main(String[] args) throws FileNotFoundException
	{
		if (args.length == 1)
		{
			String dataFileName = args[0];
			JsonParser parser = new JsonParser();
			JsonObject o = parser.parse(new FileReader(dataFileName)).getAsJsonObject();
			Gson gson = new Gson();

			Schema_chap2.Options options = (o.has("options") ? gson.fromJson(o.get("options"), Schema_chap2.Options.class) : new Schema_chap2.Options());

			Schema_chap2 simulator = new Schema_chap2(options);
			simulator.simulate();
		}
		else
		{
			System.out.println("[ERROR] Wrong number of arguments: expected 1, actual " + args.length);
			System.out.println("        Expecting user data file name, for example Schema_chap2DefaultOptions.json");
		}
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
	 * Job InitDij called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: Dij
	 */
	private void initDij()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			Dij[cCells] = -4000.0;
		});
	}

	/**
	 * Job InitFxy called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: Fx, Fy
	 */
	private void initFxy()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			Fx[cCells] = 0.0;
			Fy[cCells] = 0.0;
		});
	}

	/**
	 * Job InitRij called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: Rij_n0
	 */
	private void initRij()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			Rij_n0[cCells] = 0.0;
		});
	}

	/**
	 * Job InitU called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: U_n0
	 */
	private void initU()
	{
		{
			final int[] innerFaces = mesh.getInnerFaces();
			final int nbInnerFaces = innerFaces.length;
			IntStream.range(0, nbInnerFaces).parallel().forEach(fInnerFaces -> 
			{
				final int fId = innerFaces[fInnerFaces];
				final int fFaces = fId;
				U_n0[fFaces] = 0.0;
			});
		}
	}

	/**
	 * Job InitV called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: V_n0
	 */
	private void initV()
	{
		{
			final int[] innerFaces = mesh.getInnerFaces();
			final int nbInnerFaces = innerFaces.length;
			IntStream.range(0, nbInnerFaces).parallel().forEach(fInnerFaces -> 
			{
				final int fId = innerFaces[fInnerFaces];
				final int fFaces = fId;
				V_n0[fFaces] = 0.0;
			});
		}
	}

	/**
	 * Job InitXc called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: Xc
	 */
	private void initXc()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			final int cId = cCells;
			double[] reduction0 = new double[] {0.0, 0.0};
			{
				final int[] nodesOfCellC = mesh.getNodesOfCell(cId);
				final int nbNodesOfCellC = nodesOfCellC.length;
				for (int pNodesOfCellC=0; pNodesOfCellC<nbNodesOfCellC; pNodesOfCellC++)
				{
					final int pId = nodesOfCellC[pNodesOfCellC];
					final int pNodes = pId;
					reduction0 = sumR1(reduction0, X[pNodes]);
				}
			}
			Xc[cCells] = ArrayOperations.multiply(0.25, reduction0);
		});
	}

	/**
	 * Job UpdateHouter called @1.0 in executeTimeLoopN method.
	 * In variables: H_n
	 * Out variables: H_nplus1
	 */
	private void updateHouter()
	{
		{
			final int[] topCells = mesh.getTopCells();
			final int nbTopCells = topCells.length;
			IntStream.range(0, nbTopCells).parallel().forEach(tcTopCells -> 
			{
				final int tcId = topCells[tcTopCells];
				final int tcCells = tcId;
				final int bcId = mesh.getBottomCell(tcId);
				final int bcCells = bcId;
				H_nplus1[tcCells] = H_n[bcCells];
			});
		}
		{
			final int[] bottomCells = mesh.getBottomCells();
			final int nbBottomCells = bottomCells.length;
			IntStream.range(0, nbBottomCells).parallel().forEach(bcBottomCells -> 
			{
				final int bcId = bottomCells[bcBottomCells];
				final int bcCells = bcId;
				final int tcId = mesh.getTopCell(bcId);
				final int tcCells = tcId;
				H_nplus1[bcCells] = H_n[tcCells];
			});
		}
		{
			final int[] leftCells = mesh.getLeftCells();
			final int nbLeftCells = leftCells.length;
			IntStream.range(0, nbLeftCells).parallel().forEach(lcLeftCells -> 
			{
				final int lcId = leftCells[lcLeftCells];
				final int lcCells = lcId;
				final int rcId = mesh.getRightCell(lcId);
				final int rcCells = rcId;
				H_nplus1[lcCells] = H_n[rcCells];
			});
		}
		{
			final int[] rightCells = mesh.getRightCells();
			final int nbRightCells = rightCells.length;
			IntStream.range(0, nbRightCells).parallel().forEach(rcRightCells -> 
			{
				final int rcId = rightCells[rcRightCells];
				final int rcCells = rcId;
				final int lcId = mesh.getLeftCell(rcId);
				final int lcCells = lcId;
				H_nplus1[rcCells] = H_n[lcCells];
			});
		}
	}

	/**
	 * Job UpdateRij called @1.0 in executeTimeLoopN method.
	 * In variables: Rij_n, t_n, xc
	 * Out variables: Rij_nplus1
	 */
	private void updateRij()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			if (t_n < 1 && xc[cCells] < 5000)
				Rij_nplus1[cCells] = Rij_n[cCells] - 0.1;
			else
				Rij_nplus1[cCells] = Rij_n[cCells] + 0.0;
		});
	}

	/**
	 * Job UpdateUinner called @1.0 in executeTimeLoopN method.
	 * In variables: C, Dij, F, Fx, H_n, U_n, V_n, deltat, deltax, deltay, g
	 * Out variables: U_nplus1
	 */
	private void updateUinner()
	{
		{
			final int[] completelyInnerVerticalFaces = mesh.getCompletelyInnerVerticalFaces();
			final int nbCompletelyInnerVerticalFaces = completelyInnerVerticalFaces.length;
			IntStream.range(0, nbCompletelyInnerVerticalFaces).parallel().forEach(civfCompletelyInnerVerticalFaces -> 
			{
				final int civfId = completelyInnerVerticalFaces[civfCompletelyInnerVerticalFaces];
				final int civfFaces = civfId;
				double TV = 0.0;
				double TU1 = 0.0;
				double TU2 = 0.0;
				double THU = 0.0;
				double SB = 0.0;
				{
					final int fijId = mesh.getBottomRightFaceNeighbour(civfId);
					final int fijFaces = fijId;
					final int fijplus1Id = mesh.getTopRightFaceNeighbour(civfId);
					final int fijplus1Faces = fijplus1Id;
					final int fimoins1jplus1Id = mesh.getTopLeftFaceNeighbour(civfId);
					final int fimoins1jplus1Faces = fimoins1jplus1Id;
					final int fimoins1jId = mesh.getBottomLeftFaceNeighbour(civfId);
					final int fimoins1jFaces = fimoins1jId;
					TV = 0.25 * (V_n[fijFaces] + V_n[fijplus1Faces] + V_n[fimoins1jplus1Faces] + V_n[fimoins1jFaces]);
				}
				if (U_n[civfFaces] < 0)
				{
					{
						final int fiplus1jId = mesh.getRightFaceNeighbour(civfId);
						final int fiplus1jFaces = fiplus1jId;
						TU1 = U_n[fiplus1jFaces] - U_n[civfFaces];
					}
				}
				else
				{
					{
						final int fimoins1jId = mesh.getLeftFaceNeighbour(civfId);
						final int fimoins1jFaces = fimoins1jId;
						TU1 = U_n[civfFaces] - U_n[fimoins1jFaces];
					}
				}
				if (TV < 0)
				{
					{
						final int fijplus1Id = mesh.getTopFaceNeighbour(civfId);
						final int fijplus1Faces = fijplus1Id;
						TU2 = U_n[fijplus1Faces] - U_n[civfFaces];
					}
				}
				else
				{
					{
						final int fijmoins1Id = mesh.getBottomFaceNeighbour(civfId);
						final int fijmoins1Faces = fijmoins1Id;
						TU2 = U_n[civfFaces] - U_n[fijmoins1Faces];
					}
				}
				{
					final int cijId = mesh.getFrontCell(civfId);
					final int cijCells = cijId;
					final int cimoins1jId = mesh.getLeftCell(cijId);
					final int cimoins1jCells = cimoins1jId;
					THU = H_n[cijCells] - H_n[cimoins1jCells];
				}
				{
					final int cijId = mesh.getFrontCell(civfId);
					final int cijCells = cijId;
					final int fijvId = mesh.getBottomRightFaceNeighbour(civfId);
					final int fijvFaces = fijvId;
					SB = g * U_n[civfFaces] * (Math.sqrt(U_n[civfFaces] * U_n[civfFaces] + V_n[fijvFaces] * V_n[fijvFaces])) / (C * C * (Dij[cijCells] + H_n[cijCells]));
				}
				{
					final int fijvId = mesh.getBottomRightFaceNeighbour(civfId);
					final int fijvFaces = fijvId;
					final int cijId = mesh.getFrontCell(civfId);
					final int cijCells = cijId;
					U_nplus1[civfFaces] = U_n[civfFaces] - deltat * (U_n[civfFaces] * TU1 / deltax + TV * TU2 / deltay) - g * deltat / deltax * THU + deltat * (-F * V_n[fijvFaces] - Fx[cijCells] + SB);
				}
			});
		}
	}

	/**
	 * Job UpdateUouter called @1.0 in executeTimeLoopN method.
	 * In variables: U_n
	 * Out variables: U_nplus1
	 */
	private void updateUouter()
	{
		{
			final int[] topCells = mesh.getTopCells();
			final int nbTopCells = topCells.length;
			IntStream.range(0, nbTopCells).parallel().forEach(tcTopCells -> 
			{
				final int tcId = topCells[tcTopCells];
				final int rfId = mesh.getRightFaceOfCell(tcId);
				final int rfFaces = rfId;
				final int bfId = mesh.getBottomFaceOfCell(tcId);
				final int bcId = mesh.getFrontCell(bfId);
				final int brfId = mesh.getRightFaceOfCell(bcId);
				final int brfFaces = brfId;
				U_nplus1[rfFaces] = U_n[brfFaces];
			});
		}
		{
			final int[] bottomCells = mesh.getBottomCells();
			final int nbBottomCells = bottomCells.length;
			IntStream.range(0, nbBottomCells).parallel().forEach(bcBottomCells -> 
			{
				final int bcId = bottomCells[bcBottomCells];
				final int rfId = mesh.getRightFaceOfCell(bcId);
				final int rfFaces = rfId;
				final int tfId = mesh.getTopFaceOfCell(bcId);
				final int bcfId = mesh.getBackCell(tfId);
				final int trfId = mesh.getRightFaceOfCell(bcfId);
				final int trfFaces = trfId;
				U_nplus1[rfFaces] = U_n[trfFaces];
			});
		}
		{
			final int[] leftCells = mesh.getLeftCells();
			final int nbLeftCells = leftCells.length;
			IntStream.range(0, nbLeftCells).parallel().forEach(lcLeftCells -> 
			{
				final int lcId = leftCells[lcLeftCells];
				final int lfId = mesh.getLeftFaceOfCell(lcId);
				final int lfFaces = lfId;
				final int rfId = mesh.getRightFaceOfCell(lcId);
				final int rfFaces = rfId;
				U_nplus1[lfFaces] = U_n[rfFaces];
			});
		}
		{
			final int[] rightCells = mesh.getRightCells();
			final int nbRightCells = rightCells.length;
			IntStream.range(0, nbRightCells).parallel().forEach(rcRightCells -> 
			{
				final int rcId = rightCells[rcRightCells];
				final int rfId = mesh.getRightFaceOfCell(rcId);
				final int rfFaces = rfId;
				final int lfId = mesh.getLeftFaceOfCell(rcId);
				final int lfFaces = lfId;
				U_nplus1[rfFaces] = U_n[lfFaces];
			});
		}
	}

	/**
	 * Job UpdateVinner called @1.0 in executeTimeLoopN method.
	 * In variables: C, Dij, F, Fx, H_n, U_n, V_n, deltat, deltax, deltay, g
	 * Out variables: V_nplus1
	 */
	private void updateVinner()
	{
		{
			final int[] completelyInnerHorizontalFaces = mesh.getCompletelyInnerHorizontalFaces();
			final int nbCompletelyInnerHorizontalFaces = completelyInnerHorizontalFaces.length;
			IntStream.range(0, nbCompletelyInnerHorizontalFaces).parallel().forEach(cihfCompletelyInnerHorizontalFaces -> 
			{
				final int cihfId = completelyInnerHorizontalFaces[cihfCompletelyInnerHorizontalFaces];
				final int cihfFaces = cihfId;
				double TU = 0.0;
				double TV1 = 0.0;
				double TV2 = 0.0;
				double THV = 0.0;
				double SB = 0.0;
				{
					final int fijId = mesh.getTopLeftFaceNeighbour(cihfId);
					final int fijFaces = fijId;
					final int fiplus1jId = mesh.getTopRightFaceNeighbour(cihfId);
					final int fiplus1jFaces = fiplus1jId;
					final int fijmoins1Id = mesh.getBottomLeftFaceNeighbour(cihfId);
					final int fijmoins1Faces = fijmoins1Id;
					final int fiplus1jmoins1Id = mesh.getBottomRightFaceNeighbour(cihfId);
					final int fiplus1jmoins1Faces = fiplus1jmoins1Id;
					TU = 0.25 * (U_n[fijFaces] + U_n[fiplus1jFaces] + U_n[fijmoins1Faces] + U_n[fiplus1jmoins1Faces]);
				}
				if (TU < 0)
				{
					{
						final int fiplus1jId = mesh.getRightFaceNeighbour(cihfId);
						final int fiplus1jFaces = fiplus1jId;
						TV1 = V_n[fiplus1jFaces] - V_n[cihfFaces];
					}
				}
				else
				{
					{
						final int fimoins1jId = mesh.getLeftFaceNeighbour(cihfId);
						final int fimoins1jFaces = fimoins1jId;
						TV1 = V_n[cihfFaces] - V_n[fimoins1jFaces];
					}
				}
				if (V_n[cihfFaces] < 0)
				{
					{
						final int fijplus1Id = mesh.getTopFaceNeighbour(cihfId);
						final int fijplus1Faces = fijplus1Id;
						TV2 = V_n[fijplus1Faces] - V_n[cihfFaces];
					}
				}
				else
				{
					{
						final int fijmoins1Id = mesh.getBottomFaceNeighbour(cihfId);
						final int fijmoins1Faces = fijmoins1Id;
						TV2 = V_n[cihfFaces] - V_n[fijmoins1Faces];
					}
				}
				{
					final int cijId = mesh.getBackCell(cihfId);
					final int cijCells = cijId;
					final int cijmoins1Id = mesh.getFrontCell(cihfId);
					final int cijmoins1Cells = cijmoins1Id;
					THV = H_n[cijCells] - H_n[cijmoins1Cells];
				}
				{
					final int cijId = mesh.getBackCell(cihfId);
					final int cijCells = cijId;
					final int fijvId = mesh.getTopLeftFaceNeighbour(cihfId);
					final int fijvFaces = fijvId;
					SB = g * U_n[fijvFaces] * (Math.sqrt(U_n[fijvFaces] * U_n[fijvFaces] + V_n[cihfFaces] * V_n[cihfFaces])) / (C * C * (Dij[cijCells] + H_n[cijCells]));
				}
				{
					final int fijvId = mesh.getTopLeftFaceNeighbour(cihfId);
					final int fijvFaces = fijvId;
					final int cijId = mesh.getBackCell(cihfId);
					final int cijCells = cijId;
					V_nplus1[cihfFaces] = V_n[cihfFaces] - deltat * (V_n[cihfFaces] * TV1 / deltax + TU * TV2 / deltay) - g * deltat / deltax * THV + deltat * (-F * U_n[fijvFaces] - Fx[cijCells] + SB);
				}
			});
		}
	}

	/**
	 * Job UpdateVouter called @1.0 in executeTimeLoopN method.
	 * In variables: V_n
	 * Out variables: V_nplus1
	 */
	private void updateVouter()
	{
		{
			final int[] topCells = mesh.getTopCells();
			final int nbTopCells = topCells.length;
			IntStream.range(0, nbTopCells).parallel().forEach(tcTopCells -> 
			{
				final int tcId = topCells[tcTopCells];
				final int bfId = mesh.getBottomFaceOfCell(tcId);
				final int bfFaces = bfId;
				final int tfId = mesh.getTopFaceOfCell(tcId);
				final int tfFaces = tfId;
				V_nplus1[tfFaces] = V_n[bfFaces];
			});
		}
		{
			final int[] bottomCells = mesh.getBottomCells();
			final int nbBottomCells = bottomCells.length;
			IntStream.range(0, nbBottomCells).parallel().forEach(bcBottomCells -> 
			{
				final int bcId = bottomCells[bcBottomCells];
				final int bfId = mesh.getBottomFaceOfCell(bcId);
				final int bfFaces = bfId;
				final int tfId = mesh.getTopFaceOfCell(bcId);
				final int tfFaces = tfId;
				V_nplus1[bfFaces] = V_n[tfFaces];
			});
		}
		{
			final int[] leftCells = mesh.getLeftCells();
			final int nbLeftCells = leftCells.length;
			IntStream.range(0, nbLeftCells).parallel().forEach(lcLeftCells -> 
			{
				final int lcId = leftCells[lcLeftCells];
				final int bfId = mesh.getBottomFaceOfCell(lcId);
				final int bfFaces = bfId;
				final int rfId = mesh.getRightFaceOfCell(lcId);
				final int rcId = mesh.getFrontCell(rfId);
				final int bfrcId = mesh.getBottomFaceOfCell(rcId);
				final int bfrcFaces = bfrcId;
				V_nplus1[bfFaces] = V_n[bfrcFaces];
			});
		}
		{
			final int[] rightCells = mesh.getRightCells();
			final int nbRightCells = rightCells.length;
			IntStream.range(0, nbRightCells).parallel().forEach(rcRightCells -> 
			{
				final int rcId = rightCells[rcRightCells];
				final int bfId = mesh.getBottomFaceOfCell(rcId);
				final int bfFaces = bfId;
				final int lfId = mesh.getLeftFaceOfCell(rcId);
				final int lcId = mesh.getBackCell(lfId);
				final int bflcId = mesh.getBottomFaceOfCell(lcId);
				final int bflcFaces = bflcId;
				V_nplus1[bfFaces] = V_n[bflcFaces];
			});
		}
	}

	/**
	 * Job InitXcAndYc called @2.0 in simulate method.
	 * In variables: Xc
	 * Out variables: xc, yc
	 */
	private void initXcAndYc()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			xc[cCells] = Xc[cCells][0];
			yc[cCells] = Xc[cCells][1];
		});
	}

	/**
	 * Job UpdateHinner called @2.0 in executeTimeLoopN method.
	 * In variables: Dij, H_n, Rij_n, Rij_nplus1, U_n, V_n, deltat, deltax, deltay
	 * Out variables: H_nplus1
	 */
	private void updateHinner()
	{
		{
			final int[] innerCells = mesh.getInnerCells();
			final int nbInnerCells = innerCells.length;
			IntStream.range(0, nbInnerCells).parallel().forEach(cInnerCells -> 
			{
				final int cId = innerCells[cInnerCells];
				final int cCells = cId;
				double TD1 = 0.0;
				double TD2 = 0.0;
				double TV1 = 0.0;
				double TV2 = 0.0;
				{
					final int rfId = mesh.getRightFaceOfCell(cId);
					final int rfFaces = rfId;
					if (U_n[rfFaces] < 0)
					{
						{
							final int rcId = mesh.getRightCell(cId);
							final int rcCells = rcId;
							TD1 = Dij[rcCells] + H_n[rcCells] - Rij_n[rcCells];
						}
					}
					else
						TD1 = Dij[cCells] + H_n[cCells] - Rij_n[cCells];
				}
				{
					final int lfId = mesh.getLeftFaceOfCell(cId);
					final int lfFaces = lfId;
					if (U_n[lfFaces] < 0)
						TD2 = Dij[cCells] + H_n[cCells] - Rij_n[cCells];
					else
					{
						{
							final int lcId = mesh.getLeftCell(cId);
							final int lcCells = lcId;
							TD2 = Dij[lcCells] + H_n[lcCells] - Rij_n[lcCells];
						}
					}
				}
				{
					final int tfId = mesh.getTopFaceOfCell(cId);
					final int tfFaces = tfId;
					if (V_n[tfFaces] < 0)
					{
						{
							final int tcId = mesh.getTopCell(cId);
							final int tcCells = tcId;
							TV1 = Dij[tcCells] + H_n[tcCells] - Rij_n[tcCells];
						}
					}
					else
						TV1 = Dij[cCells] + H_n[cCells] - Rij_n[cCells];
				}
				{
					final int bfId = mesh.getBottomFaceOfCell(cId);
					final int bfFaces = bfId;
					if (V_n[bfFaces] < 0)
						TV2 = Dij[cCells] + H_n[cCells] - Rij_n[cCells];
					else
					{
						{
							final int bcId = mesh.getBottomCell(cId);
							final int bcCells = bcId;
							TV2 = Dij[bcCells] + H_n[bcCells] - Rij_n[bcCells];
						}
					}
				}
				{
					final int rfId = mesh.getRightFaceOfCell(cId);
					final int rfFaces = rfId;
					final int lfId = mesh.getLeftFaceOfCell(cId);
					final int lfFaces = lfId;
					final int tfId = mesh.getTopFaceOfCell(cId);
					final int tfFaces = tfId;
					final int bfId = mesh.getBottomFaceOfCell(cId);
					final int bfFaces = bfId;
					H_nplus1[cCells] = H_n[cCells] - deltat * (U_n[rfFaces] * TD1 / deltax - U_n[lfFaces] * TD2 / deltax + V_n[tfFaces] * TV1 / deltay - V_n[bfFaces] * TV2 / deltay) + Rij_nplus1[cCells] - Rij_n[cCells];
				}
			});
		}
	}

	/**
	 * Job InitH1 called @3.0 in simulate method.
	 * In variables: xc
	 * Out variables: H_n0
	 */
	private void initH1()
	{
		IntStream.range(0, nbCells).parallel().forEach(cCells -> 
		{
			if (xc[cCells] < 5000)
				H_n0[cCells] = 0.0;
			else
				H_n0[cCells] = 0.0;
		});
	}

	/**
	 * Job SetUpTimeLoopN called @4.0 in simulate method.
	 * In variables: H_n0, Rij_n0, U_n0, V_n0
	 * Out variables: H_n, Rij_n, U_n, V_n
	 */
	private void setUpTimeLoopN()
	{
		IntStream.range(0, U_n.length).parallel().forEach(i1 -> 
		{
			U_n[i1] = U_n0[i1];
		});
		IntStream.range(0, V_n.length).parallel().forEach(i1 -> 
		{
			V_n[i1] = V_n0[i1];
		});
		IntStream.range(0, H_n.length).parallel().forEach(i1 -> 
		{
			H_n[i1] = H_n0[i1];
		});
		IntStream.range(0, Rij_n.length).parallel().forEach(i1 -> 
		{
			Rij_n[i1] = Rij_n0[i1];
		});
	}

	/**
	 * Job ExecuteTimeLoopN called @5.0 in simulate method.
	 * In variables: C, Dij, F, Fx, H_n, Rij_n, Rij_nplus1, U_n, V_n, deltat, deltax, deltay, g, t_n, xc
	 * Out variables: H_nplus1, Rij_nplus1, U_nplus1, V_nplus1, t_nplus1
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
			computeTn(); // @1.0
			updateHouter(); // @1.0
			updateRij(); // @1.0
			updateUinner(); // @1.0
			updateUouter(); // @1.0
			updateVinner(); // @1.0
			updateVouter(); // @1.0
			updateHinner(); // @2.0
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options.stopTime && n < options.maxIter);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				double tmp_t_n = t_n;
				t_n = t_nplus1;
				t_nplus1 = tmp_t_n;
				double[] tmp_U_n = U_n;
				U_n = U_nplus1;
				U_nplus1 = tmp_U_n;
				double[] tmp_V_n = V_n;
				V_n = V_nplus1;
				V_nplus1 = tmp_V_n;
				double[] tmp_H_n = H_n;
				H_n = H_nplus1;
				H_nplus1 = tmp_H_n;
				double[] tmp_Rij_n = Rij_n;
				Rij_n = Rij_nplus1;
				Rij_nplus1 = tmp_Rij_n;
			} 
		} while (continueLoop);
		// force a last output at the end
		dumpVariables(n);
	}

	private double[] sumR1(double[] a, double[] b)
	{
		final int x = a.length;
		return ArrayOperations.plus(a, b);
	}

	private void dumpVariables(int iteration)
	{
		if (!writer.isDisabled())
		{
			VtkFileContent content = new VtkFileContent(iteration, t_n, X, mesh.getGeometry().getQuads());
			content.addCellVariable("bottommotion", Rij_n);
			content.addCellVariable("profondeur", Dij);
			content.addCellVariable("hauteur", H_n);
			writer.writeFile(content);
			lastDump = n;
		}
	}
};
