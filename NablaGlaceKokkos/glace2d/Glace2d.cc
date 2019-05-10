#include <iostream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cassert>
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
		const auto& gNodes(mesh->getGeometricMesh()->getNodes());
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
		{
			coord(rNodes) = gNodes[rNodes];
		});
	}

private:
	/**
	 * Utility function to get work load for each team of threads
	 * In : thread and number of element to use for computation
	 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
	 */
	const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const int& nb_elmt) noexcept {
//	  if (nb_elmt % thread.team_size()) {
//	    std::cerr << "[ERROR] nb of elmt (" << nb_elmt << ") not multiple of nb of thread per team ("
//	              << thread.team_size() << ")" << std::endl;
//	    std::terminate();
//	  }
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
	 * Job IniCenter @-3.0
	 * In variables: coord
	 * Out variables: center
	 */
	void iniCenter() noexcept
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId = jCells;
			Real2 sum760426371 = Real2(0.0, 0.0);
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ < nodesOfCellJ.size(); ++rNodesOfCellJ)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum760426371 = sum760426371 + (coord(rNodes));
			}
			center(jCells) = 0.25 * sum760426371;
		});
	}

	/**
	 * Job ComputeCjrIc @-3.0
	 * In variables: coord
	 * Out variables: C_ic
	 */
	void computeCjrIc()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId = jCells;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ < nodesOfCellJ.size(); ++rNodesOfCellJ)
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
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& r0Nodes)
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
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& j0Cells)
		{
			uj(j0Cells) = move(Real2(0.0, 0.0));
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
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
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
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId = jCells;
			double sum1969725503 = 0.0;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ < nodesOfCellJ.size(); ++rNodesOfCellJ)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum1969725503 = sum1969725503 + (MathFunctions::dot(C_ic(jCells,rNodesOfCellJ), coord(rNodes)));
			}
			V_ic(jCells) = 0.5 * sum1969725503;
		});
	}

	/**
	 * Job IniM @-1.0
	 * In variables: rho_ic, V_ic
	 * Out variables: m
	 */
	void iniM()
	{
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& jCells)
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
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const int& j0Cells)
		{
			E(j0Cells) = p_ic(j0Cells) / ((options->gammma - 1.0) * rho_ic(j0Cells));
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

	  const Kokkos::View<const Real2*> const_X = X;

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
		  int jCells = jTeamCells + team_work.first;
			int jId = jCells;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ < nodesOfCellJ.size(); ++rNodesOfCellJ)
			{
				int prevRNodesOfCellJ = (rNodesOfCellJ-1+nodesOfCellJ.size())%nodesOfCellJ.size();
				int nextRNodesOfCellJ = (rNodesOfCellJ+1+nodesOfCellJ.size())%nodesOfCellJ.size();
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int prevRId = nodesOfCellJ[prevRNodesOfCellJ];
				int nextRId = nodesOfCellJ[nextRNodesOfCellJ];
				int rNodes = rId;
				int prevRNodes = prevRId;
				int nextRNodes = nextRId;
				C(jCells,rNodesOfCellJ) = 0.5 * Glace2dFunctions::perp(const_X(nextRNodes) - const_X(prevRNodes));
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

    const Kokkos::View<const double*> const_E = E;
    const Kokkos::View<const Real2*> const_uj = uj;

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
      int jCells = jTeamCells + team_work.first;
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
	  const auto team_work(computeTeamWorkRange(team_member, nbCells));
    if (!team_work.second)
      return;

    const Kokkos::View<const Real2**> const_C = C;

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
      int jCells = jTeamCells + team_work.first;
      int jId = jCells;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ < nodesOfCellJ.size(); ++rNodesOfCellJ)
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
	  const auto team_work(computeTeamWorkRange(team_member, nbCells));
    if (!team_work.second)
      return;

    const Kokkos::View<const Real2**> const_C = C;
    const Kokkos::View<const Real2*> const_X = X;

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
      int jCells = jTeamCells + team_work.first;
      int jId = jCells;
			double sum1469640796 = 0.0;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ < nodesOfCellJ.size(); ++rNodesOfCellJ)
			{
				int rId = nodesOfCellJ[rNodesOfCellJ];
				int rNodes = rId;
				sum1469640796 = sum1469640796 + (MathFunctions::dot(const_C(jCells,rNodesOfCellJ), const_X(rNodes)));
			}
			V(jCells) = 0.5 * sum1469640796;
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

    const Kokkos::View<const double*> const_m = m;
    const Kokkos::View<const double*> const_V = V;

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
      int jCells = jTeamCells + team_work.first;
			rho(jCells) = const_m(jCells) / const_V(jCells);
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

    const Kokkos::View<const double*> const_rho = rho;
    const Kokkos::View<const double*> const_e = e;
    const double gamma_minus_1(options->gammma - 1.0);

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
      int jCells = jTeamCells + team_work.first;
			p(jCells) = gamma_minus_1 * const_rho(jCells) * const_e(jCells);
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

    const Kokkos::View<const double*> const_p = p;
    const Kokkos::View<const double*> const_rho = rho;

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
      int jCells = jTeamCells + team_work.first;
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
    const auto team_work(computeTeamWorkRange(team_member, nbCells));
    if (!team_work.second)
      return;

    const Kokkos::View<const double**> const_l = l;
    const Kokkos::View<const double*> const_V = V;
    const Kokkos::View<const double*> const_c = c;

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
      int jCells = jTeamCells + team_work.first;
      int jId = jCells;
			double sum200346542 = 0.0;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ < nodesOfCellJ.size(); ++rNodesOfCellJ)
			{
				sum200346542 = sum200346542 + (const_l(jCells,rNodesOfCellJ));
			}
			deltatj(jCells) = 2.0 * const_V(jCells) / (const_c(jCells) * sum200346542);
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

    const Kokkos::View<const double*> const_rho = rho;
    const Kokkos::View<const double**> const_l = l;
    const Kokkos::View<const double*> const_c = c;
    const Kokkos::View<const Real2**> const_C = C;

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
      int jCells = jTeamCells + team_work.first;
      int jId = jCells;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ < nodesOfCellJ.size(); ++rNodesOfCellJ)
			{
				Ajr(jCells,rNodesOfCellJ) = ((const_rho(jCells) * const_c(jCells)) / const_l(jCells,rNodesOfCellJ))
				    * Glace2dFunctions::tensProduct(const_C(jCells,rNodesOfCellJ), const_C(jCells,rNodesOfCellJ));
			}
		});
	}

	/**
	 * Job ComputeAr @7.0
	 * In variables: Ajr
	 * Out variables: Ar
	 */
	KOKKOS_INLINE_FUNCTION
	void computeAr(const member_type& team_member)
	{
    const auto team_work(computeTeamWorkRange(team_member, nbNodes));
    if (!team_work.second)
      return;

    const Kokkos::View<const Real2x2**> const_Ajr = Ajr;

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rTeamNodes)
		{
      int rNodes = rTeamNodes + team_work.first;
			int rId = rNodes;
			Real2x2 sum1410539089 = Real2x2(Real2(0.0, 0.0), Real2(0.0, 0.0));
			const auto& cellsOfNodeR(mesh->getCellsOfNode(rId));
			for (int jCellsOfNodeR(0); jCellsOfNodeR < cellsOfNodeR.size(); ++jCellsOfNodeR)
			{
				int jId = cellsOfNodeR[jCellsOfNodeR];
				int jCells = jId;
				const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
				int rNodesOfCellJ = utils::indexOf(nodesOfCellJ,rId);
				sum1410539089 = sum1410539089 + (const_Ajr(jCells,rNodesOfCellJ));
			}
			Ar(rNodes) = sum1410539089;
		});
	}

	/**
	 * Job ComputeBr @7.0
	 * In variables: p, C, Ajr, uj
	 * Out variables: b
	 */
	KOKKOS_INLINE_FUNCTION
	void computeBr(const member_type& team_member)
	{
	  const auto team_work(computeTeamWorkRange(team_member, nbNodes));
    if (!team_work.second)
      return;

    const Kokkos::View<const double*> const_p = p;
    const Kokkos::View<const Real2**> const_C = C;
    const Kokkos::View<const Real2x2**> const_Ajr = Ajr;
    const Kokkos::View<const Real2*> const_uj = uj;

	  Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rTeamNodes)
		{
      int rNodes = rTeamNodes + team_work.first;
      int rId = rNodes;
			Real2 sum214216623 = Real2(0.0, 0.0);
			const auto& cellsOfNodeR(mesh->getCellsOfNode(rId));
			for (int jCellsOfNodeR(0); jCellsOfNodeR < cellsOfNodeR.size(); ++jCellsOfNodeR)
			{
				int jId = cellsOfNodeR[jCellsOfNodeR];
				const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
				int rNodesOfCellJ = utils::indexOf(nodesOfCellJ,rId);
				int jCells = jId;
				sum214216623 = sum214216623 + (const_p(jCells) * const_C(jCells,rNodesOfCellJ)
				    + Glace2dFunctions::matVectProduct(const_Ajr(jCells,rNodesOfCellJ), const_uj(jCells)));
			}
			b(rNodes) = sum214216623;
		});
	}

	/**
	 *
	 * TEST FUSION DE BOUCLE
	 *
	   * Job ComputeBr @7.0
	   * In variables: p, C, Ajr, uj
	   * Out variables: b, Ar
	   */
	  void computeArAndBr(const member_type& team_member)
	  {
	    const auto team_work(computeTeamWorkRange(team_member, nbNodes));
	    if (!team_work.second)
	      return;

	    Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rTeamNodes)
      {
	      int rNodes = rTeamNodes + team_work.first;
	      int rId = rNodes;
        Real2 sum214216623 = Real2(0.0, 0.0);
        Real2x2 sum1410539089 = Real2x2(Real2(0.0, 0.0), Real2(0.0, 0.0));
        const auto& cellsOfNodeR(mesh->getCellsOfNode(rId));
        for (int jCellsOfNodeR(0); jCellsOfNodeR < cellsOfNodeR.size(); ++jCellsOfNodeR)
        {
          int jId = cellsOfNodeR[jCellsOfNodeR];
          const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
          int rNodesOfCellJ = utils::indexOf(nodesOfCellJ,rId);
          int jCells = jId;
          sum214216623 = sum214216623 + (p(jCells) * C(jCells,rNodesOfCellJ)
              + Glace2dFunctions::matVectProduct(Ajr(jCells,rNodesOfCellJ), uj(jCells)));
          sum1410539089 = sum1410539089 + (Ajr(jCells,rNodesOfCellJ));
        }
        b(rNodes) = sum214216623;
        Ar(rNodes) = sum1410539089;
      });
	  }


	/**
	 * Job Compute_ComputeDt @7.0
	 * In variables: deltatj, option_deltat_cfl
	 * Out variables: deltat_n_plus_1
	 */
  KOKKOS_INLINE_FUNCTION
	void compute_ComputeDt(const member_type& team_member) noexcept
	{
    const Kokkos::View<const double*> const_deltatj = deltatj;

		double reduceMin271222139 = numeric_limits<double>::max();
		Kokkos::Min<double> reducer(reduceMin271222139);
		Kokkos::parallel_reduce(Kokkos::TeamThreadRange(team_member, nbCells), KOKKOS_LAMBDA(const int& jCells, double& x)
		{
			reducer.join(x, const_deltatj(jCells));
		}, reducer);
		deltat_n_plus_1 = as_const<double>(options->option_deltat_cfl) * reduceMin271222139;
	}

	/**
	 * Job Copy_deltat_n_plus_1_to_deltat @8.0
	 * In variables: deltat_n_plus_1
	 * Out variables: deltat
	 */
  KOKKOS_INLINE_FUNCTION
	void copy_deltat_n_plus_1_to_deltat() noexcept
	{
		std::swap(deltat_n_plus_1, deltat);
	}

	/**
	 * Job ComputeMt @8.0
	 * In variables: Ar
	 * Out variables: Mt
	 */
  KOKKOS_INLINE_FUNCTION
	void computeMt(const member_type& team_member) noexcept
	{
	  const auto team_work(computeTeamWorkRange(team_member, nbInnerNodes));
    if (!team_work.second)
      return;

    const Kokkos::View<const Real2x2*> const_Ar = Ar;

		const auto& innerNodes(mesh->getInnerNodes());
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rTeamInnerNodes)
		{
      int rInnerNodes = rTeamInnerNodes + team_work.first;
			int rId = innerNodes[rInnerNodes];
			int rNodes = rId;
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
	  const auto team_work(computeTeamWorkRange(team_member, nbInnerNodes));
    if (!team_work.second)
      return;

    const Kokkos::View<const Real2*> const_b = b;

		const auto& innerNodes(mesh->getInnerNodes());
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rTeamInnerNodes)
		{
      int rInnerNodes = rTeamInnerNodes + team_work.first;
			int rId = innerNodes[rInnerNodes];
			int rNodes = rId;
			bt(rNodes) = const_b(rNodes);
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
	  const auto team_work(computeTeamWorkRange(team_member, nbOuterFaces));
    if (!team_work.second)
      return;

    const Kokkos::View<const Real2*> const_X = X;
    const Kokkos::View<const Real2*> const_b = b;
    const Kokkos::View<const Real2x2*> const_Ar = Ar;

		auto outerFaces(mesh->getOuterFaces());
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& kTeamOuterFaces)
		{
		  int kOuterFaces = kTeamOuterFaces + team_work.first;
			int kId = outerFaces[kOuterFaces];
			double epsilon = 1.0E-10;
			Real2x2 I = Real2x2(Real2(1.0, 0.0), Real2(0.0, 1.0));
			const double X_MIN = 0.0;
			const double X_MAX = options->X_EDGE_ELEMS * options->LENGTH;
			const double Y_MIN = 0.0;
			const double Y_MAX = options->Y_EDGE_ELEMS * options->LENGTH;
			Real2 nY = Real2(0.0, 1.0);
			const auto& nodesOfFaceK(mesh->getNodesOfFace(kId));
			for (int rNodesOfFaceK(0); rNodesOfFaceK < nodesOfFaceK.size(); ++rNodesOfFaceK)
			{
				int rId = nodesOfFaceK[rNodesOfFaceK];
				int rNodes = rId;
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
	 * Job Compute_ComputeTn @8.0
	 * In variables: t, deltat_n_plus_1
	 * Out variables: t_n_plus_1
	 */
  KOKKOS_INLINE_FUNCTION
	void compute_ComputeTn() noexcept
	{
		t_n_plus_1 = as_const<double>(t) + as_const<double>(deltat_n_plus_1);
	}

	/**
	 * Job Copy_t_n_plus_1_to_t @9.0
	 * In variables: t_n_plus_1
	 * Out variables: t
	 */
  KOKKOS_INLINE_FUNCTION
	void copy_t_n_plus_1_to_t() noexcept
	{
		std::swap(t_n_plus_1, t);
	}

	/**
	 * Job ComputeU @9.0
	 * In variables: Mt, bt
	 * Out variables: ur
	 */
  KOKKOS_INLINE_FUNCTION
	void computeU(const member_type& team_member) noexcept
	{
	  const auto team_work(computeTeamWorkRange(team_member, nbNodes));
    if (!team_work.second)
      return;

    const Kokkos::View<const Real2x2*> const_Mt = Mt;
    const Kokkos::View<const Real2*> const_bt = bt;

    Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rTeamNodes)
		{
      int rNodes = rTeamNodes + team_work.first;
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
	  const auto team_work(computeTeamWorkRange(team_member, nbCells));
    if (!team_work.second)
      return;

    const Kokkos::View<const double*> const_p = p;
    const Kokkos::View<const Real2**> const_C = C;
    const Kokkos::View<const Real2x2**> const_Ajr = Ajr;
    const Kokkos::View<const Real2*> const_uj = uj;
    const Kokkos::View<const Real2*> const_ur = ur;

    Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
      int jCells = jTeamCells + team_work.first;
      int jId = jCells;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ<nodesOfCellJ.size(); ++rNodesOfCellJ)
			{
				const int rId = nodesOfCellJ[rNodesOfCellJ];
				const int rNodes = rId;
				F(jCells,rNodesOfCellJ) = const_p(jCells) * const_C(jCells,rNodesOfCellJ)
				    + Glace2dFunctions::matVectProduct(const_Ajr(jCells,rNodesOfCellJ), (const_uj(jCells) - const_ur(rNodes)));
			}
		});
	}

	/**
	 * Job Compute_ComputeXn @10.0
	 * In variables: X, deltat, ur
	 * Out variables: X_n_plus_1
	 */
  KOKKOS_INLINE_FUNCTION
	void compute_ComputeXn(const member_type& team_member) noexcept
	{
	  const auto team_work(computeTeamWorkRange(team_member, nbNodes));
    if (!team_work.second)
      return;

    const Kokkos::View<const Real2*> const_X = X;
    const Kokkos::View<const Real2*> const_ur = ur;

	  Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& rTeamNodes)
		{
	    int rNodes = rTeamNodes + team_work.first;
			X_n_plus_1(rNodes).x = fma(as_const<double>(deltat), const_ur(rNodes).x, const_X(rNodes).x);
			X_n_plus_1(rNodes).y = fma(as_const<double>(deltat), const_ur(rNodes).y, const_X(rNodes).y);
		});
	}

	/**
	 * Job Copy_X_n_plus_1_to_X @11.0
	 * In variables: X_n_plus_1
	 * Out variables: X
	 */
  KOKKOS_INLINE_FUNCTION
	void copy_X_n_plus_1_to_X() noexcept
	{
		std::swap(X_n_plus_1, X);
	}

	/**
	 * Job Compute_ComputeUn @11.0
	 * In variables: F, uj, deltat, m
	 * Out variables: uj_n_plus_1
	 */
  KOKKOS_INLINE_FUNCTION
	void compute_ComputeUn(const member_type& team_member) noexcept
	{
	  const auto team_work(computeTeamWorkRange(team_member, nbCells));
    if (!team_work.second)
      return;

    const Kokkos::View<const Real2**> const_F = F;
    const Kokkos::View<const Real2*> const_uj = uj;
    const Kokkos::View<const double*> const_m = m;

	  Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
		{
      int jCells = jTeamCells + team_work.first;
      int jId = jCells;
			Real2 sum939905555 = Real2(0.0, 0.0);
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ < nodesOfCellJ.size(); ++rNodesOfCellJ)
			{
				sum939905555 = sum939905555 + (const_F(jCells,rNodesOfCellJ));
			}
			const double tmp(-1.0 * as_const<double>(deltat) / const_m(jCells));
			uj_n_plus_1(jCells).x = fma(tmp, sum939905555.x, const_uj(jCells).x);
			uj_n_plus_1(jCells).y = fma(tmp, sum939905555.y, const_uj(jCells).y);
		});
	}

	/**
	 * Job Compute_ComputeEn @11.0
	 * In variables: F, ur, E, deltat, m
	 * Out variables: E_n_plus_1
	 */
  KOKKOS_INLINE_FUNCTION
	void compute_ComputeEn(const member_type& team_member) noexcept
	{
	  const auto team_work(computeTeamWorkRange(team_member, nbCells));
    if (!team_work.second)
      return;

    const Kokkos::View<const Real2**> const_F = F;
    const Kokkos::View<const Real2*> const_ur = ur;
    const Kokkos::View<const double*> const_E = E;
    const Kokkos::View<const double*> const_m = m;

	  Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jTeamCells)
    {
      int jCells = jTeamCells + team_work.first;
      int jId = jCells;
			double sum364745434 = 0.0;
			const auto& nodesOfCellJ(mesh->getNodesOfCell(jId));
			for (int rNodesOfCellJ(0); rNodesOfCellJ < nodesOfCellJ.size(); ++rNodesOfCellJ)
			{
				const int& rId = nodesOfCellJ[rNodesOfCellJ];
				const int& rNodes = rId;
				sum364745434 = sum364745434 + (MathFunctions::dot(const_F(jCells,rNodesOfCellJ), const_ur(rNodes)));
			}
			const double tmp(-1.0 * as_const<double>(deltat) / const_m(jCells));
			E_n_plus_1(jCells) = fma(tmp, sum364745434, const_E(jCells));
		});
	}

	/**
	 * Job Copy_uj_n_plus_1_to_uj @12.0
	 * In variables: uj_n_plus_1
	 * Out variables: uj
	 */
  KOKKOS_INLINE_FUNCTION
	void copy_uj_n_plus_1_to_uj() noexcept
	{
		std::swap(uj_n_plus_1, uj);
	}

	/**
	 * Job Copy_E_n_plus_1_to_E @12.0
	 * In variables: E_n_plus_1
	 * Out variables: E
	 */
  KOKKOS_INLINE_FUNCTION
	void copy_E_n_plus_1_to_E() noexcept
	{
		std::swap(E_n_plus_1, E);
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
	    /*
			 * Kokkos::TeamPolicy<>(n, m)
			 * with n : league_size, arbitrary, took numa count (~= socket number)
			 *      m : team_size, maximum hardware thread per core
			 */

			// Kokkos::AUTO not working on my tests :( always giving me 1...
			auto team_policy(Kokkos::TeamPolicy<>(
			    Kokkos::hwloc::get_available_numa_count(),
			    Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));

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
          compute_ComputeDt(thread);
			});

      // @8.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
        if (thread.league_rank() == 0)
          Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){copy_deltat_n_plus_1_to_deltat();});
        computeMt(thread);
        computeBt(thread);
        outerFacesComputations(thread);
        compute_ComputeTn();
			});

			// @9.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
        if (thread.league_rank() == 0)
          Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){copy_t_n_plus_1_to_t();});
        computeU(thread);
			});

      // @10.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
        computeFjr(thread);
        compute_ComputeXn(thread);
			});

      // @11.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread) {
        if (thread.league_rank() == 0)
          Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){copy_X_n_plus_1_to_X();});
        compute_ComputeUn(thread);
        compute_ComputeEn(thread);
			});

			// @12.0
			copy_uj_n_plus_1_to_uj();
			copy_E_n_plus_1_to_E();

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
