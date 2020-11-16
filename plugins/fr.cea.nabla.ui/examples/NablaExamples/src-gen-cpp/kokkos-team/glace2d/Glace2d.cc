#include "glace2d/Glace2d.h"

using namespace nablalib;

/******************** Free functions definitions ********************/

KOKKOS_INLINE_FUNCTION
double det(RealArray2D<2,2> a)
{
	return a[0][0] * a[1][1] - a[0][1] * a[1][0];
}

KOKKOS_INLINE_FUNCTION
RealArray1D<2> perp(RealArray1D<2> a)
{
	return {a[1], -a[0]};
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

template<size_t x>
KOKKOS_INLINE_FUNCTION
double norm(RealArray1D<x> a)
{
	return std::sqrt(dot(a, a));
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

template<size_t x, size_t y>
KOKKOS_INLINE_FUNCTION
RealArray1D<x> matVectProduct(RealArray2D<x,y> a, RealArray1D<y> b)
{
	RealArray1D<x> result;
	for (size_t ix=0; ix<x; ix++)
	{
		RealArray1D<y> tmp;
		for (size_t iy=0; iy<y; iy++)
		{
			tmp[iy] = a[ix][iy];
		}
		result[ix] = dot(tmp, b);
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
	const double alpha(1.0 / det(a));
	return {a[1][1] * alpha, -a[0][1] * alpha, -a[1][0] * alpha, a[0][0] * alpha};
}

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

template<size_t x>
KOKKOS_INLINE_FUNCTION
RealArray2D<x,x> sumR2(RealArray2D<x,x> a, RealArray2D<x,x> b)
{
	return a + b;
}

KOKKOS_INLINE_FUNCTION
double minR0(double a, double b)
{
	return std::min(a, b);
}

/******************** Options definition ********************/

void
Glace2d::Options::jsonInit(const rapidjson::Value& json)
{
	assert(json.IsObject());
	const rapidjson::Value::ConstObject& o = json.GetObject();
	// outputPath
	assert(o.HasMember("outputPath"));
	const rapidjson::Value& valueof_outputPath = o["outputPath"];
	assert(valueof_outputPath.IsString());
	outputPath = valueof_outputPath.GetString();
	// outputPeriod
	assert(o.HasMember("outputPeriod"));
	const rapidjson::Value& valueof_outputPeriod = o["outputPeriod"];
	assert(valueof_outputPeriod.IsInt());
	outputPeriod = valueof_outputPeriod.GetInt();
	// stopTime
	if (o.HasMember("stopTime"))
	{
		const rapidjson::Value& valueof_stopTime = o["stopTime"];
		assert(valueof_stopTime.IsDouble());
		stopTime = valueof_stopTime.GetDouble();
	}
	else
		stopTime = 0.2;
	// maxIterations
	if (o.HasMember("maxIterations"))
	{
		const rapidjson::Value& valueof_maxIterations = o["maxIterations"];
		assert(valueof_maxIterations.IsInt());
		maxIterations = valueof_maxIterations.GetInt();
	}
	else
		maxIterations = 20000;
	// gamma
	if (o.HasMember("gamma"))
	{
		const rapidjson::Value& valueof_gamma = o["gamma"];
		assert(valueof_gamma.IsDouble());
		gamma = valueof_gamma.GetDouble();
	}
	else
		gamma = 1.4;
	// xInterface
	if (o.HasMember("xInterface"))
	{
		const rapidjson::Value& valueof_xInterface = o["xInterface"];
		assert(valueof_xInterface.IsDouble());
		xInterface = valueof_xInterface.GetDouble();
	}
	else
		xInterface = 0.5;
	// deltatIni
	if (o.HasMember("deltatIni"))
	{
		const rapidjson::Value& valueof_deltatIni = o["deltatIni"];
		assert(valueof_deltatIni.IsDouble());
		deltatIni = valueof_deltatIni.GetDouble();
	}
	else
		deltatIni = 1.0E-5;
	// deltatCfl
	if (o.HasMember("deltatCfl"))
	{
		const rapidjson::Value& valueof_deltatCfl = o["deltatCfl"];
		assert(valueof_deltatCfl.IsDouble());
		deltatCfl = valueof_deltatCfl.GetDouble();
	}
	else
		deltatCfl = 0.4;
	// rhoIniZg
	if (o.HasMember("rhoIniZg"))
	{
		const rapidjson::Value& valueof_rhoIniZg = o["rhoIniZg"];
		assert(valueof_rhoIniZg.IsDouble());
		rhoIniZg = valueof_rhoIniZg.GetDouble();
	}
	else
		rhoIniZg = 1.0;
	// rhoIniZd
	if (o.HasMember("rhoIniZd"))
	{
		const rapidjson::Value& valueof_rhoIniZd = o["rhoIniZd"];
		assert(valueof_rhoIniZd.IsDouble());
		rhoIniZd = valueof_rhoIniZd.GetDouble();
	}
	else
		rhoIniZd = 0.125;
	// pIniZg
	if (o.HasMember("pIniZg"))
	{
		const rapidjson::Value& valueof_pIniZg = o["pIniZg"];
		assert(valueof_pIniZg.IsDouble());
		pIniZg = valueof_pIniZg.GetDouble();
	}
	else
		pIniZg = 1.0;
	// pIniZd
	if (o.HasMember("pIniZd"))
	{
		const rapidjson::Value& valueof_pIniZd = o["pIniZd"];
		assert(valueof_pIniZd.IsDouble());
		pIniZd = valueof_pIniZd.GetDouble();
	}
	else
		pIniZd = 0.1;
}

/******************** Module definition ********************/

Glace2d::Glace2d(CartesianMesh2D* aMesh, Options& aOptions)
: mesh(aMesh)
, nbNodes(mesh->getNbNodes())
, nbCells(mesh->getNbCells())
, nbInnerNodes(mesh->getNbInnerNodes())
, nbTopNodes(mesh->getNbTopNodes())
, nbBottomNodes(mesh->getNbBottomNodes())
, nbLeftNodes(mesh->getNbLeftNodes())
, nbRightNodes(mesh->getNbRightNodes())
, nbNodesOfCell(CartesianMesh2D::MaxNbNodesOfCell)
, nbCellsOfNode(CartesianMesh2D::MaxNbCellsOfNode)
, options(aOptions)
, writer("Glace2d", options.outputPath)
, lastDump(numeric_limits<int>::min())
, t_n(0.0)
, t_nplus1(0.0)
, deltat_n(options.deltatIni)
, deltat_nplus1(options.deltatIni)
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
	{
		X_n0(rNodes)[0] = gNodes[rNodes][0];
		X_n0(rNodes)[1] = gNodes[rNodes][1];
	}
}

Glace2d::~Glace2d()
{
}

const std::pair<size_t, size_t> Glace2d::computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept
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
void Glace2d::computeCjr(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			const Id jId(jCells);
			{
				const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				const size_t nbNodesOfCellJ(nodesOfCellJ.size());
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					const Id rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					const Id rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
					const size_t rPlus1Nodes(rPlus1Id);
					const size_t rMinus1Nodes(rMinus1Id);
					C(jCells,rNodesOfCellJ) = 0.5 * perp(X_n(rPlus1Nodes) - X_n(rMinus1Nodes));
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
void Glace2d::computeInternalEnergy(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			e(jCells) = E_n(jCells) - 0.5 * dot(uj_n(jCells), uj_n(jCells));
		});
	}
}

/**
 * Job IniCjrIc called @1.0 in simulate method.
 * In variables: X_n0
 * Out variables: Cjr_ic
 */
void Glace2d::iniCjrIc(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			const Id jId(jCells);
			{
				const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				const size_t nbNodesOfCellJ(nodesOfCellJ.size());
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					const Id rPlus1Id(nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					const Id rMinus1Id(nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCell)%nbNodesOfCell]);
					const size_t rPlus1Nodes(rPlus1Id);
					const size_t rMinus1Nodes(rMinus1Id);
					Cjr_ic(jCells,rNodesOfCellJ) = 0.5 * perp(X_n0(rPlus1Nodes) - X_n0(rMinus1Nodes));
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
void Glace2d::setUpTimeLoopN() noexcept
{
	deep_copy(X_n, X_n0);
}

/**
 * Job ComputeLjr called @2.0 in executeTimeLoopN method.
 * In variables: C
 * Out variables: l
 */
void Glace2d::computeLjr(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			const Id jId(jCells);
			{
				const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				const size_t nbNodesOfCellJ(nodesOfCellJ.size());
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					l(jCells,rNodesOfCellJ) = norm(C(jCells,rNodesOfCellJ));
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
void Glace2d::computeV(const member_type& teamMember) noexcept
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
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					const Id rId(nodesOfCellJ[rNodesOfCellJ]);
					const size_t rNodes(rId);
					reduction0 = sumR0(reduction0, dot(C(jCells,rNodesOfCellJ), X_n(rNodes)));
				}
			}
			V(jCells) = 0.5 * reduction0;
		});
	}
}

