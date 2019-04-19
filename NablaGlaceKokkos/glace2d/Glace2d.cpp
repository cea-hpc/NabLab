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
	double t, deltat, deltat_nplus1, t_nplus1;

	// Array Variables
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
	Kokkos::View<Real2*> X_n0;
	Kokkos::View<Real2*> X_nplus1;
	Kokkos::View<Real2*> uj_nplus1;
	Kokkos::View<double*> E_nplus1;

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
	, X_n0("X_n0", nbNodes)
	, X_nplus1("X_nplus1", nbNodes)
	, uj_nplus1("uj_nplus1", nbCells)
	, E_nplus1("E_nplus1", nbCells)
	{
		// Copy node coordinates
		auto gNodes = mesh->getGeometricMesh()->getNodes();
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			X_n0(rNodes) = gNodes[rNodes];
		});
	}

private:
	/**
	 * Job Copy_X_n0_to_X @-3.0
	 * In variables: X_n0
	 * Out variables: X
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_X_n0_to_X()
	{
		Kokkos::parallel_for(X.dimension_0(), KOKKOS_LAMBDA(const int i)
		{
			X(i) = X_n0(i);
		});
	}
	
	/**
	 * Job IniCenter @-3.0
	 * In variables: X_n0
	 * Out variables: center
	 */
	KOKKOS_INLINE_FUNCTION
	void iniCenter()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			Real2 sum1917886962 = Real2(0.0, 0.0);
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum1917886962 = sum1917886962 + (X_n0(rNodes));
			}
			center(jCells) = (1.0 / 4.0) * sum1917886962;
		});
	}
	
	/**
	 * Job ComputeCjrIc @-3.0
	 * In variables: X_n0
	 * Out variables: C_ic
	 */
	KOKKOS_INLINE_FUNCTION
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
				C_ic(jCells,rNodesOfCellJ) = 0.5 * Glace2dFunctions::perp(X_n0(nextRNodes) - X_n0(prevRNodes));
			}
		});
	}
	
	/**
	 * Job IniUn @-3.0
	 * In variables: 
	 * Out variables: uj
	 */
	KOKKOS_INLINE_FUNCTION
	void iniUn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			uj(jCells) = Real2(0.0, 0.0);
		});
	}
	
	/**
	 * Job IniIc @-2.0
	 * In variables: center, option_x_interface, option_rho_ini_zg, option_p_ini_zg, option_rho_ini_zd, option_p_ini_zd
	 * Out variables: rho_ic, p_ic
	 */
	KOKKOS_INLINE_FUNCTION
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
	 * In variables: C_ic, X_n0
	 * Out variables: V_ic
	 */
	KOKKOS_INLINE_FUNCTION
	void iniVIc()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum_487317398 = 0.0;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum_487317398 = sum_487317398 + (MathFunctions::dot(C_ic(jCells,rNodesOfCellJ), X_n0(rNodes)));
			}
			V_ic(jCells) = 0.5 * sum_487317398;
		});
	}
	
	/**
	 * Job IniM @-1.0
	 * In variables: rho_ic, V_ic
	 * Out variables: m
	 */
	KOKKOS_INLINE_FUNCTION
	void iniM()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			m(jCells) = rho_ic(jCells) * V_ic(jCells);
		});
	}
	
	/**
	 * Job IniEn @-1.0
	 * In variables: p_ic, gammma, rho_ic
	 * Out variables: E
	 */
	KOKKOS_INLINE_FUNCTION
	void iniEn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			E(jCells) = p_ic(jCells) / ((options->gammma - 1.0) * rho_ic(jCells));
		});
	}
	
	/**
	 * Job ComputeCjr @1.0
	 * In variables: X
	 * Out variables: C
	 */
	KOKKOS_INLINE_FUNCTION
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
	KOKKOS_INLINE_FUNCTION
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
	KOKKOS_INLINE_FUNCTION
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
	KOKKOS_INLINE_FUNCTION
	void computeV()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum_1792633062 = 0.0;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum_1792633062 = sum_1792633062 + (MathFunctions::dot(C(jCells,rNodesOfCellJ), X(rNodes)));
			}
			V(jCells) = 0.5 * sum_1792633062;
		});
	}
	
	/**
	 * Job ComputeDensity @3.0
	 * In variables: m, V
	 * Out variables: rho
	 */
	KOKKOS_INLINE_FUNCTION
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
	KOKKOS_INLINE_FUNCTION
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
	KOKKOS_INLINE_FUNCTION
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
	KOKKOS_INLINE_FUNCTION
	void computedeltatj()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum1029918418 = 0.0;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				sum1029918418 = sum1029918418 + (l(jCells,rNodesOfCellJ));
			}
			deltatj(jCells) = 2.0 * V(jCells) / (c(jCells) * sum1029918418);
		});
	}
	
	/**
	 * Job ComputeAjr @6.0
	 * In variables: rho, c, l, C
	 * Out variables: Ajr
	 */
	KOKKOS_INLINE_FUNCTION
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
	KOKKOS_INLINE_FUNCTION
	void computeAr()
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			int rId = rNodes;
			Real2x2 sum_1190060678 = Real2x2(Real2(0.0, 0.0), Real2(0.0, 0.0));
			auto cellsOfNodeR = mesh->getCellsOfNode(rId);
			for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
			{
				int jId = cellsOfNodeR[jCellsOfNodeR];
				int jCells = jId;
				auto nodesOfCellJ = mesh->getNodesOfCell(jId);
				int rNodesOfCellJ = Utils::indexOf(nodesOfCellJ,rId);
				sum_1190060678 = sum_1190060678 + (Ajr(jCells,rNodesOfCellJ));
			}
			Ar(rNodes) = sum_1190060678;
		});
	}
	
	/**
	 * Job ComputeBr @7.0
	 * In variables: p, C, Ajr, uj
	 * Out variables: b
	 */
	KOKKOS_INLINE_FUNCTION
	void computeBr()
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			int rId = rNodes;
			Real2 sum942617414 = Real2(0.0, 0.0);
			auto cellsOfNodeR = mesh->getCellsOfNode(rId);
			for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
			{
				int jId = cellsOfNodeR[jCellsOfNodeR];
				auto nodesOfCellJ = mesh->getNodesOfCell(jId);
				int rNodesOfCellJ = Utils::indexOf(nodesOfCellJ,rId);
				int jCells = jId;
				sum942617414 = sum942617414 + (p(jCells) * C(jCells,rNodesOfCellJ) + Glace2dFunctions::matVectProduct(Ajr(jCells,rNodesOfCellJ), uj(jCells)));
			}
			b(rNodes) = sum942617414;
		});
	}
	
	/**
	 * Job ComputeDt @7.0
	 * In variables: deltatj, option_deltat_cfl
	 * Out variables: deltat_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeDt()
	{
		double reduceMin276725735 = numeric_limits<double>::max();
		Kokkos::Min<double> reducer(reduceMin276725735);
		Kokkos::parallel_reduce("ReductionreduceMin276725735", nbCells, KOKKOS_LAMBDA(const int& jCells, double& x)
		{
			reducer.join(x, deltatj(jCells));
		}, reducer);
		deltat_nplus1 = options->option_deltat_cfl * reduceMin276725735;
	}
	
	/**
	 * Job Copy_deltat_nplus1_to_deltat @8.0
	 * In variables: deltat_nplus1
	 * Out variables: deltat
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_deltat_nplus1_to_deltat()
	{
		swap(deltat_nplus1, deltat);
	}
	
	/**
	 * Job ComputeMt @8.0
	 * In variables: Ar
	 * Out variables: Mt
	 */
	KOKKOS_INLINE_FUNCTION
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
	KOKKOS_INLINE_FUNCTION
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
	KOKKOS_INLINE_FUNCTION
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
	 * Job ComputeTn @8.0
	 * In variables: t, deltat_nplus1
	 * Out variables: t_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeTn()
	{
		t_nplus1 = t + deltat_nplus1;
	}
	
	/**
	 * Job Copy_t_nplus1_to_t @9.0
	 * In variables: t_nplus1
	 * Out variables: t
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_t_nplus1_to_t()
	{
		swap(t_nplus1, t);
	}
	
	/**
	 * Job ComputeU @9.0
	 * In variables: Mt, bt
	 * Out variables: ur
	 */
	KOKKOS_INLINE_FUNCTION
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
	KOKKOS_INLINE_FUNCTION
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
	 * Job ComputeXn @10.0
	 * In variables: X, deltat, ur
	 * Out variables: X_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeXn()
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int rNodes)
		{
			X_nplus1(rNodes) = X(rNodes) + deltat * ur(rNodes);
		});
	}
	
	/**
	 * Job Copy_X_nplus1_to_X @11.0
	 * In variables: X_nplus1
	 * Out variables: X
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_X_nplus1_to_X()
	{
		swap(X_nplus1, X);
	}
	
	/**
	 * Job ComputeUn @11.0
	 * In variables: F, uj, deltat, m
	 * Out variables: uj_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeUn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			Real2 sum1021572098 = Real2(0.0, 0.0);
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				sum1021572098 = sum1021572098 + (F(jCells,rNodesOfCellJ));
			}
			uj_nplus1(jCells) = uj(jCells) - (deltat / m(jCells)) * sum1021572098;
		});
	}
	
	/**
	 * Job ComputeEn @11.0
	 * In variables: F, ur, E, deltat, m
	 * Out variables: E_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEn()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int jCells)
		{
			int jId = jCells;
			double sum_547818966 = 0.0;
			auto nodesOfCellJ = mesh->getNodesOfCell(jId);
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum_547818966 = sum_547818966 + (MathFunctions::dot(F(jCells,rNodesOfCellJ), ur(rNodes)));
			}
			E_nplus1(jCells) = E(jCells) - (deltat / m(jCells)) * sum_547818966;
		});
	}
	
	/**
	 * Job Copy_uj_nplus1_to_uj @12.0
	 * In variables: uj_nplus1
	 * Out variables: uj
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_uj_nplus1_to_uj()
	{
		swap(uj_nplus1, uj);
	}
	
	/**
	 * Job Copy_E_nplus1_to_E @12.0
	 * In variables: E_nplus1
	 * Out variables: E
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_E_nplus1_to_E()
	{
		swap(E_nplus1, E);
	}

public:
	void simulate()
	{
		std::cout << "Début de l'exécution du module Glace2d" << std::endl;
		copy_X_n0_to_X(); // @-3.0
		iniCenter(); // @-3.0
		computeCjrIc(); // @-3.0
		iniUn(); // @-3.0
		iniIc(); // @-2.0
		iniVIc(); // @-2.0
		iniM(); // @-1.0
		iniEn(); // @-1.0

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
