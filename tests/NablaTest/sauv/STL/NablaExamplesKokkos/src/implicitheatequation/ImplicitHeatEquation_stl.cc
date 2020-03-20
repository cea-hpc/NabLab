#include <iostream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <cfenv>
#pragma STDC FENV_ACCESS ON

// Project headers
#include "mesh/NumericMesh2D.h"
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/PvdFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "types/MathFunctions.h"
#include "types/LinearAlgebraFunctions_stl.h"
#include "utils/Parallel.h"

using namespace nablalib;

class ImplicitHeatEquation
{
public:
	struct Options
	{
		// Should be const but usefull to set them from main args
		double X_LENGTH = 2.0;
		double Y_LENGTH = 2.0;
		double u0 = 1.0;
		RealArray1D<2> vectOne = {1.0, 1.0};
		int X_EDGE_ELEMS = 40;
		int Y_EDGE_ELEMS = 40;
		int Z_EDGE_ELEMS = 1;
		double X_EDGE_LENGTH = as_const(X_LENGTH) / as_const(X_EDGE_ELEMS);
		double Y_EDGE_LENGTH = as_const(Y_LENGTH) / as_const(Y_EDGE_ELEMS);
		double option_stoptime = 1.0;
		int option_max_iterations = 500000000;
	};
	Options* options;

private:
	int iteration;
	NumericMesh2D* mesh;
	PvdFileWriter2D writer;
	int nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbCellsOfFace, nbNeighbourCells;

	// Global Variables
	double t, deltat, t_nplus1;

	// Connectivity Variables
	std::vector<RealArray1D<2>> X;
	std::vector<RealArray1D<2>> Xc;
	std::vector<double> xc;
	std::vector<double> yc;
	std::vector<double> V;
	std::vector<double> D;
	std::vector<double> faceLength;
	std::vector<double> faceConductivity;
	
	// Linear Algebra Variables
	VectorType u;
	NablaSparseMatrix alpha;
	VectorType u_nplus1;
	
	// Timers
	utils::Timer cpu_timer;
	utils::Timer io_timer;

