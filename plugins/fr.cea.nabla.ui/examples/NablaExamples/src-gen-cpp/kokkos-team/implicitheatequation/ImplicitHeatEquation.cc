#include "implicitheatequation/ImplicitHeatEquation.h"

using namespace nablalib;

/******************** Free functions definitions ********************/

template<size_t x>
KOKKOS_INLINE_FUNCTION
double norm(RealArray1D<x> a)
{
	return std::sqrt(dot(a, a));
}

template<size_t x>
KOKKOS_INLINE_FUNCTION
double dot(RealArray1D<x> a, RealArray1D<x> b)
{
	double result(0.0);
	for (size_t i=0; i<x; i++)
	{
		result = result + a[i] * b[i];
	}
	return result;
}

KOKKOS_INLINE_FUNCTION
double det(RealArray1D<2> a, RealArray1D<2> b)
{
	return (a[0] * b[1] - a[1] * b[0]);
}

template<size_t x>
KOKKOS_INLINE_FUNCTION
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b)
{
	return a + b;
}

KOKKOS_INLINE_FUNCTION
double minR0(double a, double b)
{
	return std::min(a, b);
}

KOKKOS_INLINE_FUNCTION
double sumR0(double a, double b)
{
	return a + b;
}

KOKKOS_INLINE_FUNCTION
double prodR0(double a, double b)
{
	return a * b;
}


/******************** Options definition ********************/

ImplicitHeatEquation::Options::Options(const std::string& fileName)
{
	ifstream ifs(fileName);
	rapidjson::IStreamWrapper isw(ifs);
	rapidjson::Document d;
	d.ParseStream(isw);
	assert(d.IsObject());
	// outputPath
	assert(d.HasMember("outputPath"));
	const rapidjson::Value& valueof_outputPath = d["outputPath"];
	assert(valueof_outputPath.IsString());
	outputPath = valueof_outputPath.GetString();
	// outputPeriod
	assert(d.HasMember("outputPeriod"));
	const rapidjson::Value& valueof_outputPeriod = d["outputPeriod"];
	assert(valueof_outputPeriod.IsInt());
	outputPeriod = valueof_outputPeriod.GetInt();
	// u0
	assert(d.HasMember("u0"));
	const rapidjson::Value& valueof_u0 = d["u0"];
	assert(valueof_u0.IsDouble());
	u0 = valueof_u0.GetDouble();
	// vectOne
	assert(d.HasMember("vectOne"));
	const rapidjson::Value& valueof_vectOne = d["vectOne"];
	assert(valueof_vectOne.IsArray());
	assert(valueof_vectOne.Size() == 2);
	for (size_t i1=0 ; i1<2 ; i1++)
	{
		assert(valueof_vectOne[i1].IsDouble());
		vectOne[i1] = valueof_vectOne[i1].GetDouble();
	}
	// X_LENGTH
	assert(d.HasMember("X_LENGTH"));
	const rapidjson::Value& valueof_X_LENGTH = d["X_LENGTH"];
	assert(valueof_X_LENGTH.IsDouble());
	X_LENGTH = valueof_X_LENGTH.GetDouble();
	// Y_LENGTH
	assert(d.HasMember("Y_LENGTH"));
	const rapidjson::Value& valueof_Y_LENGTH = d["Y_LENGTH"];
	assert(valueof_Y_LENGTH.IsDouble());
	Y_LENGTH = valueof_Y_LENGTH.GetDouble();
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
	// stopTime
	assert(d.HasMember("stopTime"));
	const rapidjson::Value& valueof_stopTime = d["stopTime"];
	assert(valueof_stopTime.IsDouble());
	stopTime = valueof_stopTime.GetDouble();
	// maxIterations
	assert(d.HasMember("maxIterations"));
	const rapidjson::Value& valueof_maxIterations = d["maxIterations"];
	assert(valueof_maxIterations.IsInt());
	maxIterations = valueof_maxIterations.GetInt();
}

/******************** Module definition ********************/

