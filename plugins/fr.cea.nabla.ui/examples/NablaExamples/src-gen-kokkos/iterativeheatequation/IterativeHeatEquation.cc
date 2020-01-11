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

class IterativeHeatEquation
{
public:
	struct Options
	{
		// Should be const but usefull to set them from main args
		double X_LENGTH = 2.0;
		double Y_LENGTH = 2.0;
		double u0 = 1.0;
		RealArray1D<2> vectOne = {{1.0, 1.0}};
		int X_EDGE_ELEMS = 40;
		int Y_EDGE_ELEMS = 40;
		double X_EDGE_LENGTH = X_LENGTH / X_EDGE_ELEMS;
		double Y_EDGE_LENGTH = Y_LENGTH / Y_EDGE_ELEMS;
		double option_stoptime = 0.1;
		int option_max_iterations = 500000000;
		int option_max_iterations_k = 1000;
	};
	Options* options;

private:
	NumericMesh2D* mesh;
	PvdFileWriter2D writer;
	int nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbCellsOfFace, nbNeighbourCells;

	// Global Variables
	int n, k, nbCalls, lastDump;
	double t_n, t_nplus1, deltat, epsilon, residual;

	// Connectivity Variables
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

	utils::Timer timer;
	const size_t maxHardThread = Kokkos::DefaultExecutionSpace::max_hardware_threads();

public:
	IterativeHeatEquation(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("IterativeHeatEquation")
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbFaces(mesh->getNbFaces())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, nbNodesOfFace(NumericMesh2D::MaxNbNodesOfFace)
	, nbCellsOfFace(NumericMesh2D::MaxNbCellsOfFace)
	, nbNeighbourCells(NumericMesh2D::MaxNbNeighbourCells)
	, t_n(0.0)
	, t_nplus1(0.0)
	, deltat(0.001)
	, epsilon(1.0E-8)
	, nbCalls(0)
	, lastDump(0)
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
	 * Job ComputeFaceLength called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: faceLength
	 */
	KOKKOS_INLINE_FUNCTION
	void computeFaceLength() noexcept
	{
		Kokkos::parallel_for("ComputeFaceLength", nbFaces, KOKKOS_LAMBDA(const int& fFaces)
		{
			int fId(fFaces);
			double reduction3 = 0.0;
			{
				auto nodesOfFaceF(mesh->getNodesOfFace(fId));
				for (int pNodesOfFaceF=0; pNodesOfFaceF<nodesOfFaceF.size(); pNodesOfFaceF++)
				{
					int pId(nodesOfFaceF[pNodesOfFaceF]);
					int pPlus1Id(nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace]);
					int pNodes(pId);
					int pPlus1Nodes(pPlus1Id);
					reduction3 = reduction3 + (MathFunctions::norm(ArrayOperations::minus(X(pNodes), X(pPlus1Nodes))));
				}
			}
			faceLength(fFaces) = 0.5 * reduction3;
		});
	}
	
