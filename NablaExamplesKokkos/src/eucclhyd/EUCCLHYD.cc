#include <iostream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <cfenv>
#pragma STDC FENV_ACCESS ON

// Kokkos headers
#include <Kokkos_Core.hpp>
#include <Kokkos_hwloc.hpp>

// Project headers
#include "mesh/NumericMesh2D.h"
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/PvdFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "types/MathFunctions.h"
#include "types/ArrayOperations.h"
#include "eucclhyd/EUCCLHYDFunctions.h"

using namespace nablalib;

class EUCCLHYD
{
public:
	struct Options
	{
		// Should be const but usefull to set them from main args
		int NohTestCase = 0;
		int SedovTestCase = 1;
		int ElasticPlasticPistonTestCase = 2;
		int eosPerfectGas = 100;
		int eosMieGruneisen = 101;
		int constitutiveLawNoElasticity = 200;
		int constitutiveLawNeoHookean = 201;
		double inf = 1.0E200;
		double twoPi = 3.141592653589793 * 2.0;
		int testCase = as_const(ElasticPlasticPistonTestCase);
		double option_stoptime = 2.0E-4;
		double gamma = 1.4;
		double cfl = 0.5;
		double BetaAxi = 0.0;
		double X_LENGTH = 1.0;
		double Y_LENGTH = 0.01;
		int X_EDGE_ELEMS = 150;
		int Y_EDGE_ELEMS = 2;
		int Z_EDGE_ELEMS = 1;
		double X_EDGE_LENGTH = as_const(X_LENGTH) / as_const(X_EDGE_ELEMS);
		double Y_EDGE_LENGTH = as_const(Y_LENGTH) / as_const(Y_EDGE_ELEMS);
		int option_max_iterations = 500000000;
		double u0 = 10.0;
		double p0 = 100000.0;
		double rho0 = 8930.0;
		RealArray1D<2> ex = {1.0, 0.0};
		RealArray1D<2> ey = {0.0, 1.0};
		double deltat_init = 1.0E-8;
		int eos = as_const(eosMieGruneisen);
		int constitutiveLaw = as_const(constitutiveLawNeoHookean);
		double a0 = 3940.0 / 1.5;
		double gamma0 = 2.0;
		double s = 1.49;
		double mu = 4.5E10;
		double Y = 9.0E7 * 2.0;
	};
	Options* options;

private:
	int iteration;
	NumericMesh2D* mesh;
	PvdFileWriter2D writer;
	int nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;

	// Global Variables
	double threshold, t, deltat, t_nplus1, deltat_nplus1;

	// Connectivity Variables
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> Xc;
	Kokkos::View<RealArray1D<2>**> nplus;
	Kokkos::View<RealArray1D<2>**> nminus;
	Kokkos::View<RealArray1D<2>**> n;
	Kokkos::View<double**> Aplus;
	Kokkos::View<double**> Aminus;
	Kokkos::View<double**> A;
	Kokkos::View<double*> rho;
	Kokkos::View<double*> e;
	Kokkos::View<double*> p;
	Kokkos::View<double*> m;
	Kokkos::View<double*> a;
	Kokkos::View<double*> v;
	Kokkos::View<double*> perim;
	Kokkos::View<double*> c;
	Kokkos::View<double*> eps;
	Kokkos::View<double*> deltatc;
	Kokkos::View<double*> normV;
	Kokkos::View<RealArray1D<2>*> Vnode;
	Kokkos::View<RealArray1D<2>*> V;
	Kokkos::View<RealArray2D<2,2>*> L;
	Kokkos::View<RealArray2D<2,2>*> Be;
	Kokkos::View<RealArray2D<2,2>*> B;
	Kokkos::View<RealArray2D<2,2>*> S;
	Kokkos::View<RealArray2D<2,2>*> T;
	Kokkos::View<RealArray2D<2,2>*> Dp;
	Kokkos::View<RealArray1D<2>**> F;
	Kokkos::View<RealArray2D<2,2>**> M;
	Kokkos::View<RealArray2D<2,2>*> MMinus1;
	Kokkos::View<double*> R;
	Kokkos::View<double*> Btt;
	Kokkos::View<double*> Bett;
	Kokkos::View<double*> Stt;
	Kokkos::View<double*> Ltt;
	Kokkos::View<RealArray1D<2>*> Xc_n0;
	Kokkos::View<RealArray1D<2>*> X_n0;
	Kokkos::View<RealArray1D<2>*> X_nplus1;
	Kokkos::View<double*> R_n0;
	Kokkos::View<double*> m_n0;
	Kokkos::View<double*> v_n0;
	Kokkos::View<RealArray1D<2>*> V_n0;
	Kokkos::View<RealArray1D<2>*> V_nplus1;
	Kokkos::View<double*> a_n0;
	Kokkos::View<double*> rho_n0;
	Kokkos::View<RealArray2D<2,2>*> B_n0;
	Kokkos::View<double*> Btt_n0;
	Kokkos::View<RealArray2D<2,2>*> Be_n0;
	Kokkos::View<RealArray2D<2,2>*> Be_nplus1;
	Kokkos::View<double*> Bett_n0;
	Kokkos::View<double*> Bett_nplus1;
	Kokkos::View<RealArray2D<2,2>*> S_n0;
	Kokkos::View<double*> Stt_n0;
	Kokkos::View<double*> e_n0;
	Kokkos::View<double*> e_nplus1;
	
