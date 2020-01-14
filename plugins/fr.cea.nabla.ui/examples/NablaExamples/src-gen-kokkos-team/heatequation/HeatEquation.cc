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

class HeatEquation
{
public:
	struct Options
	{
		// Should be const but usefull to set them from main args
		double X_EDGE_LENGTH = 0.1;
		double Y_EDGE_LENGTH = X_EDGE_LENGTH;
		int X_EDGE_ELEMS = 20;
		int Y_EDGE_ELEMS = 20;
		double option_stoptime = 0.1;
		int option_max_iterations = 500;
		double PI = 3.1415926;
		double alpha = 1.0;
	};
	Options* options;

private:
	NumericMesh2D* mesh;
	PvdFileWriter2D writer;
	int nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbNeighbourCells;

	// Global Variables
	int n, nbCalls, lastDump;
	double t_n, t_nplus1, deltat;

	// Connectivity Variables
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> center;
	Kokkos::View<double*> u_n;
	Kokkos::View<double*> u_nplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> f;
	Kokkos::View<double*> outgoingFlux;
	Kokkos::View<double*> surface;

	utils::Timer timer;
	typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

public:
	HeatEquation(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("HeatEquation")
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbFaces(mesh->getNbFaces())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, nbNodesOfFace(NumericMesh2D::MaxNbNodesOfFace)
	, nbNeighbourCells(NumericMesh2D::MaxNbNeighbourCells)
	, t_n(0.0)
	, t_nplus1(0.0)
	, deltat(0.001)
	, nbCalls(0)
	, lastDump(0)
	, X("X", nbNodes)
	, center("center", nbCells)
	, u_n("u_n", nbCells)
	, u_nplus1("u_nplus1", nbCells)
	, V("V", nbCells)
	, f("f", nbCells)
	, outgoingFlux("outgoingFlux", nbCells)
	, surface("surface", nbFaces)
	{
		// Copy node coordinates
		const auto& gNodes = mesh->getGeometricMesh()->getNodes();
		Kokkos::parallel_for(nbNodes, KOKKOS_LAMBDA(const int& rNodes)
		{
			X(rNodes) = gNodes[rNodes];
		});
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
	 * Job ComputeOutgoingFlux called @1.0 in executeTimeLoopN method.
	 * In variables: V, center, deltat, surface, u_n
	 * Out variables: outgoingFlux
	 */
	KOKKOS_INLINE_FUNCTION
	void computeOutgoingFlux(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& j1CellsTeam)
		{
			int j1Cells(j1CellsTeam + team_work.first);
			int j1Id(j1Cells);
			double reduction3 = 0.0;
			{
				auto neighbourCellsJ1(mesh->getNeighbourCells(j1Id));
				for (int j2NeighbourCellsJ1=0; j2NeighbourCellsJ1<neighbourCellsJ1.size(); j2NeighbourCellsJ1++)
				{
					int j2Id(neighbourCellsJ1[j2NeighbourCellsJ1]);
					int j2Cells(j2Id);
					int cfCommonFaceJ1J2(mesh->getCommonFace(j1Id, j2Id));
					int cfId(cfCommonFaceJ1J2);
					int cfFaces(cfId);
					reduction3 = reduction3 + ((u_n(j2Cells) - u_n(j1Cells)) / MathFunctions::norm(ArrayOperations::minus(center(j2Cells), center(j1Cells))) * surface(cfFaces));
				}
			}
			outgoingFlux(j1Cells) = deltat / V(j1Cells) * reduction3;
		});
	}
	
