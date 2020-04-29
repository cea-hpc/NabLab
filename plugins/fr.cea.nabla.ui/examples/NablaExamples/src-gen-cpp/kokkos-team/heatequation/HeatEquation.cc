#include "HeatEquation.h"

using namespace nablalib;

/******************** Free functions definitions ********************/

template<size_t x>
KOKKOS_INLINE_FUNCTION
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b)
{
	return a + b;
}

KOKKOS_INLINE_FUNCTION
double sumR0(double a, double b)
{
	return a + b;
}


/******************** Options definition ********************/

HeatEquation::Options::Options(const std::string& fileName)
{
	ifstream ifs(fileName);
	rapidjson::IStreamWrapper isw(ifs);
	rapidjson::Document d;
	d.ParseStream(isw);
	assert(d.IsObject());
	// X_EDGE_LENGTH
	assert(d.HasMember("X_EDGE_LENGTH"));
	const rapidjson::Value& valueof_X_EDGE_LENGTH = d["X_EDGE_LENGTH"];
	assert(valueof_X_EDGE_LENGTH.IsDouble());
	X_EDGE_LENGTH = valueof_X_EDGE_LENGTH.GetDouble();
	// Y_EDGE_LENGTH
	assert(d.HasMember("Y_EDGE_LENGTH"));
	const rapidjson::Value& valueof_Y_EDGE_LENGTH = d["Y_EDGE_LENGTH"];
	assert(valueof_Y_EDGE_LENGTH.IsDouble());
	Y_EDGE_LENGTH = valueof_Y_EDGE_LENGTH.GetDouble();
	// X_EDGE_ELEMS
	assert(d.HasMember("X_EDGE_ELEMS"));
	const rapidjson::Value& valueof_X_EDGE_ELEMS = d["X_EDGE_ELEMS"];
	assert(valueof_X_EDGE_ELEMS.IsInt());
	X_EDGE_ELEMS = valueof_X_EDGE_ELEMS.GetInt();
	// Y_EDGE_ELEMS
	assert(d.HasMember("Y_EDGE_ELEMS"));
	const rapidjson::Value& valueof_Y_EDGE_ELEMS = d["Y_EDGE_ELEMS"];
	assert(valueof_Y_EDGE_ELEMS.IsInt());
	Y_EDGE_ELEMS = valueof_Y_EDGE_ELEMS.GetInt();
	// option_stoptime
	assert(d.HasMember("option_stoptime"));
	const rapidjson::Value& valueof_option_stoptime = d["option_stoptime"];
	assert(valueof_option_stoptime.IsDouble());
	option_stoptime = valueof_option_stoptime.GetDouble();
	// option_max_iterations
	assert(d.HasMember("option_max_iterations"));
	const rapidjson::Value& valueof_option_max_iterations = d["option_max_iterations"];
	assert(valueof_option_max_iterations.IsInt());
	option_max_iterations = valueof_option_max_iterations.GetInt();
	// PI
	assert(d.HasMember("PI"));
	const rapidjson::Value& valueof_PI = d["PI"];
	assert(valueof_PI.IsDouble());
	PI = valueof_PI.GetDouble();
	// alpha
	assert(d.HasMember("alpha"));
	const rapidjson::Value& valueof_alpha = d["alpha"];
	assert(valueof_alpha.IsDouble());
	alpha = valueof_alpha.GetDouble();
}

/******************** Module definition ********************/

HeatEquation::HeatEquation(Options* aOptions, CartesianMesh2D* aCartesianMesh2D, string output)
: options(aOptions)
, mesh(aCartesianMesh2D)
, writer("HeatEquation", output)
, nbNodes(mesh->getNbNodes())
, nbCells(mesh->getNbCells())
, nbFaces(mesh->getNbFaces())
, nbNodesOfCell(CartesianMesh2D::MaxNbNodesOfCell)
, nbNodesOfFace(CartesianMesh2D::MaxNbNodesOfFace)
, nbNeighbourCells(CartesianMesh2D::MaxNbNeighbourCells)
, t_n(0.0)
, t_nplus1(0.0)
, deltat(0.001)
, X("X", nbNodes)
, center("center", nbCells)
, u_n("u_n", nbCells)
, u_nplus1("u_nplus1", nbCells)
, V("V", nbCells)
, f("f", nbCells)
, outgoingFlux("outgoingFlux", nbCells)
, surface("surface", nbFaces)
, lastDump(-1)
{
	// Copy node coordinates
	const auto& gNodes = mesh->getGeometry()->getNodes();
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
		X(rNodes) = gNodes[rNodes];
}