/**
 * Job Initialize called @2.0 in simulate method.
 * In variables: Cjr_ic, X_n0, gamma, pIniZd, pIniZg, rhoIniZd, rhoIniZg, xInterface
 * Out variables: E_n, m, p, rho, uj_n
 */
void Glace2d::initialize(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			const Id jId(jCells);
			double rho_ic;
			double p_ic;
			RealArray1D<2> reduction0({0.0, 0.0});
			{
				const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				const size_t nbNodesOfCellJ(nodesOfCellJ.size());
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					const Id rId(nodesOfCellJ[rNodesOfCellJ]);
					const size_t rNodes(rId);
					reduction0 = sumR1(reduction0, X_n0(rNodes));
				}
			}
			const RealArray1D<2> center(0.25 * reduction0);
			if (center[0] < options.xInterface) 
			{
				rho_ic = options.rhoIniZg;
				p_ic = options.pIniZg;
			}
			else
			{
				rho_ic = options.rhoIniZd;
				p_ic = options.pIniZd;
			}
			double reduction1(0.0);
			{
				const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				const size_t nbNodesOfCellJ(nodesOfCellJ.size());
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					const Id rId(nodesOfCellJ[rNodesOfCellJ]);
					const size_t rNodes(rId);
					reduction1 = sumR0(reduction1, dot(Cjr_ic(jCells,rNodesOfCellJ), X_n0(rNodes)));
				}
			}
			const double V_ic(0.5 * reduction1);
			m(jCells) = rho_ic * V_ic;
			p(jCells) = p_ic;
			rho(jCells) = rho_ic;
			E_n(jCells) = p_ic / ((options.gamma - 1.0) * rho_ic);
			uj_n(jCells) = {0.0, 0.0};
		});
	}
}