	// CG details
	LinearAlgebraFunctions::CGInfo cg_info;

public:
	ImplicitHeatEquation(Options* aOptions, NumericMesh2D* aNumericMesh2D, string output)
	: options(aOptions)
	, mesh(aNumericMesh2D)
	, writer("ImplicitHeatEquation")
	, nbNodes(mesh->getNbNodes())
	, nbCells(mesh->getNbCells())
	, nbFaces(mesh->getNbFaces())
	, nbNodesOfCell(NumericMesh2D::MaxNbNodesOfCell)
	, nbNodesOfFace(NumericMesh2D::MaxNbNodesOfFace)
	, nbCellsOfFace(NumericMesh2D::MaxNbCellsOfFace)
	, nbNeighbourCells(NumericMesh2D::MaxNbNeighbourCells)
	, t(0.0)
	, deltat(0.001)
	, t_nplus1(0.0)
	, X(nbNodes)
	, Xc(nbCells)
	, xc(nbCells)
	, yc(nbCells)
	, V(nbCells)
	, D(nbCells)
	, faceLength(nbFaces)
	, faceConductivity(nbFaces)
	, u(nbCells)
	, alpha("alpha", nbCells, nbCells)
	, u_nplus1(nbCells)
	{
		// Copy node coordinates
		const auto& gNodes = mesh->getGeometricMesh()->getNodes();
		for (int rNodes(0); rNodes < nbNodes; ++rNodes)
    {
			X[rNodes] = gNodes[rNodes];
		}
	}

private:
	/**
	 * Job InitXc @-3.0
	 * In variables: X
	 * Out variables: Xc
	 */
	void initXc() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& cCells)
		{
			int cId(cCells);
			RealArray1D<2> reduction948066823 = {0.0, 0.0};
			{
				auto nodesOfCellC(mesh->getNodesOfCell(cId));
				for (int pNodesOfCellC=0; pNodesOfCellC<nodesOfCellC.size(); pNodesOfCellC++)
				{
					int pId(nodesOfCellC[pNodesOfCellC]);
					int pNodes(pId);
					reduction948066823 += (X[pNodes]);
				}
			}
			Xc[cCells] = 0.25 * reduction948066823;
		});
	}
	
	/**
	 * Job InitD @-3.0
	 * In variables: 
	 * Out variables: D
	 */
	void initD() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& cCells)
		{
			D[cCells] = 1.0;
		});
	}
	
	/**
	 * Job ComputeV @-3.0
	 * In variables: X
	 * Out variables: V
	 */
	void computeV() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& jCells)
		{
			int jId(jCells);
			double reduction764078647 = 0.0;
			{
				auto nodesOfCellJ(mesh->getNodesOfCell(jId));
				for (int pNodesOfCellJ=0; pNodesOfCellJ<nodesOfCellJ.size(); pNodesOfCellJ++)
				{
					int pId(nodesOfCellJ[pNodesOfCellJ]);
					int pPlus1Id(nodesOfCellJ[(pNodesOfCellJ+1+nbNodesOfCell)%nbNodesOfCell]);
					int pNodes(pId);
					int pPlus1Nodes(pPlus1Id);
					reduction764078647 += (MathFunctions::det(X[pNodes], X[pPlus1Nodes]));
				}
			}
			V[jCells] = 0.5 * reduction764078647;
		});
	}
	
	/**
	 * Job ComputeFaceLength @-3.0
	 * In variables: X
	 * Out variables: faceLength
	 */
	void computeFaceLength() noexcept
	{
		parallel::parallel_exec(nbFaces, [&](const int& fFaces)
		{
			int fId(fFaces);
			double reduction_212101173 = 0.0;
			{
				auto nodesOfFaceF(mesh->getNodesOfFace(fId));
				for (int pNodesOfFaceF=0; pNodesOfFaceF<nodesOfFaceF.size(); pNodesOfFaceF++)
				{
					int pId(nodesOfFaceF[pNodesOfFaceF]);
					int pPlus1Id(nodesOfFaceF[(pNodesOfFaceF+1+nbNodesOfFace)%nbNodesOfFace]);
					int pNodes(pId);
					int pPlus1Nodes(pPlus1Id);
					reduction_212101173 += (MathFunctions::norm(X[pNodes] - X[pPlus1Nodes]));
				}
			}
			faceLength[fFaces] = 0.5 * reduction_212101173;
		});
	}
	
	/**
	 * Job InitXcAndYc @-2.0
	 * In variables: Xc
	 * Out variables: xc, yc
	 */
	void initXcAndYc() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& cCells)
		{
			xc[cCells] = Xc[cCells][0];
			yc[cCells] = Xc[cCells][1];
		});
	}
	
	/**
	 * Job InitU @-2.0
	 * In variables: Xc, vectOne, u0
	 * Out variables: u
	 */
	void initU() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& cCells)
		{
			if (MathFunctions::norm(Xc[cCells] - as_const(options->vectOne)) < 0.5) 
				u[cCells] = as_const(options->u0);
			else 
				u[cCells] = 0.0;
		});
	}
	
  double minR0(double a, double b)
	{
		return MathFunctions::min(a, b);
	}
  
  
	/**
	 * Job computeDeltaTn @-2.0
	 * In variables: X_EDGE_LENGTH, Y_EDGE_LENGTH, D
	 * Out variables: deltat
	 */
	void computeDeltaTn() noexcept
	{
    deltat = 0.24 * parallel::parallel_reduce(
        nbCells, numeric_limits<double>::max(),
        [&](double& accu, const int& jCells){return (accu = as_const(options->X_EDGE_LENGTH) * as_const(options->Y_EDGE_LENGTH) / D[jCells]);},
        std::bind(&ImplicitHeatEquation::minR0, this, std::placeholders::_1, std::placeholders::_2));
	}
	
	/**
	 * Job ComputeFaceConductivity @-2.0
	 * In variables: D
	 * Out variables: faceConductivity
	 */
	void computeFaceConductivity() noexcept
	{
		parallel::parallel_exec(nbFaces, [&](const int& fFaces)
		{
			int fId(fFaces);
			double reduction_760779145 = 1.0;
			{
				auto cellsOfFaceF(mesh->getCellsOfFace(fId));
				for (int c1CellsOfFaceF=0; c1CellsOfFaceF<cellsOfFaceF.size(); c1CellsOfFaceF++)
				{
					int c1Id(cellsOfFaceF[c1CellsOfFaceF]);
					int c1Cells(c1Id);
					reduction_760779145 *= (D[c1Cells]);
				}
			}
			double reduction_1934919177 = 0.0;
			{
				auto cellsOfFaceF(mesh->getCellsOfFace(fId));
				for (int c2CellsOfFaceF=0; c2CellsOfFaceF<cellsOfFaceF.size(); c2CellsOfFaceF++)
				{
					int c2Id(cellsOfFaceF[c2CellsOfFaceF]);
					int c2Cells(c2Id);
					reduction_1934919177 += (D[c2Cells]);
				}
			}
			faceConductivity[fFaces] = 2.0 * reduction_760779145 / reduction_1934919177;
		});
	}
	
	/**
	 * Job computeAlphaCoeff @-1.0
	 * In variables: deltat, V, faceLength, faceConductivity, Xc
	 * Out variables: alpha
	 */
	void computeAlphaCoeff() noexcept
	{
		parallel::parallel_exec(nbCells, [&](const int& cCells)
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
					double alphaExtraDiag = -as_const(deltat) / V[cCells] * (faceLength[fFaces] * faceConductivity[fFaces]) / MathFunctions::norm(Xc[cCells] - Xc[dCells]);
					alpha(cCells,dCells) = alphaExtraDiag;
					alphaDiag += alphaExtraDiag;
				}
			}
			alpha(cCells,cCells) = 1 - alphaDiag;
		});
	}
	
	/**
	 * Job UpdateU @1.0
	 * In variables: alpha, u
	 * Out variables: u_nplus1
	 */
	void updateU() noexcept
	{
		u_nplus1 = LinearAlgebraFunctions::solveLinearSystem(alpha, u, cg_info);
	}
	
	/**
	 * Job ComputeTn @1.0
	 * In variables: t, deltat
	 * Out variables: t_nplus1
	 */
	void computeTn() noexcept
	{
		t_nplus1 = as_const(t) + as_const(deltat);
	}
	
	/**
	 * Job dumpVariables @1.0
	 * In variables: u
	 * Out variables: 
	 */
	void dumpVariables() noexcept
	{
		if (!writer.isDisabled() && (iteration % 1 == 0)) 
		{
			cpu_timer.stop();
			io_timer.start();
			std::map<string, double*> cellVariables;
			std::map<string, double*> nodeVariables;
			cellVariables.insert(pair<string,double*>("Temperature", u.data()));
			auto quads = mesh->getGeometricMesh()->getQuads();
			writer.writeFile(iteration, t, nbNodes, X.data(), nbCells, quads.data(), cellVariables, nodeVariables);
			io_timer.stop();
			cpu_timer.start();
		}
	}
	
	/**
	 * Job Copy_u_nplus1_to_u @2.0
	 * In variables: u_nplus1
	 * Out variables: u
	 */
	void copy_u_nplus1_to_u() noexcept
	{
		std::swap(u_nplus1, u);
	}
	
	/**
	 * Job Copy_t_nplus1_to_t @2.0
	 * In variables: t_nplus1
	 * Out variables: t
	 */
	void copy_t_nplus1_to_t() noexcept
	{
		std::swap(t_nplus1, t);
	}