ImplicitHeatEquation::ImplicitHeatEquation(const Options& aOptions)
: options(aOptions)
, t_n(0.0)
, t_nplus1(0.0)
, deltat(0.001)
, lastDump(numeric_limits<int>::min())
, mesh(CartesianMesh2DGenerator::generate(options.X_EDGE_ELEMS, options.Y_EDGE_ELEMS, options.X_EDGE_LENGTH, options.Y_EDGE_LENGTH))
, writer("ImplicitHeatEquation", options.outputPath)
, nbNodes(mesh->getNbNodes())
, nbCells(mesh->getNbCells())
, nbFaces(mesh->getNbFaces())
, nbNeighbourCells(CartesianMesh2D::MaxNbNeighbourCells)
, nbNodesOfFace(CartesianMesh2D::MaxNbNodesOfFace)
, nbCellsOfFace(CartesianMesh2D::MaxNbCellsOfFace)
, nbNodesOfCell(CartesianMesh2D::MaxNbNodesOfCell)
, X("X", nbNodes)
, Xc("Xc", nbCells)
, xc("xc", nbCells)
, yc("yc", nbCells)
, u_n("u_n", nbCells)
, u_nplus1("u_nplus1", nbCells)
, V("V", nbCells)
, D("D", nbCells)
, faceLength("faceLength", nbFaces)
, faceConductivity("faceConductivity", nbFaces)
, alpha("alpha", nbCells, nbCells)
{
	// Copy node coordinates
	const auto& gNodes = mesh->getGeometry()->getNodes();
	for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
	{
		X(rNodes)[0] = gNodes[rNodes][0];
		X(rNodes)[1] = gNodes[rNodes][1];
	}
}

ImplicitHeatEquation::~ImplicitHeatEquation()
{
	delete mesh;
}

const std::pair<size_t, size_t> ImplicitHeatEquation::computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept
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
 * Job ComputeFaceLength called @1.0 in simulate method.
 * In variables: X
 * Out variables: faceLength
 */
void ImplicitHeatEquation::computeFaceLength(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbFaces));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& fFacesTeam)
		{
			int fFaces(fFacesTeam + teamWork.first);
			const Id fId(fFaces);
			double reduction0(0.0);
			{
				const auto nodesOfFaceF(mesh->getNodesOfFace(fId));
				const size_t nbNodesOfFaceF(nodesOfFaceF.size());
				for (size_t pNodesOfFaceF=0; pNodesOfFaceF<nbNodesOfFaceF; pNodesOfFaceF++)
				{
					const Id pId(nodesOfFaceF[pNodesOfFaceF]);
					const Id pPlus1Id(nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace]);
					const size_t pNodes(pId);
					const size_t pPlus1Nodes(pPlus1Id);
					reduction0 = sumR0(reduction0, norm(X(pNodes) - X(pPlus1Nodes)));
				}
			}
			faceLength(fFaces) = 0.5 * reduction0;
		});
	}
}

/**
 * Job ComputeTn called @1.0 in executeTimeLoopN method.
 * In variables: deltat, t_n
 * Out variables: t_nplus1
 */
void ImplicitHeatEquation::computeTn() noexcept
{
	t_nplus1 = t_n + deltat;
}

/**
 * Job ComputeV called @1.0 in simulate method.
 * In variables: X
 * Out variables: V
 */
void ImplicitHeatEquation::computeV(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			const Id jId(jCells);
			double reduction0(0.0);
			{
				const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				const size_t nbNodesOfCellJ(nodesOfCellJ.size());
				for (size_t pNodesOfCellJ=0; pNodesOfCellJ<nbNodesOfCellJ; pNodesOfCellJ++)
				{
					const Id pId(nodesOfCellJ[pNodesOfCellJ]);
					const Id pPlus1Id(nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					const size_t pNodes(pId);
					const size_t pPlus1Nodes(pPlus1Id);
					reduction0 = sumR0(reduction0, det(X(pNodes), X(pPlus1Nodes)));
				}
			}
			V(jCells) = 0.5 * reduction0;
		});
	}
}

/**
 * Job InitD called @1.0 in simulate method.
 * In variables: 
 * Out variables: D
 */
void ImplicitHeatEquation::initD(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			D(cCells) = 1.0;
		});
	}
}

/**
 * Job InitXc called @1.0 in simulate method.
 * In variables: X
 * Out variables: Xc
 */
void ImplicitHeatEquation::initXc(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			const Id cId(cCells);
			RealArray1D<2> reduction0({0.0, 0.0});
			{
				const auto nodesOfCellC(mesh->getNodesOfCell(cId));
				const size_t nbNodesOfCellC(nodesOfCellC.size());
				for (size_t pNodesOfCellC=0; pNodesOfCellC<nbNodesOfCellC; pNodesOfCellC++)
				{
					const Id pId(nodesOfCellC[pNodesOfCellC]);
					const size_t pNodes(pId);
					reduction0 = sumR1(reduction0, X(pNodes));
				}
			}
			Xc(cCells) = 0.25 * reduction0;
		});
	}
}