	/**
	 * Job ComputeSurface called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: surface
	 */
	KOKKOS_INLINE_FUNCTION
	void computeSurface(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbFaces));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& fFacesTeam)
		{
			int fFaces(fFacesTeam + team_work.first);
			int fId(fFaces);
			double reduction2 = 0.0;
			{
				auto nodesOfFaceF(mesh->getNodesOfFace(fId));
				for (int rNodesOfFaceF=0; rNodesOfFaceF<nodesOfFaceF.size(); rNodesOfFaceF++)
				{
					int rId(nodesOfFaceF[rNodesOfFaceF]);
					int rPlus1Id(nodesOfFaceF[(rNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace]);
					int rNodes(rId);
					int rPlus1Nodes(rPlus1Id);
					reduction2 = reduction2 + (MathFunctions::norm(ArrayOperations::minus(X(rNodes), X(rPlus1Nodes))));
				}
			}
			surface(fFaces) = 0.5 * reduction2;
		});
	}
	
	/**
	 * Job ComputeTn called @1.0 in executeTimeLoopN method.
	 * In variables: deltat, t_n
	 * Out variables: t_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept
	{
		t_nplus1 = t_n + deltat;
	}
	
	/**
	 * Job ComputeV called @1.0 in simulate method.
	 * In variables: X
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
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			double reduction1 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					int rNodes(rId);
					int rPlus1Nodes(rPlus1Id);
					reduction1 = reduction1 + (MathFunctions::det(X(rNodes), X(rPlus1Nodes)));
				}
			}
			V(jCells) = 0.5 * reduction1;
		});
	}
	
	/**
	 * Job IniCenter called @1.0 in simulate method.
	 * In variables: X
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
			int jCells(jCellsTeam + team_work.first);
			int jId(jCells);
			RealArray1D<2> reduction0 = {{0.0, 0.0}};
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int rNodesOfCellJ=0; rNodesOfCellJ<nodesOfCellJ.size(); rNodesOfCellJ++)
				{
					int rId(nodesOfCellJ[rNodesOfCellJ]);
					int rNodes(rId);
					reduction0 = ArrayOperations::plus(reduction0, (X(rNodes)));
				}
			}
			center(jCells) = ArrayOperations::multiply(0.25, reduction0);
		});
	}
	
	/**
	 * Job IniF called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: f
	 */
	KOKKOS_INLINE_FUNCTION
	void iniF(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			f(jCells) = 0.0;
		});
	}
	
	/**
	 * Job dumpVariables called @1.0 in executeTimeLoopN method.
	 * In variables: n, u_n
	 * Out variables: 
	 */
	KOKKOS_INLINE_FUNCTION
	void dumpVariables() noexcept
	{
		nbCalls++;
		if (!writer.isDisabled() && n >= lastDump + 1.0)
		{
			std::map<string, double*> cellVariables;
			std::map<string, double*> nodeVariables;
			cellVariables.insert(pair<string,double*>("Temperature", u_n.data()));
			auto quads = mesh->getGeometricMesh()->getQuads();
			writer.writeFile(nbCalls, t_n, nbNodes, X.data(), nbCells, quads.data(), cellVariables, nodeVariables);
			lastDump = n;
		}
	}
	
	/**
	 * Job ComputeUn called @2.0 in executeTimeLoopN method.
	 * In variables: deltat, f, outgoingFlux, u_n
	 * Out variables: u_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void computeUn(const member_type& team_member) noexcept
	{
		const auto team_work(computeTeamWorkRange(team_member, nbCells));
		if (!team_work.second)
			return;
		
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& jCellsTeam)
		{
			int jCells(jCellsTeam + team_work.first);
			u_nplus1(jCells) = f(jCells) * deltat + u_n(jCells) + outgoingFlux(jCells);
		});
	}
	
	/**
	 * Job IniUn called @2.0 in simulate method.
	 * In variables: PI, alpha, center
	 * Out variables: u_n
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
			u_n(jCells) = MathFunctions::cos(2 * options->PI * options->alpha * center(jCells)[0]);
		});
	}
	
	/**
	 * Job executeTimeLoopN called @3.0 in simulate method.
	 * In variables: V, center, deltat, f, n, outgoingFlux, surface, t_n, u_n
	 * Out variables: outgoingFlux, t_nplus1, u_nplus1
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
			n++;
			if (n!=1)
				std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << n << __RESET__ "] t = " << __BOLD__
					<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t_n << __RESET__;
		
			// @1.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeOutgoingFlux(thread);
				if (thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){computeTn();});
				if (thread.league_rank() == 0)
					Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){dumpVariables();});
			});
			
			// @2.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				computeUn(thread);
			});
			
		
			// Progress
			std::cout << utils::progress_bar(n, options->option_max_iterations, t_n, options->option_stoptime, 30);
			std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
				utils::eta(n, options->option_max_iterations, t_n, options->option_stoptime, deltat, timer), true)
				<< __RESET__ << "\r";
			std::cout.flush();
		
			// Evaluate loop condition with variables at time n
			continueLoop = (t_nplus1 < options->option_stoptime && n + 1 < options->option_max_iterations);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				std::swap(t_nplus1, t_n);
				std::swap(u_nplus1, u_n);
			}
		} while (continueLoop);
	}

public:
	void simulate()
	{
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting HeatEquation ..." << __RESET__ << "\n\n";
		
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

		auto team_policy(Kokkos::TeamPolicy<>(
			Kokkos::hwloc::get_available_numa_count(),
			Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));

		timer.start();
		// @1.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			if (thread.league_rank() == 0)
				Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){
					std::cout << "[" << __GREEN__ << "RUNTIME" << __RESET__ << "]   Using " << __BOLD__ << setw(3) << thread.league_size() << __RESET__ << " team(s) of "
						<< __BOLD__ << setw(3) << thread.team_size() << __RESET__<< " thread(s)" << std::endl;});
			computeSurface(thread);
			computeV(thread);
			iniCenter(thread);
			iniF(thread);
		});
		
		// @2.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			iniUn(thread);
		});
		
		// @3.0
		executeTimeLoopN();
		
		timer.stop();

		std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << timer.print() << __RESET__ << std::endl;
	}
};

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto o = new HeatEquation::Options();
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
	auto c = new HeatEquation(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete gm;
	delete o;
	Kokkos::finalize();
	return 0;
}