/**
 * Job ComputeDensity called @3.0 in executeTimeLoopN method.
 * In variables: V, m
 * Out variables: rho
 */
void Glace2d::computeDensity(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			rho(jCells) = m(jCells) / V(jCells);
		});
	}
}

/**
 * Job ExecuteTimeLoopN called @3.0 in simulate method.
 * In variables: Ajr, Ar, C, E_n, F, Mt, V, X_n, b, bt, c, deltatCfl, deltat_n, deltat_nplus1, deltatj, e, gamma, l, m, p, rho, t_n, uj_n, ur
 * Out variables: Ajr, Ar, C, E_nplus1, F, Mt, V, X_nplus1, b, bt, c, deltat_nplus1, deltatj, e, l, p, rho, t_nplus1, uj_nplus1, ur
 */
void Glace2d::executeTimeLoopN() noexcept
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
		if (!writer.isDisabled() && n >= lastDump + options.outputPeriod)
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
		continueLoop = (t_nplus1 < options.stopTime && n + 1 < options.maxIterations);
	
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
		std::cout << utils::progress_bar(n, options.maxIterations, t_n, options.stopTime, 25);
		std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
			utils::eta(n, options.maxIterations, t_n, options.stopTime, deltat_n, globalTimer), true)
			<< __RESET__ << "\r";
		std::cout.flush();
	
		cpuTimer.reset();
		ioTimer.reset();
	} while (continueLoop);
	// force a last output at the end
	dumpVariables(n, false);
}

/**
 * Job ComputeEOSp called @4.0 in executeTimeLoopN method.
 * In variables: e, gamma, rho
 * Out variables: p
 */
