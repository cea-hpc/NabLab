/* DO NOT EDIT THIS FILE - it is machine generated */

#include "Iteration.h"
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>


/******************** Module definition ********************/

Iteration::Iteration(CartesianMesh2D& aMesh)
: mesh(aMesh)
, nbNodes(mesh.getNbNodes())
, nbCells(mesh.getNbCells())
, X("X", nbNodes)
, u_n("u_n", nbCells)
, u_nplus1("u_nplus1", nbCells)
, v1_n("v1_n", nbCells)
, v1_nplus1("v1_nplus1", nbCells)
, v1_nplus1_k("v1_nplus1_k", nbCells)
, v1_nplus1_kplus1("v1_nplus1_kplus1", nbCells)
, v1_nplus1_k0("v1_nplus1_k0", nbCells)
, v2_n("v2_n", nbCells)
, v2_nplus1("v2_nplus1", nbCells)
, v2_n0("v2_n0", nbCells)
, v2_nplus1_k("v2_nplus1_k", nbCells)
, v2_nplus1_kplus1("v2_nplus1_kplus1", nbCells)
, w_n("w_n", nbCells)
, w_nplus1("w_nplus1", nbCells)
, w_nplus1_l("w_nplus1_l", nbCells)
, w_nplus1_lplus1("w_nplus1_lplus1", nbCells)
, w_nplus1_l0("w_nplus1_l0", nbCells)
{
}

Iteration::~Iteration()
{
}

void
Iteration::jsonInit(const char* jsonContent)
{
	rapidjson::Document document;
	assert(!document.Parse(jsonContent).HasParseError());
	assert(document.IsObject());
	const rapidjson::Value::Object& options = document.GetObject();


	// Copy node coordinates
	const auto& gNodes = mesh.getGeometry()->getNodes();
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		X(rNodes)[0] = gNodes[rNodes][0];
		X(rNodes)[1] = gNodes[rNodes][1];
	}
}


const std::pair<size_t, size_t> Iteration::computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept
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
 * Job computeTn called @1.0 in executeTimeLoopN method.
 * In variables: deltat, t_n
 * Out variables: t_nplus1
 */
void Iteration::computeTn() noexcept
{
	t_nplus1 = t_n + deltat;
}

/**
 * Job iniTime called @1.0 in simulate method.
 * In variables: 
 * Out variables: t_n0
 */
void Iteration::iniTime() noexcept
{
	t_n0 = 0.0;
}

/**
 * Job iniU called @1.0 in simulate method.
 * In variables: 
 * Out variables: u_n
 */
void Iteration::iniU(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			u_n(cCells) = 0.0;
		});
	}
}

/**
 * Job iniV1 called @1.0 in executeTimeLoopN method.
 * In variables: u_n
 * Out variables: v1_nplus1_k0
 */
void Iteration::iniV1(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			v1_nplus1_k0(cCells) = u_n(cCells) + 1;
		});
	}
}

/**
 * Job iniV2 called @1.0 in simulate method.
 * In variables: 
 * Out variables: v2_n0
 */
void Iteration::iniV2(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			v2_n0(cCells) = 1.0;
		});
	}
}

/**
 * Job updateV1 called @1.0 in executeTimeLoopK method.
 * In variables: v1_nplus1_k
 * Out variables: v1_nplus1_kplus1
 */
void Iteration::updateV1(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			v1_nplus1_kplus1(cCells) = v1_nplus1_k(cCells) + 1.5;
		});
	}
}

/**
 * Job updateV2 called @1.0 in executeTimeLoopK method.
 * In variables: v2_nplus1_k
 * Out variables: v2_nplus1_kplus1
 */
void Iteration::updateV2(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			v2_nplus1_kplus1(cCells) = v2_nplus1_k(cCells) + 2;
		});
	}
}

/**
 * Job updateW called @1.0 in executeTimeLoopL method.
 * In variables: w_nplus1_l
 * Out variables: w_nplus1_lplus1
 */
void Iteration::updateW(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			w_nplus1_lplus1(cCells) = w_nplus1_l(cCells) + 2.5;
		});
	}
}

/**
 * Job setUpTimeLoopK called @2.0 in executeTimeLoopN method.
 * In variables: v1_nplus1_k0, v2_n
 * Out variables: v1_nplus1_k, v2_nplus1_k
 */
