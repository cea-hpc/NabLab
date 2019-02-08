#include <iostream>
#include <limits>

// Kokkos headers
#include <Kokkos_Core.hpp>

// Project headers
#include "mesh/NumericMesh2D.h"
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/VtkFileWriter2D.h"
#include "Utils.h"
#include "types/Types.h"
#include "types/MathFunctions.h"
#include "glace2d/Glace2dFunctions.h"

using namespace nablalib;

class Glace2d
{
public:
	struct Options
	{
		double LENGTH = 0.01;
		int X_EDGE_ELEMS = 100;
		int Y_EDGE_ELEMS = 10;
		int Z_EDGE_ELEMS = 1;
		double option_stoptime = 0.2;
		int option_max_iterations = 20000;
		double gammma = 1.4;
		double option_x_interface = 0.5;
		double option_deltat_ini = 1.0E-5;
		double option_deltat_cfl = 0.4;
		double option_rho_ini_zg = 1.0;
		double option_rho_ini_zd = 0.125;
		double option_p_ini_zg = 1.0;
		double option_p_ini_zd = 0.1;
	};

private:
	Options* options;
	NumericMesh2D* mesh;
	VtkFileWriter2D writer;
	int nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;

	// Global Variables
	double t, deltat, deltat_n_plus_1, t_n_plus_1;

	// Array Variables
	Kokkos::View<Real2*> coord;
	Kokkos::View<Real2*> X;
	Kokkos::View<Real2*> b;
	Kokkos::View<Real2*> bt;
	Kokkos::View<Real2x2*> Ar;
	Kokkos::View<Real2x2*> Mt;
	Kokkos::View<Real2*> ur;
	Kokkos::View<double*> p_ic;
	Kokkos::View<double*> rho_ic;
	Kokkos::View<double*> V_ic;
	Kokkos::View<double*> c;
	Kokkos::View<double*> m;
	Kokkos::View<double*> p;
	Kokkos::View<double*> rho;
	Kokkos::View<double*> e;
	Kokkos::View<double*> E;
	Kokkos::View<double*> V;
	Kokkos::View<double*> deltatj;
	Kokkos::View<Real2*> uj;
	Kokkos::View<Real2*> center;
	Kokkos::View<double**> l;
	Kokkos::View<Real2**> C_ic;
	Kokkos::View<Real2**> C;
	Kokkos::View<Real2**> F;
	Kokkos::View<Real2x2**> Ajr;
	Kokkos::View<Real2*> X_n_plus_1;
	Kokkos::View<Real2*> uj_n_plus_1;
	Kokkos::View<double*> E_n_plus_1;

public:
	Glace2d(Options* aOptions, NumericMesh2D* aNumericMesh2D)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("Glace2d")
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, nbCellsOfNode(NumericMesh2D::MaxNbCellsOfNode)
	, nbInnerNodes(mesh->getNbInnerNodes())
	, nbOuterFaces(mesh->getNbOuterFaces())
	, nbNodesOfFace(NumericMesh2D::MaxNbNodesOfFace)
	, coord("coord", nbNodes)
	, X("X", nbNodes)
	, b("b", nbNodes)
	, bt("bt", nbNodes)
	, Ar("Ar", nbNodes)
	, Mt("Mt", nbNodes)
	, ur("ur", nbNodes)
	, p_ic("p_ic", nbCells)
	, rho_ic("rho_ic", nbCells)
	, V_ic("V_ic", nbCells)
	, c("c", nbCells)
	, m("m", nbCells)
	, p("p", nbCells)
	, rho("rho", nbCells)
	, e("e", nbCells)
	, E("E", nbCells)
	, V("V", nbCells)
	, deltatj("deltatj", nbCells)
	, uj("uj", nbCells)
	, center("center", nbCells)
	, l("l", nbCells, nbNodesOfCell)
	, C_ic("C_ic", nbCells, nbNodesOfCell)
	, C("C", nbCells, nbNodesOfCell)
	, F("F", nbCells, nbNodesOfCell)
	, Ajr("Ajr", nbCells, nbNodesOfCell)
	, X_n_plus_1("X_n_plus_1", nbNodes)
	, uj_n_plus_1("uj_n_plus_1", nbCells)
	, E_n_plus_1("E_n_plus_1", nbCells)
	{
		// Copy node coordinates
		auto gNodes = mesh->getGeometricMesh()->getNodes();
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			coord(rNodes) = gNodes[rNodes];
		});
	}