void Glace2d::computeEOSp(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			p(jCells) = (options.gamma - 1.0) * rho(jCells) * e(jCells);
		});
	}
}

/**
 * Job ComputeEOSc called @5.0 in executeTimeLoopN method.
 * In variables: gamma, p, rho
 * Out variables: c
 */
void Glace2d::computeEOSc(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			c(jCells) = std::sqrt(options.gamma * p(jCells) / rho(jCells));
		});
	}
}

/**
 * Job ComputeAjr called @6.0 in executeTimeLoopN method.
 * In variables: C, c, l, rho
 * Out variables: Ajr
 */
void Glace2d::computeAjr(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			const Id jId(jCells);
			{
				const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				const size_t nbNodesOfCellJ(nodesOfCellJ.size());
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					Ajr(jCells,rNodesOfCellJ) = ((rho(jCells) * c(jCells)) / l(jCells,rNodesOfCellJ)) * tensProduct(C(jCells,rNodesOfCellJ), C(jCells,rNodesOfCellJ));
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
void Glace2d::computedeltatj(const member_type& teamMember) noexcept
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
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					reduction0 = sumR0(reduction0, l(jCells,rNodesOfCellJ));
				}
			}
			deltatj(jCells) = 2.0 * V(jCells) / (c(jCells) * reduction0);
		});
	}
}

/**
 * Job ComputeAr called @7.0 in executeTimeLoopN method.
 * In variables: Ajr
 * Out variables: Ar
 */
void Glace2d::computeAr(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbNodes));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& rNodesTeam)
		{
			int rNodes(rNodesTeam + teamWork.first);
			const Id rId(rNodes);
			RealArray2D<2,2> reduction0({0.0, 0.0,  0.0, 0.0});
			{
				const auto cellsOfNodeR(mesh->getCellsOfNode(rId));
				const size_t nbCellsOfNodeR(cellsOfNodeR.size());
				for (size_t jCellsOfNodeR=0; jCellsOfNodeR<nbCellsOfNodeR; jCellsOfNodeR++)
				{
					const Id jId(cellsOfNodeR[jCellsOfNodeR]);
					const size_t jCells(jId);
					const size_t rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId), rId));
					reduction0 = sumR2(reduction0, Ajr(jCells,rNodesOfCellJ));
				}
			}
			Ar(rNodes) = reduction0;
		});
	}
}

/**
 * Job ComputeBr called @7.0 in executeTimeLoopN method.
 * In variables: Ajr, C, p, uj_n
 * Out variables: b
 */
void Glace2d::computeBr(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbNodes));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& rNodesTeam)
		{
			int rNodes(rNodesTeam + teamWork.first);
			const Id rId(rNodes);
			RealArray1D<2> reduction0({0.0, 0.0});
			{
				const auto cellsOfNodeR(mesh->getCellsOfNode(rId));
				const size_t nbCellsOfNodeR(cellsOfNodeR.size());
				for (size_t jCellsOfNodeR=0; jCellsOfNodeR<nbCellsOfNodeR; jCellsOfNodeR++)
				{
					const Id jId(cellsOfNodeR[jCellsOfNodeR]);
					const size_t jCells(jId);
					const size_t rNodesOfCellJ(utils::indexOf(mesh->getNodesOfCell(jId), rId));
					reduction0 = sumR1(reduction0, p(jCells) * C(jCells,rNodesOfCellJ) + matVectProduct(Ajr(jCells,rNodesOfCellJ), uj_n(jCells)));
				}
			}
			b(rNodes) = reduction0;
		});
	}
}

/**
 * Job ComputeDt called @7.0 in executeTimeLoopN method.
 * In variables: deltatCfl, deltatj
 * Out variables: deltat_nplus1
 */
void Glace2d::computeDt(const member_type& teamMember) noexcept
{
	double reduction0;
	Kokkos::parallel_reduce(Kokkos::TeamThreadRange(teamMember, nbCells), KOKKOS_LAMBDA(const size_t& jCells, double& accu)
	{
		accu = minR0(accu, deltatj(jCells));
	}, KokkosJoiner<double>(reduction0, numeric_limits<double>::max(), &minR0));
	deltat_nplus1 = options.deltatCfl * reduction0;
}