void Iteration::setUpTimeLoopK(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& i1CellsTeam)
		{
			int i1Cells(i1CellsTeam + teamWork.first);
			v1_nplus1_k(i1Cells) = v1_nplus1_k0(i1Cells);
		});
	}
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& i1CellsTeam)
		{
			int i1Cells(i1CellsTeam + teamWork.first);
			v2_nplus1_k(i1Cells) = v2_n(i1Cells);
		});
	}
}

/**
 * Job setUpTimeLoopN called @2.0 in simulate method.
 * In variables: t_n0, v2_n0
 * Out variables: t_n, v2_n
 */
void Iteration::setUpTimeLoopN(const member_type& teamMember) noexcept
{
	t_n = t_n0;
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& i1CellsTeam)
		{
			int i1Cells(i1CellsTeam + teamWork.first);
			v2_n(i1Cells) = v2_n0(i1Cells);
		});
	}
}

/**
 * Job executeTimeLoopK called @3.0 in executeTimeLoopN method.
 * In variables: k, maxIterK, v1_nplus1_k, v2_nplus1_k
 * Out variables: v1_nplus1_kplus1, v2_nplus1_kplus1
 */
void Iteration::executeTimeLoopK() noexcept
{
	auto team_policy(Kokkos::TeamPolicy<>(
		Kokkos::hwloc::get_available_numa_count(),
		Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));
	
	k = 0;
	bool continueLoop = true;
	do
	{
		k++;
		// @1.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			updateV1(thread);
			updateV2(thread);
		});
		
	
		// Evaluate loop condition with variables at time n
		continueLoop = (k + 1 < maxIterK);
	
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const size_t& i1Cells)
		{
			v1_nplus1_k(i1Cells) = v1_nplus1_kplus1(i1Cells);
		});
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const size_t& i1Cells)
		{
			v2_nplus1_k(i1Cells) = v2_nplus1_kplus1(i1Cells);
		});
	} while (continueLoop);
}

/**
 * Job executeTimeLoopN called @3.0 in simulate method.
 * In variables: maxIter, maxTime, n, t_n, t_nplus1, u_n, v1_n, v2_n, w_n
 * Out variables: t_nplus1, u_nplus1, v1_nplus1, v2_nplus1, w_nplus1
 */
void Iteration::executeTimeLoopN() noexcept
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
		if (n!=1)
			std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << n << __RESET__ "] t = " << __BOLD__
				<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t_n << __RESET__;
	
		// @1.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			if (thread.league_rank() == 0)
				Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){computeTn();});
			iniV1(thread);
		});
		
		// @2.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			setUpTimeLoopK(thread);
		});
		
		// @3.0
		executeTimeLoopK();
		
		// @4.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			tearDownTimeLoopK(thread);
		});
		
		// @5.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			iniW(thread);
		});
		
		// @6.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			setUpTimeLoopL(thread);
		});
		
		// @7.0
		executeTimeLoopL();
		
		// @8.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			tearDownTimeLoopL(thread);
		});
		
		// @9.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			updateU(thread);
		});
		
	
		// Evaluate loop condition with variables at time n
		continueLoop = (t_nplus1 < maxTime && n + 1 < maxIter);
	
		t_n = t_nplus1;
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const size_t& i1Cells)
		{
			u_n(i1Cells) = u_nplus1(i1Cells);
		});
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const size_t& i1Cells)
		{
			v1_n(i1Cells) = v1_nplus1(i1Cells);
		});
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const size_t& i1Cells)
		{
			v2_n(i1Cells) = v2_nplus1(i1Cells);
		});
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const size_t& i1Cells)
		{
			w_n(i1Cells) = w_nplus1(i1Cells);
		});
	
		cpuTimer.stop();
		globalTimer.stop();
	
		// Timers display
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";
		
		// Progress
		std::cout << progress_bar(n, maxIter, t_n, maxTime, 25);
		std::cout << __BOLD__ << __CYAN__ << Timer::print(
			eta(n, maxIter, t_n, maxTime, deltat, globalTimer), true)
			<< __RESET__ << "\r";
		std::cout.flush();
	
		cpuTimer.reset();
		ioTimer.reset();
	} while (continueLoop);
}

/**
 * Job tearDownTimeLoopK called @4.0 in executeTimeLoopN method.
 * In variables: v1_nplus1_kplus1, v2_nplus1_kplus1
 * Out variables: v1_nplus1, v2_nplus1
 */
void Iteration::tearDownTimeLoopK(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& i1CellsTeam)
		{
			int i1Cells(i1CellsTeam + teamWork.first);
			v1_nplus1(i1Cells) = v1_nplus1_kplus1(i1Cells);
		});
	}
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& i1CellsTeam)
		{
			int i1Cells(i1CellsTeam + teamWork.first);
			v2_nplus1(i1Cells) = v2_nplus1_kplus1(i1Cells);
		});
	}
}

