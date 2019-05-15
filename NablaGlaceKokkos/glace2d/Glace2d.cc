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
#include "utils/Utils.h"
#include "utils/Timer.h"
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
	Options* options;

private:
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
	
	typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;
	const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();

public:
	Glace2d(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("Glace2d", output)
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, nbCellsOfNode(NumericMesh2D::MaxNbCellsOfNode)
	, nbInnerNodes(mesh->getNbInnerNodes())
	, nbOuterFaces(mesh->getNbOuterFaces())
	, nbNodesOfFace(NumericMesh2D::MaxNbNodesOfFace)
	, t(0.0)
	, deltat(as_const(options->option_deltat_ini))
	, deltat_nplus1(as_const(options->option_deltat_ini))
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
	 * Utility function to get work load for each team of threads
	 * In  : thread and number of element to use for computation
	 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
	 */
	const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const int& nb_elmt) noexcept {
		/*
		if (nb_elmt % thread.team_size()) {
		std::cerr << "[ERROR] nb of elmt (" << nb_elmt << ") not multiple of nb of thread per team ("
	              << thread.team_size() << ")" << std::endl;
		std::terminate();
		}
		*/
		// Size
		size_t team_chunk(std::floor(nb_elmt / thread.league_size()));
		// Offset
		const size_t team_offset(thread.league_rank() * team_chunk);
		// Last team get remaining work
		if (thread.league_rank() == thread.league_size() - 1) {
			size_t left_over(nb_elmt - (team_chunk * thread.league_size()));
			team_chunk += left_over;
		}
		return std::pair<size_t, size_t>(team_offset, team_chunk);
	}

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
	void iniCenter(const member_type& team_member) noexcept
	{
		const Kokkos::View<Real2*> const_X_n0 = X_n0;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			Real2 sum25050050 = Real2(0.0, 0.0);
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId(nodesOfCellJ[rNodesOfCellJ]);
				int rNodes(rId);
				sum25050050 = sum25050050 + (const_X_n0(rNodes));
			}
			center(jCells) = 0.25 * sum25050050;
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
		const Kokkos::View<Real2*> const_X_n0 = X_n0;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
				int rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
				int rMinus1Nodes(rMinus1Id);
				int rPlus1Nodes(rPlus1Id);
				C_ic(jCells,rNodesOfCellJ) = 0.5 * Glace2dFunctions::perp(const_X_n0(rPlus1Nodes) - const_X_n0(rMinus1Nodes));
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
			int jCells(jCellsTeam + team_work.first);
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
		const Kokkos::View<Real2*> const_center = center;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			if (const_center(jCells).x < as_const(options->option_x_interface)) 
			{
				rho_ic(jCells) = as_const(options->option_rho_ini_zg);
				p_ic(jCells) = as_const(options->option_p_ini_zg);
			}
			else 
			{
				rho_ic(jCells) = as_const(options->option_rho_ini_zd);
				p_ic(jCells) = as_const(options->option_p_ini_zd);
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
		const Kokkos::View<Real2**> const_C_ic = C_ic;
		const Kokkos::View<Real2*> const_X_n0 = X_n0;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			double sum_194658110 = 0.0;
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId(nodesOfCellJ[rNodesOfCellJ]);
				int rNodes(rId);
				sum_194658110 = sum_194658110 + (MathFunctions::dot(const_C_ic(jCells,rNodesOfCellJ), const_X_n0(rNodes)));
			}
			V_ic(jCells) = 0.5 * sum_194658110;
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
		const Kokkos::View<double*> const_rho_ic = rho_ic;
		const Kokkos::View<double*> const_V_ic = V_ic;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			m(jCells) = const_rho_ic(jCells) * const_V_ic(jCells);
		});
	}
	
	/**
	 * Job IniEn @-1.0
	 * In variables: p_ic, rho_ic, gammma
	 * Out variables: E
	 */
	KOKKOS_INLINE_FUNCTION
	void iniEn(const member_type& team_member) noexcept
	{
		const Kokkos::View<double*> const_p_ic = p_ic;
		const Kokkos::View<double*> const_rho_ic = rho_ic;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			E(jCells) = const_p_ic(jCells) / ((as_const(options->gammma) - 1.0) * const_rho_ic(jCells));
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
		const Kokkos::View<Real2*> const_X = X;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
				int rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
				int rMinus1Nodes(rMinus1Id);
				int rPlus1Nodes(rPlus1Id);
				C(jCells,rNodesOfCellJ) = 0.5 * Glace2dFunctions::perp(const_X(rPlus1Nodes) - const_X(rMinus1Nodes));
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
		const Kokkos::View<double*> const_E = E;
		const Kokkos::View<Real2*> const_uj = uj;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			e(jCells) = const_E(jCells) - 0.5 * MathFunctions::dot(const_uj(jCells), const_uj(jCells));
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
		const Kokkos::View<Real2**> const_C = C;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				l(jCells,rNodesOfCellJ) = MathFunctions::norm(const_C(jCells,rNodesOfCellJ));
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
		const Kokkos::View<Real2**> const_C = C;
		const Kokkos::View<Real2*> const_X = X;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			double sum_1499973774 = 0.0;
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId(nodesOfCellJ[rNodesOfCellJ]);
				int rNodes(rId);
				sum_1499973774 = sum_1499973774 + (MathFunctions::dot(const_C(jCells,rNodesOfCellJ), const_X(rNodes)));
			}
			V(jCells) = 0.5 * sum_1499973774;
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
		const Kokkos::View<double*> const_m = m;
		const Kokkos::View<double*> const_V = V;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			rho(jCells) = const_m(jCells) / const_V(jCells);
		});
	}
	
	/**
	 * Job ComputeEOSp @4.0
	 * In variables: rho, e, gammma
	 * Out variables: p
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEOSp(const member_type& team_member) noexcept
	{
		const Kokkos::View<double*> const_rho = rho;
		const Kokkos::View<double*> const_e = e;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			p(jCells) = (as_const(options->gammma) - 1.0) * const_rho(jCells) * const_e(jCells);
		});
	}
	
	/**
	 * Job ComputeEOSc @5.0
	 * In variables: p, rho, gammma
	 * Out variables: c
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEOSc(const member_type& team_member) noexcept
	{
		const Kokkos::View<double*> const_p = p;
		const Kokkos::View<double*> const_rho = rho;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			c(jCells) = MathFunctions::sqrt(as_const(options->gammma) * const_p(jCells) / const_rho(jCells));
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
		const Kokkos::View<double**> const_l = l;
		const Kokkos::View<double*> const_V = V;
		const Kokkos::View<double*> const_c = c;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			double sum_1996771990 = 0.0;
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				sum_1996771990 = sum_1996771990 + (const_l(jCells,rNodesOfCellJ));
			}
			deltatj(jCells) = 2.0 * const_V(jCells) / (const_c(jCells) * sum_1996771990);
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
		const Kokkos::View<double*> const_rho = rho;
		const Kokkos::View<double*> const_c = c;
		const Kokkos::View<double**> const_l = l;
		const Kokkos::View<Real2**> const_C = C;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				Ajr(jCells,rNodesOfCellJ) = ((const_rho(jCells) * const_c(jCells)) / const_l(jCells,rNodesOfCellJ)) * Glace2dFunctions::tensProduct(const_C(jCells,rNodesOfCellJ), const_C(jCells,rNodesOfCellJ));
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
		const Kokkos::View<Real2x2**> const_Ajr = Ajr;
		const auto team_work(computeTeamWorkRange(team_member, nbNodes));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rNodesTeam)
		{
			int rNodes(rNodesTeam + team_work.first);
			int rId(rNodes);
			Real2x2 sum2072109202 = Real2x2(Real2(0.0, 0.0), Real2(0.0, 0.0));
			auto cellsOfNodeR(mesh->getCellsOfNode(rId));
			for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
			{
				int jId(cellsOfNodeR[jCellsOfNodeR]);
				int jCells(jId);
				int rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId),rId));
				sum2072109202 = sum2072109202 + (const_Ajr(jCells,rNodesOfCellJ));
			}
			Ar(rNodes) = sum2072109202;
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
		const Kokkos::View<double*> const_p = p;
		const Kokkos::View<Real2**> const_C = C;
		const Kokkos::View<Real2x2**> const_Ajr = Ajr;
		const Kokkos::View<Real2*> const_uj = uj;
		const auto team_work(computeTeamWorkRange(team_member, nbNodes));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rNodesTeam)
		{
			int rNodes(rNodesTeam + team_work.first);
			int rId(rNodes);
			Real2 sum390423926 = Real2(0.0, 0.0);
			auto cellsOfNodeR(mesh->getCellsOfNode(rId));
			for (int jCellsOfNodeR=0; jCellsOfNodeR<cellsOfNodeR.size(); jCellsOfNodeR++)
			{
				int jId(cellsOfNodeR[jCellsOfNodeR]);
				int jCells(jId);
				int rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId),rId));
				sum390423926 = sum390423926 + (const_p(jCells) * const_C(jCells,rNodesOfCellJ) + Glace2dFunctions::matVectProduct(const_Ajr(jCells,rNodesOfCellJ), const_uj(jCells)));
			}
			b(rNodes) = sum390423926;
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
		const Kokkos::View<double*> const_deltatj = deltatj;
		{
			double reduceMin_857127761(numeric_limits<double>::max());
			Kokkos::Min<double> reducer(reduceMin_857127761);
			Kokkos::parallel_reduce(Kokkos::TeamThreadRange(team_member, nbCells), KOKKOS_LAMBDA(const int& jCells, double& x)
			{
				reducer.join(x, const_deltatj(jCells));
			}, reducer);
			deltat_nplus1 = as_const(options->option_deltat_cfl) * reduceMin_857127761;
		}
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
		const Kokkos::View<Real2x2*> const_Ar = Ar;
		const auto team_work(computeTeamWorkRange(team_member, nbInnerNodes));
		if (!team_work.second)
			return;
		
		auto innerNodes(mesh->getInnerNodes());
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rInnerNodesTeam)
		{
			int rInnerNodes(rInnerNodesTeam + team_work.first);
			int rId(innerNodes[rInnerNodes]);
			int rNodes(rId);
			Mt(rNodes) = const_Ar(rNodes);
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
		const Kokkos::View<Real2*> const_b = b;
		const auto team_work(computeTeamWorkRange(team_member, nbInnerNodes));
		if (!team_work.second)
			return;
		
		auto innerNodes(mesh->getInnerNodes());
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rInnerNodesTeam)
		{
			int rInnerNodes(rInnerNodesTeam + team_work.first);
			int rId(innerNodes[rInnerNodes]);
			int rNodes(rId);
			bt(rNodes) = const_b(rNodes);
		});
	}
	
	/**
	 * Job OuterFacesComputations @8.0
	 * In variables: X, b, Ar, X_EDGE_ELEMS, LENGTH, Y_EDGE_ELEMS
	 * Out variables: bt, Mt
	 */
	KOKKOS_INLINE_FUNCTION
	void outerFacesComputations(const member_type& team_member) noexcept
	{
		const Kokkos::View<Real2*> const_X = X;
		const Kokkos::View<Real2*> const_b = b;
		const Kokkos::View<Real2x2*> const_Ar = Ar;
		const auto team_work(computeTeamWorkRange(team_member, nbOuterFaces));
		if (!team_work.second)
			return;
		
		auto outerFaces(mesh->getOuterFaces());
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& kOuterFacesTeam)
		{
			int kOuterFaces(kOuterFacesTeam + team_work.first);
			int kId(outerFaces[kOuterFaces]);
			double epsilon = 1.0E-10;
			Real2x2 I = Real2x2(Real2(1.0, 0.0), Real2(0.0, 1.0));
			double X_MIN = 0.0;
			double X_MAX = as_const(options->X_EDGE_ELEMS) * as_const(options->LENGTH);
			double Y_MIN = 0.0;
			double Y_MAX = as_const(options->Y_EDGE_ELEMS) * as_const(options->LENGTH);
			Real2 nY = Real2(0.0, 1.0);
			auto nodesOfFaceK(mesh->getNodesOfFace(kId));
			for (int rNodesOfFaceK=0; rNodesOfFaceK<nodesOfFaceK.size(); rNodesOfFaceK++)
			{
				int rId(nodesOfFaceK[rNodesOfFaceK]);
				int rNodes(rId);
				if ((const_X(rNodes).y - Y_MIN < epsilon) || (const_X(rNodes).y - Y_MAX < epsilon)) 
				{
					double sign = 0.0;
					if (const_X(rNodes).y - Y_MIN < epsilon) 
						sign = -1.0;
					else 
						sign = 1.0;
					Real2 n = sign * nY;
					Real2x2 nxn = Glace2dFunctions::tensProduct(n, n);
					Real2x2 IcP = I - nxn;
					bt(rNodes) = Glace2dFunctions::matVectProduct(IcP, const_b(rNodes));
					Mt(rNodes) = IcP * (const_Ar(rNodes) * IcP) + nxn * Glace2dFunctions::trace(const_Ar(rNodes));
				}
				if ((MathFunctions::fabs(const_X(rNodes).x - X_MIN) < epsilon) || ((MathFunctions::fabs(const_X(rNodes).x - X_MAX) < epsilon))) 
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
		t_nplus1 = as_const(t) + as_const(deltat_nplus1);
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
		const Kokkos::View<Real2x2*> const_Mt = Mt;
		const Kokkos::View<Real2*> const_bt = bt;
		const auto team_work(computeTeamWorkRange(team_member, nbNodes));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rNodesTeam)
		{
			int rNodes(rNodesTeam + team_work.first);
			ur(rNodes) = Glace2dFunctions::matVectProduct(Glace2dFunctions::inverse(const_Mt(rNodes)), const_bt(rNodes));
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
		const Kokkos::View<double*> const_p = p;
		const Kokkos::View<Real2**> const_C = C;
		const Kokkos::View<Real2x2**> const_Ajr = Ajr;
		const Kokkos::View<Real2*> const_uj = uj;
		const Kokkos::View<Real2*> const_ur = ur;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId(nodesOfCellJ[rNodesOfCellJ]);
				int rNodes(rId);
				F(jCells,rNodesOfCellJ) = const_p(jCells) * const_C(jCells,rNodesOfCellJ) + Glace2dFunctions::matVectProduct(const_Ajr(jCells,rNodesOfCellJ), (const_uj(jCells) - const_ur(rNodes)));
			}
		});
	}
	
	/**
	 * Job ComputeXn @10.0
	 * In variables: X, ur, deltat
	 * Out variables: X_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeXn(const member_type& team_member) noexcept
	{
		const Kokkos::View<Real2*> const_X = X;
		const Kokkos::View<Real2*> const_ur = ur;
		const auto team_work(computeTeamWorkRange(team_member, nbNodes));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rNodesTeam)
		{
			int rNodes(rNodesTeam + team_work.first);
			X_nplus1(rNodes) = const_X(rNodes) + as_const(deltat) * const_ur(rNodes);
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
	 * In variables: F, uj, m, deltat
	 * Out variables: uj_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeUn(const member_type& team_member) noexcept
	{
		const Kokkos::View<Real2**> const_F = F;
		const Kokkos::View<Real2*> const_uj = uj;
		const Kokkos::View<double*> const_m = m;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			Real2 sum_2005118310 = Real2(0.0, 0.0);
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				sum_2005118310 = sum_2005118310 + (const_F(jCells,rNodesOfCellJ));
			}
			uj_nplus1(jCells) = const_uj(jCells) - (as_const(deltat) / const_m(jCells)) * sum_2005118310;
		});
	}
	
	/**
	 * Job ComputeEn @11.0
	 * In variables: F, ur, E, m, deltat
	 * Out variables: E_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEn(const member_type& team_member) noexcept
	{
		const Kokkos::View<Real2**> const_F = F;
		const Kokkos::View<Real2*> const_ur = ur;
		const Kokkos::View<double*> const_E = E;
		const Kokkos::View<double*> const_m = m;
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			double sum_255159678 = 0.0;
			auto nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
			{
				int rId(nodesOfCellJ[rNodesOfCellJ]);
				int rNodes(rId);
				sum_255159678 = sum_255159678 + (MathFunctions::dot(const_F(jCells,rNodesOfCellJ), const_ur(rNodes)));
			}
			E_nplus1(jCells) = const_E(jCells) - (as_const(deltat) / const_m(jCells)) * sum_255159678;
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
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Glace2d ..." << __RESET__ << "\n\n";

		std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options->X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options->Y_EDGE_ELEMS
			<< __RESET__ << ", length=" << __BOLD__ << options->LENGTH << __RESET__ << std::endl;


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

		auto team_policy(Kokkos::TeamPolicy<>(
			Kokkos::hwloc::get_available_numa_count(),
			Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));

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
		
		timer.stop();
		int iteration = 0;
		while (t < options->option_stoptime && iteration < options->option_max_iterations)
		{
			timer.start();
			utils::Timer compute_timer(true);
			iteration++;
			if (iteration!=1)
				std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << iteration << __RESET__ "] t = " << __BOLD__
					<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t << __RESET__;

			// @1.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				if (iteration==1 && thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){
						std::cout << "[" << __GREEN__ << "RUNTIME" << __RESET__ << "]   Using " << __BOLD__ << setw(3) << thread.league_size() << __RESET__ << " team(s) of "
							<< __BOLD__ << setw(3) << thread.team_size() << __RESET__<< " thread(s)" << std::endl;
						std::cout << __YELLOW__ << "\tInit done, starting compute loop..." << __RESET__ << std::endl;
						std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << iteration << __RESET__ "] t = " << __BOLD__
							<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t << __RESET__;});
				computeCjr(thread);
				computeInternalEngergy(thread);
			});
			
			// @2.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computeLjr(thread);
				computeV(thread);
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
			
			// @6.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computedeltatj(thread);
				computeAjr(thread);
			});
			
			// @7.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computeAr(thread);
				computeBr(thread);
				if (thread.league_rank() == 0)
					computeDt(thread);
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
			
			// @10.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				computeFjr(thread);
				computeXn(thread);
			});
			
			// @11.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
				if (thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){copy_X_nplus1_to_X();});
				computeUn(thread);
				computeEn(thread);
			});
			
			// @12.0
			copy_uj_nplus1_to_uj();
			copy_E_nplus1_to_E();
			
			compute_timer.stop();

			if (!writer.isDisabled()) {
				utils::Timer io_timer(true);
				auto quads = mesh->getGeometricMesh()->getQuads();
				writer.writeFile(iteration, X, quads, cellVariables, nodeVariables);
				io_timer.stop();
				std::cout << " {CPU: " << __BLUE__ << compute_timer.print(true) << __RESET__ ", IO: " << __BLUE__ << io_timer.print(true) << __RESET__ "} ";
			} else {
				std::cout << " {CPU: " << __BLUE__ << compute_timer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";
			}
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
	if (argc == 4) {
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->LENGTH = std::atof(argv[3]);
	} else if (argc == 5) {
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->LENGTH = std::atof(argv[3]);
		output = argv[4];
	} else if (argc != 1) {
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 3 or 4 args: X Y length (output)." << std::endl;
		std::cerr << "(X=100, Y=10, length=0.01 output=current directory with no args)" << std::endl;
	}
	auto gm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->LENGTH, o->LENGTH);
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