/**
 * Job ComputeBoundaryConditions called @8.0 in executeTimeLoopN method.
 * In variables: Ar, b
 * Out variables: Mt, bt
 */
void Glace2d::computeBoundaryConditions(const member_type& teamMember) noexcept
{
	const RealArray2D<2,2> I({1.0, 0.0, 0.0, 1.0});
	{
		const auto topNodes(mesh->getTopNodes());
		const size_t nbTopNodes(topNodes.size());
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbTopNodes));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& rTopNodesTeam)
			{
				int rTopNodes(rTopNodesTeam + teamWork.first);
				const Id rId(topNodes[rTopNodes]);
				const size_t rNodes(rId);
				const RealArray1D<2> N({0.0, 1.0});
				const RealArray2D<2,2> NxN(tensProduct(N, N));
				const RealArray2D<2,2> IcP(I - NxN);
				bt(rNodes) = matVectProduct(IcP, b(rNodes));
				Mt(rNodes) = IcP * (Ar(rNodes) * IcP) + NxN * trace(Ar(rNodes));
			});
		}
	}
	{
		const auto bottomNodes(mesh->getBottomNodes());
		const size_t nbBottomNodes(bottomNodes.size());
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbBottomNodes));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& rBottomNodesTeam)
			{
				int rBottomNodes(rBottomNodesTeam + teamWork.first);
				const Id rId(bottomNodes[rBottomNodes]);
				const size_t rNodes(rId);
				const RealArray1D<2> N({0.0, -1.0});
				const RealArray2D<2,2> NxN(tensProduct(N, N));
				const RealArray2D<2,2> IcP(I - NxN);
				bt(rNodes) = matVectProduct(IcP, b(rNodes));
				Mt(rNodes) = IcP * (Ar(rNodes) * IcP) + NxN * trace(Ar(rNodes));
			});
		}
	}
	{
		const auto leftNodes(mesh->getLeftNodes());
		const size_t nbLeftNodes(leftNodes.size());
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbLeftNodes));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& rLeftNodesTeam)
			{
				int rLeftNodes(rLeftNodesTeam + teamWork.first);
				const Id rId(leftNodes[rLeftNodes]);
				const size_t rNodes(rId);
				Mt(rNodes) = I;
				bt(rNodes) = {0.0, 0.0};
			});
		}
	}
	{
		const auto rightNodes(mesh->getRightNodes());
		const size_t nbRightNodes(rightNodes.size());
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbRightNodes));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& rRightNodesTeam)
			{
				int rRightNodes(rRightNodesTeam + teamWork.first);
				const Id rId(rightNodes[rRightNodes]);
				const size_t rNodes(rId);
				Mt(rNodes) = I;
				bt(rNodes) = {0.0, 0.0};
			});
		}
	}
}

/**
 * Job ComputeBt called @8.0 in executeTimeLoopN method.
 * In variables: b
 * Out variables: bt
 */
void Glace2d::computeBt(const member_type& teamMember) noexcept
{
	{
		const auto innerNodes(mesh->getInnerNodes());
		const size_t nbInnerNodes(innerNodes.size());
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbInnerNodes));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& rInnerNodesTeam)
			{
				int rInnerNodes(rInnerNodesTeam + teamWork.first);
				const Id rId(innerNodes[rInnerNodes]);
				const size_t rNodes(rId);
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
void Glace2d::computeMt(const member_type& teamMember) noexcept
{
	{
		const auto innerNodes(mesh->getInnerNodes());
		const size_t nbInnerNodes(innerNodes.size());
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbInnerNodes));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& rInnerNodesTeam)
			{
				int rInnerNodes(rInnerNodesTeam + teamWork.first);
				const Id rId(innerNodes[rInnerNodes]);
				const size_t rNodes(rId);
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
void Glace2d::computeTn() noexcept
{
	t_nplus1 = t_n + deltat_nplus1;
}

/**
 * Job ComputeU called @9.0 in executeTimeLoopN method.
 * In variables: Mt, bt
 * Out variables: ur
 */
void Glace2d::computeU(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbNodes));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& rNodesTeam)
		{
			int rNodes(rNodesTeam + teamWork.first);
			ur(rNodes) = matVectProduct(inverse(Mt(rNodes)), bt(rNodes));
		});
	}
}