private:
	/**
	 * Job IniCenter @-3.0
	 * In variables: coord
	 * Out variables: center
	 */
	void iniCenter()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			Real2 sum1753114863 = Real2(0.0, 0.0);
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum1753114863 = sum1753114863 + (coord(rNodes));
			}
			center(jCells) = (1.0 / 4.0) * sum1753114863;
		});
	}
	
	/**
	 * Job ComputeCjrIc @-3.0
	 * In variables: coord
	 * Out variables: C_ic
	 */
	void computeCjrIc()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int prevRNodesOfCellJ = (rNodesOfCellJ-1+nodesOfCellJ.size())%nodesOfCellJ.size();
				int nextRNodesOfCellJ = (rNodesOfCellJ+1+nodesOfCellJ.size())%nodesOfCellJ.size();
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int prevRId = nodesOfCellJ[prevRNodesOfCellJ];
				int nextRId = nodesOfCellJ[nextRNodesOfCellJ];
				int rNodes = rId;
				int prevRNodes = prevRId;
				int nextRNodes = nextRId;
				C_ic(jCells,rNodesOfCellJ) = 0.5 * Glace2dFunctions::perp(coord(nextRNodes) - coord(prevRNodes));
			}
		});
	}
	
	/**
	 * Job Init_ComputeXn @-3.0
	 * In variables: coord
	 * Out variables: X
	 */
	void init_ComputeXn()
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int r0Nodes)
		{
			X(r0Nodes) = coord(r0Nodes);
		});
	}
	
	/**
	 * Job Init_ComputeUn @-3.0
	 * In variables: 
	 * Out variables: uj
	 */
	void init_ComputeUn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int j0Cells)
		{
			uj(j0Cells) = Real2(0.0, 0.0);
		});
	}
	
	/**
	 * Job Init_ComputeDt @-3.0
	 * In variables: option_deltat_ini
	 * Out variables: deltat
	 */
	void init_ComputeDt()
	{
		deltat = options->option_deltat_ini;
	}
	
	/**
	 * Job Init_ComputeTn @-3.0
	 * In variables: 
	 * Out variables: t
	 */
	void init_ComputeTn()
	{
		t = 0.0;
	}
	
	/**
	 * Job IniIc @-2.0
	 * In variables: center, option_x_interface, option_rho_ini_zg, option_p_ini_zg, option_rho_ini_zd, option_p_ini_zd
	 * Out variables: rho_ic, p_ic
	 */
	void iniIc()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			if (center(jCells).x < options->option_x_interface) 
			{
				rho_ic(jCells) = options->option_rho_ini_zg;
				p_ic(jCells) = options->option_p_ini_zg;
			}
			else 
			{
				rho_ic(jCells) = options->option_rho_ini_zd;
				p_ic(jCells) = options->option_p_ini_zd;
			}
		});
	}
	
	/**
	 * Job IniVIc @-2.0
	 * In variables: C_ic, coord
	 * Out variables: V_ic
	 */
	void iniVIc()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum319937920 = 0.0;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum319937920 = sum319937920 + (MathFunctions::dot(C_ic(jCells,rNodesOfCellJ), coord(rNodes)));
			}
			V_ic(jCells) = 0.5 * sum319937920;
		});
	}
	
	/**
	 * Job IniM @-1.0
	 * In variables: rho_ic, V_ic
	 * Out variables: m
	 */
	void iniM()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			m(jCells) = rho_ic(jCells) * V_ic(jCells);
		});
	}
	
	/**
	 * Job Init_ComputeEn @-1.0
	 * In variables: p_ic, gammma, rho_ic
	 * Out variables: E
	 */
	void init_ComputeEn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int j0Cells)
		{
			E(j0Cells) = p_ic(j0Cells) / ((options->gammma - 1.0) * rho_ic(j0Cells));
		});
	}
	
	/**
	 * Job ComputeCjr @1.0
	 * In variables: X
	 * Out variables: C
	 */
	void computeCjr()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int prevRNodesOfCellJ = (rNodesOfCellJ-1+nodesOfCellJ.size())%nodesOfCellJ.size();
				int nextRNodesOfCellJ = (rNodesOfCellJ+1+nodesOfCellJ.size())%nodesOfCellJ.size();
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int prevRId = nodesOfCellJ[prevRNodesOfCellJ];
				int nextRId = nodesOfCellJ[nextRNodesOfCellJ];
				int rNodes = rId;
				int prevRNodes = prevRId;
				int nextRNodes = nextRId;
				C(jCells,rNodesOfCellJ) = 0.5 * Glace2dFunctions::perp(X(nextRNodes) - X(prevRNodes));
			}
		});
	}
	
	/**
	 * Job ComputeInternalEngergy @1.0
	 * In variables: E, uj
	 * Out variables: e
	 */
	void computeInternalEngergy()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			e(jCells) = E(jCells) - 0.5 * MathFunctions::dot(uj(jCells), uj(jCells));
		});
	}
	
	/**
	 * Job ComputeLjr @2.0
	 * In variables: C
	 * Out variables: l
	 */
	void computeLjr()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				l(jCells,rNodesOfCellJ) = MathFunctions::norm(C(jCells,rNodesOfCellJ));
			}
		});
	}
	
	/**
	 * Job ComputeV @2.0
	 * In variables: C, X
	 * Out variables: V
	 */
	void computeV()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum739025242 = 0.0;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum739025242 = sum739025242 + (MathFunctions::dot(C(jCells,rNodesOfCellJ), X(rNodes)));
			}
			V(jCells) = 0.5 * sum739025242;
		});
	}
	
	/**
	 * Job ComputeDensity @3.0
	 * In variables: m, V
	 * Out variables: rho
	 */
	void computeDensity()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			rho(jCells) = m(jCells) / V(jCells);
		});
	}
	
	/**
	 * Job ComputeEOSp @4.0
	 * In variables: gammma, rho, e
	 * Out variables: p
	 */
	void computeEOSp()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			p(jCells) = (options->gammma - 1.0) * rho(jCells) * e(jCells);
		});
	}
	
	/**
	 * Job ComputeEOSc @5.0
	 * In variables: gammma, p, rho
	 * Out variables: c
	 */
	void computeEOSc()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			c(jCells) = MathFunctions::sqrt(options->gammma * p(jCells) / rho(jCells));
		});
	}
	
	/**
	 * Job Computedeltatj @6.0
	 * In variables: l, V, c
	 * Out variables: deltatj
	 */
	void computedeltatj()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum1506953708 = 0.0;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				sum1506953708 = sum1506953708 + (l(jCells,rNodesOfCellJ));
			}
			deltatj(jCells) = 2.0 * V(jCells) / (c(jCells) * sum1506953708);
		});
	}
	
	/**
	 * Job ComputeAjr @6.0
	 * In variables: rho, c, l, C
	 * Out variables: Ajr
	 */
	void computeAjr()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				Ajr(jCells,rNodesOfCellJ) = ((rho(jCells) * c(jCells)) / l(jCells,rNodesOfCellJ)) * Glace2dFunctions::tensProduct(C(jCells,rNodesOfCellJ), C(jCells,rNodesOfCellJ));
			}
		});
	}
	
	/**
	 * Job ComputeAr @7.0
	 * In variables: Ajr
	 * Out variables: Ar
	 */
	void computeAr()
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			int rId = rNodes;
			Real2x2 sum670474897 = Real2x2(Real2(0.0, 0.0), Real2(0.0, 0.0));
			auto cellsOfNodeR = mesh->getCellsOfNode(rId);
			for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
			{
				int jId = cellsOfNodeR[jCellsOfNodeR];
				auto nodesOfCellJ = mesh->getNodesOfCell(jId);
				int rNodesOfCellJ = Utils::indexOf(nodesOfCellJ,rId);
				int jCells = jId;
				sum670474897 = sum670474897 + (Ajr(jCells,rNodesOfCellJ));
			}
			Ar(rNodes) = sum670474897;
		});
	}
	
	/**
	 * Job ComputeBr @7.0
	 * In variables: p, C, Ajr, uj
	 * Out variables: b
	 */
	void computeBr()
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			int rId = rNodes;
			Real2 sum1493243246 = Real2(0.0, 0.0);
			auto cellsOfNodeR = mesh->getCellsOfNode(rId);
			for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
			{
				int jId = cellsOfNodeR[jCellsOfNodeR];
				int jCells = jId;
				auto nodesOfCellJ = mesh->getNodesOfCell(jId);
				int rNodesOfCellJ = Utils::indexOf(nodesOfCellJ,rId);
				sum1493243246 = sum1493243246 + (p(jCells) * C(jCells,rNodesOfCellJ) + Glace2dFunctions::matVectProduct(Ajr(jCells,rNodesOfCellJ), uj(jCells)));
			}
			b(rNodes) = sum1493243246;
		});
	}
	
	/**
	 * Job Compute_ComputeDt @7.0
	 * In variables: deltatj, option_deltat_cfl
	 * Out variables: deltat_n_plus_1
	 */
	void compute_ComputeDt()
	{
		double reduceMin863519323 = numeric_limits<double>::max();
		Kokkos::Min<double> reducer(reduceMin863519323);
		Kokkos::parallel_reduce("ReductionreduceMin863519323", nbCells, KOKKOS_LAMBDA(const int& jCells, double& x)
		{
			reducer.join(x, deltatj(jCells));
		}, reducer);
		deltat_n_plus_1 = options->option_deltat_cfl * reduceMin863519323;
	}
	
	/**
	 * Job Copy_deltat_n_plus_1_to_deltat @8.0
	 * In variables: deltat_n_plus_1
	 * Out variables: deltat
	 */
	void copy_deltat_n_plus_1_to_deltat()
	{
		auto tmpSwitch = deltat;
		deltat = deltat_n_plus_1;
		deltat_n_plus_1 = tmpSwitch;
	}
	
	/**
	 * Job ComputeMt @8.0
	 * In variables: Ar
	 * Out variables: Mt
	 */
	void computeMt()
	{
		auto innerNodes = mesh->getInnerNodes();
		Kokkos::parallel_for(nbInnerNodes, KOKKOS_LAMBDA(const int rInnerNodes)
		{
			int rId = innerNodes[rInnerNodes];
			int rNodes = rId;
			Mt(rNodes) = Ar(rNodes);
		});
	}
	
	/**
	 * Job ComputeBt @8.0
	 * In variables: b
	 * Out variables: bt
	 */
	void computeBt()
	{
		auto innerNodes = mesh->getInnerNodes();
		Kokkos::parallel_for(nbInnerNodes, KOKKOS_LAMBDA(const int rInnerNodes)
		{
			int rId = innerNodes[rInnerNodes];
			int rNodes = rId;
			bt(rNodes) = b(rNodes);
		});
	}
	
	/**
	 * Job OuterFacesComputations @8.0
	 * In variables: X_EDGE_ELEMS, LENGTH, Y_EDGE_ELEMS, X, b, Ar
	 * Out variables: bt, Mt
	 */
	void outerFacesComputations()
	{
		auto outerFaces = mesh->getOuterFaces();
		Kokkos::parallel_for(nbOuterFaces, KOKKOS_LAMBDA(const int kOuterFaces)
		{
			int kId = outerFaces[kOuterFaces];
			double epsilon = 1.0E-10;
			Real2x2 I = Real2x2(Real2(1.0, 0.0), Real2(0.0, 1.0));
			double X_MIN = 0.0;
			double X_MAX = options->X_EDGE_ELEMS * options->LENGTH;
			double Y_MIN = 0.0;
			double Y_MAX = options->Y_EDGE_ELEMS * options->LENGTH;
			Real2 nY = Real2(0.0, 1.0);
			auto nodesOfFaceK = mesh->getNodesOfFace(kId);
			for (int rNodesOfFaceK=0; rNodesOfFaceK<nodesOfFaceK.size(); rNodesOfFaceK++)
			{
				int rId = nodesOfFaceK[rNodesOfFaceK];
				int rNodes = rId;
				if ((X(rNodes).y - Y_MIN < epsilon) || (X(rNodes).y - Y_MAX < epsilon)) 
				{
					double sign = 0.0;
					if (X(rNodes).y - Y_MIN < epsilon) 
						sign = -1.0;
					else 
						sign = 1.0;
					Real2 n = sign * nY;
					Real2x2 nxn = Glace2dFunctions::tensProduct(n, n);
					Real2x2 IcP = I - nxn;
					bt(rNodes) = Glace2dFunctions::matVectProduct(IcP, b(rNodes));
					Mt(rNodes) = IcP * (Ar(rNodes) * IcP) + nxn * Glace2dFunctions::trace(Ar(rNodes));
				}
				if ((MathFunctions::fabs(X(rNodes).x - X_MIN) < epsilon) || ((MathFunctions::fabs(X(rNodes).x - X_MAX) < epsilon))) 
				{
					Mt(rNodes) = I;
					bt(rNodes) = Real2(0.0, 0.0);
				}
			}
		});
	}
	
	/**
	 * Job Compute_ComputeTn @8.0
	 * In variables: t, deltat_n_plus_1
	 * Out variables: t_n_plus_1
	 */
	void compute_ComputeTn()
	{
		t_n_plus_1 = t + deltat_n_plus_1;
	}
	
	/**
	 * Job Copy_t_n_plus_1_to_t @9.0
	 * In variables: t_n_plus_1
	 * Out variables: t
	 */
	void copy_t_n_plus_1_to_t()
	{
		auto tmpSwitch = t;
		t = t_n_plus_1;
		t_n_plus_1 = tmpSwitch;
	}
	
	/**
	 * Job ComputeU @9.0
	 * In variables: Mt, bt
	 * Out variables: ur
	 */
	void computeU()
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			ur(rNodes) = Glace2dFunctions::matVectProduct(Glace2dFunctions::inverse(Mt(rNodes)), bt(rNodes));
		});
	}
	
	/**
	 * Job ComputeFjr @10.0
	 * In variables: p, C, Ajr, uj, ur
	 * Out variables: F
	 */
	void computeFjr()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				F(jCells,rNodesOfCellJ) = p(jCells) * C(jCells,rNodesOfCellJ) + Glace2dFunctions::matVectProduct(Ajr(jCells,rNodesOfCellJ), (uj(jCells) - ur(rNodes)));
			}
		});
	}
	
	/**
	 * Job Compute_ComputeXn @10.0
	 * In variables: X, deltat, ur
	 * Out variables: X_n_plus_1
	 */
	void compute_ComputeXn()
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			X_n_plus_1(rNodes) = X(rNodes) + deltat * ur(rNodes);
		});
	}
	
	/**
	 * Job Copy_X_n_plus_1_to_X @11.0
	 * In variables: X_n_plus_1
	 * Out variables: X
	 */
	void copy_X_n_plus_1_to_X()
	{
		auto tmpSwitch = X;
		X = X_n_plus_1;
		X_n_plus_1 = tmpSwitch;
	}
	
	/**
	 * Job Compute_ComputeUn @11.0
	 * In variables: F, uj, deltat, m
	 * Out variables: uj_n_plus_1
	 */
	void compute_ComputeUn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			Real2 sum859884688 = Real2(0.0, 0.0);
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				sum859884688 = sum859884688 + (F(jCells,rNodesOfCellJ));
			}
			uj_n_plus_1(jCells) = uj(jCells) - (deltat / m(jCells)) * sum859884688;
		});
	}
	
	/**
	 * Job Compute_ComputeEn @11.0
	 * In variables: F, ur, E, deltat, m
	 * Out variables: E_n_plus_1
	 */
	void compute_ComputeEn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum162108343 = 0.0;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum162108343 = sum162108343 + (MathFunctions::dot(F(jCells,rNodesOfCellJ), ur(rNodes)));
			}
			E_n_plus_1(jCells) = E(jCells) - (deltat / m(jCells)) * sum162108343;
		});
	}
	
	/**
	 * Job Copy_uj_n_plus_1_to_uj @12.0
	 * In variables: uj_n_plus_1
	 * Out variables: uj
	 */
	void copy_uj_n_plus_1_to_uj()
	{
		auto tmpSwitch = uj;
		uj = uj_n_plus_1;
		uj_n_plus_1 = tmpSwitch;
	}
	
	/**
	 * Job Copy_E_n_plus_1_to_E @12.0
	 * In variables: E_n_plus_1
	 * Out variables: E
	 */
	void copy_E_n_plus_1_to_E()
	{
		auto tmpSwitch = E;
		E = E_n_plus_1;
		E_n_plus_1 = tmpSwitch;
	}

