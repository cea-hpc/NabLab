#pragma STDC FENV_ACCESS ON
#include <iostream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <cfenv>
#include <Kokkos_Core.hpp>
#include <Kokkos_hwloc.hpp>
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/CartesianMesh2D.h"
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
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	int nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;
	
	// Global Variables
	int n, lastDump;
	double t_n, t_nplus1, deltat_n, deltat_nplus1;
	
	// Connectivity Variables
	Kokkos::View<RealArray1D<2>*> X_n;
	Kokkos::View<RealArray1D<2>*> X_nplus1;
	Kokkos::View<RealArray1D<2>*> X_n0;
	Kokkos::View<RealArray1D<2>*> b;
	Kokkos::View<RealArray1D<2>*> bt;
	Kokkos::View<RealArray2D<2,2>*> Ar;
	Kokkos::View<RealArray2D<2,2>*> Mt;
	Kokkos::View<RealArray1D<2>*> ur;
	Kokkos::View<double*> c;
	Kokkos::View<double*> m;
	Kokkos::View<double*> p;
	Kokkos::View<double*> rho;
	Kokkos::View<double*> e;
	Kokkos::View<double*> E_n;
	Kokkos::View<double*> E_nplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> deltatj;
	Kokkos::View<RealArray1D<2>*> uj_n;
	Kokkos::View<RealArray1D<2>*> uj_nplus1;
	Kokkos::View<double**> l;
	Kokkos::View<RealArray1D<2>**> Cjr_ic;
	Kokkos::View<RealArray1D<2>**> C;
	Kokkos::View<RealArray1D<2>**> F;
	Kokkos::View<RealArray2D<2,2>**> Ajr;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;
	typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

public:
	Glace2d(Options* aOptions, CartesianMesh2D* aCartesianMesh2D, string output)
	: options(aOptions)
	, mesh(aCartesianMesh2D)
	, writer("Glace2d", output)
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbNodesOfCell(CartesianMesh2D::MaxNbNodesOfCell)
	, nbCellsOfNode(CartesianMesh2D::MaxNbCellsOfNode)
	, nbInnerNodes(mesh->getNbInnerNodes())
	, nbOuterFaces(mesh->getNbOuterFaces())
	, nbNodesOfFace(CartesianMesh2D::MaxNbNodesOfFace)
	, t_n(0.0)
	, t_nplus1(0.0)
	, deltat_n(options->option_deltat_ini)
	, deltat_nplus1(options->option_deltat_ini)
	, lastDump(numeric_limits<int>::min())
	, X_n("X_n", nbNodes)
	, X_nplus1("X_nplus1", nbNodes)
	, X_n0("X_n0", nbNodes)
	, b("b", nbNodes)
	, bt("bt", nbNodes)
	, Ar("Ar", nbNodes)
	, Mt("Mt", nbNodes)
	, ur("ur", nbNodes)
	, c("c", nbCells)
	, m("m", nbCells)
	, p("p", nbCells)
	, rho("rho", nbCells)
	, e("e", nbCells)
	, E_n("E_n", nbCells)
	, E_nplus1("E_nplus1", nbCells)
	, V("V", nbCells)
	, deltatj("deltatj", nbCells)
	, uj_n("uj_n", nbCells)
	, uj_nplus1("uj_nplus1", nbCells)
	, l("l", nbCells, nbNodesOfCell)
	, Cjr_ic("Cjr_ic", nbCells, nbNodesOfCell)
	, C("C", nbCells, nbNodesOfCell)
	, F("F", nbCells, nbNodesOfCell)
	, Ajr("Ajr", nbCells, nbNodesOfCell)
	{
		// Copy node coordinates
		const auto& gNodes = mesh->getGeometry()->getNodes();
		for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
			X_n0(rNodes) = gNodes[rNodes];
	}