	/**
	 * Job ComputeTn called @1.0 in executeTimeLoopN method.
	 * In variables: t_n, deltat
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
	void computeV() noexcept
	{
		Kokkos::parallel_for("ComputeV", nbCells, KOKKOS_LAMBDA(const int& jCells)
		{
			int jId(jCells);
			double reduction2 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int pNodesOfCellJ=0; pNodesOfCellJ<nodesOfCellJ.size(); pNodesOfCellJ++)
				{
					int pId(nodesOfCellJ[pNodesOfCellJ]);
					int pPlus1Id(nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					int pNodes(pId);
					int pPlus1Nodes(pPlus1Id);
					reduction2 = reduction2 + (MathFunctions::det(X(pNodes), X(pPlus1Nodes)));
				}
			}
			V(jCells) = 0.5 * reduction2;
		});
	}
	
	/**
	 * Job InitD called @1.0 in simulate method.
	 * In variables: 
	 * Out variables: D
	 */
	KOKKOS_INLINE_FUNCTION
	void initD() noexcept
	{
		Kokkos::parallel_for("InitD", nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			D(cCells) = 1.0;
		});
	}
	
	/**
	 * Job InitXc called @1.0 in simulate method.
	 * In variables: X
	 * Out variables: Xc
	 */
	KOKKOS_INLINE_FUNCTION
	void initXc() noexcept
	{
		Kokkos::parallel_for("InitXc", nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			RealArray1D<2> reduction0 = {{0.0, 0.0}};
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pNodes(pId);
					reduction0 = ArrayOperations::plus(reduction0, (X(pNodes)));
				}
			}
			Xc(cCells) = ArrayOperations::multiply(0.25, reduction0);
		});
	}
	
	/**
	 * Job UpdateU called @1.0 in executeTimeLoopK method.
	 * In variables: alpha, u_nplus1_k, u_n
	 * Out variables: u_nplus1_kplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void updateU() noexcept
	{
		Kokkos::parallel_for("UpdateU", nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			double reduction6 = 0.0;
			{
				auto neighbourCellsC(mesh->getNeighbourCells(cId));
				for (int dNeighbourCellsC=0; dNeighbourCellsC<neighbourCellsC.size(); dNeighbourCellsC++)
				{
					int dId(neighbourCellsC[dNeighbourCellsC]);
					int dCells(dId);
					reduction6 = reduction6 + (alpha(cCells,dCells) * u_nplus1_k(dCells));
				}
			}
			u_nplus1_kplus1(cCells) = u_n(cCells) + alpha(cCells,cCells) * u_nplus1_k(cCells) + reduction6;
		});
	}
	
	/**
	 * Job dumpVariables called @1.0 in executeTimeLoopN method.
	 * In variables: u_n, n
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
	 * Job setUpTimeLoopK called @1.0 in executeTimeLoopN method.
	 * In variables: u_n
	 * Out variables: u_nplus1_k
	 */
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopK() noexcept
	{
		deep_copy(u_nplus1_k, u_n);
	}
	
	/**
	 * Job ComputeFaceConductivity called @2.0 in simulate method.
	 * In variables: D
	 * Out variables: faceConductivity
	 */
	KOKKOS_INLINE_FUNCTION
	void computeFaceConductivity() noexcept
	{
		Kokkos::parallel_for("ComputeFaceConductivity", nbFaces, KOKKOS_LAMBDA(const int& fFaces)
		{
			int fId(fFaces);
			double reduction4 = 1.0;
			{
				auto cellsOfFaceF(mesh->getCellsOfFace(fId));
				for (int c1CellsOfFaceF=0; c1CellsOfFaceF<cellsOfFaceF.size(); c1CellsOfFaceF++)
				{
					int c1Id(cellsOfFaceF[c1CellsOfFaceF]);
					int c1Cells(c1Id);
					reduction4 = reduction4 * (D(c1Cells));
				}
			}
			double reduction5 = 0.0;
			{
				auto cellsOfFaceF(mesh->getCellsOfFace(fId));
				for (int c2CellsOfFaceF=0; c2CellsOfFaceF<cellsOfFaceF.size(); c2CellsOfFaceF++)
				{
					int c2Id(cellsOfFaceF[c2CellsOfFaceF]);
					int c2Cells(c2Id);
					reduction5 = reduction5 + (D(c2Cells));
				}
			}
			faceConductivity(fFaces) = 2.0 * reduction4 / reduction5;
		});
	}
	
	/**
	 * Job ComputeResidual called @2.0 in executeTimeLoopK method.
	 * In variables: u_nplus1_kplus1, u_nplus1_k
	 * Out variables: residual
	 */
	KOKKOS_INLINE_FUNCTION
	void computeResidual() noexcept
	{
		double reduction7(numeric_limits<double>::min());
		{
			Kokkos::Max<double> reducer(reduction7);
			Kokkos::parallel_reduce("Reductionreduction7", nbCells, KOKKOS_LAMBDA(const int& jCells, double& x)
			{
				reducer.join(x, MathFunctions::fabs(u_nplus1_kplus1(jCells) - u_nplus1_k(jCells)));
			}, reducer);
		}
		residual = reduction7;
	}
	
	/**
	 * Job InitU called @2.0 in simulate method.
	 * In variables: Xc, vectOne, u0
	 * Out variables: u_n
	 */
	KOKKOS_INLINE_FUNCTION
	void initU() noexcept
	{
		Kokkos::parallel_for("InitU", nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			if (MathFunctions::norm(ArrayOperations::minus(Xc(cCells), options->vectOne)) < 0.5) 
				u_n(cCells) = options->u0;
			else 
				u_n(cCells) = 0.0;
		});
	}
	
	/**
	 * Job InitXcAndYc called @2.0 in simulate method.
	 * In variables: Xc
	 * Out variables: xc, yc
	 */
	KOKKOS_INLINE_FUNCTION
	void initXcAndYc() noexcept
	{
		Kokkos::parallel_for("InitXcAndYc", nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			xc(cCells) = Xc(cCells)[0];
			yc(cCells) = Xc(cCells)[1];
		});
	}
	
	/**
	 * Job computeDeltaTn called @2.0 in simulate method.
	 * In variables: X_EDGE_LENGTH, Y_EDGE_LENGTH, D
	 * Out variables: deltat
	 */
	KOKKOS_INLINE_FUNCTION
	void computeDeltaTn() noexcept
	{
		double reduction1(numeric_limits<double>::max());
		{
			Kokkos::Min<double> reducer(reduction1);
			Kokkos::parallel_reduce("Reductionreduction1", nbCells, KOKKOS_LAMBDA(const int& cCells, double& x)
			{
				reducer.join(x, options->X_EDGE_LENGTH * options->Y_EDGE_LENGTH / D(cCells));
			}, reducer);
		}
		deltat = reduction1 * 0.1;
	}
	
	/**
	 * Job executeTimeLoopK called @2.0 in executeTimeLoopN method.
	 * In variables: u_n, u_nplus1_k, u_nplus1_kplus1, alpha
	 * Out variables: residual, u_nplus1_kplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopK() noexcept
	{
		k = 0;
		bool continueLoop = true;
		do
		{
			k++;
		
			updateU(); // @1.0
			computeResidual(); // @2.0
		
		
			// Evaluate loop condition with variables at time n
			continueLoop = (residual > epsilon && k + 1 < options->option_max_iterations_k);
		
			if (continueLoop)
			{
				// Switch variables to prepare next iteration
				std::swap(u_nplus1_kplus1, u_nplus1_k);
			}
		} while (continueLoop);
	}
	
	/**
	 * Job computeAlphaCoeff called @3.0 in simulate method.
	 * In variables: deltat, V, faceLength, faceConductivity, Xc
	 * Out variables: alpha
	 */
	KOKKOS_INLINE_FUNCTION
	void computeAlphaCoeff() noexcept
	{
		Kokkos::parallel_for("computeAlphaCoeff", nbCells, KOKKOS_LAMBDA(const int& cCells)
		{
			int cId(cCells);
			double alphaDiag = 0.0;
			{
				auto neighbourCellsC(mesh->getNeighbourCells(cId));
				for (int dNeighbourCellsC=0; dNeighbourCellsC<neighbourCellsC.size(); dNeighbourCellsC++)
				{
					int dId(neighbourCellsC[dNeighbourCellsC]);
					int dCells(dId);
					int fCommonFaceCD(mesh->getCommonFace(cId, dId));
					int fId(fCommonFaceCD);
					int fFaces(fId);
					double alphaExtraDiag = deltat / V(cCells) * (faceLength(fFaces) * faceConductivity(fFaces)) / MathFunctions::norm(ArrayOperations::minus(Xc(cCells), Xc(dCells)));
					alpha(cCells,dCells) = alphaExtraDiag;
					alphaDiag = alphaDiag + alphaExtraDiag;
				}
			}
			alpha(cCells,cCells) = -alphaDiag;
		});
	}
	
	/**
	 * Job tearDownTimeLoopK called @3.0 in executeTimeLoopN method.
	 * In variables: u_nplus1_kplus1
	 * Out variables: u_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void tearDownTimeLoopK() noexcept
	{
		deep_copy(u_nplus1, u_nplus1_kplus1);
	}
	
	/**
	 * Job executeTimeLoopN called @4.0 in simulate method.
	 * In variables: n, u_n, deltat, t_n, u_nplus1_k, u_nplus1_kplus1, alpha
	 * Out variables: residual, t_nplus1, u_nplus1_k, u_nplus1_kplus1, u_nplus1
	 */
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept
	{
		n = 0;
		bool continueLoop = true;
		do
		{
			n++;
			if (n!=1)
				std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << n << __RESET__ "] t = " << __BOLD__
					<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t_n << __RESET__;
		
			computeTn(); // @1.0
			dumpVariables(); // @1.0
			setUpTimeLoopK(); // @1.0
			executeTimeLoopK(); // @2.0
			tearDownTimeLoopK(); // @3.0
		
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
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting IterativeHeatEquation ..." << __RESET__ << "\n\n";
		
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
		timer.start();
		initXc(); // @1.0
		initD(); // @1.0
		computeV(); // @1.0
		computeFaceLength(); // @1.0
		initXcAndYc(); // @2.0
		initU(); // @2.0
		computeDeltaTn(); // @2.0
		computeFaceConductivity(); // @2.0
		computeAlphaCoeff(); // @3.0
		executeTimeLoopN(); // @4.0
		timer.stop();
		std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << timer.print() << __RESET__ << std::endl;
	}
};

int main(int argc, char* argv[]) 
{
	Kokkos::initialize(argc, argv);
	auto o = new IterativeHeatEquation::Options();
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
	auto c = new IterativeHeatEquation(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete gm;
	delete o;
	Kokkos::finalize();
	return 0;
}