/**
 * Job iniW called @5.0 in executeTimeLoopN method.
 * In variables: v1_nplus1
 * Out variables: w_nplus1_l0
 */
void Iteration::iniW(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			w_nplus1_l0(cCells) = v1_nplus1(cCells);
		});
	}
}

/**
 * Job setUpTimeLoopL called @6.0 in executeTimeLoopN method.
 * In variables: w_nplus1_l0
 * Out variables: w_nplus1_l
 */
void Iteration::setUpTimeLoopL(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& i1CellsTeam)
		{
			int i1Cells(i1CellsTeam + teamWork.first);
			w_nplus1_l(i1Cells) = w_nplus1_l0(i1Cells);
		});
	}
}

/**
 * Job executeTimeLoopL called @7.0 in executeTimeLoopN method.
 * In variables: l, maxIterL, w_nplus1_l
 * Out variables: w_nplus1_lplus1
 */
void Iteration::executeTimeLoopL() noexcept
{
	auto team_policy(Kokkos::TeamPolicy<>(
		Kokkos::hwloc::get_available_numa_count(),
		Kokkos::hwloc::get_available_cores_per_numa() * Kokkos::hwloc::get_available_threads_per_core()));
	
	l = 0;
	bool continueLoop = true;
	do
	{
		l++;
		// @1.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			updateW(thread);
		});
		
	
		// Evaluate loop condition with variables at time n
		continueLoop = (l + 1 < maxIterL);
	
		Kokkos::parallel_for(nbCells, KOKKOS_LAMBDA(const size_t& i1Cells)
		{
			w_nplus1_l(i1Cells) = w_nplus1_lplus1(i1Cells);
		});
	} while (continueLoop);
}

/**
 * Job tearDownTimeLoopL called @8.0 in executeTimeLoopN method.
 * In variables: w_nplus1_lplus1
 * Out variables: w_nplus1
 */
void Iteration::tearDownTimeLoopL(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& i1CellsTeam)
		{
			int i1Cells(i1CellsTeam + teamWork.first);
			w_nplus1(i1Cells) = w_nplus1_lplus1(i1Cells);
		});
	}
}

/**
 * Job updateU called @9.0 in executeTimeLoopN method.
 * In variables: w_nplus1
 * Out variables: u_nplus1
 */
void Iteration::updateU(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			u_nplus1(cCells) = w_nplus1(cCells);
		});
	}
}

void Iteration::simulate()
{
	std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Iteration ..." << __RESET__ << "\n\n";
	
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
		if (thread.league_rank() == 0)
			Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){iniTime();});
		iniU(thread);
		iniV2(thread);
	});
	
	// @2.0
	Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
	{
		setUpTimeLoopN(thread);
	});
	
	// @3.0
	executeTimeLoopN();
	
	std::cout << "\nFinal time = " << t_n << endl;
	std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << globalTimer.print() << __RESET__ << std::endl;
}

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	string dataFile;
	int ret = 0;
	
	if (argc == 2)
	{
		dataFile = argv[1];
	}
	else
	{
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 1 arg: dataFile." << std::endl;
		std::cerr << "(Iteration.json)" << std::endl;
		return -1;
	}
	
	// read json dataFile
	ifstream ifs(dataFile);
	rapidjson::IStreamWrapper isw(ifs);
	rapidjson::Document d;
	d.ParseStream(isw);
	assert(d.IsObject());
	
	// Mesh instanciation
	CartesianMesh2D mesh;
	assert(d.HasMember("mesh"));
	rapidjson::StringBuffer strbuf;
	rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
	d["mesh"].Accept(writer);
	mesh.jsonInit(strbuf.GetString());
	
	// Module instanciation(s)
	Iteration* iteration = new Iteration(mesh);
	if (d.HasMember("iteration"))
	{
		rapidjson::StringBuffer strbuf;
		rapidjson::Writer<rapidjson::StringBuffer> writer(strbuf);
		d["iteration"].Accept(writer);
		iteration->jsonInit(strbuf.GetString());
	}
	
	// Start simulation
	// Simulator must be a pointer when a finalize is needed at the end (Kokkos, omp...)
	iteration->simulate();
	
	delete iteration;
	// simulator must be deleted before calling finalize
	Kokkos::finalize();
	return ret;
}