	const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();

public:
	EUCCLHYD(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("EUCCLHYD")
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, nbCellsOfNode(NumericMesh2D::MaxNbCellsOfNode)
	, nbInnerNodes(mesh->getNbInnerNodes())
	, nbOuterFaces(mesh->getNbOuterFaces())
	, nbNodesOfFace(NumericMesh2D::MaxNbNodesOfFace)
	, threshold(1.0E-10)
	, t(0.0)
	, deltat(as_const(options->deltat_init))
	, t_nplus1(0.0)
	, deltat_nplus1(as_const(options->deltat_init))
	, X("X", nbNodes)
	, Xc("Xc", nbCells)
	, nplus("nplus", nbNodes, nbCells)
	, nminus("nminus", nbNodes, nbCells)
	, n("n", nbNodes, nbCells)
	, Aplus("Aplus", nbNodes, nbCells)
	, Aminus("Aminus", nbNodes, nbCells)
	, A("A", nbNodes, nbCells)
	, rho("rho", nbCells)
	, e("e", nbCells)
	, p("p", nbCells)
	, m("m", nbCells)
	, a("a", nbCells)
	, v("v", nbCells)
	, perim("perim", nbCells)
	, c("c", nbCells)
	, eps("eps", nbCells)
	, deltatc("deltatc", nbCells)
	, normV("normV", nbCells)
	, Vnode("Vnode", nbNodes)
	, V("V", nbCells)
	, L("L", nbCells)
	, Be("Be", nbCells)
	, B("B", nbCells)
	, S("S", nbCells)
	, T("T", nbCells)
	, Dp("Dp", nbCells)
	, F("F", nbNodes, nbCells)
	, M("M", nbNodes, nbCells)
	, MMinus1("MMinus1", nbNodes)
	, R("R", nbCells)
	, Btt("Btt", nbCells)
	, Bett("Bett", nbCells)
	, Stt("Stt", nbCells)
	, Ltt("Ltt", nbCells)
	, Xc_n0("Xc_n0", nbCells)
	, X_n0("X_n0", nbNodes)
	, X_nplus1("X_nplus1", nbNodes)
	, R_n0("R_n0", nbCells)
	, m_n0("m_n0", nbCells)
	, v_n0("v_n0", nbCells)
	, V_n0("V_n0", nbCells)
	, V_nplus1("V_nplus1", nbCells)
	, a_n0("a_n0", nbCells)
	, rho_n0("rho_n0", nbCells)
	, B_n0("B_n0", nbCells)
	, Btt_n0("Btt_n0", nbCells)
	, Be_n0("Be_n0", nbCells)
	, Be_nplus1("Be_nplus1", nbCells)
	, Bett_n0("Bett_n0", nbCells)
	, Bett_nplus1("Bett_nplus1", nbCells)
	, S_n0("S_n0", nbCells)
	, Stt_n0("Stt_n0", nbCells)
	, e_n0("e_n0", nbCells)
	, e_nplus1("e_nplus1", nbCells)
	{
		// Copy node coordinates
		const auto& gNodes = mesh->getGeometricMesh()->getNodes();
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
		{
			X_n0(rNodes) = gNodes[rNodes];
		});
	}

private:
	/**
	 * Job Copy_X_n0_to_X @-5.0
	 * In variables: X_n0
	 * Out variables: X
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_X_n0_to_X() noexcept
	{
		deep_copy(X, X_n0);
	}
	
	/**
	 * Job initCenter @-5.0
	 * In variables: X_n0
	 * Out variables: Xc_n0
	 */
	KOKKOS_INLINE_FUNCTION
	void initCenter() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			RealArray1D<2> reduceSum_1175350722 = {0.0, 0.0};
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pNodes(pId);
					reduceSum_1175350722 = ArrayOperations::plus(reduceSum_1175350722, (X_n0(pNodes)));
				}
			}
			Xc_n0(cCells) = ArrayOperations::multiply(0.25, reduceSum_1175350722);
		});
	}
	
	/**
	 * Job initArea @-5.0
	 * In variables: X_n0
	 * Out variables: a_n0
	 */
	KOKKOS_INLINE_FUNCTION
	void initArea() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			double reduceSum796350234 = 0.0;
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pPlus1Id(nodesOfCellC[(pNodesOfCellC+1+nbNodesOfCell)%nbNodesOfCell]);
					int pNodes(pId);
					int pPlus1Nodes(pPlus1Id);
					reduceSum796350234 = reduceSum796350234 + (EUCCLHYDFunctions::crossProduct2d(X_n0(pNodes), X_n0(pPlus1Nodes)));
				}
			}
			a_n0(cCells) = 0.5 * reduceSum796350234;
		});
	}
	
	/**
	 * Job initDensity @-5.0
	 * In variables: rho0
	 * Out variables: rho_n0
	 */
	KOKKOS_INLINE_FUNCTION
	void initDensity() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			rho_n0(cCells) = as_const(options->rho0);
		});
	}
	
	/**
	 * Job initLeftCauchyGreenTensor @-5.0
	 * In variables: constitutiveLaw, constitutiveLawNoElasticity
	 * Out variables: B_n0, Btt_n0, Be_n0, Bett_n0
	 */
	KOKKOS_INLINE_FUNCTION
	void initLeftCauchyGreenTensor() noexcept
	{
		if (as_const(options->constitutiveLaw) != as_const(options->constitutiveLawNoElasticity)) 
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			B_n0(cCells) = EUCCLHYDFunctions::identityMatrix2d();
			Btt_n0(cCells) = 1.0;
			Be_n0(cCells) = EUCCLHYDFunctions::identityMatrix2d();
			Bett_n0(cCells) = 1.0;
		});
	}
	
	/**
	 * Job initDeviatoricStressTensor @-5.0
	 * In variables: 
	 * Out variables: S_n0, Stt_n0
	 */
	KOKKOS_INLINE_FUNCTION
	void initDeviatoricStressTensor() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			S_n0(cCells) = EUCCLHYDFunctions::zeroMatrix2d();
			Stt_n0(cCells) = 0.0;
		});
	}
	
	/**
	 * Job initCellTotalEnergy @-5.0
	 * In variables: testCase, NohTestCase, p0, gamma, rho0, u0, SedovTestCase, X_n0, threshold, X_EDGE_LENGTH, Y_EDGE_LENGTH, ElasticPlasticPistonTestCase, gamma0
	 * Out variables: e_n0
	 */
	KOKKOS_INLINE_FUNCTION
	void initCellTotalEnergy() noexcept
	{
		if (as_const(options->testCase) == as_const(options->NohTestCase)) 
		{
			double eps0 = as_const(options->p0) / ((as_const(options->gamma) - 1.0) * as_const(options->rho0));
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& dCells)
			{
				e_n0(dCells) = eps0 + 0.5 * as_const(options->u0) * as_const(options->u0);
			});
		}
		else 
			if (as_const(options->testCase) == as_const(options->SedovTestCase)) 
		{
			double eps1 = as_const(options->p0) / ((as_const(options->gamma) - 1.0) * as_const(options->rho0));
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
			{
				int cId(cCells);
				bool isCenterCell = false;
				{
					auto nodesOfCellC(mesh->getNodesOfCell(cId));
					for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
					{
						int pId(nodesOfCellC[pNodesOfCellC]);
						int pNodes(pId);
						if (EUCCLHYDFunctions::norm(X_n0(pNodes)) < as_const(threshold)) 
							isCenterCell = true;
					}
				}
				if (isCenterCell) 
				{
					double total_energy_deposit = 0.979264;
					double dx = as_const(options->X_EDGE_LENGTH);
					double dy = as_const(options->Y_EDGE_LENGTH);
					e_n0(cCells) = eps1 + total_energy_deposit / (4.0 * dx * dy);
				}
				else 
				{
					e_n0(cCells) = eps1;
				}
			});
		}
		else 
			if (as_const(options->testCase) == as_const(options->ElasticPlasticPistonTestCase)) 
		{
			double eps2 = as_const(options->p0) / (as_const(options->rho0) * as_const(options->gamma0));
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& ceCells)
			{
				e_n0(ceCells) = eps2;
			});
		}
	}
	
	/**
	 * Job Copy_Xc_n0_to_Xc @-4.0
	 * In variables: Xc_n0
	 * Out variables: Xc
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_Xc_n0_to_Xc() noexcept
	{
		deep_copy(Xc, Xc_n0);
	}
	
	/**
	 * Job Copy_a_n0_to_a @-4.0
	 * In variables: a_n0
	 * Out variables: a
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_a_n0_to_a() noexcept
	{
		deep_copy(a, a_n0);
	}
	
	/**
	 * Job Copy_rho_n0_to_rho @-4.0
	 * In variables: rho_n0
	 * Out variables: rho
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_rho_n0_to_rho() noexcept
	{
		deep_copy(rho, rho_n0);
	}
	
	/**
	 * Job Copy_B_n0_to_B @-4.0
	 * In variables: B_n0
	 * Out variables: B
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_B_n0_to_B() noexcept
	{
		deep_copy(B, B_n0);
	}
	
	/**
	 * Job Copy_Btt_n0_to_Btt @-4.0
	 * In variables: Btt_n0
	 * Out variables: Btt
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_Btt_n0_to_Btt() noexcept
	{
		deep_copy(Btt, Btt_n0);
	}
	
	/**
	 * Job Copy_Be_n0_to_Be @-4.0
	 * In variables: Be_n0
	 * Out variables: Be
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_Be_n0_to_Be() noexcept
	{
		deep_copy(Be, Be_n0);
	}
	
	/**
	 * Job Copy_Bett_n0_to_Bett @-4.0
	 * In variables: Bett_n0
	 * Out variables: Bett
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_Bett_n0_to_Bett() noexcept
	{
		deep_copy(Bett, Bett_n0);
	}
	
	/**
	 * Job Copy_S_n0_to_S @-4.0
	 * In variables: S_n0
	 * Out variables: S
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_S_n0_to_S() noexcept
	{
		deep_copy(S, S_n0);
	}
	
	/**
	 * Job Copy_Stt_n0_to_Stt @-4.0
	 * In variables: Stt_n0
	 * Out variables: Stt
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_Stt_n0_to_Stt() noexcept
	{
		deep_copy(Stt, Stt_n0);
	}
	
	/**
	 * Job Copy_e_n0_to_e @-4.0
	 * In variables: e_n0
	 * Out variables: e
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_e_n0_to_e() noexcept
	{
		deep_copy(e, e_n0);
	}
	
	/**
	 * Job initRadiusOfGyration @-4.0
	 * In variables: BetaAxi, twoPi, Xc_n0
	 * Out variables: R_n0
	 */
	KOKKOS_INLINE_FUNCTION
	void initRadiusOfGyration() noexcept
	{
		if (as_const(options->BetaAxi) == 0.0) 
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& dCells)
		{
			R_n0(dCells) = 1.0;
		});
		else 
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			R_n0(cCells) = as_const(options->twoPi) * Xc_n0(cCells)[1];
		});
	}
	
	/**
	 * Job initCellVelocity @-4.0
	 * In variables: testCase, NohTestCase, Xc_n0, u0, SedovTestCase, ElasticPlasticPistonTestCase
	 * Out variables: V_n0
	 */
	KOKKOS_INLINE_FUNCTION
	void initCellVelocity() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			if (as_const(options->testCase) == as_const(options->NohTestCase)) 
			{
				double n1 = Xc_n0(cCells)[0];
				double n2 = Xc_n0(cCells)[1];
				double normVect = MathFunctions::sqrt(n1 * n1 + n2 * n2);
				V_n0(cCells)[0] = -as_const(options->u0) * n1 / normVect;
				V_n0(cCells)[1] = -as_const(options->u0) * n2 / normVect;
			}
			else 
				if ((as_const(options->testCase) == as_const(options->SedovTestCase)) || as_const(options->testCase) == as_const(options->ElasticPlasticPistonTestCase)) 
			{
				V_n0(cCells)[0] = 0.0;
				V_n0(cCells)[1] = 0.0;
			}
		});
	}
	
	/**
	 * Job Copy_R_n0_to_R @-3.0
	 * In variables: R_n0
	 * Out variables: R
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_R_n0_to_R() noexcept
	{
		deep_copy(R, R_n0);
	}
	
	/**
	 * Job Copy_V_n0_to_V @-3.0
	 * In variables: V_n0
	 * Out variables: V
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_V_n0_to_V() noexcept
	{
		deep_copy(V, V_n0);
	}
	
	/**
	 * Job initVolume @-3.0
	 * In variables: a_n0, R_n0
	 * Out variables: v_n0
	 */
	KOKKOS_INLINE_FUNCTION
	void initVolume() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			v_n0(cCells) = a_n0(cCells) * R_n0(cCells);
		});
	}
	
	/**
	 * Job Copy_v_n0_to_v @-2.0
	 * In variables: v_n0
	 * Out variables: v
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_v_n0_to_v() noexcept
	{
		deep_copy(v, v_n0);
	}
	
	/**
	 * Job initCellMass @-2.0
	 * In variables: rho0, v_n0
	 * Out variables: m_n0
	 */
	KOKKOS_INLINE_FUNCTION
	void initCellMass() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			m_n0(cCells) = as_const(options->rho0) * v_n0(cCells);
		});
	}
	
	/**
	 * Job Copy_m_n0_to_m @-1.0
	 * In variables: m_n0
	 * Out variables: m
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_m_n0_to_m() noexcept
	{
		deep_copy(m, m_n0);
	}
	
	/**
	 * Job computeArea @1.0
	 * In variables: X
	 * Out variables: a
	 */
	KOKKOS_INLINE_FUNCTION
	void computeArea() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			double reduceSum221272122 = 0.0;
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pPlus1Id(nodesOfCellC[(pNodesOfCellC+1+nbNodesOfCell)%nbNodesOfCell]);
					int pNodes(pId);
					int pPlus1Nodes(pPlus1Id);
					reduceSum221272122 = reduceSum221272122 + (EUCCLHYDFunctions::crossProduct2d(X(pNodes), X(pPlus1Nodes)));
				}
			}
			a(cCells) = 0.5 * reduceSum221272122;
		});
	}
	
	/**
	 * Job computePerimeter @1.0
	 * In variables: X
	 * Out variables: perim
	 */
	KOKKOS_INLINE_FUNCTION
	void computePerimeter() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			double reduceSum942029106 = 0.0;
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pPlus1Id(nodesOfCellC[(pNodesOfCellC+1+nbNodesOfCell)%nbNodesOfCell]);
					int pNodes(pId);
					int pPlus1Nodes(pPlus1Id);
					reduceSum942029106 = reduceSum942029106 + (EUCCLHYDFunctions::norm(ArrayOperations::minus(X(pNodes), X(pPlus1Nodes))));
				}
			}
			perim(cCells) = reduceSum942029106;
		});
	}
	
	/**
	 * Job computeCornerNormaAplusAndMinus @1.0
	 * In variables: X, BetaAxi, twoPi
	 * Out variables: nplus, Aplus, nminus, Aminus
	 */
	KOKKOS_INLINE_FUNCTION
	void computeCornerNormaAplusAndMinus() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pMinus1Id(nodesOfCellC[(pNodesOfCellC-1+nbNodesOfCell)%nbNodesOfCell]);
					int pPlus1Id(nodesOfCellC[(pNodesOfCellC+1+nbNodesOfCell)%nbNodesOfCell]);
					int pMinus1Nodes(pMinus1Id);
					int pNodes(pId);
					int pPlus1Nodes(pPlus1Id);
					RealArray1D<2> xp = X(pNodes);
					RealArray1D<2> xpPlus = X(pPlus1Nodes);
					RealArray1D<2> xpMinus = X(pMinus1Nodes);
					double Rp = 1.0 - as_const(options->BetaAxi) + as_const(options->BetaAxi) * as_const(options->twoPi) * X(pNodes)[1];
					double RpPlus = 1.0 - as_const(options->BetaAxi) + as_const(options->BetaAxi) * as_const(options->twoPi) * X(pPlus1Nodes)[1];
					double RpMinus = 1.0 - as_const(options->BetaAxi) + as_const(options->BetaAxi) * as_const(options->twoPi) * X(pMinus1Nodes)[1];
					double RpcPlus = (2.0 * Rp + RpPlus) / 3.0;
					double RpcMinus = (2.0 * Rp + RpMinus) / 3.0;
					double npctmp1 = xpPlus[1] - xp[1];
					double npctmp2 = xp[0] - xpPlus[0];
					double normVect1 = MathFunctions::sqrt(npctmp1 * npctmp1 + npctmp2 * npctmp2);
					nplus(pNodes,cCells)[0] = npctmp1 / normVect1;
					nplus(pNodes,cCells)[1] = npctmp2 / normVect1;
					Aplus(pNodes,cCells) = normVect1 / 2.0 * RpcPlus;
					npctmp1 = xp[1] - xpMinus[1];
					npctmp2 = xpMinus[0] - xp[0];
					double normVect2 = MathFunctions::sqrt(npctmp1 * npctmp1 + npctmp2 * npctmp2);
					nminus(pNodes,cCells)[0] = npctmp1 / normVect2;
					nminus(pNodes,cCells)[1] = npctmp2 / normVect2;
					Aminus(pNodes,cCells) = normVect2 / 2.0 * RpcMinus;
				}
			}
		});
	}
	
	/**
	 * Job computeVelocityNorm @1.0
	 * In variables: V
	 * Out variables: normV
	 */
	KOKKOS_INLINE_FUNCTION
	void computeVelocityNorm() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			normV(cCells) = EUCCLHYDFunctions::norm(V(cCells));
		});
	}
	
	/**
	 * Job constitutiveLawAndPlasticRadialReturnDeviatorStressTensor @1.0
	 * In variables: constitutiveLaw, constitutiveLawNeoHookean, Be, Bett, mu, BetaAxi, Y, deltat
	 * Out variables: S, B, Btt, Dp
	 */
	KOKKOS_INLINE_FUNCTION
	void constitutiveLawAndPlasticRadialReturnDeviatorStressTensor() noexcept
	{
		if (as_const(options->constitutiveLaw) == as_const(options->constitutiveLawNeoHookean)) 
		{
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
			{
				double J = MathFunctions::sqrt(EUCCLHYDFunctions::det2d(Be(cCells)) * Bett(cCells));
				double J_minus_2third = EUCCLHYDFunctions::pow(J, -2.0 / 3.0);
				RealArray2D<2,2> Bbar = ArrayOperations::multiply(J_minus_2third, Be(cCells));
				double trBbar = EUCCLHYDFunctions::trace(Bbar) + J_minus_2third * Bett(cCells);
				RealArray2D<2,2> Bbar0 = ArrayOperations::minus(Bbar, ArrayOperations::multiply(trBbar / 3.0, EUCCLHYDFunctions::identityMatrix2d()));
				RealArray2D<2,2> Se = ArrayOperations::multiply(as_const(options->mu) / J, Bbar0);
				double normS = MathFunctions::sqrt(Se[0][0] * Se[0][0] + Se[1][1] * Se[1][1] + Se[1][0] * Se[1][0] + Se[0][1] * Se[0][1] + as_const(options->BetaAxi) * ((Se[0][0] + Se[1][1]) * (Se[0][0] + Se[1][1])));
				if (normS >= MathFunctions::sqrt(2.0 / 3.0) * as_const(options->Y)) 
				{
					RealArray2D<2,2> unitS = ArrayOperations::divide(Se, normS);
					S(cCells) = ArrayOperations::multiply(ArrayOperations::multiply(unitS, MathFunctions::sqrt(2.0 / 3.0)), as_const(options->Y));
					Bbar0 = ArrayOperations::divide(ArrayOperations::multiply(ArrayOperations::multiply(ArrayOperations::multiply(unitS, MathFunctions::sqrt(2.0 / 3.0)), as_const(options->Y)), J), as_const(options->mu));
					double tr = EUCCLHYDFunctions::traceOfMatrixWithUnitDetAndKnowingDevPart(Bbar0);
					RealArray2D<2,2> newBbar = ArrayOperations::plus(Bbar0, ArrayOperations::multiply(tr / 3.0, EUCCLHYDFunctions::identityMatrix2d()));
					double newBbartt = -(Bbar0[0][0] + Bbar0[1][1]) + tr / 3.0;
					B(cCells) = ArrayOperations::divide(newBbar, J_minus_2third);
					Btt(cCells) = as_const(options->BetaAxi) * newBbartt / J_minus_2third + (1.0 - as_const(options->BetaAxi));
					RealArray2D<2,2> LvBbar = ArrayOperations::divide((ArrayOperations::minus(newBbar, Bbar)), as_const(deltat));
					Dp(cCells) = ArrayOperations::multiply(-0.25, (ArrayOperations::plus(EUCCLHYDFunctions::matProduct(LvBbar, EUCCLHYDFunctions::inverse(newBbar)), EUCCLHYDFunctions::matProduct(EUCCLHYDFunctions::inverse(newBbar), LvBbar))));
				}
				else 
				{
					S(cCells) = Se;
					B(cCells) = Be(cCells);
					Dp(cCells) = EUCCLHYDFunctions::zeroMatrix2d();
				}
			});
		}
	}
	
	/**
	 * Job computeCenter @2.0
	 * In variables: X, a
	 * Out variables: Xc
	 */
	KOKKOS_INLINE_FUNCTION
	void computeCenter() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			RealArray1D<2> reduceSum917310170 = {0.0, 0.0};
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pPlus1Id(nodesOfCellC[(pNodesOfCellC+1+nbNodesOfCell)%nbNodesOfCell]);
					int pNodes(pId);
					int pPlus1Nodes(pPlus1Id);
					reduceSum917310170 = ArrayOperations::plus(reduceSum917310170, (ArrayOperations::divide(ArrayOperations::multiply(EUCCLHYDFunctions::crossProduct2d(X(pNodes), X(pPlus1Nodes)), (ArrayOperations::plus(X(pNodes), X(pPlus1Nodes)))), (6.0 * a(cCells)))));
				}
			}
			Xc(cCells) = reduceSum917310170;
		});
	}
	
	/**
	 * Job computeInternalEnergy @2.0
	 * In variables: e, V, Dp
	 * Out variables: eps
	 */
	KOKKOS_INLINE_FUNCTION
	void computeInternalEnergy() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			eps(cCells) = e(cCells) - 0.5 * EUCCLHYDFunctions::dot(V(cCells), V(cCells)) + MathFunctions::sqrt(2.0 / 3.0 * EUCCLHYDFunctions::matrixNorm(Dp(cCells)));
		});
	}
	
	/**
	 * Job computeCornerNormal @2.0
	 * In variables: Aminus, nminus, Aplus, nplus
	 * Out variables: n, A
	 */
	KOKKOS_INLINE_FUNCTION
	void computeCornerNormal() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pNodes(pId);
					double npc1 = Aminus(pNodes,cCells) * nminus(pNodes,cCells)[0] + Aplus(pNodes,cCells) * nplus(pNodes,cCells)[0];
					double npc2 = Aminus(pNodes,cCells) * nminus(pNodes,cCells)[1] + Aplus(pNodes,cCells) * nplus(pNodes,cCells)[1];
					double normVect = MathFunctions::sqrt(npc1 * npc1 + npc2 * npc2);
					n(pNodes,cCells)[0] = npc1 / normVect;
					n(pNodes,cCells)[1] = npc2 / normVect;
					A(pNodes,cCells) = normVect;
				}
			}
		});
	}
	
	/**
	 * Job computeRadiusOfGyration @3.0
	 * In variables: BetaAxi, twoPi, Xc
	 * Out variables: R
	 */
	KOKKOS_INLINE_FUNCTION
	void computeRadiusOfGyration() noexcept
	{
		if (as_const(options->BetaAxi) > 0.0) 
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			R(cCells) = as_const(options->twoPi) * Xc(cCells)[1];
		});
	}
	
	/**
	 * Job computeVolume @4.0
	 * In variables: a, R
	 * Out variables: v
	 */
	KOKKOS_INLINE_FUNCTION
	void computeVolume() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			v(cCells) = a(cCells) * R(cCells);
		});
	}
	
	/**
	 * Job computeDensity @5.0
	 * In variables: m, v
	 * Out variables: rho
	 */
	KOKKOS_INLINE_FUNCTION
	void computeDensity() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			rho(cCells) = m(cCells) / v(cCells);
		});
	}
	
	/**
	 * Job EOSPressure @6.0
	 * In variables: eos, eosPerfectGas, gamma, rho, eps, eosMieGruneisen, rho0, threshold, gamma0, s, a0
	 * Out variables: p
	 */
	KOKKOS_INLINE_FUNCTION
	void eOSPressure() noexcept
	{
		if (as_const(options->eos) == as_const(options->eosPerfectGas)) 
		{
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
			{
				p(cCells) = (as_const(options->gamma) - 1.0) * rho(cCells) * eps(cCells);
			});
		}
		else 
			if (as_const(options->eos) == as_const(options->eosMieGruneisen)) 
		{
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& dCells)
			{
				double eta = rho(dCells) / as_const(options->rho0);
				if (EUCCLHYDFunctions::abs(eta - 1.0) < as_const(threshold)) 
					eta = 1.0;
				double f = (eta - 1.0) * (eta - 0.5 * as_const(options->gamma0) * (eta - 1.0)) / ((eta - as_const(options->s) * (eta - 1.0)) * (eta - as_const(options->s) * (eta - 1.0)));
				p(dCells) = as_const(options->rho0) * as_const(options->a0) * as_const(options->a0) * f + as_const(options->rho0) * (as_const(options->gamma0)) * eps(dCells);
			});
		}
	}
	
	/**
	 * Job computeStressTensor @7.0
	 * In variables: p, S
	 * Out variables: T
	 */
	KOKKOS_INLINE_FUNCTION
	void computeStressTensor() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			T(cCells) = ArrayOperations::plus(ArrayOperations::multiply(-p(cCells), EUCCLHYDFunctions::identityMatrix2d()), S(cCells));
		});
	}
	
	/**
	 * Job EOSSoundSpeed @7.0
	 * In variables: eos, eosPerfectGas, gamma, p, rho, eosMieGruneisen, rho0, threshold, s, gamma0, a0, mu
	 * Out variables: c
	 */
	KOKKOS_INLINE_FUNCTION
	void eOSSoundSpeed() noexcept
	{
		if (as_const(options->eos) == as_const(options->eosPerfectGas)) 
		{
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
			{
				c(cCells) = MathFunctions::sqrt(as_const(options->gamma) * p(cCells) / rho(cCells));
			});
		}
		else 
			if (as_const(options->eos) == as_const(options->eosMieGruneisen)) 
		{
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& dCells)
			{
				double eta = rho(dCells) / as_const(options->rho0);
				if (EUCCLHYDFunctions::abs(eta - 1.0) < as_const(threshold)) 
					eta = 1.0;
				double df = (eta + (as_const(options->s) - as_const(options->gamma0)) * (eta - 1.0)) / ((eta - as_const(options->s) * (eta - 1.0)) * (eta - as_const(options->s) * (eta - 1.0)) * (eta - as_const(options->s) * (eta - 1.0)));
				double a2Hydro = as_const(options->a0) * as_const(options->a0) * df + as_const(options->gamma0) * p(dCells) / (as_const(options->rho0) * eta * eta);
				double a2Elasto = 4.0 / 3.0 * as_const(options->mu) / rho(dCells);
				c(dCells) = MathFunctions::sqrt(a2Hydro + a2Elasto);
			});
		}
	}
	
	/**
	 * Job dumpVariables @7.0
	 * In variables: p, rho, e, v, normV, eps, m
	 * Out variables: 
	 */
	KOKKOS_INLINE_FUNCTION
	void dumpVariables() noexcept
	{
		if (!writer.isDisabled() && (iteration % 1 == 0)) 
		{
			std::map<string, double*> cellVariables;
			std::map<string, double*> nodeVariables;
			cellVariables.insert(pair<string,double*>("Pressure", p.data()));
			cellVariables.insert(pair<string,double*>("Density", rho.data()));
			cellVariables.insert(pair<string,double*>("totalEnergy", e.data()));
			cellVariables.insert(pair<string,double*>("Volume", v.data()));
			cellVariables.insert(pair<string,double*>("VelocityNorm", normV.data()));
			cellVariables.insert(pair<string,double*>("InternalEnergy", eps.data()));
			cellVariables.insert(pair<string,double*>("Mass", m.data()));
			auto quads = mesh->getGeometricMesh()->getQuads();
			writer.writeFile(iteration, t, nbNodes, X.data(), nbCells, quads.data(), cellVariables, nodeVariables);
		}
	}
	
	/**
	 * Job computeDissipationMatrix @8.0
	 * In variables: rho, c, Aplus, nplus, Aminus, nminus
	 * Out variables: M
	 */
	KOKKOS_INLINE_FUNCTION
	void computeDissipationMatrix() noexcept
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& pNodes)
		{
			int pId(pNodes);
			{
				auto cellsOfNodeP(mesh->getCellsOfNode(pId));
				for (int cCellsOfNodeP=0; cCellsOfNodeP<cellsOfNodeP.size(); cCellsOfNodeP++)
				{
					int cId(cellsOfNodeP[cCellsOfNodeP]);
					int cCells(cId);
					M(pNodes,cCells) = ArrayOperations::multiply(rho(cCells) * c(cCells), (ArrayOperations::plus(ArrayOperations::multiply(Aplus(pNodes,cCells), EUCCLHYDFunctions::tensProduct(nplus(pNodes,cCells), nplus(pNodes,cCells))), ArrayOperations::multiply(Aminus(pNodes,cCells), EUCCLHYDFunctions::tensProduct(nminus(pNodes,cCells), nminus(pNodes,cCells))))));
				}
			}
		});
	}
	
	/**
	 * Job computedeltatc @8.0
	 * In variables: A, a, c
	 * Out variables: deltatc
	 */
	KOKKOS_INLINE_FUNCTION
	void computedeltatc() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			double reduceSum_612217622 = 0.0;
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pNodes(pId);
					reduceSum_612217622 = reduceSum_612217622 + (A(pNodes,cCells));
				}
			}
			deltatc(cCells) = 2.0 * a(cCells) / (c(cCells) * reduceSum_612217622);
		});
	}
	
	/**
	 * Job computeNodeDissipationMatrix @9.0
	 * In variables: M
	 * Out variables: MMinus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeNodeDissipationMatrix() noexcept
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& pNodes)
		{
			int pId(pNodes);
			RealArray2D<2,2> reduceSum_1020986738 = {{{0.0, 0.0}, {0.0, 0.0}}};
			{
				auto cellsOfNodeP(mesh->getCellsOfNode(pId));
				for (int cCellsOfNodeP=0; cCellsOfNodeP<cellsOfNodeP.size(); cCellsOfNodeP++)
				{
					int cId(cellsOfNodeP[cCellsOfNodeP]);
					int cCells(cId);
					reduceSum_1020986738 = ArrayOperations::plus(reduceSum_1020986738, (M(pNodes,cCells)));
				}
			}
			MMinus1(pNodes) = EUCCLHYDFunctions::inverse(reduceSum_1020986738);
		});
	}
	
	/**
	 * Job computedeltat @9.0
	 * In variables: deltatc, cfl, deltat
	 * Out variables: deltat_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computedeltat() noexcept
	{
		double reduceMin1092064957(numeric_limits<double>::max());
		{
			Kokkos::Min<double> reducer(reduceMin1092064957);
			Kokkos::parallel_reduce("ReductionreduceMin1092064957", nbCells, KOKKOS_LAMBDA(const int& cCells, double& x)
			{
				reducer.join(x, deltatc(cCells));
			}, reducer);
		}
		deltat_nplus1 = MathFunctions::min(as_const(options->cfl) * reduceMin1092064957, as_const(deltat) * 1.05);
	}
	
	/**
	 * Job Copy_deltat_nplus1_to_deltat @10.0
	 * In variables: deltat_nplus1
	 * Out variables: deltat
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_deltat_nplus1_to_deltat() noexcept
	{
		std::swap(deltat_nplus1, deltat);
	}
	
	/**
	 * Job computeNodeVelocity @10.0
	 * In variables: M, V, A, T, n, MMinus1
	 * Out variables: Vnode
	 */
	KOKKOS_INLINE_FUNCTION
	void computeNodeVelocity() noexcept
	{
		auto innerNodes(mesh->getInnerNodes());
		Kokkos::parallel_for(nbInnerNodes, KOKKOS_LAMBDA(const int& pInnerNodes)
		{
			int pId(innerNodes[pInnerNodes]);
			int pNodes(pId);
			RealArray1D<2> reduceSum1187380618 = {0.0, 0.0};
			{
				auto cellsOfNodeP(mesh->getCellsOfNode(pId));
				for (int cCellsOfNodeP=0; cCellsOfNodeP<cellsOfNodeP.size(); cCellsOfNodeP++)
				{
					int cId(cellsOfNodeP[cCellsOfNodeP]);
					int cCells(cId);
					reduceSum1187380618 = ArrayOperations::plus(reduceSum1187380618, (ArrayOperations::minus(EUCCLHYDFunctions::matVectProduct(M(pNodes,cCells), V(cCells)), ArrayOperations::multiply(A(pNodes,cCells), EUCCLHYDFunctions::matVectProduct(T(cCells), n(pNodes,cCells))))));
				}
			}
			Vnode(pNodes) = EUCCLHYDFunctions::matVectProduct(MMinus1(pNodes), reduceSum1187380618);
		});
	}
	
	/**
	 * Job computeTime @10.0
	 * In variables: t, deltat_nplus1
	 * Out variables: t_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeTime() noexcept
	{
		t_nplus1 = as_const(t) + as_const(deltat_nplus1);
	}
	
	/**
	 * Job computeNodeVelocityBoundaryCondition @10.0
	 * In variables: testCase, NohTestCase, SedovTestCase, X, threshold, M, V, A, T, n, MMinus1, ex, ey, ElasticPlasticPistonTestCase, u0, t, Y_LENGTH
	 * Out variables: Vnode
	 */
	KOKKOS_INLINE_FUNCTION
	void computeNodeVelocityBoundaryCondition() noexcept
	{
		if ((as_const(options->testCase) == as_const(options->NohTestCase)) || (as_const(options->testCase) == as_const(options->SedovTestCase))) 
		{
			auto outerFaces(mesh->getOuterFaces());
			Kokkos::parallel_for(nbOuterFaces, KOKKOS_LAMBDA(const int& fOuterFaces)
			{
				int fId(outerFaces[fOuterFaces]);
				{
					auto nodesOfFaceF(mesh->getNodesOfFace(fId));
					for (int pNodesOfFaceF=0; pNodesOfFaceF<nodesOfFaceF.size(); pNodesOfFaceF++)
					{
						int pId(nodesOfFaceF[pNodesOfFaceF]);
						int pNodes(pId);
						if ((X(pNodes)[0] > as_const(threshold)) && (X(pNodes)[1] > as_const(threshold))) 
						{
							RealArray1D<2> reduceSum_1534915614 = {0.0, 0.0};
							{
								auto cellsOfNodeP(mesh->getCellsOfNode(pId));
								for (int ccCellsOfNodeP=0; ccCellsOfNodeP<cellsOfNodeP.size(); ccCellsOfNodeP++)
								{
									int ccId(cellsOfNodeP[ccCellsOfNodeP]);
									int ccCells(ccId);
									reduceSum_1534915614 = ArrayOperations::plus(reduceSum_1534915614, (ArrayOperations::minus(EUCCLHYDFunctions::matVectProduct(M(pNodes,ccCells), V(ccCells)), ArrayOperations::multiply(A(pNodes,ccCells), EUCCLHYDFunctions::matVectProduct(T(ccCells), n(pNodes,ccCells))))));
								}
							}
							Vnode(pNodes) = EUCCLHYDFunctions::matVectProduct(MMinus1(pNodes), reduceSum_1534915614);
						}
						else 
							if ((X(pNodes)[0] > as_const(threshold)) && (X(pNodes)[1] <= as_const(threshold))) 
						{
							RealArray1D<2> reduceSum_443252330 = {0.0, 0.0};
							{
								auto cellsOfNodeP(mesh->getCellsOfNode(pId));
								for (int cxCellsOfNodeP=0; cxCellsOfNodeP<cellsOfNodeP.size(); cxCellsOfNodeP++)
								{
									int cxId(cellsOfNodeP[cxCellsOfNodeP]);
									int cxCells(cxId);
									reduceSum_443252330 = ArrayOperations::plus(reduceSum_443252330, (ArrayOperations::minus(EUCCLHYDFunctions::matVectProduct(M(pNodes,cxCells), V(cxCells)), ArrayOperations::multiply(A(pNodes,cxCells), EUCCLHYDFunctions::matVectProduct(T(cxCells), n(pNodes,cxCells))))));
								}
							}
							double reduceSum_1247653638 = 0.0;
							{
								auto cellsOfNodeP(mesh->getCellsOfNode(pId));
								for (int dxCellsOfNodeP=0; dxCellsOfNodeP<cellsOfNodeP.size(); dxCellsOfNodeP++)
								{
									int dxId(cellsOfNodeP[dxCellsOfNodeP]);
									int dxCells(dxId);
									reduceSum_1247653638 = reduceSum_1247653638 + (EUCCLHYDFunctions::dot(EUCCLHYDFunctions::matVectProduct(M(pNodes,dxCells), as_const(options->ex)), as_const(options->ex)));
								}
							}
							double vpNormX = EUCCLHYDFunctions::dot(reduceSum_443252330, as_const(options->ex)) / reduceSum_1247653638;
							Vnode(pNodes) = ArrayOperations::multiply(vpNormX, as_const(options->ex));
						}
						else 
							if ((X(pNodes)[0] <= as_const(threshold)) && (X(pNodes)[1] > as_const(threshold))) 
						{
							RealArray1D<2> reduceSum1858476410 = {0.0, 0.0};
							{
								auto cellsOfNodeP(mesh->getCellsOfNode(pId));
								for (int cyCellsOfNodeP=0; cyCellsOfNodeP<cellsOfNodeP.size(); cyCellsOfNodeP++)
								{
									int cyId(cellsOfNodeP[cyCellsOfNodeP]);
									int cyCells(cyId);
									reduceSum1858476410 = ArrayOperations::plus(reduceSum1858476410, (ArrayOperations::minus(EUCCLHYDFunctions::matVectProduct(M(pNodes,cyCells), V(cyCells)), ArrayOperations::multiply(A(pNodes,cyCells), EUCCLHYDFunctions::matVectProduct(T(cyCells), n(pNodes,cyCells))))));
								}
							}
							double reduceSum179578710 = 0.0;
							{
								auto cellsOfNodeP(mesh->getCellsOfNode(pId));
								for (int dyCellsOfNodeP=0; dyCellsOfNodeP<cellsOfNodeP.size(); dyCellsOfNodeP++)
								{
									int dyId(cellsOfNodeP[dyCellsOfNodeP]);
									int dyCells(dyId);
									reduceSum179578710 = reduceSum179578710 + (EUCCLHYDFunctions::dot(EUCCLHYDFunctions::matVectProduct(M(pNodes,dyCells), as_const(options->ey)), as_const(options->ey)));
								}
							}
							double vpNormY = EUCCLHYDFunctions::dot(reduceSum1858476410, as_const(options->ey)) / reduceSum179578710;
							Vnode(pNodes) = ArrayOperations::multiply(vpNormY, as_const(options->ey));
						}
						else 
						{
							Vnode(pNodes)[0] = 0.0;
							Vnode(pNodes)[1] = 0.0;
						}
					}
				}
			});
		}
		else 
			if (as_const(options->testCase) == as_const(options->ElasticPlasticPistonTestCase)) 
		{
			auto outerFaces(mesh->getOuterFaces());
			Kokkos::parallel_for(nbOuterFaces, KOKKOS_LAMBDA(const int& f1OuterFaces)
			{
				int f1Id(outerFaces[f1OuterFaces]);
				{
					auto nodesOfFaceF1(mesh->getNodesOfFace(f1Id));
					for (int p1NodesOfFaceF1=0; p1NodesOfFaceF1<nodesOfFaceF1.size(); p1NodesOfFaceF1++)
					{
						int p1Id(nodesOfFaceF1[p1NodesOfFaceF1]);
						int p1Nodes(p1Id);
						if (EUCCLHYDFunctions::abs(X(p1Nodes)[0] - as_const(options->u0) * as_const(t)) < 0.001) 
						{
							Vnode(p1Nodes)[0] = as_const(options->u0);
							Vnode(p1Nodes)[1] = 0.0;
						}
						else 
							if ((X(p1Nodes)[1] <= as_const(threshold)) || (X(p1Nodes)[1] > as_const(options->Y_LENGTH) - as_const(threshold))) 
						{
							RealArray1D<2> reduceSum97485430 = {0.0, 0.0};
							{
								auto cellsOfNodeP1(mesh->getCellsOfNode(p1Id));
								for (int cx1CellsOfNodeP1=0; cx1CellsOfNodeP1<cellsOfNodeP1.size(); cx1CellsOfNodeP1++)
								{
									int cx1Id(cellsOfNodeP1[cx1CellsOfNodeP1]);
									int cx1Cells(cx1Id);
									reduceSum97485430 = ArrayOperations::plus(reduceSum97485430, (ArrayOperations::minus(EUCCLHYDFunctions::matVectProduct(M(p1Nodes,cx1Cells), V(cx1Cells)), ArrayOperations::multiply(A(p1Nodes,cx1Cells), EUCCLHYDFunctions::matVectProduct(T(cx1Cells), n(p1Nodes,cx1Cells))))));
								}
							}
							double reduceSum_296036882 = 0.0;
							{
								auto cellsOfNodeP1(mesh->getCellsOfNode(p1Id));
								for (int dx1CellsOfNodeP1=0; dx1CellsOfNodeP1<cellsOfNodeP1.size(); dx1CellsOfNodeP1++)
								{
									int dx1Id(cellsOfNodeP1[dx1CellsOfNodeP1]);
									int dx1Cells(dx1Id);
									reduceSum_296036882 = reduceSum_296036882 + (EUCCLHYDFunctions::dot(EUCCLHYDFunctions::matVectProduct(M(p1Nodes,dx1Cells), as_const(options->ex)), as_const(options->ex)));
								}
							}
							double vpNormX1 = EUCCLHYDFunctions::dot(reduceSum97485430, as_const(options->ex)) / reduceSum_296036882;
							Vnode(p1Nodes) = ArrayOperations::multiply(vpNormX1, as_const(options->ex));
						}
						else 
						{
							Vnode(p1Nodes) = ArrayOperations::multiply(0.0, as_const(options->ex));
						}
					}
				}
			});
		}
	}
	
	/**
	 * Job Copy_t_nplus1_to_t @11.0
	 * In variables: t_nplus1
	 * Out variables: t
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_t_nplus1_to_t() noexcept
	{
		std::swap(t_nplus1, t);
	}
	
	/**
	 * Job computeGradV @11.0
	 * In variables: constitutiveLaw, constitutiveLawNoElasticity, A, Vnode, n, BetaAxi, twoPi, a, V, ey, v
	 * Out variables: L, Ltt
	 */
	KOKKOS_INLINE_FUNCTION
	void computeGradV() noexcept
	{
		if (as_const(options->constitutiveLaw) != as_const(options->constitutiveLawNoElasticity)) 
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			RealArray2D<2,2> reduceSum1541967482 = {{{0.0, 0.0}, {0.0, 0.0}}};
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pNodes(pId);
					reduceSum1541967482 = ArrayOperations::plus(reduceSum1541967482, (ArrayOperations::minus(ArrayOperations::multiply(A(pNodes,cCells), EUCCLHYDFunctions::tensProduct(Vnode(pNodes), n(pNodes,cCells))), ArrayOperations::multiply(as_const(options->BetaAxi) * as_const(options->twoPi) * a(cCells), EUCCLHYDFunctions::tensProduct(V(cCells), as_const(options->ey))))));
				}
			}
			L(cCells) = ArrayOperations::divide(reduceSum1541967482, v(cCells));
			Ltt(cCells) = as_const(options->BetaAxi) * as_const(options->twoPi) * a(cCells) * V(cCells)[1] / v(cCells);
		});
	}
	
	/**
	 * Job computeSubCellForce @11.0
	 * In variables: A, T, n, M, Vnode, V
	 * Out variables: F
	 */
	KOKKOS_INLINE_FUNCTION
	void computeSubCellForce() noexcept
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& pNodes)
		{
			int pId(pNodes);
			{
				auto cellsOfNodeP(mesh->getCellsOfNode(pId));
				for (int cCellsOfNodeP=0; cCellsOfNodeP<cellsOfNodeP.size(); cCellsOfNodeP++)
				{
					int cId(cellsOfNodeP[cCellsOfNodeP]);
					int cCells(cId);
					F(pNodes,cCells) = ArrayOperations::plus(ArrayOperations::multiply(A(pNodes,cCells), EUCCLHYDFunctions::matVectProduct(T(cCells), n(pNodes,cCells))), EUCCLHYDFunctions::matVectProduct(M(pNodes,cCells), ArrayOperations::minus(Vnode(pNodes), V(cCells))));
				}
			}
		});
	}
	
	/**
	 * Job updateNodePosition @11.0
	 * In variables: X, deltat, Vnode
	 * Out variables: X_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void updateNodePosition() noexcept
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& pNodes)
		{
			X_nplus1(pNodes) = ArrayOperations::plus(X(pNodes), ArrayOperations::multiply(as_const(deltat), Vnode(pNodes)));
		});
	}
	
	/**
	 * Job Copy_X_nplus1_to_X @12.0
	 * In variables: X_nplus1
	 * Out variables: X
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_X_nplus1_to_X() noexcept
	{
		std::swap(X_nplus1, X);
	}
	
	/**
	 * Job leftCauchyGreenTensorElasticPrediction @12.0
	 * In variables: constitutiveLaw, constitutiveLawNoElasticity, B, deltat, L, Btt, Ltt
	 * Out variables: Be_nplus1, Bett_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void leftCauchyGreenTensorElasticPrediction() noexcept
	{
		if (as_const(options->constitutiveLaw) != as_const(options->constitutiveLawNoElasticity)) 
			Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			Be_nplus1(cCells) = ArrayOperations::plus(B(cCells), ArrayOperations::multiply(as_const(deltat), (ArrayOperations::plus(EUCCLHYDFunctions::matProduct(L(cCells), B(cCells)), EUCCLHYDFunctions::matProduct(B(cCells), EUCCLHYDFunctions::transpose(L(cCells)))))));
			Bett_nplus1(cCells) = Btt(cCells) + as_const(deltat) * 2.0 * Ltt(cCells) * Btt(cCells);
		});
	}
	
	/**
	 * Job updateVelocity @12.0
	 * In variables: F, V, deltat, m, BetaAxi, twoPi, a, p, S, ey
	 * Out variables: V_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void updateVelocity() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			RealArray1D<2> reduceSum_611119422 = {0.0, 0.0};
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pNodes(pId);
					reduceSum_611119422 = ArrayOperations::plus(reduceSum_611119422, (F(pNodes,cCells)));
				}
			}
			V_nplus1(cCells) = ArrayOperations::plus(V(cCells), ArrayOperations::multiply(as_const(deltat) / m(cCells), (ArrayOperations::plus(reduceSum_611119422, ArrayOperations::multiply(as_const(options->BetaAxi) * as_const(options->twoPi) * a(cCells) * (p(cCells) + S(cCells)[0][0] + S(cCells)[1][1]), as_const(options->ey))))));
		});
	}
	
	/**
	 * Job updateTotalEnergy @12.0
	 * In variables: F, Vnode, e, deltat, m
	 * Out variables: e_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void updateTotalEnergy() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			double reduceSum232713490 = 0.0;
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pNodes(pId);
					reduceSum232713490 = reduceSum232713490 + (EUCCLHYDFunctions::dot(F(pNodes,cCells), Vnode(pNodes)));
				}
			}
			e_nplus1(cCells) = e(cCells) + as_const(deltat) / m(cCells) * reduceSum232713490;
		});
	}
	
	/**
	 * Job Copy_V_nplus1_to_V @13.0
	 * In variables: V_nplus1
	 * Out variables: V
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_V_nplus1_to_V() noexcept
	{
		std::swap(V_nplus1, V);
	}
	
	/**
	 * Job Copy_Be_nplus1_to_Be @13.0
	 * In variables: Be_nplus1
	 * Out variables: Be
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_Be_nplus1_to_Be() noexcept
	{
		std::swap(Be_nplus1, Be);
	}
	
	/**
	 * Job Copy_Bett_nplus1_to_Bett @13.0
	 * In variables: Bett_nplus1
	 * Out variables: Bett
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_Bett_nplus1_to_Bett() noexcept
	{
		std::swap(Bett_nplus1, Bett);
	}
	
	/**
	 * Job Copy_e_nplus1_to_e @13.0
	 * In variables: e_nplus1
	 * Out variables: e
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_e_nplus1_to_e() noexcept
	{
		std::swap(e_nplus1, e);
	}

public:
	void simulate()
	{
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting EUCCLHYD ..." << __RESET__ << "\n\n";

		std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options->X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options->Y_EDGE_ELEMS
			<< __RESET__ << ", X length=" << __BOLD__ << options->X_EDGE_LENGTH << __RESET__ << ", Y length=" << __BOLD__ << options->Y_EDGE_LENGTH << __RESET__ << std::endl;


		if (Kokkos::hwloc::available()) {
			std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_numa_count()
				<< __RESET__ << ", Cores/NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_cores_per_numa()
				<< __RESET__ << ", Threads/Core=" << __BOLD__ << Kokkos::hwloc::get_available_threads_per_core() << __RESET__ << std::endl;
		} else {
			std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
		}

		// std::cout << "[" << __GREEN__ << "KOKKOS" << __RESET__ << "]    " << __BOLD__ << (is_same<MyLayout,Kokkos::LayoutLeft>::value?"Left":"Right")" << __RESET__ << " layout" << std::endl;

		if (!writer.isDisabled())
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
		else
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

		utils::Timer timer(true);

		copy_X_n0_to_X(); // @-5.0
		initCenter(); // @-5.0
		initArea(); // @-5.0
		initDensity(); // @-5.0
		initLeftCauchyGreenTensor(); // @-5.0
		initDeviatoricStressTensor(); // @-5.0
		initCellTotalEnergy(); // @-5.0
		copy_Xc_n0_to_Xc(); // @-4.0
		copy_a_n0_to_a(); // @-4.0
		copy_rho_n0_to_rho(); // @-4.0
		copy_B_n0_to_B(); // @-4.0
		copy_Btt_n0_to_Btt(); // @-4.0
		copy_Be_n0_to_Be(); // @-4.0
		copy_Bett_n0_to_Bett(); // @-4.0
		copy_S_n0_to_S(); // @-4.0
		copy_Stt_n0_to_Stt(); // @-4.0
		copy_e_n0_to_e(); // @-4.0
		initRadiusOfGyration(); // @-4.0
		initCellVelocity(); // @-4.0
		copy_R_n0_to_R(); // @-3.0
		copy_V_n0_to_V(); // @-3.0
		initVolume(); // @-3.0
		copy_v_n0_to_v(); // @-2.0
		initCellMass(); // @-2.0
		copy_m_n0_to_m(); // @-1.0
		timer.stop();

		iteration = 0;
		while (t < options->option_stoptime && iteration < options->option_max_iterations)
		{
			timer.start();
			utils::Timer compute_timer(true);
			iteration++;
			if (iteration!=1)
				std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << iteration << __RESET__ "] t = " << __BOLD__
					<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t << __RESET__;

			computeArea(); // @1.0
			computePerimeter(); // @1.0
			computeCornerNormaAplusAndMinus(); // @1.0
			computeVelocityNorm(); // @1.0
			constitutiveLawAndPlasticRadialReturnDeviatorStressTensor(); // @1.0
			computeCenter(); // @2.0
			computeInternalEnergy(); // @2.0
			computeCornerNormal(); // @2.0
			computeRadiusOfGyration(); // @3.0
			computeVolume(); // @4.0
			computeDensity(); // @5.0
			eOSPressure(); // @6.0
			computeStressTensor(); // @7.0
			eOSSoundSpeed(); // @7.0
			dumpVariables(); // @7.0
			computeDissipationMatrix(); // @8.0
			computedeltatc(); // @8.0
			computeNodeDissipationMatrix(); // @9.0
			computedeltat(); // @9.0
			copy_deltat_nplus1_to_deltat(); // @10.0
			computeNodeVelocity(); // @10.0
			computeTime(); // @10.0
			computeNodeVelocityBoundaryCondition(); // @10.0
			copy_t_nplus1_to_t(); // @11.0
			computeGradV(); // @11.0
			computeSubCellForce(); // @11.0
			updateNodePosition(); // @11.0
			copy_X_nplus1_to_X(); // @12.0
			leftCauchyGreenTensorElasticPrediction(); // @12.0
			updateVelocity(); // @12.0
			updateTotalEnergy(); // @12.0
			copy_V_nplus1_to_V(); // @13.0
			copy_Be_nplus1_to_Be(); // @13.0
			copy_Bett_nplus1_to_Bett(); // @13.0
			copy_e_nplus1_to_e(); // @13.0
			compute_timer.stop();

			// Progress
			std::cout << utils::progress_bar(iteration, options->option_max_iterations, t, options->option_stoptime, 30);
			timer.stop();
			std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
				utils::eta(iteration, options->option_max_iterations, t, options->option_stoptime, deltat, timer), true)
				<< __RESET__ << "\r";
			std::cout.flush();
		}
		std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << timer.print() << __RESET__ << std::endl;
	}
};	

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto o = new EUCCLHYD::Options();
	string output;
	if (argc == 5) {
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->X_EDGE_LENGTH = std::atof(argv[3]);
		o->Y_EDGE_LENGTH = std::atof(argv[4]);
	} else if (argc == 6) {
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->X_EDGE_LENGTH = std::atof(argv[3]);
		o->Y_EDGE_LENGTH = std::atof(argv[4]);
		output = argv[5];
	} else if (argc != 1) {
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 4 or 5 args: X Y Xlength Ylength (output)." << std::endl;
		std::cerr << "(X=100, Y=10, Xlength=0.01, Ylength=0.01 output=current directory with no args)" << std::endl;
	}
	auto gm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->X_EDGE_LENGTH, o->Y_EDGE_LENGTH);
	auto nm = new NumericMesh2D(gm);
	auto c = new EUCCLHYD(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete gm;
	delete o;
	Kokkos::finalize();
	return 0;
}