/**
 * Job UpdateU called @1.0 in executeTimeLoopN method.
 * In variables: alpha, u_n
 * Out variables: u_nplus1
 */
void ImplicitHeatEquation::updateU() noexcept
{
	u_nplus1 = LinearAlgebraFunctions::solveLinearSystem(alpha, u_n, cg_info);
}

/**
 * Job ComputeDeltaTn called @2.0 in simulate method.
 * In variables: D, X_EDGE_LENGTH, Y_EDGE_LENGTH
 * Out variables: deltat
 */
void ImplicitHeatEquation::computeDeltaTn(const member_type& teamMember) noexcept
{
	double reduction0;
	Kokkos::parallel_reduce(Kokkos::TeamThreadRange(teamMember, nbCells), KOKKOS_LAMBDA(const size_t& cCells, double& accu)
	{
		accu = minR0(accu, options.X_EDGE_LENGTH * options.Y_EDGE_LENGTH / D(cCells));
	}, KokkosJoiner<double>(reduction0, numeric_limits<double>::max(), &minR0));
	deltat = reduction0 * 0.24;
}

/**
 * Job ComputeFaceConductivity called @2.0 in simulate method.
 * In variables: D
 * Out variables: faceConductivity
 */
void ImplicitHeatEquation::computeFaceConductivity(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbFaces));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& fFacesTeam)
		{
			int fFaces(fFacesTeam + teamWork.first);
			const Id fId(fFaces);
			double reduction0(1.0);
			{
				const auto cellsOfFaceF(mesh->getCellsOfFace(fId));
				const size_t nbCellsOfFaceF(cellsOfFaceF.size());
				for (size_t c1CellsOfFaceF=0; c1CellsOfFaceF<nbCellsOfFaceF; c1CellsOfFaceF++)
				{
					const Id c1Id(cellsOfFaceF[c1CellsOfFaceF]);
					const size_t c1Cells(c1Id);
					reduction0 = prodR0(reduction0, D(c1Cells));
				}
			}
			double reduction1(0.0);
			{
				const auto cellsOfFaceF(mesh->getCellsOfFace(fId));
				const size_t nbCellsOfFaceF(cellsOfFaceF.size());
				for (size_t c2CellsOfFaceF=0; c2CellsOfFaceF<nbCellsOfFaceF; c2CellsOfFaceF++)
				{
					const Id c2Id(cellsOfFaceF[c2CellsOfFaceF]);
					const size_t c2Cells(c2Id);
					reduction1 = sumR0(reduction1, D(c2Cells));
				}
			}
			faceConductivity(fFaces) = 2.0 * reduction0 / reduction1;
		});
	}
}

/**
 * Job InitU called @2.0 in simulate method.
 * In variables: Xc, u0, vectOne
 * Out variables: u_n
 */
void ImplicitHeatEquation::initU(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			if (norm(Xc(cCells) - options.vectOne) < 0.5) 
				u_n(cCells) = options.u0;
			else
				u_n(cCells) = 0.0;
		});
	}
}

/**
 * Job InitXcAndYc called @2.0 in simulate method.
 * In variables: Xc
 * Out variables: xc, yc
 */
void ImplicitHeatEquation::initXcAndYc(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			xc(cCells) = Xc(cCells)[0];
			yc(cCells) = Xc(cCells)[1];
		});
	}
}

/**
 * Job ComputeAlphaCoeff called @3.0 in simulate method.
 * In variables: V, Xc, deltat, faceConductivity, faceLength
 * Out variables: alpha
 */
