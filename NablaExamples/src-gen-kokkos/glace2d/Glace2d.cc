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

using namespace nablalib;

class Glace2d
{
public:
	struct Options
	{
		// Should be const but usefull to set them from main args
		double X_EDGE_LENGTH = 0.01;
		double Y_EDGE_LENGTH = X_EDGE_LENGTH;
		int X_EDGE_ELEMS = 100;
		int Y_EDGE_ELEMS = 10;
		int Z_EDGE_ELEMS = 1;
		double option_stoptime = 0.2;
		int option_max_iterations = 20000;
		double gamma = 1.4;
		double option_x_interface = 0.5;
		double option_deltat_ini = 1.0E-5;
		double option_deltat_cfl = 0.4;
		double option_rho_ini_zg = 1.0;
		double option_rho_ini_zd = 0.125;
		double option_p_ini_zg = 1.0;
		double option_p_ini_zd = 0.1;
	};
	Options* options;

private:
	int iteration;
	NumericMesh2D* mesh;
	PvdFileWriter2D writer;
	int nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;

	// Global Variables
	double t, deltat, deltat_nplus1, t_nplus1;

	// Connectivity Variables
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> b;
	Kokkos::View<RealArray1D<2>*> bt;
	Kokkos::View<RealArray2D<2,2>*> Ar;
	Kokkos::View<RealArray2D<2,2>*> Mt;
	Kokkos::View<RealArray1D<2>*> ur;
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
	Kokkos::View<RealArray1D<2>*> uj;
	Kokkos::View<RealArray1D<2>*> center;
	Kokkos::View<double**> l;
	Kokkos::View<RealArray1D<2>**> C_ic;
	Kokkos::View<RealArray1D<2>**> C;
	Kokkos::View<RealArray1D<2>**> F;
	Kokkos::View<RealArray2D<2,2>**> Ajr;
	Kokkos::View<RealArray1D<2>*> X_n0;
	Kokkos::View<RealArray1D<2>*> X_nplus1;
	Kokkos::View<RealArray1D<2>*> uj_nplus1;
	Kokkos::View<double*> E_nplus1;