/**
 * Utility function to get work load for each team of threads
 * In  : thread and number of element to use for computation
 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
 */
const std::pair<size_t, size_t> HeatEquation::computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept
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
void HeatEquation::computeOutgoingFlux(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& j1CellsTeam)
		{
			int j1Cells(j1CellsTeam + teamWork.first);
			const Id j1Id(j1Cells);
			double reduction3(0.0);
			{
				const auto neighbourCellsJ1(mesh->getNeighbourCells(j1Id));
				const size_t nbNeighbourCellsJ1(neighbourCellsJ1.size());
				for (size_t j2NeighbourCellsJ1=0; j2NeighbourCellsJ1<nbNeighbourCellsJ1; j2NeighbourCellsJ1++)
				{
					const Id j2Id(neighbourCellsJ1[j2NeighbourCellsJ1]);
					const size_t j2Cells(j2Id);
					const Id cfId(mesh->getCommonFace(j1Id, j2Id));
					const size_t cfFaces(cfId);
					reduction3 = sumR0(reduction3, (u_n(j2Cells) - u_n(j1Cells)) / MathFunctions::norm(center(j2Cells) - center(j1Cells)) * surface(cfFaces));
				}
			}
			outgoingFlux(j1Cells) = deltat / V(j1Cells) * reduction3;
		});
	}
}

/**
 * Job ComputeSurface called @1.0 in simulate method.
 * In variables: X
 * Out variables: surface
 */
void HeatEquation::computeSurface(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbFaces));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& fFacesTeam)
		{
			int fFaces(fFacesTeam + teamWork.first);
			const Id fId(fFaces);
			double reduction2(0.0);
			{
				const auto nodesOfFaceF(mesh->getNodesOfFace(fId));
				const size_t nbNodesOfFaceF(nodesOfFaceF.size());
				for (size_t rNodesOfFaceF=0; rNodesOfFaceF<nbNodesOfFaceF; rNodesOfFaceF++)
				{
					const Id rId(nodesOfFaceF[rNodesOfFaceF]);
					const Id rPlus1Id(nodesOfFaceF[(rNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace]);
					const size_t rNodes(rId);
					const size_t rPlus1Nodes(rPlus1Id);
					reduction2 = sumR0(reduction2, MathFunctions::norm(X(rNodes) - X(rPlus1Nodes)));
				}
			}
			surface(fFaces) = 0.5 * reduction2;
		});
	}
}

/**
 * Job ComputeTn called @1.0 in executeTimeLoopN method.
 * In variables: deltat, t_n
 * Out variables: t_nplus1
 */
void HeatEquation::computeTn() noexcept
{
	t_nplus1 = t_n + deltat;
}

/**
 * Job ComputeV called @1.0 in simulate method.
 * In variables: X
 * Out variables: V
 */
void HeatEquation::computeV(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			const Id jId(jCells);
			double reduction1(0.0);
			{
				const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				const size_t nbNodesOfCellJ(nodesOfCellJ.size());
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					const Id rId(nodesOfCellJ[rNodesOfCellJ]);
					const Id rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					const size_t rNodes(rId);
					const size_t rPlus1Nodes(rPlus1Id);
					reduction1 = sumR0(reduction1, MathFunctions::det(X(rNodes), X(rPlus1Nodes)));
				}
			}
			V(jCells) = 0.5 * reduction1;
		});
	}
}

/**
 * Job IniCenter called @1.0 in simulate method.
 * In variables: X
 * Out variables: center
 */
void HeatEquation::iniCenter(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			const Id jId(jCells);
			RealArray1D<2> reduction0({0.0, 0.0});
			{
				const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				const size_t nbNodesOfCellJ(nodesOfCellJ.size());
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					const Id rId(nodesOfCellJ[rNodesOfCellJ]);
					const size_t rNodes(rId);
					reduction0 = sumR1(reduction0, X(rNodes));
				}
			}
			center(jCells) = 0.25 * reduction0;
		});
	}
}

/**
 * Job IniF called @1.0 in simulate method.
 * In variables: 
 * Out variables: f
 */
void HeatEquation::iniF(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			f(jCells) = 0.0;
		});
	}
}

/**
 * Job ComputeUn called @2.0 in executeTimeLoopN method.
 * In variables: deltat, f, outgoingFlux, u_n
 * Out variables: u_nplus1
 */
void HeatEquation::computeUn(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			u_nplus1(jCells) = f(jCells) * deltat + u_n(jCells) + outgoingFlux(jCells);
		});
	}
}