public:
	void simulate()
	{
		std::cout << "Début de l'exécution du module Glace2d" << std::endl;
		iniCenter(); // @-3.0
		computeCjrIc(); // @-3.0
		init_ComputeXn(); // @-3.0
		init_ComputeUn(); // @-3.0
		init_ComputeDt(); // @-3.0
		init_ComputeTn(); // @-3.0
		iniIc(); // @-2.0
		iniVIc(); // @-2.0
		iniM(); // @-1.0
		init_ComputeEn(); // @-1.0

		map<string, Kokkos::View<double*>> cellVariables;
		map<string, Kokkos::View<double*>> nodeVariables;
		cellVariables.insert(pair<string,Kokkos::View<double*>>("Density", rho));
		int iteration = 0;
		while (t < options->option_stoptime && iteration < options->option_max_iterations)
		{
			iteration++;
			std::cout << "[" << iteration << "] t = " << t << std::endl;
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
			compute_ComputeDt(); // @7.0
			copy_deltat_n_plus_1_to_deltat(); // @8.0
			computeMt(); // @8.0
			computeBt(); // @8.0
			outerFacesComputations(); // @8.0
			compute_ComputeTn(); // @8.0
			copy_t_n_plus_1_to_t(); // @9.0
			computeU(); // @9.0
			computeFjr(); // @10.0
			compute_ComputeXn(); // @10.0
			copy_X_n_plus_1_to_X(); // @11.0
			compute_ComputeUn(); // @11.0
			compute_ComputeEn(); // @11.0
			copy_uj_n_plus_1_to_uj(); // @12.0
			copy_E_n_plus_1_to_E(); // @12.0
			auto quads = mesh->getGeometricMesh()->getQuads();
			writer.writeFile(iteration, X, quads, cellVariables, nodeVariables);
		}
		std::cout << "Fin de l'exécution du module Glace2d" << std::endl;
	}	
};	

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto o = new Glace2d::Options();
	auto gm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->LENGTH, o->LENGTH);
	auto nm = new NumericMesh2D(gm);
	auto c = new Glace2d(o, nm);
	c->simulate();
	delete c;
	delete nm;
	delete gm;
	delete o;
	Kokkos::finalize();
	return 0;
}