	const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();

public:
	Glace2d(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
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
	, t(0.0)
	, deltat(options->option_deltat_ini)
	, deltat_nplus1(options->option_deltat_ini)
	, t_nplus1(0.0)
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
		const auto& gNodes = mesh->getGeometricMesh()->getNodes();
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
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
	void copy_X_n0_to_X() noexcept
	{
		deep_copy(X, X_n0);
	}
	
	/**
	 * Job IniCenter @-3.0
	 * In variables: X_n0
	 * Out variables: center
	 */
	KOKKOS_INLINE_FUNCTION
	void iniCenter() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			RealArray1D<2> reduction91753293 = {{0.0, 0.0}};
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					reduction91753293 = ArrayOperations::plus(reduction91753293, (X_n0(rNodes)));
				}
			}
			center(jCells) = ArrayOperations::multiply(0.25, reduction91753293);
		});
	}
	
	/**
	 * Job ComputeCjrIc @-3.0
	 * In variables: X_n0
	 * Out variables: C_ic
	 */
	KOKKOS_INLINE_FUNCTION
	void computeCjrIc() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
					int rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					int rMinus1Nodes(rMinus1Id);
					int rPlus1Nodes(rPlus1Id);
					C_ic(jCells,rNodesOfCellJ) = ArrayOperations::multiply(0.5, perp(ArrayOperations::minus(X_n0(rPlus1Nodes), X_n0(rMinus1Nodes))));
				}
			}
		});
	}
	
	/**
	 * Job IniUn @-3.0
	 * In variables: 
	 * Out variables: uj
	 */
	KOKKOS_INLINE_FUNCTION
	void iniUn() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			uj(jCells)[0] = 0.0;
			uj(jCells)[1] = 0.0;
		});
	}
	
	/**
	 * Job IniIc @-2.0
	 * In variables: center, option_x_interface, option_rho_ini_zg, option_p_ini_zg, option_rho_ini_zd, option_p_ini_zd
	 * Out variables: rho_ic, p_ic
	 */
	KOKKOS_INLINE_FUNCTION
	void iniIc() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			if (center(jCells)[0] < options->option_x_interface) 
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
	void iniVIc() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			double reduction_1455110305 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					reduction_1455110305 = reduction_1455110305 + (MathFunctions::dot(C_ic(jCells,rNodesOfCellJ), X_n0(rNodes)));
				}
			}
			V_ic(jCells) = 0.5 * reduction_1455110305;
		});
	}
	
	/**
	 * Job IniM @-1.0
	 * In variables: rho_ic, V_ic
	 * Out variables: m
	 */
	KOKKOS_INLINE_FUNCTION
	void iniM() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			m(jCells) = rho_ic(jCells) * V_ic(jCells);
		});
	}
	
	/**
	 * Job IniEn @-1.0
	 * In variables: p_ic, gamma, rho_ic
	 * Out variables: E
	 */
	KOKKOS_INLINE_FUNCTION
	void iniEn() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			E(jCells) = p_ic(jCells) / ((options->gamma - 1.0) * rho_ic(jCells));
		});
	}
	
	/**
	 * Job ComputeCjr @1.0
	 * In variables: X
	 * Out variables: C
	 */
	KOKKOS_INLINE_FUNCTION
	void computeCjr() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
					int rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					int rMinus1Nodes(rMinus1Id);
					int rPlus1Nodes(rPlus1Id);
					C(jCells,rNodesOfCellJ) = ArrayOperations::multiply(0.5, perp(ArrayOperations::minus(X(rPlus1Nodes), X(rMinus1Nodes))));
				}
			}
		});
	}
	
	/**
	 * Job ComputeInternalEnergy @1.0
	 * In variables: E, uj
	 * Out variables: e
	 */
	KOKKOS_INLINE_FUNCTION
	void computeInternalEnergy() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
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
	void computeLjr() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					l(jCells,rNodesOfCellJ) = MathFunctions::norm(C(jCells,rNodesOfCellJ));
				}
			}
		});
	}
	
	/**
	 * Job ComputeV @2.0
	 * In variables: C, X
	 * Out variables: V
	 */
	KOKKOS_INLINE_FUNCTION
	void computeV() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			double reduction_443215113 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					reduction_443215113 = reduction_443215113 + (MathFunctions::dot(C(jCells,rNodesOfCellJ), X(rNodes)));
				}
			}
			V(jCells) = 0.5 * reduction_443215113;
		});
	}
	
	/**
	 * Job ComputeDensity @3.0
	 * In variables: m, V
	 * Out variables: rho
	 */
	KOKKOS_INLINE_FUNCTION
	void computeDensity() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			rho(jCells) = m(jCells) / V(jCells);
		});
	}
	
	/**
	 * Job ComputeEOSp @4.0
	 * In variables: gamma, rho, e
	 * Out variables: p
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEOSp() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			p(jCells) = (options->gamma - 1.0) * rho(jCells) * e(jCells);
		});
	}
	
	/**
	 * Job dumpVariables @4.0
	 * In variables: rho
	 * Out variables: 
	 */
	KOKKOS_INLINE_FUNCTION
	void dumpVariables() noexcept
	{
		if (!writer.isDisabled() && (iteration % 1 == 0)) 
		{
			std::map<string, double*> cellVariables;
			std::map<string, double*> nodeVariables;
			cellVariables.insert(pair<string,double*>("Density", rho.data()));
			auto quads = mesh->getGeometricMesh()->getQuads();
			writer.writeFile(iteration, t, nbNodes, X.data(), nbCells, quads.data(), cellVariables, nodeVariables);
		}
	}
	
	/**
	 * Job ComputeEOSc @5.0
	 * In variables: gamma, p, rho
	 * Out variables: c
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEOSc() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			c(jCells) = MathFunctions::sqrt(options->gamma * p(jCells) / rho(jCells));
		});
	}
	
	/**
	 * Job Computedeltatj @6.0
	 * In variables: l, V, c
	 * Out variables: deltatj
	 */
	KOKKOS_INLINE_FUNCTION
	void computedeltatj() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			double reduction_1941980426 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					reduction_1941980426 = reduction_1941980426 + (l(jCells,rNodesOfCellJ));
				}
			}
			deltatj(jCells) = 2.0 * V(jCells) / (c(jCells) * reduction_1941980426);
		});
	}
	
	/**
	 * Job ComputeAjr @6.0
	 * In variables: rho, c, l, C
	 * Out variables: Ajr
	 */
	KOKKOS_INLINE_FUNCTION
	void computeAjr() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					Ajr(jCells,rNodesOfCellJ) = ArrayOperations::multiply(((rho(jCells) * c(jCells)) / l(jCells,rNodesOfCellJ)), tensProduct(C(jCells,rNodesOfCellJ), C(jCells,rNodesOfCellJ)));
				}
			}
		});
	}
	
	/**
	 * Job ComputeAr @7.0
	 * In variables: Ajr
	 * Out variables: Ar
	 */
	KOKKOS_INLINE_FUNCTION
	void computeAr() noexcept
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
		{
			int rId(rNodes);
			RealArray2D<2,2> reduction_646088144 = {{{0.0, 0.0}, {0.0, 0.0}}};
			{
				auto cellsOfNodeR(mesh->getCellsOfNode(rId));
				for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
				{
					int jId(cellsOfNodeR[jCellsOfNodeR]);
					int jCells(jId);
					int rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId),rId));
					reduction_646088144 = ArrayOperations::plus(reduction_646088144, (Ajr(jCells,rNodesOfCellJ)));
				}
			}
			Ar(rNodes) = reduction_646088144;
		});
	}
	
	/**
	 * Job ComputeBr @7.0
	 * In variables: p, C, Ajr, uj
	 * Out variables: b
	 */
	KOKKOS_INLINE_FUNCTION
	void computeBr() noexcept
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
		{
			int rId(rNodes);
			RealArray1D<2> reduction265492794 = {{0.0, 0.0}};
			{
				auto cellsOfNodeR(mesh->getCellsOfNode(rId));
				for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
				{
					int jId(cellsOfNodeR[jCellsOfNodeR]);
					int jCells(jId);
					int rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId),rId));
					reduction265492794 = ArrayOperations::plus(reduction265492794, (ArrayOperations::plus(ArrayOperations::multiply(p(jCells), C(jCells,rNodesOfCellJ)), MathFunctions::matVectProduct(Ajr(jCells,rNodesOfCellJ), uj(jCells)))));
				}
			}
			b(rNodes) = reduction265492794;
		});
	}
	
	/**
	 * Job ComputeDt @7.0
	 * In variables: deltatj, option_deltat_cfl
	 * Out variables: deltat_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeDt() noexcept
	{
		double reduction_1441609733(numeric_limits<double>::max());
		{
			Kokkos::Min<double> reducer(reduction_1441609733);
			Kokkos::parallel_reduce("Reductionreduction_1441609733", nbCells, KOKKOS_LAMBDA(const int& jCells, double& x)
			{
				reducer.join(x, deltatj(jCells));
			}, reducer);
		}
		deltat_nplus1 = options->option_deltat_cfl * reduction_1441609733;
	}
	
	/**
	 * Job Copy_deltat_nplus1_to_deltat @8.0
	 * In variables: deltat_nplus1
	 * Out variables: deltat
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_deltat_nplus1_to_deltat() noexcept
	{
		std::swap(deltat_nplus1, deltat);
	}
	
	/**
	 * Job ComputeMt @8.0
	 * In variables: Ar
	 * Out variables: Mt
	 */
	KOKKOS_INLINE_FUNCTION
	void computeMt() noexcept
	{
		auto innerNodes(mesh->getInnerNodes());
		Kokkos::parallel_for(nbInnerNodes, KOKKOS_LAMBDA(const int& rInnerNodes)
		{
			int rId(innerNodes[rInnerNodes]);
			int rNodes(rId);
			Mt(rNodes) = Ar(rNodes);
		});
	}
	
	/**
	 * Job ComputeBt @8.0
	 * In variables: b
	 * Out variables: bt
	 */
	KOKKOS_INLINE_FUNCTION
	void computeBt() noexcept
	{
		auto innerNodes(mesh->getInnerNodes());
		Kokkos::parallel_for(nbInnerNodes, KOKKOS_LAMBDA(const int& rInnerNodes)
		{
			int rId(innerNodes[rInnerNodes]);
			int rNodes(rId);
			bt(rNodes) = b(rNodes);
		});
	}
	
	/**
	 * Job OuterFacesComputations @8.0
	 * In variables: X_EDGE_ELEMS, X_EDGE_LENGTH, Y_EDGE_ELEMS, Y_EDGE_LENGTH, X, b, Ar
	 * Out variables: bt, Mt
	 */
	KOKKOS_INLINE_FUNCTION
	void outerFacesComputations() noexcept
	{
		auto outerFaces(mesh->getOuterFaces());
		Kokkos::parallel_for(nbOuterFaces, KOKKOS_LAMBDA(const int& kOuterFaces)
		{
			int kId(outerFaces[kOuterFaces]);
			const double epsilon = 1.0E-10;
			RealArray2D<2,2> I = {{{{1.0, 0.0}}, {{0.0, 1.0}}}};
			double X_MIN = 0.0;
			double X_MAX = options->X_EDGE_ELEMS * options->X_EDGE_LENGTH;
			double Y_MIN = 0.0;
			double Y_MAX = options->Y_EDGE_ELEMS * options->Y_EDGE_LENGTH;
			RealArray1D<2> nY = {{0.0, 1.0}};
			{
				auto nodesOfFaceK(mesh->getNodesOfFace(kId));
				for (int rNodesOfFaceK=0; rNodesOfFaceK<nodesOfFaceK.size(); rNodesOfFaceK++)
				{
					int rId(nodesOfFaceK[rNodesOfFaceK]);
					int rNodes(rId);
					if ((X(rNodes)[1] - Y_MIN < epsilon) || (X(rNodes)[1] - Y_MAX < epsilon)) 
					{
						double sign = 0.0;
						if (X(rNodes)[1] - Y_MIN < epsilon) 
							sign = -1.0;
						else 
							sign = 1.0;
						RealArray1D<2> n = ArrayOperations::multiply(sign, nY);
						RealArray2D<2,2> nxn = tensProduct(n, n);
						RealArray2D<2,2> IcP = ArrayOperations::minus(I, nxn);
						bt(rNodes) = MathFunctions::matVectProduct(IcP, b(rNodes));
						Mt(rNodes) = ArrayOperations::plus(ArrayOperations::multiply(IcP, (ArrayOperations::multiply(Ar(rNodes), IcP))), ArrayOperations::multiply(nxn, trace(Ar(rNodes))));
					}
					if ((MathFunctions::fabs(X(rNodes)[0] - X_MIN) < epsilon) || ((MathFunctions::fabs(X(rNodes)[0] - X_MAX) < epsilon))) 
					{
						Mt(rNodes) = I;
						bt(rNodes)[0] = 0.0;
						bt(rNodes)[1] = 0.0;
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
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept
	{
		t_nplus1 = t + deltat_nplus1;
	}
	
	/**
	 * Job Copy_t_nplus1_to_t @9.0
	 * In variables: t_nplus1
	 * Out variables: t
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_t_nplus1_to_t() noexcept
	{
		std::swap(t_nplus1, t);
	}
	
	/**
	 * Job ComputeU @9.0
	 * In variables: Mt, bt
	 * Out variables: ur
	 */
	KOKKOS_INLINE_FUNCTION
	void computeU() noexcept
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
		{
			ur(rNodes) = MathFunctions::matVectProduct(inverse(Mt(rNodes)), bt(rNodes));
		});
	}
	
	/**
	 * Job ComputeFjr @10.0
	 * In variables: p, C, Ajr, uj, ur
	 * Out variables: F
	 */
	KOKKOS_INLINE_FUNCTION
	void computeFjr() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					F(jCells,rNodesOfCellJ) = ArrayOperations::plus(ArrayOperations::multiply(p(jCells), C(jCells,rNodesOfCellJ)), MathFunctions::matVectProduct(Ajr(jCells,rNodesOfCellJ), (ArrayOperations::minus(uj(jCells), ur(rNodes)))));
				}
			}
		});
	}
	
	/**
	 * Job ComputeXn @10.0
	 * In variables: X, deltat, ur
	 * Out variables: X_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeXn() noexcept
	{
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
		{
			X_nplus1(rNodes) = ArrayOperations::plus(X(rNodes), ArrayOperations::multiply(deltat, ur(rNodes)));
		});
	}
	
	/**
	 * Job Copy_X_nplus1_to_X @11.0
	 * In variables: X_nplus1
	 * Out variables: X
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_X_nplus1_to_X() noexcept
	{
		std::swap(X_nplus1, X);
	}
	
	/**
	 * Job ComputeUn @11.0
	 * In variables: F, uj, deltat, m
	 * Out variables: uj_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeUn() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			RealArray1D<2> reduction_1949909430 = {{0.0, 0.0}};
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					reduction_1949909430 = ArrayOperations::plus(reduction_1949909430, (F(jCells,rNodesOfCellJ)));
				}
			}
			uj_nplus1(jCells) = ArrayOperations::minus(uj(jCells), ArrayOperations::multiply((deltat / m(jCells)), reduction_1949909430));
		});
	}
	
	/**
	 * Job ComputeEn @11.0
	 * In variables: F, ur, E, deltat, m
	 * Out variables: E_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEn() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			double reduction_119635181 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					reduction_119635181 = reduction_119635181 + (MathFunctions::dot(F(jCells,rNodesOfCellJ), ur(rNodes)));
				}
			}
			E_nplus1(jCells) = E(jCells) - (deltat / m(jCells)) * reduction_119635181;
		});
	}
	
	/**
	 * Job Copy_uj_nplus1_to_uj @12.0
	 * In variables: uj_nplus1
	 * Out variables: uj
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_uj_nplus1_to_uj() noexcept
	{
		std::swap(uj_nplus1, uj);
	}
	
	/**
	 * Job Copy_E_nplus1_to_E @12.0
	 * In variables: E_nplus1
	 * Out variables: E
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_E_nplus1_to_E() noexcept
	{
		std::swap(E_nplus1, E);
	}

	KOKKOS_INLINE_FUNCTION
	RealArray1D<2> perp(RealArray1D<2> a) 
	{
		return {{a[1], -a[0]}};
	}

	template<size_t x>
	KOKKOS_INLINE_FUNCTION
	RealArray2D<x,x> tensProduct(RealArray1D<x> a, RealArray1D<x> b) 
	{
		RealArray2D<x,x> result;
		for (size_t ia=0; ia<x; ia++)
			for (size_t ib=0; ib<x; ib++)
				result[ia][ib] = a[ia] * b[ib];
		return result;
	}

	template<size_t x>
	KOKKOS_INLINE_FUNCTION
	double trace(RealArray2D<x,x> a) 
	{
		double result = 0.0;
		for (size_t ia=0; ia<x; ia++)
			result = result + a[ia][ia];
		return result;
	}

	KOKKOS_INLINE_FUNCTION
	RealArray2D<2,2> inverse(RealArray2D<2,2> a) 
	{
		double alpha = 1.0 / MathFunctions::det(a);
		return {{{{a[1][1] * alpha, -a[0][1] * alpha}}, {{-a[1][0] * alpha, a[0][0] * alpha}}}};
	}

public:
	void simulate()
	{
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Glace2d ..." << __RESET__ << "\n\n";

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

		copy_X_n0_to_X(); // @-3.0
		iniCenter(); // @-3.0
		computeCjrIc(); // @-3.0
		iniUn(); // @-3.0
		iniIc(); // @-2.0
		iniVIc(); // @-2.0
		iniM(); // @-1.0
		iniEn(); // @-1.0
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
	auto o = new Glace2d::Options();
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
	auto c = new Glace2d(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete gm;
	delete o;
	Kokkos::finalize();
	return 0;
}