/**
 * Job IniUn called @2.0 in simulate method.
 * In variables: PI, alpha, center
 * Out variables: u_n
 */
void HeatEquation::iniUn(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			u_n(jCells) = MathFunctions::cos(2 * options->PI * options->alpha * center(jCells)[0]);
		});
	}
}

/**
 * Job ExecuteTimeLoopN called @3.0 in simulate method.
 * In variables: V, center, deltat, f, outgoingFlux, surface, t_n, u_n
 * Out variables: outgoingFlux, t_nplus1, u_nplus1
 */
void HeatEquation::executeTimeLoopN() noexcept
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
			computeOutgoingFlux(thread);
			if (thread.league_rank() == 0)
				Kokkos::single(Kokkos::PerTeam(thread), KOKKOS_LAMBDA(){computeTn();});
		});
		
		// @2.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			computeUn(thread);
		});
		
	
		// Evaluate loop condition with variables at time n
		continueLoop = (t_nplus1 < options->option_stoptime && n + 1 < options->option_max_iterations);
	
		if (continueLoop)
		{
			// Switch variables to prepare next iteration
			std::swap(t_nplus1, t_n);
			std::swap(u_nplus1, u_n);
		}
	
		cpuTimer.stop();
		globalTimer.stop();
	
		// Timers display
		if (!writer.isDisabled())
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __BLUE__ << ioTimer.print(true) << __RESET__ "} ";
		else
			std::cout << " {CPU: " << __BLUE__ << cpuTimer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";
		
		// Progress
		std::cout << utils::progress_bar(n, options->option_max_iterations, t_n, options->option_stoptime, 25);
		std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
			utils::eta(n, options->option_max_iterations, t_n, options->option_stoptime, deltat, globalTimer), true)
			<< __RESET__ << "\r";
		std::cout.flush();
	
		cpuTimer.reset();
		ioTimer.reset();
	} while (continueLoop);
}

void HeatEquation::dumpVariables(int iteration)
{
	if (!writer.isDisabled() && (lastDump < 0 || n >= lastDump + 1.0))
	{
		cpuTimer.stop();
		ioTimer.start();
		std::map<string, double*> cellVariables;
		std::map<string, double*> nodeVariables;
		cellVariables.insert(pair<string,double*>("Temperature", u_n.data()));
		auto quads = mesh->getGeometry()->getQuads();
		writer.writeFile(iteration, t_n, nbNodes, X.data(), nbCells, quads.data(), cellVariables, nodeVariables);
		lastDump = n;
		ioTimer.stop();
		cpuTimer.start();
	}
}

void HeatEquation::simulate()
{
	std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting HeatEquation ..." << __RESET__ << "\n\n";
	
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
	
	std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << globalTimer.print() << __RESET__ << std::endl;
}


/******************** Module definition ********************/

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	HeatEquation::Options* o = nullptr;
	string dataFile, output;
	
	if (argc == 2)
	{
		dataFile = argv[1];
		o = new HeatEquation::Options(dataFile);
	}
	else if (argc == 6)
	{
		dataFile = argv[1];
		o = new HeatEquation::Options(dataFile);
		o->X_EDGE_ELEMS = std::atoi(argv[2]);
		o->Y_EDGE_ELEMS = std::atoi(argv[3]);
		o->X_EDGE_LENGTH = std::atof(argv[4]);
		o->Y_EDGE_LENGTH = std::atof(argv[5]);
	}
	else if (argc == 7)
	{
		dataFile = argv[1];
		o = new HeatEquation::Options(dataFile);
		o->X_EDGE_ELEMS = std::atoi(argv[2]);
		o->Y_EDGE_ELEMS = std::atoi(argv[3]);
		o->X_EDGE_LENGTH = std::atof(argv[4]);
		o->Y_EDGE_LENGTH = std::atof(argv[5]);
		output = argv[6];
	}
	else
	{
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 1, 5 or 6 args: dataFile [X Y Xlength Ylength [output]]." << std::endl;
		std::cerr << "(HeatEquationDefaultOptions.json, X=100, Y=10, Xlength=0.01, Ylength=0.01 output=current directory with no args)" << std::endl;
		return -1;
	}
	auto nm = CartesianMesh2DGenerator::generate(o->X_EDGE_ELEMS, o->Y_EDGE_ELEMS, o->X_EDGE_LENGTH, o->Y_EDGE_LENGTH);
	auto c = new HeatEquation(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete o;
	Kokkos::finalize();
	return 0;
}
