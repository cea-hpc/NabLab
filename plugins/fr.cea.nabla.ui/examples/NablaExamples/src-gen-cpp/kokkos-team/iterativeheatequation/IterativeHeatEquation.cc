#include <iostream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <Kokkos_Core.hpp>
#include <Kokkos_hwloc.hpp>
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/CartesianMesh2D.h"
#include "mesh/PvdFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "types/MathFunctions.h"
#include "utils/kokkos/Parallel.h"

using namespace nablalib;

class IterativeHeatEquation
{
public:
	struct Options
	{
		// Should be const but usefull to set them from main args
		double X_LENGTH = 2.0;
		double Y_LENGTH = 2.0;
		double u0 = 1.0;
		RealArray1D<2> vectOne = {1.0, 1.0};
		size_t X_EDGE_ELEMS = 40;
		size_t Y_EDGE_ELEMS = 40;
		double X_EDGE_LENGTH = X_LENGTH / X_EDGE_ELEMS;
		double Y_EDGE_LENGTH = Y_LENGTH / Y_EDGE_ELEMS;
		double option_stoptime = 0.1;
		size_t option_max_iterations = 500000000;
		size_t option_max_iterations_k = 1000;
		double epsilon = 1.0E-8;
	};
	Options* options;

private:
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbCellsOfFace, nbNeighbourCells;
	int n;
	int k;
	double t_n;
	double t_nplus1;
	double deltat;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> Xc;
	Kokkos::View<double*> xc;
	Kokkos::View<double*> yc;
	Kokkos::View<double*> u_n;
	Kokkos::View<double*> u_nplus1;
	Kokkos::View<double*> u_nplus1_k;
	Kokkos::View<double*> u_nplus1_kplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> D;
	Kokkos::View<double*> faceLength;
	Kokkos::View<double*> faceConductivity;
	Kokkos::View<double**> alpha;
	double residual;
	int lastDump;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;
	typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

public:
	IterativeHeatEquation(Options* aOptions, CartesianMesh2D* aCartesianMesh2D, string output)
	: options(aOptions)
	, mesh(aCartesianMesh2D)
	, writer("IterativeHeatEquation", output)
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbFaces(mesh->getNbFaces())
	, nbNodesOfCell(CartesianMesh2D::MaxNbNodesOfCell)
	, nbNodesOfFace(CartesianMesh2D::MaxNbNodesOfFace)
	, nbCellsOfFace(CartesianMesh2D::MaxNbCellsOfFace)
	, nbNeighbourCells(CartesianMesh2D::MaxNbNeighbourCells)
	, t_n(0.0)
	, t_nplus1(0.0)
	, deltat(0.001)
	, X("X", nbNodes)
	, Xc("Xc", nbCells)
	, xc("xc", nbCells)
	, yc("yc", nbCells)
	, u_n("u_n", nbCells)
	, u_nplus1("u_nplus1", nbCells)
	, u_nplus1_k("u_nplus1_k", nbCells)
	, u_nplus1_kplus1("u_nplus1_kplus1", nbCells)
	, V("V", nbCells)
	, D("D", nbCells)
	, faceLength("faceLength", nbFaces)
	, faceConductivity("faceConductivity", nbFaces)
	, alpha("alpha", nbCells, nbCells)
	, lastDump(numeric_limits<int>::min())
	{
		// Copy node coordinates
		const auto& gNodes = mesh->getGeometry()->getNodes();
		for (size_t rNodes=0; rNodes<nbNodes; rNodes++)
			X(rNodes) = gNodes[rNodes];
	}

private:
	/**
	 * Utility function to get work load for each team of threads
	 * In  : thread and number of element to use for computation
	 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
	 */
	const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept
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
	KOKKOS_INLINE_FUNCTION
	void computeFaceLength(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbFaces));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& fFacesTeam)
			{
				int fFaces(fFacesTeam + teamWork.first);
				const Id fId(fFaces);
				double reduction3(0.0);
				{
					const auto nodesOfFaceF(mesh->getNodesOfFace(fId));
					const size_t nbNodesOfFaceF(nodesOfFaceF.size());
					for (size_t pNodesOfFaceF=0; pNodesOfFaceF<nbNodesOfFaceF; pNodesOfFaceF++)
					{
						const Id pId(nodesOfFaceF[pNodesOfFaceF]);
						const Id pPlus1Id(nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace]);
						const size_t pNodes(pId);
						const size_t pPlus1Nodes(pPlus1Id);
						reduction3 = sumR0(reduction3, MathFunctions::norm(X(pNodes) - X(pPlus1Nodes)));
					}
				}
				faceLength(fFaces) = 0.5 * reduction3;
			});
		}
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
	void computeV(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& jCellsTeam)
			{
				int jCells(jCellsTeam + teamWork.first);
				const Id jId(jCells);
				double reduction2(0.0);
				{
					const auto nodesOfCellJ(mesh->getNodesOfCell(jId));
					const size_t nbNodesOfCellJ(nodesOfCellJ.size());
					for (size_t pNodesOfCellJ=0; pNodesOfCellJ<nbNodesOfCellJ; pNodesOfCellJ++)
					{
						const Id pId(nodesOfCellJ[pNodesOfCellJ]);
						const Id pPlus1Id(nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
						const size_t pNodes(pId);
						const size_t pPlus1Nodes(pPlus1Id);
						reduction2 = sumR0(reduction2, MathFunctions::det(X(pNodes), X(pPlus1Nodes)));
					}
				}
				V(jCells) = 0.5 * reduction2;
			});
		}
	}
	
	/**
	 * Job InitD called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: D
	 */
	KOKKOS_INLINE_FUNCTION
	void initD(const member_type& teamMember) noexcept
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
	KOKKOS_INLINE_FUNCTION
	void initXc(const member_type& teamMember) noexcept
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
	 * Job SetUpTimeLoopK called @1.0 in executeTimeLoopN method.
	 * In variables: u_n
	 * Out variables: u_nplus1_k
	 */
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopK() noexcept
	{
		deep_copy(u_nplus1_k, u_n);
	}
	
	/**
	 * Job UpdateU called @1.0 in executeTimeLoopK method.
	 * In variables: alpha, u_n, u_nplus1_k
	 * Out variables: u_nplus1_kplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void updateU(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
			{
				int cCells(cCellsTeam + teamWork.first);
				const Id cId(cCells);
				double reduction6(0.0);
				{
					const auto neighbourCellsC(mesh->getNeighbourCells(cId));
					const size_t nbNeighbourCellsC(neighbourCellsC.size());
					for (size_t dNeighbourCellsC=0; dNeighbourCellsC<nbNeighbourCellsC; dNeighbourCellsC++)
					{
						const Id dId(neighbourCellsC[dNeighbourCellsC]);
						const size_t dCells(dId);
						reduction6 = sumR0(reduction6, alpha(cCells,dCells) * u_nplus1_k(dCells));
					}
				}
				u_nplus1_kplus1(cCells) = u_n(cCells) + alpha(cCells,cCells) * u_nplus1_k(cCells) + reduction6;
			});
		}
	}
	
	/**
	 * Job ComputeFaceConductivity called @2.0 in simulate method.
	 * In variables: D
	 * Out variables: faceConductivity
	 */
	KOKKOS_INLINE_FUNCTION
	void computeFaceConductivity(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbFaces));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& fFacesTeam)
			{
				int fFaces(fFacesTeam + teamWork.first);
				const Id fId(fFaces);
				double reduction4(1.0);
				{
					const auto cellsOfFaceF(mesh->getCellsOfFace(fId));
					const size_t nbCellsOfFaceF(cellsOfFaceF.size());
					for (size_t c1CellsOfFaceF=0; c1CellsOfFaceF<nbCellsOfFaceF; c1CellsOfFaceF++)
					{
						const Id c1Id(cellsOfFaceF[c1CellsOfFaceF]);
						const size_t c1Cells(c1Id);
						reduction4 = prodR0(reduction4, D(c1Cells));
					}
				}
				double reduction5(0.0);
				{
					const auto cellsOfFaceF(mesh->getCellsOfFace(fId));
					const size_t nbCellsOfFaceF(cellsOfFaceF.size());
					for (size_t c2CellsOfFaceF=0; c2CellsOfFaceF<nbCellsOfFaceF; c2CellsOfFaceF++)
					{
						const Id c2Id(cellsOfFaceF[c2CellsOfFaceF]);
						const size_t c2Cells(c2Id);
						reduction5 = sumR0(reduction5, D(c2Cells));
					}
				}
				faceConductivity(fFaces) = 2.0 * reduction4 / reduction5;
			});
		}
	}
	
	/**
	 * Job ComputeResidual called @2.0 in executeTimeLoopK method.
	 * In variables: u_nplus1_k, u_nplus1_kplus1
	 * Out variables: residual
	 */
	KOKKOS_INLINE_FUNCTION
	void computeResidual(const member_type& teamMember) noexcept
	{
		double reduction7;
		Kokkos::parallel_reduce(Kokkos::TeamThreadRange(teamMember, nbCells), KOKKOS_LAMBDA(const size_t& jCells, double& accu)
		{
			accu = maxR0(accu, MathFunctions::fabs(u_nplus1_kplus1(jCells) - u_nplus1_k(jCells)));
		}, KokkosJoiner<double>(reduction7, numeric_limits<double>::min(), std::bind(&IterativeHeatEquation::maxR0, this, std::placeholders::_1, std::placeholders::_2)));
		residual = reduction7;
	}
	
	/**
	 * Job ExecuteTimeLoopK called @2.0 in executeTimeLoopN method.
	 * In variables: alpha, u_n, u_nplus1_k, u_nplus1_kplus1
	 * Out variables: residual, u_nplus1_kplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopK() noexcept
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
				updateU(thread);
			});
			
			// @2.0
			Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
			{
				if (thread.league_rank() == 0)
					computeResidual(thread);
			});
			
		
			// Evaluate loop condition with variables at time n
			continueLoop = (residual > options->epsilon && check(k + 1 < options->option_max_iterations_k));
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				std::swap(u_nplus1_kplus1, u_nplus1_k);
			}
		
		
		} while (continueLoop);
	}
	
	/**
	 * Job InitU called @2.0 in simulate method.
	 * In variables: Xc, u0, vectOne
	 * Out variables: u_n
	 */
	KOKKOS_INLINE_FUNCTION
	void initU(const member_type& teamMember) noexcept
	{
		{
			const auto teamWork(computeTeamWorkRange(teamMember, nbCells));
			if (!teamWork.second)
				return;
		
			Kokkos::parallel_for(Kokkos::TeamThreadRange(teamMember, teamWork.second), KOKKOS_LAMBDA(const size_t& cCellsTeam)
			{
				int cCells(cCellsTeam + teamWork.first);
				if (MathFunctions::norm(Xc(cCells) - options->vectOne) < 0.5) 
					u_n(cCells) = options->u0;
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
	KOKKOS_INLINE_FUNCTION
	void initXcAndYc(const member_type& teamMember) noexcept
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
	 * Job computeDeltaTn called @2.0 in simulate method.
	 * In variables: D, X_EDGE_LENGTH, Y_EDGE_LENGTH
	 * Out variables: deltat
	 */
	KOKKOS_INLINE_FUNCTION
	void computeDeltaTn(const member_type& teamMember) noexcept
	{
		double reduction1;
		Kokkos::parallel_reduce(Kokkos::TeamThreadRange(teamMember, nbCells), KOKKOS_LAMBDA(const size_t& cCells, double& accu)
		{
			accu = minR0(accu, options->X_EDGE_LENGTH * options->Y_EDGE_LENGTH / D(cCells));
		}, KokkosJoiner<double>(reduction1, numeric_limits<double>::max(), std::bind(&IterativeHeatEquation::minR0, this, std::placeholders::_1, std::placeholders::_2)));
		deltat = reduction1 * 0.1;
	}
	
	/**
	 * Job TearDownTimeLoopK called @3.0 in executeTimeLoopN method.
	 * In variables: u_nplus1_kplus1
	 * Out variables: u_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void tearDownTimeLoopK() noexcept
	{
		deep_copy(u_nplus1, u_nplus1_kplus1);
	}
	
	/**
	 * Job computeAlphaCoeff called @3.0 in simulate method.
	 * In variables: V, Xc, deltat, faceConductivity, faceLength
	 * Out variables: alpha
	 */
	KOKKOS_INLINE_FUNCTION
	void computeAlphaCoeff(const member_type& teamMember) noexcept
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
						double alphaExtraDiag(deltat / V(cCells) * (faceLength(fFaces) * faceConductivity(fFaces)) / MathFunctions::norm(Xc(cCells) - Xc(dCells)));
						alpha(cCells,dCells) = alphaExtraDiag;
						alphaDiag = alphaDiag + alphaExtraDiag;
					}
				}
				alpha(cCells,cCells) = -alphaDiag;
			});
		}
	}
	
	/**
	 * Job ExecuteTimeLoopN called @4.0 in simulate method.
	 * In variables: alpha, deltat, t_n, u_n, u_nplus1_k, u_nplus1_kplus1
	 * Out variables: residual, t_nplus1, u_nplus1, u_nplus1_k, u_nplus1_kplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept
	{
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
			computeTn();
			setUpTimeLoopK();
			
			// @2.0
			executeTimeLoopK();
			
			// @3.0
			tearDownTimeLoopK();
			
		
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
	
	KOKKOS_INLINE_FUNCTION
	bool check(bool a) 
	{
		if (a) 
			return true;
		else
			throw std::runtime_error("Assertion failed");
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
		return MathFunctions::min(a, b);
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
	
	KOKKOS_INLINE_FUNCTION
	double maxR0(double a, double b) 
	{
		return MathFunctions::max(a, b);
	}

	void dumpVariables(int iteration)
	{
		if (!writer.isDisabled() && n >= lastDump + 1.0)
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

public:
	void simulate()
	{
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting IterativeHeatEquation ..." << __RESET__ << "\n\n";
		
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
			computeFaceLength(thread);
			computeV(thread);
			initD(thread);
			initXc(thread);
		});
		
		// @2.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			computeFaceConductivity(thread);
			initU(thread);
			initXcAndYc(thread);
			if (thread.league_rank() == 0)
				computeDeltaTn(thread);
		});
		
		// @3.0
		Kokkos::parallel_for(team_policy, KOKKOS_LAMBDA(member_type thread)
		{
			computeAlphaCoeff(thread);
		});
		
		// @4.0
		executeTimeLoopN();
		
		std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << globalTimer.print() << __RESET__ << std::endl;
	}
};

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto o = new IterativeHeatEquation::Options();
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
	auto c = new IterativeHeatEquation(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete o;
	Kokkos::finalize();
	return 0;
}