void ImplicitHeatEquation::computeAlphaCoeff(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
		{
			int cCells(cCellsTeam + teamWork.first);
			const Id cId(cCells);
			double alphaDiag(0.0);
			{
				const auto neighbourCellsC(mesh->getNeighbourCells(cId));
				const size_t nbNeighbourCellsC(neighbourCellsC.size());
				for (size_t dNeighbourCellsC=0; dNeighbourCellsC<nbNeighbourCellsC; dNeighbourCellsC++)
				{
					const Id dId(neighbourCellsC[dNeighbourCellsC]);
					const size_t dCells(dId);
					const Id fId(mesh->getCommonFace(cId, dId));
					const size_t fFaces(fId);
					const double alphaExtraDiag(-deltat / V(cCells) * (faceLength(fFaces) * faceConductivity(fFaces)) / norm(Xc(cCells) - Xc(dCells)));
					alpha(cCells,dCells) = alphaExtraDiag;
					alphaDiag = alphaDiag + alphaExtraDiag;
				}
			}
			alpha(cCells,cCells) = 1 - alphaDiag;
		});
	}
}

/**
 * Job ExecuteTimeLoopN called @4.0 in simulate method.
 * In variables: alpha, deltat, t_n, u_n
 * Out variables: t_nplus1, u_nplus1
 */
void ImplicitHeatEquation::executeTimeLoopN() noexcept
{
	n = 0;
	bool continueLoop = true;
	do
	{
		globalTimer.start();
		cpuTimer.start();
		n++;
		if (!writer.isDisabled() && n >= lastDump + options.outputPeriod)
			dumpVariables(n);
		if (n!=1)
			std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << n << __RESET__ "] t = " << __BOLD__
				<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t_n << __RESET__;
	
		// @1.0
		computeTn();
		updateU();
		
	
		// Evaluate loop condition with variables at time n
		continueLoop = (t_nplus1 < options.stopTime && n + 1 < options.maxIterations);
	
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
		std::cout << utils::progress_bar(n, options.maxIterations, t_n, options.stopTime, 25);
		std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
			utils::eta(n, options.maxIterations, t_n, options.stopTime, deltat, globalTimer), true)
			<< __RESET__ << "\r";
		std::cout.flush();
	
		cpuTimer.reset();
		ioTimer.reset();
	} while (continueLoop);
	// force a last output at the end
	dumpVariables(n, false);
}

void ImplicitHeatEquation::dumpVariables(int iteration, bool useTimer)
{
	if (!writer.isDisabled())
	{
		if (useTimer)
		{
			cpuTimer.stop();
			ioTimer.start();
		}
		auto quads = mesh->getGeometry()->getQuads();
		writer.startVtpFile(iteration, t_n, nbNodes, X.data(), nbCells, quads.data());
		writer.openNodeData();
		writer.closeNodeData();
		writer.openCellData();
		writer.write("Temperature", u_n);
		writer.closeCellData();
		writer.closeVtpFile();
		lastDump = n;
		if (useTimer)
		{
			ioTimer.stop();
			cpuTimer.start();
		}
	}
}

void ImplicitHeatEquation::simulate()
{
	std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting ImplicitHeatEquation ..." << __RESET__ << "\n\n";
	
	std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options.X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options.Y_EDGE_ELEMS
		<< __RESET__ << ", X length=" << __BOLD__ << options.X_EDGE_LENGTH << __RESET__ << ", Y length=" << __BOLD__ << options.Y_EDGE_LENGTH << __RESET__ << std::endl;
	
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
		computeFaceLength(thread);
		computeV(thread);
		initD(thread);
		initXc(thread);
	});
	
	// @2.0
	Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
	{
		if (thread.league_rank() == 0)
			computeDeltaTn(thread);
		computeFaceConductivity(thread);
		initU(thread);
		initXcAndYc(thread);
	});
	
	// @3.0
	Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
	{
		computeAlphaCoeff(thread);
	});
	
	// @4.0
	executeTimeLoopN();
	
	std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << globalTimer.print() << __RESET__ << std::endl;
	std::cout << "[CG] average iteration: " << cg_info.m_nb_it / n << std::endl;
}


/******************** Module definition ********************/

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	string dataFile;
	
	if (argc == 2)
	{
		dataFile = argv[1];
	}
	else
	{
		std::cerr << "[ERROR] Wrong number of arguments. Expecting 1 arg: dataFile." << std::endl;
		std::cerr << "(ImplicitHeatEquationDefaultOptions.json)" << std::endl;
		return -1;
	}
	
	ImplicitHeatEquation::Options options(dataFile);
	// simulator must be a pointer if there is a finalize at the end (Kokkos, omp...)
	auto simulator = new ImplicitHeatEquation(options);
	simulator->simulate();
	// simulator must be deleted before calling finalize
	delete simulator;
	Kokkos::finalize();
	return 0;
}
