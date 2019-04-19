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
	
	// alias
	typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

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
	// TODO : importer la version
	const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const int& nb_elmt) noexcept
	{
		return std::pair<size_t, size_t>(0, 0);
	}
	
	/**
	 * Job Copy_X_n0_to_X @-3.0
	 * In variables: X_n0
	 * Out variables: X
	 */
	KOKKOS_INLINE_FUNCTION
	void copy_X_n0_to_X() noexcept
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
	void iniCenter(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			Real2 sum1917886962 = Real2(0.0, 0.0);
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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
	void computeCjrIc(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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
	void iniUn(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			uj(jCells) = Real2(0.0, 0.0);
		});
	}
	
	/**
	 * Job IniIc @-2.0
	 * In variables: center, option_x_interface, option_rho_ini_zg, option_p_ini_zg, option_rho_ini_zd, option_p_ini_zd
	 * Out variables: rho_ic, p_ic
	 */
	KOKKOS_INLINE_FUNCTION
	void iniIc(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
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
	void iniVIc(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			double sum_487317398 = 0.0;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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
	void iniM(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			m(jCells) = rho_ic(jCells) * V_ic(jCells);
		});
	}
	
	/**
	 * Job IniEn @-1.0
	 * In variables: p_ic, gammma, rho_ic
	 * Out variables: E
	 */
	KOKKOS_INLINE_FUNCTION
	void iniEn(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			E(jCells) = p_ic(jCells) / ((options->gammma - 1.0) * rho_ic(jCells));
		});
	}
	
	/**
	 * Job ComputeCjr @1.0
	 * In variables: X
	 * Out variables: C
	 */
	KOKKOS_INLINE_FUNCTION
	void computeCjr(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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
	void computeInternalEngergy(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			e(jCells) = E(jCells) - 0.5 * MathFunctions::dot(uj(jCells), uj(jCells));
		});
	}
	
	/**
	 * Job ComputeLjr @2.0
	 * In variables: C
	 * Out variables: l
	 */
	KOKKOS_INLINE_FUNCTION
	void computeLjr(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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
	void computeV(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			double sum_1792633062 = 0.0;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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
	void computeDensity(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			rho(jCells) = m(jCells) / V(jCells);
		});
	}
	
	/**
	 * Job ComputeEOSp @4.0
	 * In variables: gammma, rho, e
	 * Out variables: p
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEOSp(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			p(jCells) = (options->gammma - 1.0) * rho(jCells) * e(jCells);
		});
	}
	
	/**
	 * Job ComputeEOSc @5.0
	 * In variables: gammma, p, rho
	 * Out variables: c
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEOSc(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			c(jCells) = MathFunctions::sqrt(options->gammma * p(jCells) / rho(jCells));
		});
	}
	
	/**
	 * Job Computedeltatj @6.0
	 * In variables: l, V, c
	 * Out variables: deltatj
	 */
	KOKKOS_INLINE_FUNCTION
	void computedeltatj(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			double sum1029918418 = 0.0;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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
	void computeAjr(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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
	void computeAr(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rNodesTeam)
		{
			int rNodes = rNodesTeam + team_work.first;
			int rId = rNodes;
			Real2x2 sum_1190060678 = Real2x2(Real2(0.0, 0.0), Real2(0.0, 0.0));
			const auto& cellsOfNodeR(mesh->getCellsOfNode(rId));
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
	void computeBr(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rNodesTeam)
		{
			int rNodes = rNodesTeam + team_work.first;
			int rId = rNodes;
			Real2 sum942617414 = Real2(0.0, 0.0);
			const auto& cellsOfNodeR(mesh->getCellsOfNode(rId));
			for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
			{
				int jId = cellsOfNodeR[jCellsOfNodeR];
				int jCells = jId;
				auto nodesOfCellJ = mesh->getNodesOfCell(jId);
				int rNodesOfCellJ = Utils::indexOf(nodesOfCellJ,rId);
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
	void computeDt(const member_type& team_member) noexcept
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
	void computeMt(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		const auto& innerNodes(mesh->getInnerNodes());
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rInnerNodesTeam)
		{
			int rInnerNodes = rInnerNodesTeam + team_work.first;
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
	void computeBt(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		const auto& innerNodes(mesh->getInnerNodes());
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rInnerNodesTeam)
		{
			int rInnerNodes = rInnerNodesTeam + team_work.first;
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
	void outerFacesComputations(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		const auto& outerFaces(mesh->getOuterFaces());
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& kOuterFacesTeam)
		{
			int kOuterFaces = kOuterFacesTeam + team_work.first;
			int kId = outerFaces[kOuterFaces];
			double epsilon = 1.0E-10;
			Real2x2 I = Real2x2(Real2(1.0, 0.0), Real2(0.0, 1.0));
			double X_MIN = 0.0;
			double X_MAX = options->X_EDGE_ELEMS * options->LENGTH;
			double Y_MIN = 0.0;
			double Y_MAX = options->Y_EDGE_ELEMS * options->LENGTH;
			Real2 nY = Real2(0.0, 1.0);
			const auto& nodesOfFaceK(mesh->getNodesOfFace(kId));
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
	void computeU(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rNodesTeam)
		{
			int rNodes = rNodesTeam + team_work.first;
			ur(rNodes) = Glace2dFunctions::matVectProduct(Glace2dFunctions::inverse(Mt(rNodes)), bt(rNodes));
		});
	}
	
	/**
	 * Job ComputeFjr @10.0
	 * In variables: p, C, Ajr, uj, ur
	 * Out variables: F
	 */
	KOKKOS_INLINE_FUNCTION
	void computeFjr(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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
	void computeXn(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rNodesTeam)
		{
			int rNodes = rNodesTeam + team_work.first;
			X_nplus1(rNodes) = X(rNodes) + deltat * ur(rNodes);
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
	void computeUn(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			Real2 sum1021572098 = Real2(0.0, 0.0);
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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
	void computeEn(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells = jCellsTeam + team_work.first;
			int jId = jCells;
			double sum_547818966 = 0.0;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
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

public:
	void simulate()
	{
		auto team_policy(Kokkos::TeamPolicy<>(
			Kokkos::hwloc::get_available_numa_count(),
			Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));
		
		std::cout << "Début de l'exécution du module Glace2d" << std::endl;
		// @-3.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
			if (thread.league_rank() == 0)
				Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){copy_X_n0_to_X();});
			iniCenter(thread);
			computeCjrIc(thread);
			iniUn(thread);
		});
		// @-2.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
			iniIc(thread);
			iniVIc(thread);
		});
		// @-1.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
			iniM(thread);
			iniEn(thread);
		});

		map<string, Kokkos::View<double*>> cellVariables;
		map<string, Kokkos::View<double*>> nodeVariables;
		cellVariables.insert(pair<string,Kokkos::View<double*>>("Density", rho));
		int iteration = 0;
		while (t < options->option_stoptime && iteration < options->option_max_iterations)
		{
			iteration++;
			std::cout << "[" << iteration << "] t = " << t << std::endl;
			// @11.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				if (thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){copy_X_nplus1_to_X();});
				computeUn(thread);
				computeEn(thread);
			});
			// @12.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				if (thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){copy_uj_nplus1_to_uj();});
				if (thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){copy_E_nplus1_to_E();});
			});
			// @8.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				if (thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){copy_deltat_nplus1_to_deltat();});
				computeMt(thread);
				computeBt(thread);
				outerFacesComputations(thread);
				if (thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){computeTn();});
			});
			// @9.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				if (thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){copy_t_nplus1_to_t();});
				computeU(thread);
			});
			// @1.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computeCjr(thread);
				computeInternalEngergy(thread);
			});
			// @2.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computeLjr(thread);
				computeV(thread);
			});
			// @6.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computedeltatj(thread);
				computeAjr(thread);
			});
			// @3.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computeDensity(thread);
			});
			// @4.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computeEOSp(thread);
			});
			// @5.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computeEOSc(thread);
			});
			// @10.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computeFjr(thread);
				computeXn(thread);
			});
			// @7.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computeAr(thread);
				computeBr(thread);
				if (thread.league_rank() == 0)
					computeDt(thread);
			});
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