public:
	void simulate()
	{
		std::cout << "\n" << __BLUE_BKG__ << __YELLOW__ << __BOLD__ <<"\tStarting ImplicitHeatEquation ..." << __RESET__ << "\n\n";

		std::cout << "[" << __GREEN__ << "MESH" << __RESET__ << "]      X=" << __BOLD__ << options->X_EDGE_ELEMS << __RESET__ << ", Y=" << __BOLD__ << options->Y_EDGE_ELEMS
			<< __RESET__ << ", X length=" << __BOLD__ << options->X_EDGE_LENGTH << __RESET__ << ", Y length=" << __BOLD__ << options->Y_EDGE_LENGTH << __RESET__ << std::endl;

    std::cout << "[" << __GREEN__ << "TOPOLOGY" << __RESET__ << "]  Running "
              << (std::thread::hardware_concurrency()>2?std::thread::hardware_concurrency():2) << " threads" << std::endl;
              
		if (!writer.isDisabled())
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    VTK files stored in " << __BOLD__ << writer.outputDirectory() << __RESET__ << " directory" << std::endl;
		else
			std::cout << "[" << __GREEN__ << "OUTPUT" << __RESET__ << "]    " << __BOLD__ << "Disabled" << __RESET__ << std::endl;

		utils::Timer timer(true);

		initXc(); // @-3.0
		initD(); // @-3.0
		computeV(); // @-3.0
		computeFaceLength(); // @-3.0
		initXcAndYc(); // @-2.0
		initU(); // @-2.0
		computeDeltaTn(); // @-2.0
		computeFaceConductivity(); // @-2.0
		computeAlphaCoeff(); // @-1.0
		timer.stop();

		iteration = 0;
		while (t < options->option_stoptime && iteration < options->option_max_iterations)
		{
			timer.start();
			cpu_timer.start();
			iteration++;
			if (iteration!=1)
				std::cout << "[" << __CYAN__ << __BOLD__ << setw(3) << iteration << __RESET__ "] t = " << __BOLD__
					<< setiosflags(std::ios::scientific) << setprecision(8) << setw(16) << t << __RESET__;

			updateU(); // @1.0
			computeTn(); // @1.0
			dumpVariables(); // @1.0
			copy_u_nplus1_to_u(); // @2.0
			copy_t_nplus1_to_t(); // @2.0
			cpu_timer.stop();

			// Timers display
			if (!writer.isDisabled()) {
				std::cout << " {CPU: " << __BLUE__ << cpu_timer.print(true) << __RESET__ ", IO: " << __BLUE__ << io_timer.print(true) << __RESET__ "} ";
			} else {
				std::cout << " {CPU: " << __BLUE__ << cpu_timer.print(true) << __RESET__ ", IO: " << __RED__ << "none" << __RESET__ << "} ";
			}

			// Progress
			std::cout << utils::progress_bar(iteration, options->option_max_iterations, t, options->option_stoptime, 25);
			timer.stop();
			std::cout << __BOLD__ << __CYAN__ << utils::Timer::print(
				utils::eta(iteration, options->option_max_iterations, t, options->option_stoptime, deltat, timer), true)
				<< __RESET__ << "\r";
			std::cout.flush();
			cpu_timer.reset();
			io_timer.reset();
		}
		std::cout << __YELLOW__ << "\n\tDone ! Took " << __MAGENTA__ << __BOLD__ << timer.print() << __RESET__ << std::endl;
		std::cout << "[CG] average iteration: " << cg_info.m_nb_it / iteration << std::endl;	
	}
};	

int main(int argc, char* argv[]) 
{
	auto o = new ImplicitHeatEquation::Options();
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
	auto c = new ImplicitHeatEquation(o, nm, output);
	c->simulate();
	delete c;
	delete nm;
	delete gm;
	delete o;
	return 0;
}