/**
 * Job ComputeFjr called @10.0 in executeTimeLoopN method.
 * In variables: Ajr, C, p, uj_n, ur
 * Out variables: F
 */
void Glace2d::computeFjr(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
		{
			int jCells(jCellsTeam + teamWork.first);
			const Id jId(jCells);
			{
				const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				const size_t nbNodesOfCellJ(nodesOfCellJ.size());
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					const Id rId(nodesOfCellJ[rNodesOfCellJ]);
					const size_t rNodes(rId);
					F(jCells,rNodesOfCellJ) = p(jCells) * C(jCells,rNodesOfCellJ) + matVectProduct(Ajr(jCells,rNodesOfCellJ), (uj_n(jCells) - ur(rNodes)));
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
void Glace2d::computeXn(const member_type& teamMember) noexcept
{
	{
		const auto teamWork(computeTeamWorkRange(teamMember, nbNodes));
		if (!teamWork.second)
			return;
	
		Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& rNodesTeam)
		{
			int rNodes(rNodesTeam + teamWork.first);
			X_nplus1(rNodes) = X_n(rNodes) + deltat_n * ur(rNodes);
		});
	}
}

/**
 * Job ComputeEn called @11.0 in executeTimeLoopN method.
 * In variables: E_n, F, deltat_n, m, ur
 * Out variables: E_nplus1
 */
void Glace2d::computeEn(const member_type& teamMember) noexcept
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
				for (size_t rNodesOfCellJ=0; rNodesOfCellJ<nbNodesOfCellJ; rNodesOfCellJ++)
				{
					const Id rId(nodesOfCellJ[rNodesOfCellJ]);
					const size_t rNodes(rId);
					reduction0 = sumR0(reduction0, dot(F(jCells,rNodesOfCellJ), ur(rNodes)));
				}
			}
			E_nplus1(jCells) = E_n(jCells) - (deltat_n / m(jCells)) * reduction0;
		});
	}
}

/**
 * Job ComputeUn called @11.0 in executeTimeLoopN method.
 * In variables: F, deltat_n, m, uj_n
 * Out variables: uj_nplus1
 */
void Glace2d::computeUn(const member_type& teamMember) noexcept
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
					reduction0 = sumR1(reduction0, F(jCells,rNodesOfCellJ));
				}
			}
			uj_nplus1(jCells) = uj_n(jCells) - (deltat_n / m(jCells)) * reduction0;
		});
	}
}

void Glace2d::dumpVariables(int iteration, bool useTimer)
{
	if (!writer.isDisabled())
	{
		if (useTimer)
		{
			cpuTimer.stop();
			ioTimer.start();
		}
		auto quads = mesh->getGeometry()->getQuads();
		writer.startVtpFile(iteration, t_n, nbNodes, X_n.data(), nbCells, quads.data());
		writer.openNodeData();
		writer.closeNodeData();
		writer.openCellData();
		writer.write("Density", rho);
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

void Glace2d::simulate()
{
	std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting Glace2d ..." << __RESET__ << "\n\n";
	
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
		std::cerr << "(Glace2dDefault.json)" << std::endl;
		return -1;
	}
	
	// read json dataFile
	ifstream ifs(dataFile);
	rapidjson::IStreamWrapper isw(ifs);
	rapidjson::Document d;
	d.ParseStream(isw);
	assert(d.IsObject());
	
	// mesh
	assert(d.HasMember("mesh"));
	CartesianMesh2DFactory meshFactory;
	meshFactory.jsonInit(d["mesh"]);
	CartesianMesh2D* mesh = meshFactory.create();
	
	// glace2d
	Glace2d::Options Glace2d_options;
	if (d.HasMember("glace2d"))
		Glace2d_options.jsonInit(d["glace2d"]);
	
	// simulator must be a pointer if there is a finalize at the end (Kokkos, omp...)
	auto simulator = new Glace2d(mesh, Glace2d_options);
	simulator->simulate();
	
	// simulator must be deleted before calling finalize
	delete simulator;
	delete mesh;
	Kokkos::finalize();
	return ret;
}