private:
	/**
	 * Utility function to get work load for each team of threads
	 * In  : thread and number of element to use for computation
	 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
	 */
	const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const int& nb_elmt) noexcept
	{
		/*
		if (nb_elmt % thread.team_size())
		{
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
		if (thread.league_rank() == thread.league_size() - 1)
		{
			size_t left_over(nb_elmt - (team_chunk * thread.league_size()));
			team_chunk += left_over;
		}
		return std::pair<size_t, size_t>(team_offset, team_chunk);
	}
	
	/**
	 * Job ComputeCjr called @1.0 in executeTimeLoopN method.
	 * In variables: X_n
	 * Out variables: C
	 */
	KOKKOS_INLINE_FUNCTION
	void computeCjr(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const int jId(jCells);
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						const int rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
						const int rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
						const int rPlus1Nodes(rPlus1Id);
						const int rMinus1Nodes(rMinus1Id);
						C(jCells,rNodesOfCellJ) = ArrayOperations::multiply(0.5, perp(ArrayOperations::minus(X_n(rPlus1Nodes), X_n(rMinus1Nodes))));
					}
				}
			});
		}
	}
	
	/**
	 * Job ComputeInternalEnergy called @1.0 in executeTimeLoopN method.
	 * In variables: E_n, uj_n
	 * Out variables: e
	 */
	KOKKOS_INLINE_FUNCTION
	void computeInternalEnergy(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				e(jCells) = E_n(jCells) - 0.5 * MathFunctions::dot(uj_n(jCells), uj_n(jCells));
			});
		}
	}
	
	/**
	 * Job IniCjrIc called @1.0 in simulate method.
	 * In variables: X_n0
	 * Out variables: Cjr_ic
	 */
	KOKKOS_INLINE_FUNCTION
	void iniCjrIc(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const int jId(jCells);
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						const int rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
						const int rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
						const int rPlus1Nodes(rPlus1Id);
						const int rMinus1Nodes(rMinus1Id);
						Cjr_ic(jCells,rNodesOfCellJ) = ArrayOperations::multiply(0.5, perp(ArrayOperations::minus(X_n0(rPlus1Nodes), X_n0(rMinus1Nodes))));
					}
				}
			});
		}
	}
	
	/**
	 * Job SetUpTimeLoopN called @1.0 in simulate method.
	 * In variables: X_n0
	 * Out variables: X_n
	 */
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopN() noexcept
	{
		deep_copy(X_n, X_n0);
	}
	
	/**
	 * Job ComputeLjr called @2.0 in executeTimeLoopN method.
	 * In variables: C
	 * Out variables: l
	 */
	KOKKOS_INLINE_FUNCTION
	void computeLjr(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const int jId(jCells);
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						l(jCells,rNodesOfCellJ) = MathFunctions::norm(C(jCells,rNodesOfCellJ));
					}
				}
			});
		}
	}
	
	/**
	 * Job ComputeV called @2.0 in executeTimeLoopN method.
	 * In variables: C, X_n
	 * Out variables: V
	 */
	KOKKOS_INLINE_FUNCTION
	void computeV(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const int jId(jCells);
				double reduction5(0.0);
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						const int rId(nodesOfCellJ[rNodesOfCellJ]);
						const int rNodes(rId);
						reduction5 = sumR0(reduction5, MathFunctions::dot(C(jCells,rNodesOfCellJ), X_n(rNodes)));
					}
				}
				V(jCells) = 0.5 * reduction5;
			});
		}
	}
	
	/**
	 * Job Initialize called @2.0 in simulate method.
	 * In variables: Cjr_ic, X_n0, gamma, option_p_ini_zd, option_p_ini_zg, option_rho_ini_zd, option_rho_ini_zg, option_x_interface
	 * Out variables: E_n, m, p, rho, uj_n
	 */
	KOKKOS_INLINE_FUNCTION
	void initialize(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const int jId(jCells);
				double rho_ic;
				double p_ic;
				RealArray1D<2> reduction0({{0.0, 0.0}});
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						const int rId(nodesOfCellJ[rNodesOfCellJ]);
						const int rNodes(rId);
						reduction0 = sumR1(reduction0, X_n0(rNodes));
					}
				}
				RealArray1D<2> center(ArrayOperations::multiply(0.25, reduction0));
				if (center[0] < options->option_x_interface) 
				{
					rho_ic = options->option_rho_ini_zg;
					p_ic = options->option_p_ini_zg;
				}
				else
				{
					rho_ic = options->option_rho_ini_zd;
					p_ic = options->option_p_ini_zd;
				}
				double reduction1(0.0);
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						const int rId(nodesOfCellJ[rNodesOfCellJ]);
						const int rNodes(rId);
						reduction1 = sumR0(reduction1, MathFunctions::dot(Cjr_ic(jCells,rNodesOfCellJ), X_n0(rNodes)));
					}
				}
				double V_ic(0.5 * reduction1);
				m(jCells) = rho_ic * V_ic;
				p(jCells) = p_ic;
				rho(jCells) = rho_ic;
				E_n(jCells) = p_ic / ((options->gamma - 1.0) * rho_ic);
				uj_n(jCells) = {{0.0, 0.0}};
			});
		}
	}
	
	/**
	 * Job ComputeDensity called @3.0 in executeTimeLoopN method.
	 * In variables: V, m
	 * Out variables: rho
	 */
	KOKKOS_INLINE_FUNCTION
	void computeDensity(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				rho(jCells) = m(jCells) / V(jCells);
			});
		}
	}
	
	/**
	 * Job ExecuteTimeLoopN called @3.0 in simulate method.
	 * In variables: Ajr, Ar, C, E_n, F, Mt, V, X_EDGE_ELEMS, X_EDGE_LENGTH, X_n, Y_EDGE_ELEMS, Y_EDGE_LENGTH, b, bt, c, deltat_n, deltat_nplus1, deltatj, e, gamma, l, m, option_deltat_cfl, p, rho, t_n, uj_n, ur
	 * Out variables: Ajr, Ar, C, E_nplus1, F, Mt, V, X_nplus1, b, bt, c, deltat_nplus1, deltatj, e, l, p, rho, t_nplus1, uj_nplus1, ur
	 */
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept
	{
		auto team_policy(Kokkos::TeamPolicy<>(
			Kokkos::hwloc::get_available_numa_count(),
			Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));
		
		n = 0;
		bool continueLoop = true;
		do
		{
			globalTimer.start();
			cpuTimer.start();
			n++;
			dumpVariables(n);
			if (n!=1)
				std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << n << __RESET__ "] t = " << __BOLD__
					<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t_n << __RESET__;
		
			// @1.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeCjr(thread);
				computeInternalEnergy(thread);
			});
			
			// @2.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeLjr(thread);
				computeV(thread);
			});
			
			// @3.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeDensity(thread);
			});
			
			// @4.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeEOSp(thread);
			});
			
			// @5.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeEOSc(thread);
			});
			
			// @6.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeAjr(thread);
				computedeltatj(thread);
			});
			
			// @7.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeAr(thread);
				computeBr(thread);
				if (thread.league_rank() == 0)
					computeDt(thread);
			});
			
			// @8.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeBoundaryConditions(thread);
				computeBt(thread);
				computeMt(thread);
				if (thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){computeTn();});
			});
			
			// @9.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeU(thread);
			});
			
			// @10.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeFjr(thread);
				computeXn(thread);
			});
			
			// @11.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeEn(thread);
				computeUn(thread);
			});
			
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options->option_stoptime && n + 1 < options->option_max_iterations);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				std::swap(t_nplus1, t_n);
				std::swap(deltat_nplus1, deltat_n);
				std::swap(X_nplus1, X_n);
				std::swap(E_nplus1, E_n);
				std::swap(uj_nplus1, uj_n);
			}
		
			cpuTimer.stop();
			globalTimer.stop();
		
			// Timers display
			if (!writer.isDisabled())
				std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __BLUE__ << ioTimer.print(true) << __RESET__ "} ";
			else
				std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";
			
			// Progress
			std::cout << utils::progress_bar(n, options->option_max_iterations, t_n, options->option_stoptime, 30);
			std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
				utils::eta(n, options->option_max_iterations, t_n, options->option_stoptime, deltat_n, globalTimer), true)
				<< __RESET__ << "\r";
			std::cout.flush();
		
			cpuTimer.reset();
			ioTimer.reset();
		} while (continueLoop);
	}
	
	/**
	 * Job ComputeEOSp called @4.0 in executeTimeLoopN method.
	 * In variables: e, gamma, rho
	 * Out variables: p
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEOSp(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				p(jCells) = (options->gamma - 1.0) * rho(jCells) * e(jCells);
			});
		}
	}
	
	/**
	 * Job ComputeEOSc called @5.0 in executeTimeLoopN method.
	 * In variables: gamma, p, rho
	 * Out variables: c
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEOSc(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				c(jCells) = MathFunctions::sqrt(options->gamma * p(jCells) / rho(jCells));
			});
		}
	}
	
	/**
	 * Job ComputeAjr called @6.0 in executeTimeLoopN method.
	 * In variables: C, c, l, rho
	 * Out variables: Ajr
	 */
	KOKKOS_INLINE_FUNCTION
	void computeAjr(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const int jId(jCells);
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						Ajr(jCells,rNodesOfCellJ) = ArrayOperations::multiply(((rho(jCells) * c(jCells)) / l(jCells,rNodesOfCellJ)), tensProduct(C(jCells,rNodesOfCellJ), C(jCells,rNodesOfCellJ)));
					}
				}
			});
		}
	}
	
	/**
	 * Job Computedeltatj called @6.0 in executeTimeLoopN method.
	 * In variables: V, c, l
	 * Out variables: deltatj
	 */
	KOKKOS_INLINE_FUNCTION
	void computedeltatj(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const int jId(jCells);
				double reduction2(0.0);
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						reduction2 = sumR0(reduction2, l(jCells,rNodesOfCellJ));
					}
				}
				deltatj(jCells) = 2.0 * V(jCells) / (c(jCells) * reduction2);
			});
		}
	}
	
	/**
	 * Job ComputeAr called @7.0 in executeTimeLoopN method.
	 * In variables: Ajr
	 * Out variables: Ar
	 */
	KOKKOS_INLINE_FUNCTION
	void computeAr(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbNodes));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& rNodesTeam)
			{
				int rNodes(rNodesTeam + teamWork.first);
				const int rId(rNodes);
				RealArray2D<2,2> reduction3({{{0.0, 0.0}, {0.0, 0.0}}});
				{
					const auto cellsOfNodeR(mesh->getCellsOfNode(rId));
					const int nbElemsJCellsOfNodeR(cellsOfNodeR.size());
					for (size_t jCellsOfNodeR=0; jCellsOfNodeR<nbElemsJCellsOfNodeR; jCellsOfNodeR++)
					{
						const int jId(cellsOfNodeR[jCellsOfNodeR]);
						const int jCells(jId);
						const int rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId), rId));
						reduction3 = sumR2(reduction3, Ajr(jCells,rNodesOfCellJ));
					}
				}
				Ar(rNodes) = reduction3;
			});
		}
	}
	
	/**
	 * Job ComputeBr called @7.0 in executeTimeLoopN method.
	 * In variables: Ajr, C, p, uj_n
	 * Out variables: b
	 */
	KOKKOS_INLINE_FUNCTION
	void computeBr(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbNodes));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& rNodesTeam)
			{
				int rNodes(rNodesTeam + teamWork.first);
				const int rId(rNodes);
				RealArray1D<2> reduction4({{0.0, 0.0}});
				{
					const auto cellsOfNodeR(mesh->getCellsOfNode(rId));
					const int nbElemsJCellsOfNodeR(cellsOfNodeR.size());
					for (size_t jCellsOfNodeR=0; jCellsOfNodeR<nbElemsJCellsOfNodeR; jCellsOfNodeR++)
					{
						const int jId(cellsOfNodeR[jCellsOfNodeR]);
						const int jCells(jId);
						const int rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId), rId));
						reduction4 = sumR1(reduction4, ArrayOperations::plus(ArrayOperations::multiply(p(jCells), C(jCells,rNodesOfCellJ)), MathFunctions::matVectProduct(Ajr(jCells,rNodesOfCellJ), uj_n(jCells))));
					}
				}
				b(rNodes) = reduction4;
			});
		}
	}
	
	/**
	 * Job ComputeDt called @7.0 in executeTimeLoopN method.
	 * In variables: deltatj, option_deltat_cfl
	 * Out variables: deltat_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeDt(const member_type& teamMember) noexcept
	{
		double reduction8(numeric_limits<double>::max());
		Kokkos::parallel_reduce(Kokkos::TeamThreadRange(teamMember, nbCells), KOKKOS_LAMBDA(const int& jCells, double& accu)
		{
			accu = minR0(accu, deltatj(jCells));
		}, Kokkos::Min<double>(reduction8));
		deltat_nplus1 = options->option_deltat_cfl * reduction8;
	}
	
	/**
	 * Job ComputeBoundaryConditions called @8.0 in executeTimeLoopN method.
	 * In variables: Ar, X_EDGE_ELEMS, X_EDGE_LENGTH, X_n, Y_EDGE_ELEMS, Y_EDGE_LENGTH, b
	 * Out variables: Mt, bt
	 */
	KOKKOS_INLINE_FUNCTION
	void computeBoundaryConditions(const member_type& teamMember) noexcept
	{
		{
			const auto outerFaces(mesh->getOuterFaces());
			const int nbElemsFOuterFaces(outerFaces.size());
			{
				const auto teamWork(computeTeamWorkRange(teamMember, nbElemsFOuterFaces));
				if (!teamWork.second)
					return;
			
				Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& fOuterFacesTeam)
				{
					int fOuterFaces(fOuterFacesTeam + teamWork.first);
					const int fId(outerFaces[fOuterFaces]);
					const double epsilon(1.0E-10);
					RealArray2D<2,2> I({{{{1.0, 0.0}}, {{0.0, 1.0}}}});
					double X_MIN(0.0);
					double X_MAX(options->X_EDGE_ELEMS * options->X_EDGE_LENGTH);
					double Y_MIN(0.0);
					double Y_MAX(options->Y_EDGE_ELEMS * options->Y_EDGE_LENGTH);
					RealArray1D<2> nY({{0.0, 1.0}});
					{
						const auto nodesOfFaceF(mesh->getNodesOfFace(fId));
						const int nbElemsRNodesOfFaceF(nodesOfFaceF.size());
						for (size_t rNodesOfFaceF=0; rNodesOfFaceF<nbElemsRNodesOfFaceF; rNodesOfFaceF++)
						{
							const int rId(nodesOfFaceF[rNodesOfFaceF]);
							const int rNodes(rId);
							if ((X_n(rNodes)[1] - Y_MIN < epsilon) || (X_n(rNodes)[1] - Y_MAX < epsilon)) 
							{
								double sign(0.0);
								if (X_n(rNodes)[1] - Y_MIN < epsilon) 
									sign = -1.0;
								else
									sign = 1.0;
								RealArray1D<2> N(ArrayOperations::multiply(sign, nY));
								RealArray2D<2,2> NxN(tensProduct(N, N));
								RealArray2D<2,2> IcP(ArrayOperations::minus(I, NxN));
								bt(rNodes) = MathFunctions::matVectProduct(IcP, b(rNodes));
								Mt(rNodes) = ArrayOperations::plus(ArrayOperations::multiply(IcP, (ArrayOperations::multiply(Ar(rNodes), IcP))), ArrayOperations::multiply(NxN, trace(Ar(rNodes))));
							}
							if ((MathFunctions::fabs(X_n(rNodes)[0] - X_MIN) < epsilon) || ((MathFunctions::fabs(X_n(rNodes)[0] - X_MAX) < epsilon))) 
							{
								Mt(rNodes) = I;
								bt(rNodes) = {{0.0, 0.0}};
							}
						}
					}
				});
			}
		}
	}
	
	/**
	 * Job ComputeBt called @8.0 in executeTimeLoopN method.
	 * In variables: b
	 * Out variables: bt
	 */
	KOKKOS_INLINE_FUNCTION
	void computeBt(const member_type& teamMember) noexcept
	{
		{
			const auto innerNodes(mesh->getInnerNodes());
			const int nbElemsRInnerNodes(innerNodes.size());
			{
				const auto teamWork(computeTeamWorkRange(teamMember, nbElemsRInnerNodes));
				if (!teamWork.second)
					return;
			
				Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& rInnerNodesTeam)
				{
					int rInnerNodes(rInnerNodesTeam + teamWork.first);
					const int rId(innerNodes[rInnerNodes]);
					const int rNodes(rId);
					bt(rNodes) = b(rNodes);
				});
			}
		}
	}
	
	/**
	 * Job ComputeMt called @8.0 in executeTimeLoopN method.
	 * In variables: Ar
	 * Out variables: Mt
	 */
	KOKKOS_INLINE_FUNCTION
	void computeMt(const member_type& teamMember) noexcept
	{
		{
			const auto innerNodes(mesh->getInnerNodes());
			const int nbElemsRInnerNodes(innerNodes.size());
			{
				const auto teamWork(computeTeamWorkRange(teamMember, nbElemsRInnerNodes));
				if (!teamWork.second)
					return;
			
				Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& rInnerNodesTeam)
				{
					int rInnerNodes(rInnerNodesTeam + teamWork.first);
					const int rId(innerNodes[rInnerNodes]);
					const int rNodes(rId);
					Mt(rNodes) = Ar(rNodes);
				});
			}
		}
	}
	
	/**
	 * Job ComputeTn called @8.0 in executeTimeLoopN method.
	 * In variables: deltat_nplus1, t_n
	 * Out variables: t_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept
	{
		t_nplus1 = t_n + deltat_nplus1;
	}
	
	/**
	 * Job ComputeU called @9.0 in executeTimeLoopN method.
	 * In variables: Mt, bt
	 * Out variables: ur
	 */
	KOKKOS_INLINE_FUNCTION
	void computeU(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbNodes));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& rNodesTeam)
			{
				int rNodes(rNodesTeam + teamWork.first);
				ur(rNodes) = MathFunctions::matVectProduct(inverse(Mt(rNodes)), bt(rNodes));
			});
		}
	}
	
	/**
	 * Job ComputeFjr called @10.0 in executeTimeLoopN method.
	 * In variables: Ajr, C, p, uj_n, ur
	 * Out variables: F
	 */
	KOKKOS_INLINE_FUNCTION
	void computeFjr(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const int jId(jCells);
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						const int rId(nodesOfCellJ[rNodesOfCellJ]);
						const int rNodes(rId);
						F(jCells,rNodesOfCellJ) = ArrayOperations::plus(ArrayOperations::multiply(p(jCells), C(jCells,rNodesOfCellJ)), MathFunctions::matVectProduct(Ajr(jCells,rNodesOfCellJ), (ArrayOperations::minus(uj_n(jCells), ur(rNodes)))));
					}
				}
			});
		}
	}
	
	/**
	 * Job ComputeXn called @10.0 in executeTimeLoopN method.
	 * In variables: X_n, deltat_n, ur
	 * Out variables: X_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeXn(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbNodes));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& rNodesTeam)
			{
				int rNodes(rNodesTeam + teamWork.first);
				X_nplus1(rNodes) = ArrayOperations::plus(X_n(rNodes), ArrayOperations::multiply(deltat_n, ur(rNodes)));
			});
		}
	}
	
	/**
	 * Job ComputeEn called @11.0 in executeTimeLoopN method.
	 * In variables: E_n, F, deltat_n, m, ur
	 * Out variables: E_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeEn(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const int jId(jCells);
				double reduction7(0.0);
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						const int rId(nodesOfCellJ[rNodesOfCellJ]);
						const int rNodes(rId);
						reduction7 = sumR0(reduction7, MathFunctions::dot(F(jCells,rNodesOfCellJ), ur(rNodes)));
					}
				}
				E_nplus1(jCells) = E_n(jCells) - (deltat_n / m(jCells)) * reduction7;
			});
		}
	}
	
	/**
	 * Job ComputeUn called @11.0 in executeTimeLoopN method.
	 * In variables: F, deltat_n, m, uj_n
	 * Out variables: uj_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeUn(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const int& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const int jId(jCells);
				RealArray1D<2> reduction6({{0.0, 0.0}});
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const int nbElemsRNodesOfCellJ(nodesOfCellJ.size());
					for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbElemsRNodesOfCellJ; rNodesOfCellJ++)
					{
						reduction6 = sumR1(reduction6, F(jCells,rNodesOfCellJ));
					}
				}
				uj_nplus1(jCells) = ArrayOperations::minus(uj_n(jCells), ArrayOperations::multiply((deltat_n / m(jCells)), reduction6));
			});
		}
	}
	
	KOKKOS_INLINE_FUNCTION
	RealArray1D<2> perp(RealArray1D<2> a) 
	{
		return {{a[1], -a[0]}};
	}
	
	template<size_t l>
	KOKKOS_INLINE_FUNCTION
	RealArray2D<l,l> tensProduct(RealArray1D<l> a, RealArray1D<l> b) 
	{
		RealArray2D<l,l> result;
		for (size_t ia=0; ia<l; ia++)
		{
			for (size_t ib=0; ib<l; ib++)
			{
				result[ia][ib] = a[ia] * b[ib];
			}
		}
		return result;
	}
	
	template<size_t l>
	KOKKOS_INLINE_FUNCTION
	double trace(RealArray2D<l,l> a) 
	{
		double result(0.0);
		for (size_t ia=0; ia<l; ia++)
		{
			result = result + a[ia][ia];
		}
		return result;
	}
	
	KOKKOS_INLINE_FUNCTION
	RealArray2D<2,2> inverse(RealArray2D<2,2> a) 
	{
		double alpha(1.0 / MathFunctions::det(a));
		return {{{{a[1][1] * alpha, -a[0][1] * alpha}}, {{-a[1][0] * alpha, a[0][0] * alpha}}}};
	}
	
	template<size_t x>
	KOKKOS_INLINE_FUNCTION
	RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b) 
	{
		return ArrayOperations::plus(a, b);
	}
	
	KOKKOS_INLINE_FUNCTION
	double sumR0(double a, double b) 
	{
		return a + b;
	}
	
	template<size_t x>
	KOKKOS_INLINE_FUNCTION
	RealArray2D<x,x> sumR2(RealArray2D<x,x> a, RealArray2D<x,x> b) 
	{
		return ArrayOperations::plus(a, b);
	}
	
	KOKKOS_INLINE_FUNCTION
	double minR0(double a, double b) 
	{
		return MathFunctions::min(a, b);
	}

	void dumpVariables(int iteration)
	{
		if (!writer.isDisabled() && n >= lastDump + 1.0)
		{
			cpuTimer.stop();
			ioTimer.start();
			std::map<string, double*> cellVariables;
			std::map<string, double*> nodeVariables;
			cellVariables.insert(pair<string,double*>("Density", rho.data()));
			auto quads = mesh->getGeometry()->getQuads();
			writer.writeFile(iteration, t_n, nbNodes, X_n.data(), nbCells, quads.data(), cellVariables, nodeVariables);
			lastDump = n;
			ioTimer.stop();
			cpuTimer.start();
		}
	}

public:
	void simulate()
	{
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Glace2d ..." << __RESET__ << "\n\n";
		
		std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options->X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options->Y_EDGE_ELEMS
			<< __RESET__ << ", X length=" << __BOLD__ << options->X_EDGE_LENGTH << __RESET__ << ", Y length=" << __BOLD__ << options->Y_EDGE_LENGTH << __RESET__ << std::endl;
		
		if (Kokkos::hwloc::available())
		{
			std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_numa_count()
				<< __RESET__ << ", Cores/NUMA=" << __BOLD__ << Kokkos::hwloc::get_available_cores_per_numa()
				<< __RESET__ << ", Threads/Core=" << __BOLD__ << Kokkos::hwloc::get_available_threads_per_core() << __RESET__ << std::endl;
		}
		else
		{
			std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  HWLOC unavailable cannot get topological informations" << std::endl;
		}
		
		// std::cout << "[" << __GREEN__ << "KOKKOS" << __RESET__ << "]    " << __BOLD__ << (is_same<MyLayout,Kokkos::LayoutLeft>::value?"Left":"Right")" << __RESET__ << " layout" << std::endl;
		
		if (!writer.isDisabled())
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
		else
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

		auto team_policy(Kokkos::TeamPolicy<>(
			Kokkos::hwloc::get_available_numa_count(),
			Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));
		
		// @1.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			if (thread.league_rank() == 0)
				Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){
					std::cout << "[" << __GREEN__ << "RUNTIME" << __RESET__ << "]   Using " << __BOLD__ << setw(3) << thread.league_size() << __RESET__ << " team(s) of "
						<< __BOLD__ << setw(3) << thread.team_size() << __RESET__<< " thread(s)" << std::endl;});
			iniCjrIc(thread);
			if (thread.league_rank() == 0)
				Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){setUpTimeLoopN();});
		});
		
		// @2.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			initialize(thread);
		});
		
		// @3.0
		executeTimeLoopN();
		
		std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << globalTimer.print() << __RESET__ << std::endl;
	}
};

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto o = new Glace2d::Options();
	string output;
	if (argc == 5)
	{
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->X_EDGE_LENGTH = std::atof(argv[3]);
		o->Y_EDGE_LENGTH = std::atof(argv[4]);
	}
	else if (argc == 6)
	{
		o->X_EDGE_ELEMS = std::atoi(argv[1]);
		o->Y_EDGE_ELEMS = std::atoi(argv[2]);
		o->X_EDGE_LENGTH = std::atof(argv[3]);
		o->Y_EDGE_LENGTH = std::atof(argv[4]);
		output = argv[5];
	}
	else if (argc != 1)
	{
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 4 or 5 args: X Y Xlength Ylength (output)." << std::endl;
		std::cerr << "(X=100, Y=10, Xlength=0.01, Ylength=0.01 output=current directory with no args)" << std::endl;
	}
	auto nm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->X_EDGE_LENGTH, o->Y_EDGE_LENGTH);
	auto c = new Glace2d(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete o;
	Kokkos::finalize();
	return 0;
}
